#!/usr/bin/env bash

# Check Requirements
requirements_list=("zsh" "git" "curl" "rsync")
for i in "${requirements_list[@]}"; do
    if ! [ "$(command -v "$i")" ]; then
        echo "$i not installed. Install it and then run the script."
        exit 1
    fi
done

# Create installation files/directories
source sync-functions.sh 
mkdir "$HOME"/.dotfiles_backups "$HOME"/terminal-utilities

# Menu
printf "Hello! This is the KDotfiles Dotfile Selection Menu:\n"
while true; do
    printf "Choose Dotfiles to Install/Sync:\n"
    printf " ,1. gnupg,2. zsh,3. git,4. vim,5. bin\n,6. npmrc,7. bat,8. lazygit,9. lsd\n,10. poetry,11. ngrok,12. starship, 13. topgrade, 14. All" |  column --table -s ","
    read -rp "Choose dotfiles [1-15/q](comma-separated): " CHOOSE
    IFS="," read -ra CHOOSE_ARRAY <<< "$CHOOSE"
    for i in "${CHOOSE_ARRAY[@]}"; do
        if [ "$i" -eq "1" ]; then
            if [ "$(command -v gpg)" ]; then
                sync_gnupg
            else
                echo "GPG is not installed. Skipping."
            fi
        elif [ "$i" -eq "2" ]; then
            if [ "$(command -v omz)" ]; then
                sync_zshrc
                sync_zsh_scripts
            else
                echo "zsh is not installed. Skipping."
            fi
        elif [ "$i" -eq "3" ]; then
            if [ "$(command -v git)" ]; then
                sync_git_files
            else
                echo "git is not installed. Skipping."
            fi
        elif [ "$i" -eq "4" ]; then
            if [ "$(command -v vim)" ]; then
                sync_vim_config
            else
                echo "vim is not installed. Skipping."
            fi
        elif [ "$i" -eq "5" ]; then
            sync_bin_dir
        elif [ "$i" -eq "6" ]; then
            if [ "$(command -v npm)" ]; then
                sync_npm
            else
                echo "npm is not installed. Skipping."
            fi
       elif [ "$i" -eq "7" ]; then
            if [ "$(command -v bat)" ]; then
                sync_bat
            else
                echo "bat is not installed. Skipping."
            fi
        elif [ "$i" -eq "8" ]; then
            if [ "$(command -v lazygit)" ]; then
                sync_lazygit
            else
                echo "lazygit is not installed. Skipping."
            fi
        elif [ "$i" -eq "9" ]; then
            if [ "$(command -v lsd)" ]; then
                sync_lsd
            else
                echo "lsd is not installed. Skipping."
            fi
        elif [ "$i" -eq "10" ]; then
            if [ "$(command -v poetry)" ]; then
                sync_poetry
            else
                echo "poetry is not installed. Skipping."
            fi
        elif [ "$i" -eq "11" ]; then
            if [ "$(command -v ngrok)" ]; then
                sync_ngrok
            else
                echo "ngrok is not installed. Skipping."
            fi
        elif [ "$i" -eq "12" ]; then
            if [ "$(command -v starship)" ]; then
                sync_starship
            else
                echo "starship is not installed. Skipping."
            fi
        elif [ "$i" -eq "13" ]; then
            if [ "$(command -v topgrade)" ]; then
                sync_topgrade
            else
                echo "topgrade is not installed. Skipping."
            fi
        elif [ "$i" -eq "14" ]; then
            sync_all
            break 2
        elif [ "$i" = "q" ]; then
            echo "Exiting..."
            break 2
        else; then
            echo "Invalid Option!"
        fi
    done
done

printf "Dotfiles Installation/Syncing Done.\n"
printf "It's recommended to restart your device. If you encountered any bugs/mistakes:\n"
printf "Please raise an issue at https://github.com/Kunal2007-web/KDotfiles/issues"
