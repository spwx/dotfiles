;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "John Doe"
      user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-unicode-font' -- for unicode glyphs
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
(setq doom-font (font-spec :family "VictorMono Nerd Font" :size 20 :weight 'medium))

;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-gruvbox)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
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
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

(map! :desc "parent headline"
      :map org-mode-map
      :n
      "z u" 'org-up-element)

(map! :n "U" 'undo-tree-visualize)

(map! :n "g h" 'evil-first-non-blank)
(map! :v "g h" 'evil-first-non-blank)
(map! :n "g l" 'evil-end-of-line)
(map! :v "g l" 'evil-end-of-line)

(setq projectile-project-search-path '("~/projects/"))

(use-package! org
  :config (setq org-startup-folded t))

;; (setq ispell-personal-dictionary "~/.aspell.en.pws")

(setq confirm-kill-emacs nil)

;; (setq evil-snipe-scope 'whole-buffer)

(setq deft-directory "~/org")

;; (after! persp-mode
;;   (setq persp-emacsclient-init-frame-behaviour-override "main"))

;; ;; (server-start)

;; ;; GUI Settings
;; (when (display-graphic-p)
;;   (setq doom-font (font-spec :family "VictorMono NF" :size 15)))
;; ;; (when (display-graphic-p)
;; ;;   (setq doom-font (font-spec :family "JetBrainsMono Nerd Font" :size 15)
;; ;;         doom-big-font (font-spec :family "JetBrainsMono Nerd Font" :size 36))

;; ;;   (setq-default line-spacing 0.1)

;; ;;   ;; (use-package! doom-modeline
;; ;;   ;;   :custom-face
;; ;;   ;;   (mode-line ((t (:height 0.85))))
;; ;;   ;;   (mode-line-inactive ((t (:height 0.85)))))
;; ;; )

;; ;; Terminal Settings
;; (unless (display-graphic-p)
;;   ;; better touch scroll on iPad
;;   (xterm-mouse-mode t)
;;   (global-set-key (kbd "<mouse-4>") 'scroll-down-line)
;;   (global-set-key (kbd "<mouse-5>") 'scroll-up-line)

;;   ;; tell tmux to enable CSI u mode
;;   (when (getenv "TMUX")
;;     (send-string-to-terminal "\033[>4;1m")))


(use-package! lsp-rust
  :config
  (setq! lsp-inlay-hint-enable t
         lsp-rust-analyzer-max-inlay-hint-length 25
         lsp-rust-analyzer-display-chaining-hints t
         lsp-rust-analyzer-display-parameter-hints t))

;; (map! :desc "Open external docs"
;;       :after rustic
;;       :map rustic-mode-map
;;       :n
;;       "SPC m d" #'lsp-rust-analyzer-open-external-docs)

(map! :desc "reposition to code"
      :map rustic-mode-map
      :n
      "z z" #'reposition-window)

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
;; quick escape inside vterm
(map! :desc "send escape to vterm"
      :after vterm
      :map vterm-mode-map
      "C-c <escape>" #'vterm-send-escape)

;; ;; Fix tmux cursor shaping. Found here:
;; ;; https://github.com/7696122/evil-terminal-cursor-changer/issues/29
;; (advice-add 'etcc--make-tmux-seq :override #'identity)

;; ;; org-store-link uses a headline's ID (if it has one)
;; ;; org-insert-last-stored-link
;; (after! org
;;   (setq org-id-link-to-org-use-id 'use-existing))

;; ;; make OSC-52 work inside of mosh
;; ;; https://github.com/spudlyo/clipetty/issues/9#issuecomment-1289300261
;; (setq clipetty-tmux-ssh-tty "echo \"SSH_TTY=$(tmux display-message -p '#{pane_tty}')\"")

;; ;; for rounded borders with emacs-plus 29 and above
;; ;; (add-to-list 'default-frame-alist '(undecorated-round . t))

;; (setq doom-modeline-icon nil)


;; ;; Fix evil-search in org-mode
;; ;; https://github.com/doomemacs/doomemacs/issues/6478
;; ;; https://github.com/emacs-evil/evil/issues/1630#issuecomment-1406169113
;; (setq org-fold-core-style 'overlays)

;; ;; (evil-select-search-module 'evil-search-module 'evil-search)

;; ;; https://github.com/zerolfx/copilot.el/issues/193#issue-1936577081
;; ;; accept completion from copilot and fallback to company
;; (use-package! copilot
;;   :hook (prog-mode . copilot-mode)
;;   :bind (:map copilot-completion-map
;;               ("<tab>" . 'copilot-accept-completion)
;;               ("TAB" . 'copilot-accept-completion)
;;               ("C-TAB" . 'copilot-accept-completion-by-word)
;;               ("C-<tab>" . 'copilot-accept-completion-by-word)))

;; (after! (evil copilot)
;;   ;; Define the custom function that either accepts the completion or does the default behavior
;;   (defun my/copilot-tab-or-default ()
;;     (interactive)
;;     (if (and (bound-and-true-p copilot-mode)
;;              ;; Add any other conditions to check for active copilot suggestions if necessary
;;              )
;;         (copilot-accept-completion)
;;       (evil-insert 1))) ; Default action to insert a tab. Adjust as needed.

;;   ;; Bind the custom function to <tab> in Evil's insert state
;;   (evil-define-key 'insert 'global (kbd "<tab>") 'my/copilot-tab-or-default))

;; ;; Italicize comments
;; ;; (after! doom-themes
;; ;;   (setq doom-themes-enable-italic t)
;; ;;   (custom-set-faces!
;; ;;     '(font-lock-comment-face :slant italic)))

;; (defun disable-company-auto-completion ()
;;   (setq-local company-idle-delay nil))
;; (add-hook! 'org-mode-hook #'disable-company-auto-completion)

;; (setq treemacs-no-png-images t)

;; ;; (use-package! gptel
;; ;;   :config
;; ;;   (setq! gptel-model "gpt-4-1106-preview")
;; ;;   (setq! gptel-prompt-prefix-alist
;; ;;          '((markdown-mode . "### ")
;; ;;            (org-mode . "* ")
;; ;;            (text-mode . "### ")))
;; ;;   (setq! gptel-default-mode 'org-mode))

;; ;; (map! :desc "org-meta-insert"
;; ;;       :after org
;; ;;       :map org-mode-map
;; ;;       "C-<return>" #'org-meta-return)

;; ;; From: https://zzamboni.org/post/my-doom-emacs-configuration-with-commentary/#general-org-configurationhttps://zzamboni.org/post/my-doom-emacs-configuration-with-commentary/#general-org-configuration
;; ;; I really dislike completion of words as I type prose (in code it’s OK), so I disable it in Org:
;; (defun zz/adjust-org-company-backends ()
;;   (remove-hook 'after-change-major-mode-hook '+company-init-backends-h)
;;   (setq-local company-backends nil))
;; (add-hook! org-mode (zz/adjust-org-company-backends))
;; (after! org (setq org-hide-emphasis-markers t))

;; ;; (defun org-to-clipboard-as-markdown ()
;; ;;   (interactive)
;; ;;   (let ((org-export-with-toc nil))
;; ;;     (with-current-buffer (org-md-export-as-markdown)
;; ;;       (clipboard-kill-region (point-min) (point-max))
;; ;;       (kill-buffer))))

(defun org-to-gfm-to-clipboard ()
  "Convert the current buffer's content from Org toGFM and copy to clipboard."
  (interactive)
  (let* ((org-content (buffer-string))
         (temp-file (make-temp-file "org-to-gfm")))
    (with-temp-file temp-file
      (insert org-content))
    (shell-command (format "pandoc -f org -t gfm --wrap=none %s | sed -E 's|^<https://(.*)>$|![](https://\\1)|' | pbcopy" temp-file))
    (delete-file temp-file)
    (message "Org content converted to GFM and copied to clipboard.")))
(map! :desc "copy to gfm"
      :map org-mode-map
      :n
      "SPC m z" 'org-to-gfm-to-clipboard)


(add-to-list 'default-frame-alist '(undecorated-round . t))
