#!/usr/bin/env bash

# Check Requirements
requirements_list=("zsh" "git" "curl" "rsync" "omz")
for i in "${requirements_list[@]}"; do
    if ! [ "$(command -v "$i")" ]; then
        echo "$i not installed. Install it and then run the script."
        exit 1
    fi
done

# Create installation files/directories
echo "#!/usr/bin/env bash" > dotfiles.sh
echo "source sync-functions.sh" >> dotfiles.sh
mkdir "$HOME"/.dotfiles_backups "$HOME"/terminal-utilities

# Menu
printf "Hello! This is the KDotfiles Dotfile Selection Menu:\n"
while true; do
    printf "Choose Dotfiles to Install/Sync:\n"
    printf " ,1. gnupg,2. zsh,3. git,4. vim,5. bin\n,6. npmrc,7. amfora,8. bat,9. lazygit,10. lsd\n,11. poetry,12. ngrok,13. starship, 14. topgrade, 15. All" |  column --table -s ","
    read -rp "Choose dotfiles [1-15/q](comma-separated): " CHOOSE
    IFS="," read -ra CHOOSE_ARRAY <<< "$CHOOSE"
    for i in "${CHOOSE_ARRAY[@]}"; do
        if [ "$i" -eq "1" ]; then
            if [ "$(command -v gpg)" ]; then
                echo "sync_gnupg" >> dotfiles.sh
            else
                echo "GPG is not installed. Skipping."
            fi
        elif [ "$i" -eq "2" ]; then
            if [ "$(command -v omz)" ]; then
                echo "sync_zshrc" >> dotfiles.sh
                echo "sync_zsh_scripts" >> dotfiles.sh
            else
                echo "zsh is not installed. Skipping."
            fi
        elif [ "$i" -eq "3" ]; then
            if [ "$(command -v git)" ]; then
                echo "sync_git_files" >> dotfiles.sh
            else
                echo "git is not installed. Skipping."
            fi
        elif [ "$i" -eq "4" ]; then
            if [ "$(command -v vim)" ]; then
                echo "sync_vim_config" >> dotfiles.sh
            else
                echo "vim is not installed. Skipping."
            fi
        elif [ "$i" -eq "5" ]; then
            echo "sync_bin_dir" >> dotfiles.sh
        elif [ "$i" -eq "6" ]; then
            if [ "$(command -v npm)" ]; then
                echo "sync_npm" >> dotfiles.sh
            else
                echo "npm is not installed. Skipping."
            fi
        elif [ "$i" -eq "7" ]; then
            if [ "$(command -v amfora)" ]; then
                echo "sync_amfora" >> dotfiles.sh
            else
                echo "amfora is not installed. Skipping."
            fi
        elif [ "$i" -eq "8" ]; then
            if [ "$(command -v bat)" ]; then
                echo "sync_bat" >> dotfiles.sh
            else
                echo "bat is not installed. Skipping."
            fi
        elif [ "$i" -eq "9" ]; then
            if [ "$(command -v lazygit)" ]; then
                echo "sync_lazygit" >> dotfiles.sh
            else
                echo "lazygit is not installed. Skipping."
            fi
        elif [ "$i" -eq "10" ]; then
            if [ "$(command -v lsd)" ]; then
                echo "sync_lsd" >> dotfiles.sh
            else
                echo "lsd is not installed. Skipping."
            fi
        elif [ "$i" -eq "11" ]; then
            if [ "$(command -v poetry)" ]; then
                echo "sync_poetry" >> dotfiles.sh
            else
                echo "poetry is not installed. Skipping."
            fi
        elif [ "$i" -eq "12" ]; then
            if [ "$(command -v ngrok)" ]; then
                echo "sync_ngrok" >> dotfiles.sh
            else
                echo "ngrok is not installed. Skipping."
            fi
        elif [ "$i" -eq "13" ]; then
            if [ "$(command -v starship)" ]; then
                echo "sync_starship" >> dotfiles.sh
            else
                echo "starship is not installed. Skipping."
            fi
        elif [ "$i" -eq "14" ]; then
            if [ "$(command -v topgrade)" ]; then
                echo "sync_topgrade" >> dotfiles.sh
            else
                echo "topgrade is not installed. Skipping."
            fi
        elif [ "$i" -eq "15" ]; then
            echo "sync_all" >> dotfiles.sh
            break 2
        elif [ "$i" = "q" ]; then
            echo "Exiting..."
            break 2
        fi
    done
done

sh dotfiles.sh
printf "Dotfiles Installation/Syncing Done.\n"
printf "It's recommended to restart your device. If you encountered any bugs/mistakes:\n"
printf "Please raise an issue at https://github.com/Kunal2007-web/KDotfiles/issues"