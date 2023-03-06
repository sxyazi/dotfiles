# Paths
set -g fish_user_paths ~/go/bin $fish_user_paths
set -g fish_user_paths ~/.cargo/bin $fish_user_paths
set -g fish_user_paths ~/.composer/vendor/bin $fish_user_paths
if [ (uname -sm) = "Darwin arm64" ]; set -g fish_user_paths /opt/homebrew/bin $fish_user_paths; end

# Environment
set -x HOMEBREW_NO_ANALYTICS 1

# Key bindings
bind \cn beginning-of-line
bind \ci end-of-line
bind \cb backward-word
bind \ch forward-word
#bind \cw forward-bigword
bind \b  backward-kill-line  # C-Backspace

# Alias
alias p="pwd"
alias o="open ."
alias l="exa --icons --group-directories-first"
alias ls="exa -al --icons --group-directories-first"
alias vim="nvim"
alias cat="bat --theme Dracula"
alias du="dust -r -n 999999999"
alias icpng="mkdir converted-images; sips -s format png * --out converted-images"
alias icjpg="mkdir converted-images; sips -s format jpeg * --out converted-images"

# Functions
function pb
	git add -A
	git commit -m "chore: publish"
	git push
end
function tc
	set TEMP_DIR $(mktemp -d)
	cd $TEMP_DIR
	code $TEMP_DIR
end

# Initialize tools
starship init fish | source
zoxide init fish | source
