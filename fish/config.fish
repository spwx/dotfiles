if status --is-interactive
  set -l os (uname)
  if test "$os" = Darwin
    eval (/opt/homebrew/bin/brew shellenv)
    alias ls="gls --color -F"
  end

  starship init fish | source
  alias e='emacsclient -n -a ""'

  set -gx PATH "$HOME/.cargo/bin" $PATH
  set -gx PATH "$HOME/.local/bin" $PATH

  alias ssh="env TERM=xterm-256color ssh"
  set -gx LC_ALL en_US.UTF-8
  set -gx LANG en_US.UTF-8
  set -gx LANGUAGE en_US.UTF-8

  set -gx FZF_DEFAULT_OPTS "--layout=reverse --cycle --height=40% --color=bg+:#3c3836,bg:#32302f,spinner:#fb4934,hl:#928374,fg:#ebdbb2,header:#928374,info:#8ec07c,pointer:#fb4934,marker:#fb4934,fg+:#ebdbb2,prompt:#fb4934,hl+:#fb4934"
  set -gx BAT_THEME "gruvbox-dark"

  set fish_greeting

  source $HOME/.emacs.d/.local/straight/repos/emacs-libvterm/etc/emacs-vterm.fish
end
