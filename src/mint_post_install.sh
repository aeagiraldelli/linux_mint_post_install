#!/usr/bin/env bash

readonly flatpak_apps=(
  'com.github.jeromerobert.pdfarranger'
  'com.github.tchx84.Flatseal'
  'nl.hjdskes.gcolor3'
  'com.belmoussaoui.Decoder'
  'com.github.fabiocolacio.marker'
  'com.github.johnfactotum.Foliate'
  'com.github.unrud.VideoDownloader'
  'io.github.seadve.Kooha'
  'com.github.junrrein.PDFSlicer'
  'org.gnome.SoundRecorder'
  'com.adrienplazas.Metronome'
  'io.github.lainsce.Colorway'
  'io.github.lainsce.Emulsion'
  'org.ardour.Ardour'
  'org.gnome.Cheese'
  'com.spotify.Client'
  'com.discordapp.Discord'
  'us.zoom.Zoom'
  'com.obsproject.Studio'
  'com.skype.Client'
  'com.slack.Slack'
  'org.libretro.RetroArch'
  'io.github.seadve.Mousai'
  'org.onlyoffice.desktopeditors'
  'net.rpcs3.RPCS3'
  'com.google.AndroidStudio'
  'com.jetbrains.IntelliJ-IDEA-Community'
)

readonly nerdfonts=(
  'CascadiaCode'
  'DroidSansMono'
  'FantasqueSansMono'
  'FiraCode'
  'Go-Mono'
  'Hack'
  'IBMPlexMono'
  'Iosevka'
  'JetBrainsMono'
  'Meslo'
  'RobotoMono'
  'Ubuntu'
  'UbuntuMono'
)

update_os() {
  sudo apt update
  sudo apt full-upgrade -y
}

install_packages() {
  echo $'\nInstalling basic packages\n'
  sudo apt install git git-lfs xclip wget rsync curl gnome-keyring -y
  sudo apt install build-essential clang cmake ninja-build pkg-config libgtk-3-dev liblzma-dev -y
  sudo apt install ubuntu-restricted-extras ubuntu-restricted-addons -y
  sudo apt install zip unzip p7zip-full p7zip-rar unrar -y
  sudo apt install texlive-full texmaker -y
}

configure_flatpak() {
  sudo apt install flatpak -y
  sudo apt install gnome-software-plugin-flatpak -y
  flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
}

install_flatpak_apps() {
  echo $'\nInstalling flatpak apps\n'
  for app in "${flatpak_apps[@]}"; do
    flatpak install flathub "$app"
  done
}

install_nerdfonts() {
  # create dir if not exists
  if [ ! -d "/usr/share/fonts/nerdfonts" ]; then
    sudo mkdir -p /usr/share/fonts/nerdfonts
  fi

  for font_name in "${nerdfonts[@]}"; do
    if [[ ! -d "/usr/share/fonts/nerdfonts/$font_name" ]]; then
      printf "\nDownloading %s font\n\n" "$font_name"
      url="https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/$font_name.zip"
      wget -c "$url"

      # Unzip and delete some files
      unzip "${font_name}.zip" -d "$font_name"
      rm -Rfv "$font_name"/*Windows*
      rm -Rfv "$font_name"/*Mono.ttf*
      rm -Rfv "$font_name"/*.otf*

      # move to correct location and delete downloaded file
      sudo mv -v "$font_name" "/usr/share/fonts/nerdfonts/$font_name"
      rm -v "${font_name}.zip"
    else
      echo "Font $font_name already exists. Skiping..."
    fi
  done

  fc-cache -rv
}

update_os
install_packages
configure_flatpak
install_flatpak_apps
install_nerdfonts

printf "\n\nDONE!\n"