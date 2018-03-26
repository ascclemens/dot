###########
# Cleanup #
###########

# Sort and clean $PATH. This should always remain at the end of the file.
[[ -x $(which path) ]] && export PATH=$(path sort -s ~/.path/sort.json)
