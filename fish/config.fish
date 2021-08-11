if status --is-interactive
  set -l os (uname)
  if test "$os" = Darwin
    eval (/opt/homebrew/bin/brew shellenv)
    alias ls="gls --color -F"
    alias pwcopy="tr -d '\n' | pbcopy"
  end

  starship init fish | source
  alias e='emacsclient -nw -a ""'

  set -gx PATH "$HOME/.cargo/bin" $PATH
  set -gx PATH "$HOME/.local/bin" $PATH

  alias ssh="env TERM=xterm-256color ssh"
  set -gx LC_ALL en_US.UTF-8
  set -gx LANG en_US.UTF-8
  set -gx LANGUAGE en_US.UTF-8
end
