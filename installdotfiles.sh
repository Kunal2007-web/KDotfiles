#!/usr/bin/env bash

# Variables
kdot_dir=$(pwd)

# Functions
# Installs .zshrc file after backing up old file.
install_zshrc() {
    # Backs up old .zshrc
    if [ -f ~/.zshrc ]; then
        echo "Backing up current .zshrc..." 1>>"$(tty)"
        rm ~/.zshrc.bak
        mv ~/.zshrc ~/.zshrc.bak
        echo "Done..." 1>>"$(tty)"
    fi
    echo "Syncing new .zshrc..." 1>>"$(tty)"
    rsync -zvh "$kdot_dir"/zshrc ~/.zshrc # Syncs new .zshrc
    echo "Done." 1>>"$(tty)"
} &>>kdotfiles.log # Logs Output

# Installs scripts and dotfiles for zsh
install_zsh_scripts() {
    # Backs up old zsh scripts
    file_lst=(".aliases.zsh" ".functions.zsh" ".env" ".completions")
    echo "Creating Backups of Old zsh scripts..." 1>>"$(tty)"
    for i in "${file_lst[@]}"; do
        if [ -e "$i" ]; then
            rm ~/"$i".bak
            mv ~/"$i" ~/"$i".bak 
        fi
    done
    echo "Done..." 1>>"$(tty)"

    # Syncs zsh scripts
    echo "Syncing New zsh scripts..." 1>>"$(tty)"
    rsync -zvh "$kdot_dir"/aliases ~/.aliases.zsh
    rsync -zvh "$kdot_dir"/functions ~/.functions.zsh
    rsync -zvh "$kdot_dir"/home_env ~/.env
    rsync -azvh "$kdot_dir"/.completions ~/
    echo "Done." 1>>"$(tty)"
} &>>kdotfiles.log

# Installs git dotfiles
install_git_files() {
    # Backs up git files
    file_lst=(".gitconfig" ".gitmessage")
    echo "Creating Backups of git files..." 1>>"$(tty)"
    for i in "${file_lst[@]}"; do 
        if [ -f "$i" ]; then
            rm ~/"$i".bak
            mv ~/"$i" ~/"$i".bak
        fi
    done
    echo "Done..."

    # Syncs git files
    rsync -zvh "$kdot_dir"/gitconfig ~/.gitconfig
    rsync -zvh "$kdot_dir"/gitmessage ~/.gitmessage

    # Sets up personal configuraions
    # Reading Details
    { echo "Setting Up Personal Configurations in git files..."
    read -rp "Enter your full name for .gitconfig: " fullname
    read -rp "Enter your email for .gitconfig: " email
    read -rp "Enter your github username for .gitconfig: " username
    read -rp "Enter a valid editor command for git (default:vim): " editor
    read -rp "Do you want to use GPG signing in git commits and tags? [y/N]: " gpg_choice
    read -rp "Do you want to use a difftool and mergetool? [y/n]: " tool_choice
    } 1>>"$(tty)"

    # Configuring Details
    git config --global user.name "$fullname"
    git config --global user.email "$email"
    git config --global github.user "$username"
    if [ $editor -eq "" || $editor -eq " "]; then
        git config --global core.editor "vim"
    else
        git config --global core.editor "$editor"
    fi

    # Setting up GPG Signing and Diff and Merge Tool
    # Diff and Merge Tool
    case $tool_choice in
    [yY]* ) 
    read -rp "Enter a diff and merge tool (default: vimdiff): "  tool
    if [ $tool -eq "" || $tool -eq " " ]; then
        git config --global diff.tool "vimdiff"
        git config --gloabl difftool.vimdiff.cmd "vimdiff $LOCAL $REMOTE"
        git config --gloabl merge.tool "vimdiff"
        git config --global mergetool.vimdiff.cmd "vimdiff $MERGED $LOCAL $REMOTE"
    else
        read -rp "Enter the valid command for the diff and merge tool: " tool_cmd
        git config --global diff.tool "$tool"
        git config --global difftool."$tool".cmd "$tool_cmd $LOCAL $REMOTE"
        git config --global merge.tool "$tool"
        git config --global mergetool."$tool".cmd "$tool_cmd $MERGED $LOCAL $REMOTE"
    fi ;;
    [nN]* ) 
    git config --global --unset diff.tool
    git config --global --unset merge.tool ;;
    esac

} &>>kdotfiles.log

# Execution