repPath=${HOME}"/.git/dotfiles"

ConfigArray=(
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
    ~/.nanorc
)

function SyncInternal
{
    formatHome=$(echo ${HOME} | sed 's_/_\\/_g')
    formatRepo=$(echo ${repPath} | sed 's_/_\\/_g')
    for i in "${ConfigArray[@]}"
    do
        if [ -f "${i}" ]; 
        then
            $(cp ${i} ${repPath}) && echo $(tput setaf 2)Synchronized$(tput sgr0): ${i}
        else
            current=$(echo ${i} | sed 's/'${formatHome}'/'${formatRepo}'/')
            mkdir -p ${current}
            $(rsync -ar --delete ${i}/ ${current}/) && echo $(tput setaf 2)Synchronized$(tput sgr0): ${i}
        fi
    done
}

function ClearTempFiles
{
    formatHome=$(echo ${HOME}/ | sed 's_/_\\/_g')
    formatRepo=$(echo ${repPath} | sed 's_/_\\/_g')
    for i in "${ConfigArray[@]}"
    do
        temp=${repPath}/$(echo ${i} | sed 's/'${formatHome}'// ; s/\/.*//')

        if [ -f "${temp}" ]; 
        then
            $(rm ${temp})
        else
            $(rm -rf ${temp})
        fi
    done
}

function Commit
{
    SyncInternal

    # check if modified
    if [ -n "$(git -C ${repPath} status --porcelain)" ]; 
    then
        git -C ${repPath} add -A
        git -C ${repPath} status
        read -p "Commit? [Y/n]: " doCommit
        if [ "$doCommit" == "Y" ] || [ "$doCommit" == "" ]; 
        then
            git -C ${repPath} commit -m "c"
            git -C ${repPath} push
        fi
    else
        echo $(tput setaf 2)No files to update$(tput sgr0)   
    fi

    ClearTempFiles
}

case $1 in
    "-C") Commit ;;
    "-R") ClearTempFiles ;;
    *)
        echo HELP
        echo 
        echo -C commit files to git repository
        echo -S pull files from git and synchronize local files
        echo 
    ;;
esac