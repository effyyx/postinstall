
# overwrite greeting
# potentially disabling fastfetch
#function fish_greeting

alias ls='eza --icons --group-directories-first'

set -x SPACEFISH_ARROW_COLOR green
set -gx EDITOR nvim
set -g theme_font Hiragino Sans

function y
	set tmp (mktemp -t "yazi-cwd.XXXXXX")
	yazi $argv --cwd-file="$tmp"
	if read -z cwd < "$tmp"; and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
		builtin cd -- "$cwd"
	end
	rm -f -- "$tmp"
end

set -U fish_greeting
starship init fish | source
set -gx EDITOR nvim
