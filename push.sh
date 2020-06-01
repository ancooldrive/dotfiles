# ------------------------------------------------------------------------------
# COPING FILES
# ------------------------------------------------------------------------------

repPath=${HOME}"/.git/dotfiles"

# .config

configPath=${HOME}"/.config"
configRepPath=${repPath}"/.config"

rm -rf ${configRepPath}
mkdir -p ${configRepPath}

rsync -var --delete ${configPath}/tint2 ${configRepPath}
rsync -var --delete ${configPath}/openbox ${configRepPath}
rsync -var --delete ${configPath}/pcmanfm ${configRepPath}
rsync -var --delete ${configPath}/geany ${configRepPath}
rsync -var --delete ${configPath}/alacritty ${configRepPath}
rsync -var --delete ${configPath}/compton ${configRepPath}
rsync -var --delete ${configPath}/gtk-2.0 ${configRepPath}
rsync -var --delete ${configPath}/gtk-3.0 ${configRepPath}
rsync -var --delete ${configPath}/i3 ${configRepPath}
rsync -var --delete ${configPath}/nitrogen ${configRepPath}
rsync -var --delete ${configPath}/rofi ${configRepPath}

# .local

localPath=${HOME}"/.local/share"
localRepPath=${repPath}"/.local/share"

rm -rf ${localRepPath}
mkdir -p ${localRepPath}

rsync -var --delete ${localPath}/rofi ${localRepPath}

# .themes

themesPath=${HOME}"/.themes"

rsync -var --delete ${themesPath} ${repPath}

# home files

cp ${HOME}/.bash_profile ${repPath}
cp ${HOME}/.bashrc ${repPath}
cp ${HOME}/.gtkrc-2.0 ${repPath}
cp ${HOME}/.xinitrc ${repPath}

# ------------------------------------------------------------------------------
# PUSHING TO GIT
# ------------------------------------------------------------------------------

git add -A
git status
