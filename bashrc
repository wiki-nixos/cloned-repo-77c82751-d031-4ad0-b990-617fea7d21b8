# ~/.bashrc: user-specifc .bashrc file for bash(1).
# shellcheck disable=1090

[ -z "$PS1" ] && return

. ~/.shrc

# shellcheck source=.config/fzf/fzf.bash
[ -e "$XDG_CONFIG_HOME"/fzf/fzf.bash ] &&
	. "$XDG_CONFIG_HOME/fzf/fzf.bash"

[ -e ~/.bashrc.local ] &&
	. ~/.bashrc.local

#: https://starship.rs/
if hash starship 2>/dev/null; then
	eval "$(starship init bash)"
fi

#: https://dystroy.org/broot/
function br {
	local cmd cmd_file code
	cmd_file=$(mktemp)
	if broot --outcmd "$cmd_file" "$@"; then
		cmd=$(<"$cmd_file")
		rm -f "$cmd_file"
		eval "$cmd"
	else
		code=$?
		rm -f "$cmd_file"
		return "$code"
	fi
}
