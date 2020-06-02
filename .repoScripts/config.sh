repPath=${HOME}"/.git/dotfiles"

configPath=${HOME}"/.config"
configRepPath=${repPath}"/.config"

localPath=${HOME}"/.local/share"
localRepPath=${repPath}"/.local/share"

function deleteLocalFiles
{
  rm -rf ${configRepPath}
  rm -rf ${repPath}"/.local"
  rm -rf ${repPath}"/.fonts"
  rm -rf ${repPath}"/.themes"
  rm -rf ${repPath}"/.wallpapers"

  rm ${repPath}/.bash_profile
  rm ${repPath}/.bashrc
  rm ${repPath}/.gtkrc-2.0
  rm ${repPath}/.xinitrc
}
