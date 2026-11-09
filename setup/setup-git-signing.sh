#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
SHARED_CONFIG="$DOTFILES_DIR/git/dot-gitconfig"
LOCAL_CONFIG="$DOTFILES_DIR/git/dot-gitconfig-local"

command -v gpg >/dev/null || { echo "Install gnupg before configuring Git signing." >&2; exit 1; }

# Read the personal identity directly, without loading machine or work overrides.
PERSONAL_NAME=$(git config --file "$SHARED_CONFIG" --no-includes --get user.name)
PERSONAL_EMAIL=$(git config --file "$SHARED_CONFIG" --no-includes --get user.email)

if tty -s; then
    export GPG_TTY
    GPG_TTY=$(tty)
fi

signing_fingerprints() {
    # Uppercase S means a usable signing key (including signing subkeys).
    # Only select keys with a valid UID matching the personal email.
    gpg --with-colons --fingerprint --list-secret-keys |
        awk -F: -v email="$PERSONAL_EMAIL" -v now="$(date +%s)" '
            $1 == "sec" {
                usable = $2 !~ /^[red]$/ && $12 ~ /S/ && $12 !~ /D/ &&
                    ($7 == "" || $7 == 0 || $7 > now)
                fingerprint = ""
                next
            }
            $1 == "fpr" && fingerprint == "" { fingerprint = $10; next }
            $1 == "uid" && usable && $2 !~ /^[red]$/ &&
                index($10, "<" email ">") {
                print fingerprint
                usable = 0
            }
        '
}

FINGERPRINTS=$(signing_fingerprints)
if [ -z "$FINGERPRINTS" ]; then
    echo "Creating a personal GPG signing key for $PERSONAL_NAME <$PERSONAL_EMAIL>."
    echo "Choose a passphrase when prompted. The key will expire in six months."
    gpg --quick-generate-key "$PERSONAL_NAME <$PERSONAL_EMAIL>" ed25519 sign 6m
    FINGERPRINTS=$(signing_fingerprints)
fi

if [ -z "$FINGERPRINTS" ]; then
    echo "No usable personal GPG signing key found after generation." >&2
    exit 1
fi

# Preserve the machine's previous choice when it is still usable.
PREVIOUS_KEY=$(git config --file "$LOCAL_CONFIG" --get user.signingkey 2>/dev/null || true)
SIGNING_KEY=""
while IFS= read -r fingerprint; do
    if [ -z "$SIGNING_KEY" ] || [ "$fingerprint" = "$PREVIOUS_KEY" ]; then
        SIGNING_KEY="$fingerprint"
    fi
done <<< "$FINGERPRINTS"

# Write atomically; the generated file contains only a public fingerprint.
umask 077
TEMP_CONFIG=$(mktemp "$LOCAL_CONFIG.XXXXXX")
trap 'rm -f "$TEMP_CONFIG"' EXIT
git config --file "$TEMP_CONFIG" user.signingkey "$SIGNING_KEY"
mv "$TEMP_CONFIG" "$LOCAL_CONFIG"

echo "Personal signing key: $SIGNING_KEY"
echo "Wrote $LOCAL_CONFIG; run setup/stow-all for your profile to install it."
echo "Add this key to personal GitHub and Codeberg accounts if not already registered:"
echo "  gpg --armor --export $SIGNING_KEY"
