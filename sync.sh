repPath=${HOME}"/.git/dotfiles"

ConfigArray=(
    # configs
    ~/.config/tint2
    ~/.config/openbox
    ~/.config/geany
    ~/.config/alacritty
    ~/.config/compton
    ~/.config/gtk-2.0
    ~/.config/gtk-3.0
    ~/.config/i3
    ~/.config/i3blocks
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

function SyncRemote
{
    # coping files from main path to rep

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


    # clear 

    ClearTempFiles
}

function SyncLocal
{
    # pull files from git

    git -C checkout master
    git -C ${repPath} reset --hard
    git -C ${repPath} pull


    # coping files from rep to main path

    formatHome=$(echo ${HOME} | sed 's_/_\\/_g')
    formatRepo=$(echo ${repPath} | sed 's_/_\\/_g')
    for i in "${ConfigArray[@]}"
    do
        current=$(echo ${i} | sed 's/'${formatHome}'/'${formatRepo}'/')

        if [ -f "${current}" ]; 
        then
            $(cp ${current} ${i}) && echo $(tput setaf 2)Synchronized$(tput sgr0): ${i}
        else
            mkdir -p ${i}
            $(rsync -ar --delete ${current}/ ${i}/) && echo $(tput setaf 2)Synchronized$(tput sgr0): ${i}
        fi
    done


    # installing flat-remix icons

    mkdir ${HOME}"/.icons" 2>/dev/null
    iconName="flat-remix"
    git -C ${repPath} clone https://github.com/daniruiz/${iconName}.git
    rm -rf ${HOME}/.icons/Flat-Remix-*
    mv ${repPath}/${iconName}/Flat-Remix-* ${HOME}"/.icons"
    rm -rf ${repPath}/${iconName}


    # clear 

    ClearTempFiles
}

case $1 in
    "-commit") SyncRemote ;;
    "-install") SyncLocal ;;
    "-r") ClearTempFiles ;;
    *)
        echo HELP
        echo 
        echo -commit \"commit files to git repository\"
        echo -install \"pull files from git and synchronize local files\"
        echo -r \"clear temp files\"
        echo 
    ;;
esac
