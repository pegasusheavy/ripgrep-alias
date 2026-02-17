#!/bin/sh
# Install ripgrep GNU grep -E compatibility wrapper.
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/pegasusheavy/ripgrep-alias/main/install.sh | sh
#   wget -qO- https://raw.githubusercontent.com/pegasusheavy/ripgrep-alias/main/install.sh | sh
set -e

REPO="pegasusheavy/ripgrep-alias"
BRANCH="main"
RAW_URL="https://raw.githubusercontent.com/${REPO}/${BRANCH}"
INSTALL_DIR="${HOME}/.local/share/ripgrep-alias"

info()  { printf '  \033[1;34m>\033[0m %s\n' "$*"; }
ok()    { printf '  \033[1;32m>\033[0m %s\n' "$*"; }
err()   { printf '  \033[1;31m>\033[0m %s\n' "$*" >&2; }

# --- preflight ---------------------------------------------------------------

if ! command -v rg >/dev/null 2>&1; then
    err "ripgrep (rg) is not installed. Install it first."
    exit 1
fi

# --- download -----------------------------------------------------------------

mkdir -p "$INSTALL_DIR"
info "Downloading rg.sh to ${INSTALL_DIR}"

if command -v curl >/dev/null 2>&1; then
    curl -fsSL "${RAW_URL}/rg.sh" -o "${INSTALL_DIR}/rg.sh"
elif command -v wget >/dev/null 2>&1; then
    wget -qO "${INSTALL_DIR}/rg.sh" "${RAW_URL}/rg.sh"
else
    err "curl or wget is required."
    exit 1
fi

chmod +x "${INSTALL_DIR}/rg.sh"

# --- detect shell profile -----------------------------------------------------

detect_profile() {
    case "${SHELL:-}" in
        */zsh)  echo "${HOME}/.zshrc"   ;;
        */bash) echo "${HOME}/.bashrc"  ;;
        *)      echo "${HOME}/.profile" ;;
    esac
}

PROFILE="$(detect_profile)"
# shellcheck disable=SC2016
SOURCE_LINE='. "$HOME/.local/share/ripgrep-alias/rg.sh"'

# --- patch profile ------------------------------------------------------------

if [ -f "$PROFILE" ] && grep -qF "ripgrep-alias/rg.sh" "$PROFILE" 2>/dev/null; then
    info "Already present in ${PROFILE}, skipping."
else
    printf '\n# ripgrep: consume GNU grep -E so it behaves like --extended-regexp\n%s\n' \
        "$SOURCE_LINE" >> "$PROFILE"
    ok "Added source line to ${PROFILE}"
fi

# --- done ---------------------------------------------------------------------

ok "Installed."
info "Restart your shell or run:  . ${PROFILE}"
