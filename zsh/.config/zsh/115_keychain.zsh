############
# Keychain #
############

# Start keychain as our ssh-agent, using AddKeysToAgent in ~/.ssh/config
[[ -x $(which keychain) ]] && eval "$(keychain --eval --quiet --noask --agents ssh)"
