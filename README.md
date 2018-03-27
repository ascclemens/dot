# .dot

Clone to `~/.dot`, use [GNU Stow](https://www.gnu.org/software/stow/) to initialize whichever
packages you want.

```sh
stow zsh
stow path
# and so on
```

## init.sh

Also included is a quick shell script I wrote (compatible with even bare `sh`, assuming it supports
`local`) to bootstrap new servers.

It assumes Debian-based (e.g. has `apt`). It kind of also assumes `curl` is installed, assuming you
run it with `curl -sSf ... | sh`, but otherwise not.

It will update `apt`, upgrade, upgrade your distribution if necessary, install some packages, set
your default shell to `zsh`, download this repo, install a program to generate `$PROMPT` and
`$RPROMPT`, install a program to clean and sort `$PATH`, run `stow zsh` and `stow path`, then prompt
to install [Rust](https://rust-lang.org/).

It does not pollute the shell it is run in.
