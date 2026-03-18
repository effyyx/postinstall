#!/usr/bin/env bash
# =============================================================================
#  Arch Linux Post-Install Setup Script
#  Target: Minimal archinstall base → Hyprland + Quickshell + fish + chezmoi
#  Packages sourced from explicit-packages.txt + aur-packages.txt
# =============================================================================

set -euo pipefail

# ── Colors ────────────────────────────────────────────────────────────────────
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
CYAN='\033[0;36m'; BOLD='\033[1m'; RESET='\033[0m'

log()  { echo -e "${GREEN}[✔]${RESET} $*"; }
info() { echo -e "${CYAN}[→]${RESET} $*"; }
warn() { echo -e "${YELLOW}[!]${RESET} $*"; }
die()  { echo -e "${RED}[✘]${RESET} $*"; exit 1; }

# ── Sanity checks ─────────────────────────────────────────────────────────────
[[ $EUID -eq 0 ]] && die "Do NOT run as root. Run as your regular user (with sudo access)."
command -v pacman &>/dev/null || die "This script is for Arch Linux only."

# ── Config — edit before running ─────────────────────────────────────────────
CHEZMOI_REPO=""        # e.g. https://github.com/yourname/dotfiles
CHEZMOI_BRANCH="main"

# ── Prompt for chezmoi repo if not hardcoded ──────────────────────────────────
if [[ -z "$CHEZMOI_REPO" ]]; then
  echo -e "\n${BOLD}Enter your chezmoi dotfiles GitHub repo URL${RESET}"
  echo -e "  ${CYAN}e.g. https://github.com/yourname/dotfiles${RESET}"
  echo -e "  Leave blank to install chezmoi without initialising.\n"
  read -rp "Repo URL: " CHEZMOI_REPO
fi

echo -e "\n${BOLD}${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
echo -e "  ${BOLD}Arch Post-Install — starting setup${RESET}"
echo -e "${BOLD}${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}\n"

# =============================================================================
#  1. Enable multilib + system update
# =============================================================================
info "Checking multilib repo..."
if ! grep -q '^\[multilib\]' /etc/pacman.conf; then
  warn "Enabling [multilib] in /etc/pacman.conf..."
  sudo sed -i '/^#\[multilib\]/{N; s/#\[multilib\]\n#Include/[multilib]\nInclude/}' /etc/pacman.conf
fi
sudo pacman -Sy --noconfirm
sudo pacman -Syu --noconfirm
log "System updated, multilib enabled."

# =============================================================================
#  2. pacman packages
# =============================================================================
info "Installing pacman packages..."
sudo pacman -S --noconfirm --needed \
  \
  base-devel git wget \
  btrfs-progs efibootmgr os-prober \
  intel-ucode \
  linux-firmware \
  rustup nodejs python-pip python-pipx luarocks \
  \
  fish ghostty \
  fzf \
  fastfetch \
  \
  bottom ncdu smartmontools \
  ouch \
  socat \
  imagemagick ffmpegthumbnailer mediainfo \
  poppler tesseract tesseract-data-jpn \
  yazi \
  eva \
  rmpc mpc mpd \
  playerctl \
  \
  hyprland \
  hypridle hyprlock hyprpicker \
  hyprpolkitagent \
  swww \
  grim slurp swappy wf-recorder \
  wl-clipboard wlr-randr \
  xdg-user-dirs xdg-utils \
  gvfs udiskie \
  polkit-gnome \
  nwg-look \
  qt5-wayland qt6-wayland \
  \
  sddm \
  quickshell \
  \
  pipewire pipewire-alsa pipewire-pulse pipewire-jack \
  gst-plugin-pipewire \
  wireplumber \
  libpulse pavucontrol \
  \
  networkmanager \
  avahi \
  \
  ttf-jetbrains-mono-nerd \
  \
  adw-gtk-theme papirus-icon-theme \
  matugen \
  \
  thunar thunar-archive-plugin thunar-media-tags-plugin \
  thunar-shares-plugin thunar-volman \
  \
  firefox \
  anki \
  mpv imv \
  filezilla \
  \
  fcitx5 fcitx5-configtool fcitx5-gtk fcitx5-mozc fcitx5-qt \
  \
  flatpak \
  fuse2 fuse2fs \
  \
  steam lutris \
  mangohud lib32-mangohud \
  gamemode lib32-gamemode \
  protontricks winetricks \
  vulkan-icd-loader lib32-vulkan-icd-loader \
  \
  \
  lib32-giflib lib32-gnutls lib32-gtk3 \
  lib32-libjpeg-turbo lib32-libpulse \
  lib32-libxcomposite lib32-libxslt \
  lib32-mpg123 lib32-ocl-icd lib32-openal \
  lib32-v4l-utils \
  lib32-gst-plugins-base-libs lib32-gst-plugins-good \
  \
  sof-firmware

log "pacman packages installed."

# =============================================================================
#  3. Rust stable toolchain
# =============================================================================
info "Setting up Rust stable via rustup..."
rustup default stable
log "Rust stable installed."

# =============================================================================
#  3b. Cargo packages
# =============================================================================
info "Installing cargo packages..."
cargo install bat eza fd-find ripgrep starship zoxide
log "Cargo packages installed."

# =============================================================================
#  4. paru (AUR helper)
# =============================================================================
if command -v paru &>/dev/null; then
  warn "paru already installed, skipping build."

# Disable Provides in system paru.conf and write user config
sudo sed -i 's/^Provides/# Provides/' /etc/paru.conf
  mkdir -p "$HOME/.config/paru"
cat > "$HOME/.config/paru/paru.conf" <<'PARUCONF'
[options]
SkipReview
Provides = no
PARUCONF
else
  info "Building paru from AUR..."
  _paru_tmp=$(mktemp -d)
  git clone https://aur.archlinux.org/paru.git "$_paru_tmp/paru"
  (cd "$_paru_tmp/paru" && makepkg -si --noconfirm)
  rm -rf "$_paru_tmp"
  log "paru installed."

# Disable Provides in system paru.conf and write user config
sudo sed -i 's/^Provides/# Provides/' /etc/paru.conf
  mkdir -p "$HOME/.config/paru"
cat > "$HOME/.config/paru/paru.conf" <<'PARUCONF'
[options]
SkipReview
Provides = no
PARUCONF
fi

# =============================================================================
#  5. AUR packages
# =============================================================================
info "Installing AUR packages..."
paru -S --noconfirm --needed --skipreview --noprovides \
  alass \
  faugus-launcher \
  icoextract \
  impd-git \
  mecab-git \
  mecab-ipadic \
  mecab-ipadic-neologd-git \
  mpdris \
  mpdris2 \
  mpv-mpvacious \
  papirus-folders-git \
  patool \
  sddm-sugar-dark \
  vesktop

log "AUR packages installed."

# =============================================================================
#  6. fish — set as default shell
# =============================================================================
info "Setting fish as default shell..."
FISH_BIN=$(command -v fish)
if ! grep -qF "$FISH_BIN" /etc/shells; then
  echo "$FISH_BIN" | sudo tee -a /etc/shells > /dev/null
fi
if [[ "$SHELL" != "$FISH_BIN" ]]; then
  chsh -s "$FISH_BIN"
  log "Default shell set to fish (takes effect on next login)."
else
  warn "fish is already the default shell."
fi

# =============================================================================
#  7. fcitx5 environment variables
# =============================================================================
info "Writing fcitx5 environment variables..."
FCITX5_ENV="$HOME/.config/environment.d/fcitx5.conf"
mkdir -p "$(dirname "$FCITX5_ENV")"
cat > "$FCITX5_ENV" <<'EOF'
GTK_IM_MODULE=fcitx
QT_IM_MODULE=fcitx
XMODIFIERS=@im=fcitx
SDL_IM_MODULE=fcitx
GLFW_IM_MODULE=ibus
EOF
log "fcitx5 env vars written to $FCITX5_ENV"

# =============================================================================
#  8. Flatpak — add Flathub remote
# =============================================================================
info "Adding Flathub remote..."
flatpak remote-add --if-not-exists flathub \
  https://dl.flathub.org/repo/flathub.flatpakrepo

info "Installing Flatpak apps..."
flatpak install --system --noninteractive flathub com.unity.UnityHub
flatpak install --system --noninteractive flathub io.github.wivrn.wivrn
log "Flatpak apps installed."
log "Flathub remote added."

# =============================================================================
#  9. chezmoi — dotfiles
# =============================================================================
info "Installing chezmoi..."
sudo pacman -S --noconfirm --needed chezmoi

if [[ -n "$CHEZMOI_REPO" ]]; then
  info "Initialising chezmoi from: $CHEZMOI_REPO (branch: $CHEZMOI_BRANCH)"
  chezmoi init --branch "$CHEZMOI_BRANCH" "$CHEZMOI_REPO"

  echo -e "\n${YELLOW}[?]${RESET} Preview of changes chezmoi will apply:"
  chezmoi diff || true

  read -rp $'\nApply dotfiles now? [y/N] ' _apply
  if [[ "$_apply" =~ ^[Yy]$ ]]; then
    chezmoi apply
    fc-cache -fv
    log "Dotfiles applied, font cache refreshed."
  else
    warn "Skipped — run 'chezmoi apply' whenever you're ready."
  fi
else
  warn "No repo provided — chezmoi installed but not initialised."
  info "Run later: chezmoi init https://github.com/yourname/dotfiles"
fi

# =============================================================================
#  10. Enable system services
# =============================================================================
info "Enabling system services..."
sudo systemctl enable NetworkManager
sudo systemctl enable NetworkManager-dispatcher
sudo systemctl enable sddm
sudo systemctl enable systemd-timesyncd
# NVIDIA suspend/resume hooks (you have these enabled)
log "System services enabled."

info "Enabling user services (pipewire, wireplumber)..."
# These are user-session services, not system — enabled per-user only
systemctl --user enable pipewire pipewire-pulse wireplumber
log "User audio services enabled."

# =============================================================================
#  11. XDG user dirs
# =============================================================================
xdg-user-dirs-update
log "XDG user directories created."

# =============================================================================
#  Done
# =============================================================================
echo -e "\n${BOLD}${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
echo -e "  ${BOLD}All done! Reboot when ready. 🎉${RESET}"
echo -e "${BOLD}${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}\n"
echo -e "  ${CYAN}Post-reboot checklist:${RESET}"
echo -e "  • Open ${BOLD}fcitx5-configtool${RESET} → add Mozc as input method"
echo -e "  • Run ${BOLD}chezmoi diff && chezmoi apply${RESET} to verify dotfiles"
echo -e "  • Run ${BOLD}papirus-folders${RESET} to tint Papirus icons to your colour"
echo -e "  • Steam → Settings → Compatibility → enable Proton for all titles"
echo -e "  • ${BOLD}paru-debug${RESET} not auto-installed — add manually if needed:\n"
echo -e "      paru -S paru-debug\n"
