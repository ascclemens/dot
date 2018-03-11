############
# Keychain #
############

# Start keychain as our ssh-agent, using AddKeysToAgent in ~/.ssh/config
[[ -e $(which keychain) ]] && eval $(keychain --eval --quiet --noask --agents ssh)
