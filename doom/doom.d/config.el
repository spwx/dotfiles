;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "John Doe"
      user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;; (setq doom-font (font-spec :family "monospace" :size 12 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "sans" :size 13))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-gruvbox)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
;; (setq display-line-numbers-type t)
(setq display-line-numbers-type 'nil)


;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

(map! :desc "parent headline"
      :map org-mode-map
      :n
      "z u" #'outline-up-heading)

(map! :n "U" 'undo-tree-visualize)

(setq projectile-project-search-path '("~/projects/"))

(setq org-startup-folded t)

(setq ispell-personal-dictionary "~/.aspell.en.pws")

(setq confirm-kill-emacs nil)


(setq deft-directory "~/org")

(after! persp-mode
  (setq persp-emacsclient-init-frame-behaviour-override "main"))

;; (server-start)

;; GUI Settings
(when (display-graphic-p)
  (setq doom-font (font-spec :family "JetBrains Mono" :size 15)
        doom-big-font (font-spec :family "JetBrains Mono" :size 36))

  (setq-default line-spacing 0.1)

  (use-package! doom-modeline
    :custom-face
    (mode-line ((t (:height 0.85))))
    (mode-line-inactive ((t (:height 0.85))))))

;; Terminal Settings
(unless (display-graphic-p)
  ;; better touch scroll on iPad
  (xterm-mouse-mode t)
  (global-set-key (kbd "<mouse-4>") 'scroll-down-line)
  (global-set-key (kbd "<mouse-5>") 'scroll-up-line)

  ;; tell tmux to enable CSI u mode
  (when (getenv "TMUX")
    (send-string-to-terminal "\033[>4;1m")))


(use-package! lsp-rust
  :config
  (setq! lsp-rust-analyzer-server-display-inlay-hints t
         lsp-rust-analyzer-max-inlay-hint-length 25
         lsp-rust-analyzer-display-chaining-hints t
         lsp-rust-analyzer-display-parameter-hints t))

(map! :desc "reposition to code"
      :map rustic-mode-map
      :n
      "z z" #'reposition-window)

(use-package! org-roam
  :custom
  (setq org-roam-directory "~/org/roam")
  (org-roam-dailies-capture-templates
   '(("d" "default" entry "* %<%I:%M %p>: %?"
      :if-new (file+head "%<%Y-%m-%d>.org" "#+title: %<%Y-%m-%d>\n")))))

;; emacs-libvterm
;; --------------
;;
;; bring back the modeline when run from TTY
(unless (display-graphic-p)
(remove-hook! 'vterm-mode-hook 'hide-mode-line-mode))
;;
;; close window when vterm exits:
;; https://github.com/akermu/emacs-libvterm/issues/24#issuecomment-907660950
(add-hook 'vterm-exit-functions
(lambda (_a _b)
(let* ((buffer (current-buffer))
        (window (get-buffer-window buffer)))
        (when (not (one-window-p))
        (delete-window window))
        (kill-buffer buffer))))
;;
;; escape vim inside of emacs
(map! :desc "send escape to vterm"
      :after vterm
      :map vterm-mode-map
      "C-c <escape>" #'vterm-send-escape)
