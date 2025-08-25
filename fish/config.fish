# this config requires the installation of:
# exa, bat, and starship

if status --is-interactive
    set fish_greeting
    set -gx COLORTERM truecolor

    # PATH Setup -- Must come early
    set -gx PATH "$HOME/go/bin" $PATH
    set -gx PATH "$HOME/.toolbox/bin" $PATH
    set -gx PATH "$HOME/.local/bin" $PATH

    # Setup Homebrew -- Must come early
    if test -x /opt/homebrew/bin/brew
        eval (/opt/homebrew/bin/brew shellenv)
        set -gx INFOPATH /opt/homebrew/share/info/emacs $INFOPATH
    end

    # Starship Setup
    starship init fish | source

    # Neovim Setup
    if type -q nvim
        set -gx EDITOR (command -s nvim)
        alias vi nvim
    end

    # SSH setup
    if test -n "$SSH_TTY" || test -n "$ET_VERSION"
        if test -n "$TMUX"
            tmux set-option status-bg green
            tmux set-option status-fg black
        end
    end
    alias ssh="env TERM=xterm-256color ssh"

    # Setup Eza
    alias ls eza
    set -gx LS_COLORS (vivid generate gruvbox-dark-hard)

    # Setup Bat
    set -gx BAT_THEME gruvbox-dark
    set -gx BAT_STYLE plain
    if type -q bat
        alias cat bat
    else if type batcat
        alias cat batcat
    end

    # Setup Rust
    set -gx PATH "$HOME/.cargo/bin" $PATH
    set -gx LC_ALL en_US.UTF-8
    set -gx LANG en_US.UTF-8
    set -gx LANGUAGE en_US.UTF-8

    alias e='emacsclient -n -a ""'
    # source $HOME/.emacs.d/.local/straight/repos/emacs-libvterm/etc/emacs-vterm.fish

    # fzf --fish | source
    # set -gx FZF_DEFAULT_OPTS "--layout=reverse --cycle --height=40% --color=bg+:#3c3836,bg:#32302f,spinner:#fb4934,hl:#928374,fg:#ebdbb2,header:#928374,info:#8ec07c,pointer:#fb4934,marker:#fb4934,fg+:#ebdbb2,prompt:#fb4934,hl+:#fb4934"
    atuin init fish | source

    # pnpm
    set -gx PNPM_HOME /Users/spwx/Library/pnpm
    if not string match -q -- $PNPM_HOME $PATH
        set -gx PATH "$PNPM_HOME" $PATH
    end
    # pnpm end

    # Setup PATH
    set -gx PATH "$HOME/go/bin" $PATH
    set -gx PATH "$HOME/.toolbox/bin" $PATH
    set -gx PATH "$HOME/.local/bin" $PATH
end

# The below may not be necessary anymore due to the line below this block
# if test "$TERM_PROGRAM" != "kiro"
#     starship init fish | source
# end

string match -q "$TERM_PROGRAM" "kiro" and . (kiro --locate-shell-integration-path fish)


# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH
