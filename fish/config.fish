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

  set -g FZF_DEFAULT_OPTS "--layout=reverse --cycle --height=40% --color fg:#ebdbb2,bg:#282828,hl:#fabd2f,fg+:#ebdbb2,bg+:#3c3836,hl+:#fabd2f --color info:#83a598,prompt:#bdae93,spinner:#fabd2f,pointer:#83a598,marker:#fe8019,header:#665c54"

  set fish_greeting

  source $HOME/.emacs.d/.local/straight/repos/emacs-libvterm/etc/emacs-vterm.fish
end
