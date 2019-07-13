############
# Keychain #
############

# Start keychain as our ssh-agent, using AddKeysToAgent in ~/.ssh/config
[[ -x $(command -v keychain) ]] && eval "$(keychain --eval --quiet --noask --agents ssh,gpg)"
