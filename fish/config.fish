# this config requires the installation of:
# exa, bat, zoxide, and starship

if status --is-interactive
  set fish_greeting

  set -l os (uname)
  if test "$os" = Darwin
    if test -e /opt/homebrew/bin/brew
      eval (/opt/homebrew/bin/brew shellenv)
    else if test -e /usr/local/bin/brew
      eval (/usr/local/bin/brew shellenv)
    end
  end

  starship init fish | source
  # zoxide init fish | source

  alias ls "exa"
  set -gx LS_COLORS (vivid generate gruvbox-dark-hard)

  alias cd "z"

  alias cat "bat"
  set -gx BAT_THEME "gruvbox-dark"
  set -gx BAT_STYLE "plain"

  set -gx FZF_DEFAULT_OPTS "--layout=reverse --cycle --height=40% --color=bg+:#3c3836,bg:#32302f,spinner:#fb4934,hl:#928374,fg:#ebdbb2,header:#928374,info:#8ec07c,pointer:#fb4934,marker:#fb4934,fg+:#ebdbb2,prompt:#fb4934,hl+:#fb4934"

  set -gx PATH "$HOME/.cargo/bin" $PATH
  set -gx PATH "$HOME/.local/bin" $PATH

  alias ssh="env TERM=xterm-256color ssh"
  set -gx LC_ALL en_US.UTF-8
  set -gx LANG en_US.UTF-8
  set -gx LANGUAGE en_US.UTF-8

  alias e='emacsclient -n -a ""'
  source $HOME/.emacs.d/.local/straight/repos/emacs-libvterm/etc/emacs-vterm.fish
end
