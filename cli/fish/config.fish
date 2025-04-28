# this config requires the installation of:
# exa, bat, and starship

if status --is-interactive
    set fish_greeting
    set -gx PATH "$HOME/.local/bin" $PATH
    set -gx COLORTERM truecolor

    if test (uname) = Darwin
        eval (/opt/homebrew/bin/brew shellenv)
        set -gx INFOPATH /opt/homebrew/share/info/emacs $INFOPATH
        set -gx EDITOR /opt/homebrew/bin/nvim
    end

    alias vi nvim

    if test -n "$SSH_TTY" || test -n "$ET_VERSION"
        if test -n "$TMUX"
            tmux set-option status-bg green
            tmux set-option status-fg black
        end
    end

    alias ls eza
    set -gx LS_COLORS (vivid generate gruvbox-dark-hard)

    alias cat bat
    set -gx BAT_THEME gruvbox-dark
    set -gx BAT_STYLE plain
    set -gx FZF_DEFAULT_OPTS "--layout=reverse --cycle --height=40% --color=bg+:#3c3836,bg:#32302f,spinner:#fb4934,hl:#928374,fg:#ebdbb2,header:#928374,info:#8ec07c,pointer:#fb4934,marker:#fb4934,fg+:#ebdbb2,prompt:#fb4934,hl+:#fb4934"

    alias ssh="env TERM=xterm-256color ssh"

    set -gx PATH "$HOME/.cargo/bin" $PATH
    set -gx LC_ALL en_US.UTF-8
    set -gx LANG en_US.UTF-8
    set -gx LANGUAGE en_US.UTF-8

    alias e='emacsclient -n -a ""'
    # source $HOME/.emacs.d/.local/straight/repos/emacs-libvterm/etc/emacs-vterm.fish

    starship init fish | source

    fzf --fish | source

    # pnpm
    set -gx PNPM_HOME /Users/spwx/Library/pnpm
    if not string match -q -- $PNPM_HOME $PATH
        set -gx PATH "$PNPM_HOME" $PATH
    end
    # pnpm end

    set -gx PATH "$HOME/go/bin" $PATH
end
