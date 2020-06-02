# ------------------------------------------------------------------------------
# LOAD CONFIG FILE
# ------------------------------------------------------------------------------

source ${HOME}"/.git/dotfiles/.repoScripts/config.sh"

# ------------------------------------------------------------------------------
# COPING FILES
# ------------------------------------------------------------------------------

# .config

mkdir -p ${configPath}

rsync -var --delete ${configRepPath}/tint2 ${configPath}
rsync -var --delete ${configRepPath}/openbox ${configPath}
rsync -var --delete ${configRepPath}/pcmanfm ${configPath}
rsync -var --delete ${configRepPath}/geany ${configPath}
rsync -var --delete ${configRepPath}/alacritty ${configPath}
rsync -var --delete ${configRepPath}/compton ${configPath}
rsync -var --delete ${configRepPath}/gtk-2.0 ${configPath}
rsync -var --delete ${configRepPath}/gtk-3.0 ${configPath}
rsync -var --delete ${configRepPath}/i3 ${configPath}
rsync -var --delete ${configRepPath}/nitrogen ${configPath}
rsync -var --delete ${configRepPath}/rofi ${configPath}

# .local

mkdir -p ${localPath}

rsync -var --delete ${localRepPath}/rofi ${localPath}

# .themes

rsync -var --delete ${repPath}"/.fonts" ${HOME}

# .themes

rsync -var --delete ${repPath}"/.themes" ${HOME}

# .wallpapers

rsync -var --delete ${repPath}"/.wallpapers" ${HOME}

# home files

cp ${repPath}/.bash_profile ${HOME}
cp ${repPath}/.bashrc ${HOME}
cp ${repPath}/.gtkrc-2.0 ${HOME}
cp ${repPath}/.xinitrc ${HOME}
