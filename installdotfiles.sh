#!/usr/bin/env bash

# Variables
kdot_dir=$(pwd)
backup_dir=.dotfiles_backups

# Functions
# Installs .zshrc file after backing up old file.
install_zshrc() {
    # Checks if oh-my-zsh is installed
    if ! [ "$(command -v omz)" ]; then
        {
        echo "Installing Oh My Zsh..."
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
        echo "Done."
        } 1>&3
    fi

    # Backs up .zshrc
    if [ -f ~/.zshrc ]; then
        echo "Backing up current .zshrc..." 1>&3
        mv ~/.zshrc ~/"$backup_dir"/.zshrc.bak
        echo "Done." 1>&3
    fi

    # Syncs new .zshrc
    echo "Syncing new .zshrc..." 1>&3
    rsync -zvh "$kdot_dir"/zshrc ~/.zshrc
    echo "Installing zsh extensions..."
    git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}"/plugins/zsh-autosuggestions
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}"/plugins/zsh-syntax-highlighting
    cd terminal-utilities || exit
    git clone --depth 1 -- https://github.com/marlonrichert/zsh-autocomplete.git
    cd ~ || exit
    echo "Done." 1>&3
} &>>kdotfiles.log # Logs Output

# Installs scripts and dotfiles for zsh
install_zsh_scripts() {
    # Backs up zsh scripts
    file_lst=(".aliases.zsh" ".functions.zsh" ".env" ".completions")
    echo "Creating Backups of Old zsh scripts..." 1>&3
    for i in "${file_lst[@]}"; do
        if [ -e "$i" ]; then
            mv ~/"$i" ~/"$backup_dir"/"$i".bak
        fi
    done
    echo "Done." 1>&3

    # Syncs zsh scripts
    echo "Syncing New zsh scripts..." 1>&3
    rsync -zvh "$kdot_dir"/aliases ~/.aliases.zsh
    rsync -zvh "$kdot_dir"/functions ~/.functions.zsh
    rsync -zvh "$kdot_dir"/home_env ~/.env
    rsync -azvh "$kdot_dir"/.completions ~/
    echo "Done." 1>&3
} &>>kdotfiles.log

# Installs git dotfiles
install_git_files() {
    # Backs up git files
    file_lst=(".gitconfig" ".gitmessage")
    echo "Creating Backups of git files..." 1>&3
    for i in "${file_lst[@]}"; do
        if [ -f "$i" ]; then
            mv ~/"$i" ~/"$backup_dir"/"$i".bak
        fi
    done
    echo "Done." 1>&3

    # Syncs git files
    rsync -zvh "$kdot_dir"/gitconfig ~/.gitconfig
    rsync -zvh "$kdot_dir"/gitmessage ~/.gitmessage

    # Sets up personal configuraions
    # Reading Details
    {
        echo "Setting Up Personal Configurations in git files..."
        read -rp "Enter your full name for .gitconfig: " fullname
        read -rp "Enter your email for .gitconfig: " email
        read -rp "Enter your github username for .gitconfig: " username
        read -rp "Enter a valid editor command for git (default:vim): " editor
        read -rp "Do you want to use GPG signing in git commits and tags? [y/n]: " gpg_choice
        read -rp "Do you want to use a difftool and mergetool? [y/n]: " tool_choice
    } 1>&3

    # Configuring Details
    git config --global user.name "$fullname"
    git config --global user.email "$email"
    git config --global github.user "$username"
    if [ -z "$editor" ]; then
        git config --global core.editor "vim"
    else
        git config --global core.editor "$editor"
    fi

    # Setting up GPG Signing and Diff and Merge Tool
    # Diff and Merge Tool
    case $tool_choice in
    [yY]*)
        read -rp "Enter a diff and merge tool (default: vimdiff): " tool 1>&3
        if [ -z "$tool" ]; then
            git config --global diff.tool "vimdiff"
            git config --global difftool.vimdiff.cmd "vimdiff $LOCAL $REMOTE"
            git config --global merge.tool "vimdiff"
            git config --global mergetool.vimdiff.cmd "vimdiff $MERGED $LOCAL $REMOTE"
        else
            read -rp "Enter the valid command for the diff and merge tool: " tool_cmd 1>&3
            git config --global diff.tool "$tool"
            git config --global difftool."$tool".cmd "$tool_cmd $LOCAL $REMOTE"
            git config --global merge.tool "$tool"
            git config --global mergetool."$tool".cmd "$tool_cmd $MERGED $LOCAL $REMOTE"
        fi
        ;;
    [nN]*)
        git config --global --unset diff.tool
        git config --global --unset merge.tool
        ;;
    *)
        echo "Keeping defaults" 1>&3
        ;;
    esac

    # GPG
    case $gpg_choice in
    [yY]*)
        read -rp "Enter your gpg signing key for commits and tags: " gpg_key 1>&3
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
        echo "Keeping Defaults" 1>&3
        ;;
    esac

} &>>kdotfiles.log

install_vim_config() {
    # Backs up vim files
    file_lst=(".vimrc" ".vim")
    echo "Creating Backups of vim files and folders..." 1>&3
    for i in "${file_lst[@]}"; do
        if [ -e "$i" ]; then
            mv ~/"$i" ~/"$backup_dir"/"$i".bak
        fi
    done
    echo "Done..." 1>&3

    # Sets up new vim folder and syncs vimrc
    echo "Setting up vimrc and vim folder..." 1>&3
    mkdir -p ~/.vim ~/.vim/autoload ~/.vim/backup ~/.vim/colors ~/.vim/plugged
    rsync -zvh "$kdot_dir"/vimrc ~/.vimrc
    echo "Plugins will be installed on first startup," 1>&3
    echo "Done." 1>&3

} &>>kdotfiles.log

install_bin_dir() {
    # Backs up bin directory
    echo "Backing up Bin Directory..." 1>&3
    if [ -d ~/bin ]; then
        cp -r ~/bin ~/"$backup_dir"/bin.bak
    fi
    echo "Done." 1>&3

    # Sync new bin directory
    echo "Syncing new Bin Directory..." 1>&3
    rsync -azvhu "$kdot_dir"/bin ~/
    echo "Done." 1>&3
    echo "Tip: To keep the external scripts up to date periodically pull their repositories and rsync them." 1>&3
} &>>kdotfiles.log

install_gnupg() {
    # Backups old gpg configuration files
    echo "Backing up old gpg configuration files..." 1>&3
    file_lst=("dirmngr.conf" "gpg-agent.conf" "gpg.conf")
    for i in "${file_lst[@]}"; do
        if [ -f ~/.gnupg/"$i" ]; then
            mv ~/.gnupg/"$i" ~/"$backup_dir"/"$i".bak
        fi
    done
    echo "Done." 1>&3

    # Syncs gnupg configuration files
    echo "Syncing gnupg configuration files..." 1>&3
    rsync -zvh "$kdot_dir"/.gnupg/dirmngr.conf ~/.gnupg/dirmngr.conf
    rsync -zvh "$kdot_dir"/.gnupg/gpg-agent.conf ~/.gnupg/gpg-agent.conf
    rsync -zvh "$kdot_dir"/.gnupg/gpg.conf ~/.gnupg/gpg.conf
    echo "Done." 1>&3
} &>>kdotfiles.log

# Installs config files for different terminal utilities
install_utility_configs() {
    # Backs up and Syncs npmrc file, if npm exists
    if [ "$(command -v npm)" ]; then
        echo "Backing up npmrc..." 1>&3
        if [ -f ~/.npmrc ]; then
            mv ~/.npmrc ~/"$backup_dir"/.npmrc.bak
        fi
        echo "Done." 1>&3

        # Syncs npmrc
        {
            echo "Setting up npmrc..."
            rsync -zvh "$kdot_dir"/npmrc ~/.npmrc
            echo "Logging in..."
            npm login # Logs in with npm for authtoken
            echo "Done."
        } 1>&3
    else
        echo "NodeJS and npm not installed, skipping." 1>&3
    fi

    # Backs up and syncs amfora configs, if it exists
    if [ "$(command -v amfora)" ]; then
        if [ -d ~/.config/amfora ]; then
            echo "Backing up amfora config directory..." 1>&3
            mv ~/.config/amfora ~/"$backup_dir"
            echo "Done." 1>&3
        fi

        echo "Syncing amfora config folder..." 1>&3
        rsync -azvh "$kdot_dir"/amfora ~/.config/
        echo "Done." 1>&3
    else
        echo "Amfora not installed, skipping." 1>&3
    fi

    # Backs up and Syncs bat config, if it exists
    if [ "$(command -v bat)" ]; then
        if [ -f ~/.config/bat/config ]; then
            echo "Backing up bat config file..." 1>&3
            mv ~/.config/bat/config ~/"$backup_dir"/bat_config
            echo "Done." 1>&3
        fi

        echo "Syncing bat config file..." 1>&3
        rsync -zvh "$kdot_dir"/bat_config ~/.config/bat/config
        echo "Done." 1>&3
    else
        echo "Bat not installed, skipping." 1>&3
    fi

    # Backs up and Syncs Lazygit config file
    if [ "$(command -v lazygit)" ]; then
        if [ -f ~/.config/lazygit/config.yml ]; then
            echo "Backing up lazygit config file..." 1>&3
            mv ~/.config/lazygit/config.yml ~/"$backup_dir"/lazygit_config.yml
            echo "Done." 1>&3
        fi

        echo "Syncing lazygit config file..." 1>&3
        rsync -zvh "$kdot_dir"/lazygit_config.yml ~/.config/lazygit/config.yml
        echo "Done." 1>&3
    else
        echo "Lazygit not installed, skipping." 1>&3
    fi

    # Backs us and Syncs LSD config file
    if [ "$(command -v lsd)" ]; then
        if [ -f ~/.config/lsd/config.yaml ]; then
            echo "Backing up lsd config file..." 1>&3
            mv ~/.config/lsd/config.yaml ~/"$backup_dir"/lsd_config.yaml
            echo "Done." 1>&3
        fi

        echo "Syncing lsd config file..." 1>&3
        rsync -zvh "$kdot_dir"/lsd_config.yaml ~/.config/lsd/config.yaml
        echo "Done." 1>&3
    else
        echo "lsd not installed, skipping." 1>&3
    fi

    # Backs up and Syncs Ngrok config file
    if [ "$(command -v ngrok)" ]; then
        if [ -f ~/.config/ngrok/ngrok.yml ]; then
            echo "Backing up ngrok config file..." 1>&3
            mv ~/.config/ngrok/ngrok.yml ~/"$backup_dir"/ngrok_config.yml
            echo "Done." 1>&3
        fi

        echo "Syncing ngrok config file..." 1>&3
        rsync -zvh "$kdot_dir"/ngrok_config.yml ~/.config/ngrok/ngrok.yml
        read -rp "Enter ngrok authtoken from https://dashboard.ngrok.com/get-started/your-authtoken : " ngrok_authtoken 1>&3
        echo "Logging in..." 1>&3
        ngrok config add-authtoken "$ngrok_authtoken"
        echo "Tip: Change the username and password for predefined tunnels in the config file, in ~/.config/ngrok/ngrok.yml ." 1>&3
        echo "Done." 1>&3
    else
        echo "Ngrok not installed, skipping." 1>&3
    fi

    # Backs up and Syncs Starship config file
    if [ "$(command -v starship)" ]; then
        if [ -f ~/.config/starship.toml ]; then
            echo "Backing up starship config file..." 1>&3
            mv ~/.config/starship.toml ~/"$backup_dir"/
            echo "Done." 1>&3
        fi

        echo "Syncing starship config file..." 1>&3
        rsync -zvh "$kdot_dir"/starship.toml ~/.config/starship.toml
        echo "Done." 1>&3
    else
        echo "Starship not installed, skipping" 1>&3
    fi

    # Backs up and syncs topgrade config file
    if [ "$(command -v topgrade)" ]; then
        if [ -f ~/.config/topgrade.toml ]; then
            echo "Backing up topgrade config file..." 1>&3
            mv ~/.config/topgrade.toml ~/"$backup_dir"/topgrade.toml
            echo "Done." 1>&3
        fi

        echo "Syncing topgrade config file..." 1>&3
        rsync -zvh "$kdot_dir"/topgrade.toml ~/.config/topgrade.toml
        echo "Done." 1>&3
    else
        echo "Topgrade not installed, skipping" 1>&3
    fi

} &>>kdotfiles.log

# Checks if the requirements of the scripts are installed
check_requirements() {
    requirements_list=("zsh" "git" "curl" "rsync")
    for i in "${requirements_list[@]}"; do
        if ! [ "$(command -v "$i")" ]; then
            echo "$i not installed. Install the program and then run the script."
            exit 1
        fi
    done    
}

# Execution
echo "Hello, Welcome to the KDotfiles Installation Script"
echo "Preparing to install the dotfiles..."
cd ~ || exit
echo "Checking Requirements..."
check_requirements
echo "All required commands are installed."
echo "Proceeding..."
install_zshrc
install_zsh_scripts
install_git_files
install_vim_config
install_bin_dir
install_gnupg
install_utility_configs
echo "All Done. Thank You."
echo "If there were any mistakes or errors, if you want to ask some questions,"
echo "or you want to make a feature request, visit: https://github.com/Kunal2007-web/KDotfiles/issues"
echo "If you would like to contribute to the project, see docs/CONTRIBUTING.md file."
