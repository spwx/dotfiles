if status --is-interactive
  eval (/opt/homebrew/bin/brew shellenv)

  starship init fish | source
  alias ls="gls --color -F"
  alias pwcopy="tr -d '\n' | pbcopy"
  # alias e="emacsclient -n"
  alias e='emacsclient -nw -a ""'

  set -gx PATH "$HOME/.cargo/bin" $PATH
  set -gx PATH "$HOME/.local/bin" $PATH

  alias ssh="env TERM=xterm-256color ssh"
  set -gx LC_ALL en_US.UTF-8
  set -gx LANG en_US.UTF-8
  set -gx LANGUAGE en_US.UTF-8
end
