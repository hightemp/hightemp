#!/bin/bash

declare -a fonts=(
  # BitstreamVeraSansMono
  # CascadiaCode
  # CodeNewRoman
  # DroidSansMono
  # FiraCode
  # FiraMono
  # Go-Mono
  Hack
  # Hermit
  JetBrainsMono
  # Meslo
  # Noto
  # Overpass
  # ProggyClean
  # RobotoMono
  # SourceCodePro
  # SpaceMono
  Ubuntu
  UbuntuMono
)

version=$(curl -s 'https://api.github.com/repos/ryanoasis/nerd-fonts/releases/latest' | jq -r '.name')
fonts_dir="${HOME}/.local/share/fonts"

if [[ ! -d "$fonts_dir" ]]; then
  mkdir -p "$fonts_dir"
fi

for font in "${fonts[@]}"; do
  zip_file="${font}.zip"
  download_url="https://github.com/ryanoasis/nerd-fonts/releases/download/${version}/${zip_file}"
  echo "Downloading $download_url"
  wget "$download_url"
  unzip "$zip_file" -d "$fonts_dir"
  rm "$zip_file"
done

find "$fonts_dir" -name 'Windows Compatible' -delete

fc-cache -fv
