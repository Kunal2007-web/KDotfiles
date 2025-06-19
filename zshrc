# ZSH Configuration File - Kunal Kumar
# Load Environment Variables
source ~/.env

# Load Homebrew
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"


# Completion Scripts
if [ "$(command -v gh)" ]; then
    source ~/.completions/gh.zsh
fi

if [ "$(command -v npm)" ]; then
    source ~/.completions/npm.zsh
fi

if [ "$(command -v ngrok)" ]; then
    source ~/.completions/ngrok.zsh
fi

if [ "$(command -v typioca)" ]; then
    source ~/.completions/typioca.zsh
fi

if [ "$(command -v netlify)" ]; then
    source ~/.completions/netlify.zsh
fi

if [ "$(command -v zoxide)" ]; then
    source ~/.completions/zoxide.zsh
fi

if [ "$(command -v glow)" ]; then
    source ~/.completions/glow.zsh
fi

if [ "$(command -v fzf)" ]; then
    source ~/.completions/fzf.zsh
fi

# Plugins and Additional Scripts
plugins=(git zsh-autosuggestions zsh-syntax-highlighting web-search)

source ~/.aliases.zsh
source ~/.functions.zsh
source ~/terminal-utilities/zsh-autocomplete/zsh-autocomplete.plugin.zsh
source $ZSH/oh-my-zsh.sh

# Start Up
if [ "$(command -v starship)" ]; then
    eval "$(starship init zsh)"
fi

if [ "$(command -v zoxide)" ]; then
    eval "$(zoxide init zsh)"
fi

if [ "$(command -v please)" ]; then
    please
fi

if [ "$(command -v nitch)" ]; then
    nitch
fi

if [ "$(command -v theme.sh)" ]; then
    theme.sh gruvbox-dark
fi

if [ "$(command -v zellij)" ]; then
    eval "$(zellij setup --generate-auto-start zsh)" 
fi
