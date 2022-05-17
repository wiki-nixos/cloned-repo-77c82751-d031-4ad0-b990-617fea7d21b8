#!/usr/bin/env sh
#
# shellcheck disable=SC1090,SC1091

export ENV="$HOME/.shrc"

# export GIT_CURL_VERBOSE=true
# export GIT_CONFIG_NOSYSTEM=true
# export GIT_TRACE=true
# export GIT_TRACE_PACKET=true
# export GIT_TRACE_PERFORMANCE=true
# export GIT_TRACE_SETUP=true

export FZF_DEFAULT_OPTS="--color 'bg+:239,marker:226'"
export FZF_CTRL_R_OPTS="--sort"
export FZF_CTRL_T_COMMAND='rg --files --hidden --follow --no-messages --glob "!.git/"'
export FZF_CTRL_T_OPTS="--preview 'bat {} --color=always --line-range :30'"
export FZF_ALT_C_COMMAND='fasd_cd -d -l -R'
export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -200'"

export NIX_PATH="$HOME/.nix-defexpr/channels${NIX_PATH:+:}$NIX_PATH"

export RESTIC_PASSWORD_COMMAND='pass show restic'

[ -e "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"

[ -e "$HOME/.asdf/asdf.sh" ] && . "$HOME/.asdf/asdf.sh"

[ -e "$HOME/.nix-profile/etc/profile.d/nix.sh" ] && . "$HOME/.nix-profile/etc/profile.d/nix.sh"

[ -e "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh" ] && . "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"

if [ -d "$HOME/.profile.d" ]; then
  for f in "$HOME"/.profile.d/*; do
    if [ -f "$f" ]; then . "$f"; fi
  done
  unset f
fi

case ":$XDG_DATA_DIRS:"  in
*":$HOME/.nix-profile/share:"*) ;;
*) export XDG_DATA_DIRS="$HOME/.nix-profile/share:$XDG_DATA_DIRS"
esac

export DOOMDIR="$HOME/.config/doom"

PATH="$PATH:/usr/local/go/bin"
PATH="$HOME/.krew/bin:$PATH"
PATH="$HOME/.deno/bin:$PATH"
PATH="$HOME/.local/share/gem/ruby/2.7.0/bin:$PATH" # quickfix
PATH="$HOME/.local/share/flatpak/exports/bin:$PATH"
PATH="$HOME/src/github.com/npryce/adr-tools/src:$PATH"
PATH="$HOME/.fzf/share/bin:$PATH"
PATH="$HOME/.emacs.d/bin:$PATH"
PATH="$HOME/.local/bin:$PATH"
PATH="$HOME/bin:$PATH"

export PATH

## Host

! [ -e "$HOME/.profile.local" ] || . "$HOME/.profile.local"
