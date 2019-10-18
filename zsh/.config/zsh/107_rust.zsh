########
# Rust #
########

if [[ -d ~/.cargo/bin ]]; then
  export PATH=$PATH:~/.cargo/bin
fi
if [[ $(uname) == "Darwin" ]]; then
  if [[ -d ~/.rustup/toolchains/nightly-x86_64-apple-darwin/lib/rustlib/src/rust/src ]]; then
    export RUST_SRC_PATH=~/.rustup/toolchains/nightly-x86_64-apple-darwin/lib/rustlib/src/rust/src
  fi
else
  if [[ -d ~/.rustup/toolchains/nightly-x86_64-unknown-linux-gnu/lib/rustlib/src/rust/src ]]; then
    export RUST_SRC_PATH=~/.rustup/toolchains/nightly-x86_64-unknown-linux-gnu/lib/rustlib/src/rust/src
  fi
fi
