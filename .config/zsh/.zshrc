###~~~~~~~~~~~~~~~~~~~~~~~~Zoomer shell~~~~~~~~~~~~~~~~~~~~~~~~~###
###            )    )`					 	                    ###
###     (     /\)  ((    (  `     `       (         )       (	###
###    ))/   (  (__/     )(      (     `  )        /(      /(	###
###   /((_) )\) /\ \__  (()\     )/    /(/(      )(_)     \()	###
###  (_))   (_\_\ \ ,_\  ((_)_  ((_)  ((_)_\    ((_)    (_(\\	###
###  /'__`\/' _ `\ \ \/ /\` __\/'__`\/\ '__`\  /'__`\  /\'\/'\	###
### /\  __//\ \/\ \ \ \_\ \ \//\ \L\ \ \ \L\ \/\ \L\.\_\/>  </	###
### \ \____\ \_\ \_\ \__\\ \_\\ \____/\ \ ,__/\ \__/.\_\/\_/\_\	###
###  \/____/\/_/\/_/\/__/ \/_/ \/___/  \ \ \/  \/__/\/_/\//\/_/	###
###                                     \ \_\			        ###
###                                      \/_/			        ###
###~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~###
###Author:    Cain Maxwell <entropax@posteo.net>~~~~~~~~~~~~~~~~###
###~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~###

### More colors and rice promtp:
source ~/.config/zsh/zsh-git-prompt/zshrc.sh
autoload -U colors && colors	# Load colors
setopt autocd		            # Automatically cd into typed directory.
setopt interactive_comments



PS1=$'┏╸%(?..%F{red}%?%f · )%B%(6~|%-3~/.../%2~|%3~)%b\n\\
┗╸%F{blue}❯%f%F{cyan}❯%f%F{green}❯%f '
RPS1='%@  $(git_super_status)'
#For short path user $'%(5~|%-2~/.../%2~|%3~)' (if |true|false)
# Old prompt
#PS1=$'%B%{$fg[red]%}[%{$fg[yellow]%}%n%{$fg[green]%}@%{$fg[blue]%}%M \\
#%{$fg[magenta]%}%~%{$fg[red]%}]%{$reset_color%}$%b$(git_super_status) '

### Main options
#stty stop undef		        # Disable ctrl-s to freeze terminal.

### History in cache directory:
HISTSIZE=1000000
SAVEHIST=1000000
HISTFILE=~/.cache/zsh/history

### Nice keybindings:
bindkey -s '^o' 'lfcd\n'
bindkey -s '^a' 'bc -lq\n'
bindkey -s '^f' 'cd "$(dirname "$(fzf)")"\n'
bindkey '^[[P' delete-char

### Load aliases and shortcuts if existent.
[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/shell/aliasrc" ] && source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/aliasrc"
[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/shell/shortcutrc" ] && source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/shortcutrc"

### Basic auto/tab complete:
autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)		# Include hidden files.

### vi mode for nice interactive:
bindkey -v
export KEYTIMEOUT=1

### Use vim keys in tab complete menu:
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'h' vi-backward-char
bindkey -v '^?' backward-delete-char

### Change cursor shape for different vi modes.
function zle-keymap-select () {
    case $KEYMAP in
        vicmd) echo -ne '\e[1 q';;      # block
        viins|main) echo -ne '\e[5 q';; # beam
    esac
}
zle -N zle-keymap-select
zle-line-init() {
    zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
    echo -ne "\e[5 q"
}
zle -N zle-line-init
echo -ne '\e[5 q' # Use beam shape cursor on startup.
preexec() { echo -ne '\e[5 q' ;} # Use beam shape cursor for each new prompt.

### Use lf to switch directories and bind it to ctrl-o
lfcd () {
    tmp="$(mktemp)"
    lf -last-dir-path="$tmp" "$@"
    if [ -f "$tmp" ]; then
        dir="$(cat "$tmp")"
        rm -f "$tmp" >/dev/null
        [ -d "$dir" ] && [ "$dir" != "$(pwd)" ] && cd "$dir"
    fi
}


### Edit line in vim with ctrl-e:
autoload edit-command-line; zle -N edit-command-line
bindkey '^e' edit-command-line

### Load syntax highlighting; should be last option in zshrc.
source /usr/share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh 2>/dev/null
