########
# Rust #
########

if [[ -d ~/.cargo/bin ]]; then
  export PATH=$PATH:~/.cargo/bin
fi
if [[ -d ~/.multirust/toolchains/nightly-x86_64-apple-darwin/lib/rustlib/src/rust/src ]]; then
  export RUST_SRC_PATH=~/.multirust/toolchains/nightly-x86_64-apple-darwin/lib/rustlib/src/rust/src
fi
