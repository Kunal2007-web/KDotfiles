#!/usr/bin/env bash

# Variables
KDOT_DIR=$(pwd)
BACKUP_DIR="$HOME"/.dotfiles_backups

# Functions
sync_zshrc() {
    echo "Backing up current .zshrc..."
    mv "$HOME"/.zshrc "$BACKUP_DIR"/.zshrc.bak
    echo "Done."

    echo "Syncing new .zshrc..."
    rsync -zvh "$KDOT_DIR"/zshrc "$HOME"/.zshrc
    echo "Installing oh my zsh extensions..."
    git clone https://github.com/zsh-users/zsh-autosuggestions "$HOME"/.oh-my-zsh/custom/plugins/zsh-autosuggestions
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$HOME"/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
    git clone https://github.com/marlonrichert/zsh-autocomplete.git "$HOME"/terminal-utilities/zsh-autocomplete
    echo "Done."
}

sync_zsh_scripts() {
    file_lst=(".aliases.zsh" ".functions.zsh" ".env" ".completions")
    echo "Creating Backups of Old zsh scripts..."
    for i in "${file_lst[@]}"; do
        if [ -e "$i" ]; then
            mv "$HOME"/"$i" "$BACKUP_DIR"/"$i".bak
        fi
    done
    echo "Done."

    echo "Syncing New zsh scripts..."
    rsync -zvh "$KDOT_DIR"/aliases "$HOME"/.aliases.zsh
    rsync -zvh "$KDOT_DIR"/functions "$HOME"/.functions.zsh
    rsync -zvh "$KDOT_DIR"/home_env "$HOME"/.env
    rsync -azvhu "$KDOT_DIR"/.completions "$HOME"/
    echo "Done."
}

sync_git_files() {
    file_lst=(".gitconfig" ".gitmessage")
    echo "Creating Backups of git files..."
    for i in "${file_lst[@]}"; do
        if [ -f "$i" ]; then
            mv "$HOME"/"$i" "$BACKUP_DIR"/"$i".bak
        fi
    done
    echo "Done."

    # Syncs git files
    rsync -zvh "$KDOT_DIR"/gitconfig "$HOME"/.gitconfig
    rsync -zvh "$KDOT_DIR"/gitmessage "$HOME"/.gitmessage

    echo "Setting Up Personal Configurations in git files..."
    read -rp "Enter your full name for .gitconfig: " fullname
    read -rp "Enter your email for .gitconfig: " email
    read -rp "Enter your github username for .gitconfig: " username
    read -rp "Enter a valid editor command for git (default:vim): " editor
    read -rp "Do you want to use GPG signing in git commits and tags? [y/n]: " gpg_choice
    read -rp "Do you want to use a difftool and mergetool? [y/n]: " tool_choice

    git config --global user.name "$fullname"
    git config --global user.email "$email"
    git config --global github.user "$username"
    if [ -z "$editor" ]; then
        git config --global core.editor "vim"
    else
        git config --global core.editor "$editor"
    fi

    case $tool_choice in
    [yY]*)
        read -rp "Enter a diff and merge tool (default: vimdiff): " tool
        if [ -z "$tool" ]; then
            git config --global diff.tool "vimdiff"
            git config --global difftool.vimdiff.cmd "vimdiff \$LOCAL \$REMOTE"
            git config --global merge.tool "vimdiff"
            git config --global mergetool.vimdiff.cmd "vimdiff \$MERGED \$LOCAL \$REMOTE"
        else
            read -rp "Enter the valid command for the diff and merge tool: " tool_cmd
            git config --global diff.tool "$tool"
            git config --global difftool."$tool".cmd "$tool_cmd \$LOCAL \$REMOTE"
            git config --global merge.tool "$tool"
            git config --global mergetool."$tool".cmd "$tool_cmd \$MERGED \$LOCAL \$REMOTE"
        fi
        ;;
    [nN]*)
        git config --global --unset diff.tool
        git config --global --unset merge.tool
        ;;
    *)
        echo "Keeping defaults"
        ;;
    esac

    case $gpg_choice in
    [yY]*)
        read -rp "Enter your gpg signing key for commits and tags: " gpg_key
        git config --global user.signingkey "$gpg_key"
        git config --global commit.gpgsign true
        git config --global tag.gpgsign true
        ;;
    [nN]*)
        git config --global --unset user.signingkey
        git config --global --unset commit.gpgsign
        git config --global --unset tag.gpgsign
        git config --global --unset tag.minTrustLevel
        git config --global --unset gpg.format
        ;;
    *)
        echo "Keeping Defaults"
        ;;
    esac

}

sync_vim_config() {
    file_lst=(".vimrc" ".vim" "coc-settings.vim")
    echo "Creating Backups of vim files and folders..."
    for i in "${file_lst[@]}"; do
        if [ -e "$i" ]; then
            mv "$HOME"/"$i" "$BACKUP_DIR"/"$i".bak
        fi
    done
    echo "Done..."

    echo "Setting up vimrc and vim folder..."
    mkdir -p "$HOME"/.vim "$HOME"/.vim/autoload "$HOME"/.vim/backup "$HOME"/.vim/colors "$HOME"/.vim/plugged
    rsync -zvh "$KDOT_DIR"/vimrc "$HOME"/.vimrc
    rsync -zvh "$KDOT_DIR"/coc-settings.vim "$HOME"/.vim/coc-settings.vim
    echo "Plugins will be installed on first startup,"
    echo "Done."

}

sync_bin_dir() {
    echo "Backing up Bin Directory..."
    if [ -d "$HOME"/bin ]; then
        cp -r "$HOME"/bin "$BACKUP_DIR"/bin.bak
    fi
    echo "Done."

    # Sync new bin directory
    echo "Syncing new Bin Directory..."
    rsync -azvhu "$KDOT_DIR"/bin "$HOME"/
    echo "Done."
    echo "Tip: To keep the external scripts up to date periodically pull their repositories and rsync them."
}

sync_gnupg() {
    echo "Backing up old gpg configuration files..."
    file_lst=("dirmngr.conf" "gpg-agent.conf" "gpg.conf")
    for i in "${file_lst[@]}"; do
        if [ -f "$HOME"/.gnupg/"$i" ]; then
            mv "$HOME"/.gnupg/"$i" "$BACKUP_DIR"/"$i".bak
        fi
    done
    echo "Done."

    echo "Syncing gnupg configuration files..."
    rsync -azvhu "$KDOT_DIR"/.gnupg "$HOME"/
    echo "Done."
}

sync_amfora() {
    echo "Backing up old amfora files..."
    file_lst=("config.toml" "newtab.gmi")
    for i in "${file_lst[@]}"; do
        if [ -f "$HOME"/.config/amfora/"$i" ]; then
            mv "$HOME"/.config/amfora/"$i" "$BACKUP_DIR"/"$i".bak
        fi
    done
    echo "Done."

    echo "Syncing amfora files..."
    rsync -azvhu "$KDOT_DIR"/amfora "$HOME"/.config/
    echo "Done."
}

sync_npm() {
    if [ -f "$HOME"/.npmrc ]; then
        echo "Backing up npmrc..."
        mv "$HOME"/.npmrc "$BACKUP_DIR"/.npmrc.bak
        echo "Done."
    fi

    echo "Setting up npmrc..."
    rsync -zvh "$KDOT_DIR"/npmrc "$HOME"/.npmrc
    echo "Logging in..."
    npm login 
    echo "Done."
}

sync_bat() {
    if [ -d "$HOME"/.config/bat ]; then
        if [ -f "$HOME"/.config/bat/config ]; then
            echo "Backing up bat config file..."
            mv "$HOME"/.config/bat/config "$BACKUP_DIR"/bat_config.bak
            echo "Done."
        fi

        echo "Syncing bat config file..."
        rsync -zvh "$KDOT_DIR"/bat_config "$HOME"/.config/bat/config
        echo "Done."
    else
        mkdir "$HOME"/.config/bat
        echo "Syncing bat config file..."
        rsync -zvh "$KDOT_DIR"/bat_config "$HOME"/.config/bat/config
        echo "Done."
    fi
}

sync_lazygit() {
    if [ -d "$HOME"/.config/lazygit ]; then
        if [ -f "$HOME"/.config/lazygit/config.yml ]; then
            echo "Backing up lazygit config file..."
            mv "$HOME"/.config/lazygit/config.yml "$BACKUP_DIR"/lazygit_config.yml.bak
            echo "Done."
        fi

        echo "Syncing lazygit config file..."
        rsync -zvh "$KDOT_DIR"/lazygit_config.yml "$HOME"/.config/lazygit/config.yml
        echo "Done."
    else
        mkdir "$HOME"/.config/lazygit
        echo "Syncing lazygit config file..."
        rsync -zvh "$KDOT_DIR"/lazygit_config.yml "$HOME"/.config/lazygit/config.yml
        echo "Done."
    fi
}

sync_lsd() {
    if [ -d "$HOME"/.config/lsd ]; then
        if [ -f "$HOME"/.config/lsd/config.yaml ]; then
            echo "Backing up lsd config file..."
            mv "$HOME"/.config/lsd/config.yaml "$BACKUP_DIR"/lsd_config.yaml.bak
            echo "Done."
        fi

        echo "Syncing lsd config file..."
        rsync -zvh "$KDOT_DIR"/lsd_config.yaml "$HOME"/.config/lsd/config.yaml
        echo "Done."
    else
        mkdir "$HOME"/.config/lsd
        echo "Syncing lsd config file..."
        rsync -zvh "$KDOT_DIR"/lsd_config.yaml "$HOME"/.config/lsd/config.yaml
        echo "Done."
    fi
}

sync_poetry() {
    if [ -d "$HOME"/.config/pypoetry ]; then
        if [ -f "$HOME"/.config/pypoetry/config.toml ]; then
            echo "Backing up poetry config file..."
            mv "$HOME"/.config/pypoetry/config.toml "$BACKUP_DIR"/poetry_config.toml.bak
            echo "Done."
        fi

        echo "Syncing poetry config file..."
        rsync -zvh "$KDOT_DIR"/poetry_config.toml "$HOME"/.config/pypoetry/config.toml
        echo "Done."
    else
        mkdir "$HOME"/.config/pypoetry
        echo "Syncing poetry config file..."
        rsync -zvh "$KDOT_DIR"/poetry_config.toml "$HOME"/.config/pypoetry/config.toml
        echo "Done."
    fi
}

sync_ngrok() {
    if [ -d "$HOME"/.config/ngrok ]; then
        if [ -f "$HOME"/.config/ngrok/ngrok.yml ]; then
            echo "Backing up ngrok config file..."
            mv "$HOME"/.config/ngrok/ngrok.yml "$BACKUP_DIR"/ngrok_config.yml.bak
            echo "Done."
        fi

        echo "Syncing ngrok config file..."
        rsync -zvh "$KDOT_DIR"/ngrok_config.yml "$HOME"/.config/ngrok/ngrok.yml
        read -rp "Enter ngrok authtoken from https://dashboard.ngrok.com/get-started/your-authtoken : " ngrok_authtoken
        echo "Logging in..."
        ngrok config add-authtoken "$ngrok_authtoken"
        echo "Tip: Change the username and password for predefined tunnels in the config file, in ~/.config/ngrok/ngrok.yml ."
        echo "Done."
    else
        mkdir "$HOME"/.config/ngrok
        echo "Syncing ngrok config file..."
        rsync -zvh "$KDOT_DIR"/ngrok_config.yml "$HOME"/.config/ngrok/ngrok.yml
        read -rp "Enter ngrok authtoken from https://dashboard.ngrok.com/get-started/your-authtoken : " ngrok_authtoken
        echo "Logging in..."
        ngrok config add-authtoken "$ngrok_authtoken"
        echo "Tip: Change the username and password for predefined tunnels in the config file, in ~/.config/ngrok/ngrok.yml ."
        echo "Done."
    fi
}

sync_starship() {
    if [ -f "$HOME"/.config/starship.toml ]; then
        echo "Backing up starship config file..."
        mv "$HOME"/.config/starship.toml "$BACKUP_DIR"/starship.toml.bak
        echo "Done."
    fi

    echo "Syncing starship config file..."
    rsync -zvh "$KDOT_DIR"/starship.toml "$HOME"/.config/starship.toml
    echo "Done."
}

sync_topgrade() {
    if [ -f "$HOME"/.config/topgrade.toml ]; then
        echo "Backing up topgrade config file..."
        mv "$HOME"/.config/topgrade.toml "$BACKUP_DIR"/topgrade.toml.bak
        echo "Done."
    fi

    echo "Syncing topgrade config file..."
    rsync -zvh "$KDOT_DIR"/topgrade.toml "$HOME"/.config/topgrade.toml
    echo "Done."
}

sync_zellij() {
    if [ -f "$HOME"/.config/zellij/config.kdl ]; then
        echo "Backing up zellij config file..."
        mv "$HOME"/.config/zellij/config.kdl "$BACKUP_DIR"/zellij_config.kdl.bak
        echo "Done."
    fi

    echo "Syncing zellij config file..."
    rsync -zvh "$KDOT_DIR"/zellij_config.kdl "$HOME"/.config/zellij/config.kdl
    echo "Done."
}

sync_ghostty() {
    if [ -f "$HOME"/.config/ghostty/config ]; then
        echo "Backing up ghostty config file..."
        mv "$HOME"/.config/ghostty/config "$BACKUP_DIR"/ghostty_config.bak
        echo "Done."
    fi

    echo "Syncing ghostty config file..."
    rsync -zvh "$KDOT_DIR"/ghostty_config "$HOME"/.config/ghostty/config
    echo "Done."
}

sync_superfile() {
    if [ -f "$HOME"/.config/superfile/config.toml ]; then
        echo "Backing up superfile config file..."
        mv "$HOME"/.config/superfile/config.toml "$BACKUP_DIR"/superfile_config.toml.bak
        echo "Done."
    fi

    echo "Syncing superfile config file..."
    rsync -zvh "$KDOT_DIR"/superfile_config.toml "$HOME"/.config/superfile/config.toml
    echo "Done."
}

sync_all() {
    sync_gnupg
    sync_zshrc
    sync_zsh_scripts
    sync_git_files
    sync_vim_config
    sync_bin_dir
    sync_bat
    sync_amfora
    sync_lazygit
    sync_lsd
    sync_npm
    sync_ngrok
    sync_poetry
    sync_starship
    sync_topgrade
    sync_zellij
    sync_ghostty
}
