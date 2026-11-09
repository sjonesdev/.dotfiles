# .dotfiles
My dotfiles managed with GNU Stow. Currently setup for my arch linux desktop, Macbook personal laptop, and Macbook work laptop.

### Git signing

Both `setup/setup-arch` and `setup/setup-mac` install GnuPG and run
`setup/setup-git-signing`. This reuses a valid signing key for the personal email
in `git/dot-gitconfig`, or prompts to create a passphrase-protected Ed25519 key
with a two-year expiry. If several keys match, it preserves the existing local
selection or uses the first matching key.

The selected fingerprint is written to the gitignored `git/dot-gitconfig-local`.
Run `setup/stow-all arch`, `setup/stow-all home`, or `setup/stow-all work` after
setup to install it as `~/.gitconfig-local`. To configure signing without running
the full machine setup, run `bash setup/setup-git-signing` first.

Add the selected public key to both personal GitHub and Codeberg accounts. GitHub
authentication still uses `gh auth`, and Flexport repositories override the
personal key with 1Password SSH signing.

### Tips to remember
- Use `init` to start up a fresh machine
- Can use `.stow-local-ignore` to set patterns to ignore in packages, but this completely overrides the default stow ignore file
