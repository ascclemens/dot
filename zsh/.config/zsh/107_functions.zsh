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


function ec2_ssh() {
  local ec2_ip
  local curr_ip

  echo "Getting current SSH IP in $2"
  ec2_ip=$(aws --region "$1" ec2 describe-security-groups --group-name "$2" | jq -r '.SecurityGroups[0].IpPermissions | map(select(.FromPort == 22)) | .[0].IpRanges[0].CidrIp')

  echo "Getting current IP"
  curr_ip="$(curl -4sSfL icanhazip.com | tr -d '\n')/32"

  echo "Revoking $ec2_ip in $2"
  aws ec2 revoke-security-group-ingress --region "$1" --group-name "$2" --protocol tcp --port 22 --cidr "$ec2_ip"

  echo "Authorizing $curr_ip in $2"
  aws ec2 authorize-security-group-ingress --region "$1" --group-name "$2" --protocol tcp --port 22 --cidr "$curr_ip"

  echo "Done"
}
