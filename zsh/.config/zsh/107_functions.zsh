#############
# Functions #
#############

# mkdir, then cd to it
mkdircd() {
  mkdir -p "$*";
  cd "$*";
}

# undollar
\$() { $@ }

#
# Defines transfer alias and provides easy command line file and folder sharing.
#
# Authors:
#   Remco Verhoef <remco@dutchcoders.io>
#
transfer() {
  # check arguments
  if [ $# -eq 0 ];
  then
    echo "No arguments specified. Usage:\necho transfer /tmp/test.md\ncat /tmp/test.md | transfer test.md"
    return 1
  fi

  # get temporarily filename, output is written to this file show progress can be showed
  tmpfile=$( mktemp -t transferXXX )

  # upload stdin or file
  file=$1

  if tty -s;
  then
    basefile=$(basename "$file" | sed -e 's/[^a-zA-Z0-9._-]/-/g')

    if [ ! -e "$file" ];
    then
      echo "File $file doesn't exist."
      return 1
    fi

    if [ -d "$file" ];
    then
      # zip directory and transfer
      zipfile=$( mktemp -t transferXXX.zip )
      cd $(dirname "$file") && zip -r -q - $(basename "$file") >> "$zipfile"
      curl --progress-bar --upload-file "$zipfile" "https://transfer.sh/$basefile.zip" >> "$tmpfile"
      rm -f "$zipfile"
    else
      # transfer file
      curl --progress-bar --upload-file "$file" "https://transfer.sh/$basefile" >> "$tmpfile"
    fi
  else
    # transfer pipe
    curl --progress-bar --upload-file "-" "https://transfer.sh/$file" >> "$tmpfile"
  fi

  # cat output link
  cat "$tmpfile"

  # cleanup
  rm -f "$tmpfile"
}

function ec2_ssh() {
  local ec2_ip
  local curr_ip

  echo "Getting current SSH IP in $1"
  ec2_ip=$(aws ec2 describe-security-groups --group-name "$1" | jq -r '.SecurityGroups[0].IpPermissions | map(select(.FromPort == 22)) | .[0].IpRanges[0].CidrIp')

  echo "Getting current IP"
  curr_ip="$(curl -4sSfL icanhazip.com | tr -d '\n')/32"

  echo "Revoking $ec2_ip in $1"
  aws ec2 revoke-security-group-ingress --region us-east-1 --group-name "$1" --protocol tcp --port 22 --cidr "$ec2_ip"

  echo "Authorizing $curr_ip in $1"
  aws ec2 authorize-security-group-ingress --region us-east-1 --group-name "$1" --protocol tcp --port 22 --cidr "$curr_ip"

  echo "Done"
}
