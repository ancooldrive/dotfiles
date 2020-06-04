repPath=${HOME}"/.git/dotfiles"

configPath=${HOME}"/.config"
configRepPath=${repPath}"/.config"

localPath=${HOME}"/.local/share"
localRepPath=${repPath}"/.local/share"

configArray=(tint2
             openbox
             pcmanfm
             geany
             alacritty
             compton
             gtk-2.0
             gtk-3.0
             i3
             i3blocks
             nitrogen
             rofi
             st
             nano)

localArray=(rofi
            scripts
            fonts)

homeArray=(.themes
           .wallpapers
           .bash_profile
           .bashrc
           .gtkrc-2.0
           .xinitrc
           .nanorc)

# functions

function rsyncInternal
{
  array=("$@")
  for i in "${array[@]:3}"
  do
    if [ -f "${2}/${i}" ]; then
      #if this is regular file then just copy it
      cp ${2}/${i} ${3}
    else
      #if directory then rsync
      echo $(rsync -var ${1} ${2}/${i} ${3})
    fi
  done
}

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
  rm ${repPath}/.nanorc
}



TestconfigArray=(
                 # configs
                 ~/.config/tint2
                 ~/.config/openbox
                 ~/.config/pcmanfm
                 ~/.config/geany
                 ~/.config/alacritty
                 ~/.config/compton
                 ~/.config/gtk-2.0
                 ~/.config/gtk-3.0
                 ~/.config/i3
                 ~/.config/i3blocks
                 ~/.config/nitrogen
                 ~/.config/rofi
                 ~/.config/st
                 ~/.config/nano
                 # local
                 ~/.local/share/rofi
                 ~/.local/share/scripts
                 ~/.local/share/fonts
                 # dotfiles
                ~/.themes
                ~/.wallpapers
                ~/.bash_profile
                ~/.bashrc
                ~/.gtkrc-2.0
                ~/.xinitrc
                ~/.nanorc)

function TestrsyncInternal
{
 array=("$@")
 formatHome=$(echo ${HOME} | sed 's_/_\\/_g')
 formatRepo=$(echo ${repPath} | sed 's_/_\\/_g')
 for i in "${array[@]}"
 do
   if [ -f "${i}" ]; then
     echo $(cp ${i} ${repPath})
   else
     current=$(echo ${i} | sed 's/'${formatHome}'/'${formatRepo}'/')
     mkdir -p ${current}
     echo $(rsync -var --delete ${i}/ ${current}/)
   fi
 done
}

#TestrsyncInternal "${TestconfigArray[@]}"
