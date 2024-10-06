# Alias
alias ..="cd .."
alias ...="cd ../.."
alias ~="cd ~"
alias -- -="cd -"

alias p="pwd"
alias v="nvim"
alias l="eza -al --icons --group-directories-first"
alias ll="eza -a --icons --group-directories-first"
alias ssh="kitty +kitten ssh"
alias du="dust -r -n 999999999"
alias tree="tree -aC"
alias icpng="mkdir converted-images; sips -s format png * --out converted-images"
alias icjpg="mkdir converted-images; sips -s format jpeg * --out converted-images"

alias g='XDG_CONFIG_HOME="$HOME/.config" lazygit'
alias gs="git status"
alias ga="git add -A"
alias gc="git commit -v"
alias gc!="git commit -v --amend --no-edit"
alias gl="git pull"
alias gp="git push"
alias gp!="git push --force"
alias gcl="git clone --depth 1 --single-branch"
alias gf="git fetch --all"
alias gb="git branch"
alias gr="git rebase"
alias gt='cd "$(git rev-parse --show-toplevel)"'

alias rl="echo '' > ~/.local/state/yazi/yazi.log; tail -F ~/.local/state/yazi/yazi.log"
alias rr="~/Desktop/yazi/target/debug/yazi --clear-cache"

function y() {
	if [ -n "$YAZI_LEVEL" ]; then
		exit
	fi

	local tmp="$(mktemp -t "yazi-cwd.XXXXX")"
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

function gpr() {
	local username=$(git config user.name)
	if [ -z "$username" ]; then
		echo "Please set your git username"
		return 1
	fi

	local origin=$(git config remote.origin.url)
	if [ -z "$origin" ]; then
		echo "No remote origin found"
		return 1
	fi

	local remote_username=$(basename $(dirname $origin))
	if [ "$remote_username" != "$username" ]; then
		local new_origin=${origin/\/$remote_username\//\/$username\/}
		new_origin=${new_origin/https:\/\/github.com\//git@github.com:/}

		git config remote.origin.url $new_origin
		git remote remove upstream > /dev/null 2>&1
		git remote add upstream $origin
	fi

	git checkout -b "pr-$(openssl rand -hex 4)"
}

# Change Yazi's CWD to PWD on subshell exit
if [[ -n "$YAZI_ID" ]]; then
	function _yazi_cd() {
		ya pub dds-cd --str "$PWD"
	}
	add-zsh-hook zshexit _yazi_cd
fi
