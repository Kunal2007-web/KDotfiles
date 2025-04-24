# ZSH Configuration File - Kunal Kumar
# Load Environment Variables
source ~/.env

# Load Homebrew
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# Utility functions for zoxide.
# pwd based on the value of _ZO_RESOLVE_SYMLINKS.
function __zoxide_pwd() {
    \builtin pwd -L
}

# cd + custom logic based on the value of _ZO_ECHO.
function __zoxide_cd() {
    # shellcheck disable=SC2164
    \builtin cd -- "$@"
}

# Hook to add new entries to the database.
function __zoxide_hook() {
    # shellcheck disable=SC2312
    \command zoxide add -- "$(__zoxide_pwd)"
}

# Initialize hook.
# shellcheck disable=SC2154
if [[ ${precmd_functions[(Ie)__zoxide_hook]:-} -eq 0 ]] && [[ ${chpwd_functions[(Ie)__zoxide_hook]:-} -eq 0 ]]; then
    chpwd_functions+=(__zoxide_hook)
fi

__zoxide_z_prefix='z#'

# Jump to a directory using only keywords.
function __zoxide_z() {
    # shellcheck disable=SC2199
    if [[ "$#" -eq 0 ]]; then
        __zoxide_cd ~
    elif [[ "$#" -eq 1 ]] && { [[ -d "$1" ]] || [[ "$1" = '-' ]] || [[ "$1" =~ ^[-+][0-9]$ ]]; }; then
        __zoxide_cd "$1"
    elif [[ "$@[-1]" == "${__zoxide_z_prefix}"?* ]]; then
        # shellcheck disable=SC2124
        \builtin local result="${@[-1]}"
        __zoxide_cd "${result:${#__zoxide_z_prefix}}"
    else
        \builtin local result
        # shellcheck disable=SC2312
        result="$(\command zoxide query --exclude "$(__zoxide_pwd)" -- "$@")" &&
            __zoxide_cd "${result}"
    fi
}

# Jump to a directory using interactive search.
function __zoxide_zi() {
    \builtin local result
    result="$(\command zoxide query --interactive -- "$@")" && __zoxide_cd "${result}"
}

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
    theme.sh duotone-dark
fi
