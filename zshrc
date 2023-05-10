# ZSH Configuration File - Kunal Kumar
# Load Environment Variables
source ~/.env

# Path to oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set Zsh Theme
ZSH_THEME="robbyrussell"

# Disable auto-setting terminal title.
DISABLE_AUTO_TITLE="true"

# Enable command auto-correction.
ENABLE_CORRECTION="true"

# Completion Scripts
source ~/.completions/gh.zsh
source ~/.completions/npm.zsh
source ~/.completions/ngrok.zsh
source ~/.completions/typioca.zsh
source ~/.completions/netlify.zsh
source ~/.completions/starship.zsh

# Plugins and Additional Scripts
plugins=(git zsh-autosuggestions zsh-syntax-highlighting web-search)

source ~/.aliases.zsh
source ~/.functions.zsh
source ~/terminal-utilities/zsh-autocomplete/zsh-autocomplete.plugin.zsh
source $ZSH/oh-my-zsh.sh

# Start Up
if [ "$(command -v theme.sh)" ]; then
    theme.sh argonaut
fi

if [ "$(command -v starship)" ]; then
    eval "$(starship init zsh)"
fi

if [ "$(command -v )" ]; then
    please
fi

if [ "$(command -v )" ]; then
    pfetch
fi
