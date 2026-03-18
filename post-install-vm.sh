#!/usr/bin/env bash
# =============================================================================
#  Arch Linux Post-Install Setup Script — VM VERSION (no NVIDIA)
#  Target: Minimal archinstall base → Hyprland + Quickshell + fish + chezmoi
#  NOTE: Enable multilib in archinstall before running!
#        archinstall → Additional repositories → multilib
# =============================================================================

set -euo pipefail

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
CYAN='\033[0;36m'; BOLD='\033[1m'; RESET='\033[0m'

log()  { echo -e "${GREEN}[✔]${RESET} $*"; }
info() { echo -e "${CYAN}[→]${RESET} $*"; }
warn() { echo -e "${YELLOW}[!]${RESET} $*"; }
die()  { echo -e "${RED}[✘]${RESET} $*"; exit 1; }

step() {
  local num="$1"; local title="$2"; local total=12
  echo -e "\n${BOLD}${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
  echo -e "  ${BOLD}[${num}/${total}] ${title}${RESET}"
  echo -e "${BOLD}${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}\n"
}

[[ $EUID -eq 0 ]] && die "Do NOT run as root. Run as your regular user (with sudo access)."
command -v pacman &>/dev/null || die "This script is for Arch Linux only."

CHEZMOI_REPO="https://github.com/effyyx/postinstall"
CHEZMOI_BRANCH="main"
START_TIME=$SECONDS

echo -e "\n${BOLD}${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
echo -e "  ${BOLD}Arch Post-Install — nemui setup [VM mode]${RESET}"
echo -e "${BOLD}${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}\n"
echo -e "  Hyprland · Quickshell · fish · chezmoi\n"
sleep 2

# =============================================================================
#  1. System update
# =============================================================================
step 1 "System update"
sudo pacman -Sy --noconfirm
sudo pacman -Syu --noconfirm
log "System updated."
sleep 1

# =============================================================================
#  2. pacman packages
# =============================================================================
step 2 "Installing pacman packages (this will take a while)"
info "Base, shell, CLI tools, Hyprland, audio, gaming..."
sudo pacman -S --noconfirm --needed \
  base-devel git wget \
  btrfs-progs efibootmgr os-prober \
  intel-ucode \
  linux-firmware \
  rustup nodejs python-pip python-pipx luarocks \
  fish ghostty \
  fzf fastfetch \
  bottom ncdu smartmontools \
  ouch socat \
  imagemagick ffmpegthumbnailer mediainfo \
  poppler tesseract tesseract-data-jpn \
  yazi eva \
  rmpc mpc mpd playerctl \
  hyprland \
  hypridle hyprlock hyprpicker \
  hyprpolkitagent \
  swww \
  grim slurp swappy wf-recorder \
  wl-clipboard wlr-randr \
  xdg-user-dirs xdg-utils \
  gvfs udiskie \
  polkit-gnome nwg-look \
  qt5-wayland qt6-wayland \
  sddm quickshell \
  pipewire pipewire-alsa pipewire-pulse pipewire-jack \
  gst-plugin-pipewire wireplumber \
  libpulse pavucontrol \
  networkmanager avahi \
  ttf-jetbrains-mono-nerd \
  adw-gtk-theme papirus-icon-theme matugen \
  thunar thunar-archive-plugin thunar-media-tags-plugin \
  thunar-shares-plugin thunar-volman \
  firefox anki mpv imv filezilla \
  fcitx5 fcitx5-configtool fcitx5-gtk fcitx5-mozc fcitx5-qt \
  flatpak fuse2 fuse2fs \
  steam lutris \
  mangohud lib32-mangohud \
  gamemode lib32-gamemode \
  protontricks winetricks \
  vulkan-icd-loader lib32-vulkan-icd-loader \
  lib32-giflib lib32-gnutls lib32-gtk3 \
  lib32-libjpeg-turbo lib32-libpulse \
  lib32-libxcomposite lib32-libxslt \
  lib32-mpg123 lib32-ocl-icd lib32-openal \
  lib32-v4l-utils \
  lib32-gst-plugins-base-libs lib32-gst-plugins-good \
  sof-firmware
log "pacman packages installed."
sleep 1

# =============================================================================
#  3. Rust + cargo packages
# =============================================================================
step 3 "Setting up Rust + cargo packages"
info "Installing Rust stable toolchain..."
rustup default stable
log "Rust stable installed."
info "Compiling cargo packages (bat, eza, fd, ripgrep, starship, zoxide)..."
info "This will take several minutes — go grab a coffee ☕"
cargo install bat eza fd-find ripgrep starship zoxide
log "Cargo packages installed."
sleep 1

# =============================================================================
#  4. paru (AUR helper)
# =============================================================================
step 4 "Setting up paru (AUR helper)"
if command -v paru &>/dev/null; then
  warn "paru already installed, skipping build."
else
  info "Building paru from AUR..."
  _paru_tmp=$(mktemp -d)
  git clone https://aur.archlinux.org/paru.git "$_paru_tmp/paru"
  (cd "$_paru_tmp/paru" && makepkg -si --noconfirm)
  rm -rf "$_paru_tmp"
  log "paru installed."
fi
info "Configuring paru..."
sudo sed -i 's/^Provides/# Provides/' /etc/paru.conf
mkdir -p "$HOME/.config/paru"
cat > "$HOME/.config/paru/paru.conf" <<'PARUCONF'
[options]
SkipReview
Provides = no
PARUCONF
log "paru configured."
sleep 1

# =============================================================================
#  5. AUR packages
# =============================================================================
step 5 "Installing AUR packages"
info "alass, faugus-launcher, vesktop, mecab, mpd tools, sddm theme..."
paru -S --noconfirm --needed --skipreview --noprovides \
  alass \
  faugus-launcher \
  icoextract \
  impd-git \
  mecab-git \
  mecab-ipadic \
  mecab-ipadic-neologd-git \
  mpdris-bin \
  mpdris2 \
  mpv-mpvacious \
  papirus-folders-git \
  patool \
  sddm-sugar-dark \
  vesktop
log "AUR packages installed."
sleep 1

# =============================================================================
#  6. fish — default shell
# =============================================================================
step 6 "Setting fish as default shell"
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
sleep 1

# =============================================================================
#  7. Config files
# =============================================================================
step 7 "Writing config files"

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
log "fcitx5 env vars written."

info "Writing Elgato Wave 3 WirePlumber config..."
mkdir -p "$HOME/.config/wireplumber/wireplumber.conf.d"
cat > "$HOME/.config/wireplumber/wireplumber.conf.d/51-wave3.conf" <<'EOF'
monitor.alsa.rules = [
  {
    matches = [
      {
        node.name = "~alsa_input.usb-Elgato_Systems_Elgato_Wave_3_*"
      }
    ]
    actions = {
      update-props = {
        node.always-process = true
      }
    }
  }
]
EOF
log "Elgato Wave 3 config written."
sleep 1

# =============================================================================
#  8. Flatpak
# =============================================================================
step 8 "Setting up Flatpak + apps"
info "Adding Flathub remote..."
flatpak remote-add --if-not-exists flathub \
  https://dl.flathub.org/repo/flathub.flatpakrepo
log "Flathub remote added."
info "Installing Unity Hub..."
flatpak install --system --noninteractive flathub com.unity.UnityHub
info "Installing WiVRn server..."
flatpak install --system --noninteractive flathub io.github.wivrn.wivrn
log "Flatpak apps installed."
sleep 1

# =============================================================================
#  9. chezmoi — dotfiles
# =============================================================================
step 9 "Applying dotfiles via chezmoi"
sudo pacman -S --noconfirm --needed chezmoi
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
sleep 1

# =============================================================================
#  10. System services
# =============================================================================
step 10 "Enabling system services"
sudo systemctl enable NetworkManager
sudo systemctl enable NetworkManager-dispatcher
sudo systemctl enable sddm
sudo systemctl enable systemd-timesyncd
log "System services enabled."
info "Enabling user services (pipewire, wireplumber)..."
systemctl --user enable pipewire pipewire-pulse wireplumber
log "User audio services enabled."
sleep 1

# =============================================================================
#  11. Finalising
# =============================================================================
# =============================================================================
#  11. Cleanup
# =============================================================================
step 11 "Cleaning up"

info "Clearing pacman package cache..."
sudo pacman -Sc --noconfirm
log "Pacman cache cleared."

info "Clearing paru/AUR build cache..."
rm -rf "$HOME/.cache/paru/clone"
log "AUR build cache cleared."

info "Clearing cargo registry cache..."
rm -rf "$HOME/.cargo/registry/cache"
log "Cargo registry cache cleared."

info "Removing orphaned packages..."
mapfile -t _orphans < <(pacman -Qdtq 2>/dev/null)
if [[ ${#_orphans[@]} -gt 0 ]]; then
  sudo pacman -Rns --noconfirm "${_orphans[@]}"
  log "Orphaned packages removed."
else
  warn "No orphaned packages found."
fi
sleep 1

# =============================================================================
#  12. Finalising
step 12 "Finalising"
xdg-user-dirs-update
log "XDG user directories created."

_elapsed=$(( SECONDS - START_TIME ))
_mins=$(( _elapsed / 60 ))
_secs=$(( _elapsed % 60 ))

echo -e "\n${BOLD}${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
echo -e "  ${BOLD}All done! Reboot when ready. 🎉${RESET}"
echo -e "${BOLD}${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}\n"
echo -e "  ${CYAN}Post-reboot checklist:${RESET}"
echo -e "  • Open ${BOLD}fcitx5-configtool${RESET} → add Mozc as input method"
echo -e "  • Run ${BOLD}papirus-folders${RESET} to tint Papirus icons to your colour"
echo -e "  • Steam → Settings → Compatibility → enable Proton for all titles"
echo -e "  • ${BOLD}paru-debug${RESET} not auto-installed — add manually if needed:"
echo -e "      paru -S paru-debug\n"
echo -e "  ${CYAN}Total time: ${BOLD}${_mins}m ${_secs}s${RESET}\n"
