;;; init.el --- main config -*- lexical-binding: t; -*-

;;;; Package sources
;; GNU ELPA and NonGNU ELPA are configured by default; MELPA has most
;; everything else (evil, magit, ...).
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)

;; use-package is built in (since 29). With this, every (use-package foo)
;; installs foo if it's missing.
(setq use-package-always-ensure t)

;; Keep Customize's generated code out of this file.
(setq custom-file (locate-user-emacs-file "custom.el"))
(load custom-file 'noerror)

;; init.el and friends are symlinks into ~/.dotfiles (see nix/home.nix).
;; Open the real file so VC/magit see the repo, without asking each time.
(setq vc-follow-symlinks t)

;;;; Environment
(use-package exec-path-from-shell
  :if (memq window-system '(mac ns))   ; only needed for the GUI app
  :config
  (exec-path-from-shell-initialize))

;; Enabled from `after-init-hook', i.e. after every other global mode.
;; Hooks added last run first, so envrc sets up each buffer's environment
;; before other modes (like eglot) look for programs.
(use-package envrc
  :hook (after-init . envrc-global-mode))

;;;; Built-in behaviour
(use-package emacs
  :ensure nil                      ; built in, nothing to install
  :custom
  (ring-bell-function #'ignore)
  (make-backup-files nil)          ; no foo.txt~ files
  (create-lockfiles nil)           ; no .#foo.txt files
  (use-short-answers t)            ; y/n instead of yes/no
  (tab-always-indent 'complete)    ; TAB indents, or completes if already indented
  (column-number-indicator-zero-based nil) ; columns start at 1, not zero
  (read-process-output-max (* 1024 1024)) ; read 1MB at a time from LSP servers
  (recentf-max-saved-items 200)    ; remember up to 200 recent files
  (help-window-select t)           ; jump into *Help* when it opens
  (global-auto-revert-non-file-buffers t) ; also refresh dired etc.
  (treesit-font-lock-level 4)      ; richest tree-sitter highlighting
  :config
  (global-auto-revert-mode)        ; reload buffers when files change on disk
  (column-number-mode)
  (which-key-mode)
  (savehist-mode)                  ; remember minibuffer history
  (recentf-mode)                   ; remember recently opened files
  (save-place-mode)                ; reopen files where you left off
  (electric-pair-mode)             ; auto-close brackets; RET between {} opens a line
  ;; Code folding: hideshow finds the blocks, evil's z keys (za, zc, zo, zM, zR) drive it.
  (add-hook 'prog-mode-hook #'hs-minor-mode)
  ;; Tab toggles a fold (like za), only where hideshow is on. Binding <tab>
  ;; rather than TAB keeps C-i free for evil-jump-forward in the GUI.
  (with-eval-after-load 'hideshow
    (evil-define-key 'normal hs-minor-mode-map (kbd "<tab>") #'evil-toggle-fold))

  ;; Automatically switch to help documentation buffers
  (add-to-list 'display-buffer-alist
    '("\\*eldoc\\*"
      (display-buffer-reuse-window display-buffer-pop-up-window)
      (body-function . select-window))))

;;;; Appearance
(set-face-attribute 'default nil :family "VictorMono NF" :height 160)
(set-face-attribute 'fixed-pitch nil :family "VictorMono NF")

(use-package ef-themes
  :config
  (load-theme 'ef-maris-dark :no-confirm))

(use-package doom-modeline
  :init
  (doom-modeline-mode 1))

;;;; Evil
(use-package evil
  :init
  ;; These must be set BEFORE evil loads, so they go in :init.
  (setq evil-want-keybinding nil      ; leave other modes to evil-collection
        evil-want-C-u-scroll t        ; C-u scrolls up, as in Vim
        evil-want-Y-yank-to-eol t     ; Y behaves like y$
        evil-undo-system 'undo-redo)  ; Emacs's own linear undo/redo (C-r)
  :config
  (evil-mode 1)

  ;; Leader key: SPC in normal, visual and motion (help buffers etc.) states.
  (evil-set-leader '(normal visual motion) (kbd "SPC"))
  (evil-define-key '(normal visual motion) 'global
    (kbd "<leader>:")  #'execute-extended-command ; SPC : = M-x
    (kbd "<leader>u")  #'universal-argument       ; SPC u = C-u (C-u scrolls)
    (kbd "<leader>w")  evil-window-map            ; SPC w = C-w (window commands)
    (kbd "<leader>ff") #'find-file
    (kbd "<leader>fs") #'save-buffer              ; SPC f s = save file
    (kbd "<leader>bd") #'kill-current-buffer
    (kbd "<leader>bl") #'ibuffer
    (kbd "<leader>`")  #'evil-switch-to-windows-last-buffer ; toggle with previous buffer
    (kbd "<leader>pp") #'project-switch-project
    (kbd "<leader>pc") #'project-compile          ; run a command at the project root
    (kbd "<leader>pr") #'recompile              ; rerun the last one
    (kbd "<leader>qq") #'save-buffers-kill-emacs  ; SPC q q = quit Emacs
    (kbd "<leader>qr") #'restart-emacs))          ; SPC q r = restart

(use-package evil-collection
  :after evil
  :config
  ;; Its agenda keys bind SPC to org-agenda-show, shadowing the leader. Its
  ;; setup runs when org-agenda loads (which org-habit can trigger during
  ;; init), so add the unbind hook before `evil-collection-init'.
  (add-hook 'evil-collection-setup-hook
            (lambda (mode _keymaps)
              (when (eq mode 'org-agenda)
                (evil-define-key 'normal org-agenda-mode-map (kbd "SPC") nil))))
  (evil-collection-init))

(use-package evil-commentary
  :after evil
  :config
  (evil-commentary-mode))

(use-package evil-surround
  :after evil
  :config
  (global-evil-surround-mode))

(use-package expreg
  :bind (("M-o" . expreg-expand)
         ("M-i" . expreg-contract)))

;;;; Minibuffer completion
(use-package vertico
  :init (vertico-mode))

(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  ;; For files, keep partial-completion so ~/.c/em expands to ~/.config/emacs
  (completion-category-overrides '((file (styles partial-completion)))))

(use-package marginalia
  :init (marginalia-mode))

(use-package consult
  :custom
  ;; Show go-to-definition / find-references results in Vertico, with preview.
  (xref-show-xrefs-function #'consult-xref)
  (xref-show-definitions-function #'consult-xref)
  :init
  (evil-define-key '(normal visual motion) 'global
    (kbd "<leader>SPC") #'consult-buffer      ; SPC SPC
    (kbd "<leader>bb")  #'consult-buffer      ; buffers + recent files, with preview
    (kbd "<leader>fr")  #'consult-recent-file
    (kbd "<leader>sl")  #'consult-line        ; search lines in this buffer
    (kbd "<leader>sr")  #'consult-ripgrep     ; search the whole project
    (kbd "<leader>si")  #'consult-imenu))     ; jump to a function/definition

;;;; In-buffer completion
(use-package corfu
  :custom
  (corfu-auto t)          ; pop up on its own, without pressing a key
  (corfu-auto-delay 0.2)
  (corfu-auto-prefix 2)   ; after 2 characters
  (corfu-popupinfo-delay '(0.5 . 0.2))
  :init
  (global-corfu-mode)
  (corfu-popupinfo-mode))

;;;; Embark (right-click)
(use-package embark
  :bind ("C-." . embark-act)          ; global: works in the minibuffer and insert state
  :init
  (evil-define-key '(normal visual motion) 'global
    (kbd "C-.") #'embark-act)
  :custom
  ;; Show the action list in Vertico instead of a keymap popup.
  ;; With an empty prompt, single-key bindings (e.g. "G") still fire directly.
  (embark-prompter #'embark-completing-read-prompter)
  ;; Drop the keymap popup (redundant with Vertico); keep target highlighting.
  (embark-indicators '(embark-minimal-indicator
                       embark-highlight-indicator
                       embark-isearch-highlight-indicator))
  :config
  (defun my/google-search (term)
    "Search Google for TERM."
    (interactive "sSearch: ")
    (browse-url (concat "https://www.google.com/search?q="
                        (url-hexify-string term))))
  ;; `general' actions are offered for every target type.
  (keymap-set embark-general-map "G" #'my/google-search))

;; Glue between embark and consult; makes `export' work on search results.
;; :after keeps it (and embark) from loading until both are needed.
(use-package embark-consult
  :after (embark consult))

;;;; Git
(use-package magit
  :init
  ;; In :init so the key exists before magit loads (pressing it loads magit).
  (evil-define-key '(normal visual motion) 'global
    (kbd "<leader>gg") #'magit-status))   ; SPC g g = git status

;; Changed/added/deleted line markers in the fringe.
(use-package diff-hl
  :hook ((after-init . global-diff-hl-mode)
         ;; Refresh the markers after magit commits, stages, etc.
         (magit-pre-refresh . diff-hl-magit-pre-refresh)
         (magit-post-refresh . diff-hl-magit-post-refresh))
  :config
  (diff-hl-flydiff-mode)                 ; update markers as you type, not just on save
  (evil-define-key 'normal 'global
    (kbd "]h")         #'diff-hl-next-hunk
    (kbd "[h")         #'diff-hl-previous-hunk
    (kbd "<leader>gr") #'diff-hl-revert-hunk         ; discard the change at point
    (kbd "<leader>gs") #'diff-hl-stage-current-hunk  ; stage just this hunk
    (kbd "<leader>gp") #'diff-hl-show-hunk)          ; popup showing the old text

  ;; Thin bar instead of a full-width block.
  ;; [224] = #b11100000: 3 pixels lit out of the fringe's 8, repeated down the line.
  (define-fringe-bitmap 'my/diff-hl-thin [224] nil nil '(center repeated))
  (setq diff-hl-fringe-bmp-function
        (lambda (type _pos)
          (if (eq type 'delete)
              'diff-hl-bmp-delete     ; keep the small triangle for deleted lines
            'my/diff-hl-thin)))
  ;; The theme colours these faces by background only, but a fringe bitmap's
  ;; lit pixels use the foreground. Move the colour over so only the bar is
  ;; coloured and the rest of the fringe stays the normal background.
  (dolist (face '(diff-hl-insert diff-hl-delete diff-hl-change))
    (set-face-foreground face (face-background face nil t))
    (set-face-background face 'unspecified)))

;;;; AI agents
;; agent-shell: chat with coding agents (Claude Code, Codex, Gemini, ...) in
;; a normal Emacs buffer. It talks to each agent over ACP (Agent Client
;; Protocol), so Claude Code needs its ACP adapter on PATH: the
;; claude-agent-acp package in nix/home.nix.
(use-package agent-shell
  ;; These aren't autoloaded by agent-shell; listing them here makes
  ;; use-package autoload them, so pressing their key loads the package.
  :commands (agent-shell-send-dwim agent-shell-help-menu)
  :init
  ;; In :init so the keys exist before agent-shell loads (pressing one loads it).
  (evil-define-key '(normal visual motion) 'global
    (kbd "<leader>aa") #'agent-shell                          ; start/reuse any agent
    (kbd "<leader>ac") #'agent-shell-anthropic-start-claude-code ; new Claude session
    ;; Region (or error at point) into this project's shell. C-u: new
    ;; shell; C-u C-u: pick which shell.
    (kbd "<leader>as") #'agent-shell-send-dwim
    (kbd "<leader>at") #'agent-shell-toggle                   ; show/hide agent window
    (kbd "<leader>a?") #'agent-shell-help-menu)               ; transient of all commands
  :custom
  ;; SPC a a goes straight to Claude instead of asking which agent.
  (agent-shell-preferred-agent-config 'claude-code)
  :config
  ;; This calls an agent-shell function, so it goes in :config (after it
  ;; loads) rather than :custom, which runs before.
  ;; Use the Claude subscription you're logged into with the `claude' CLI,
  ;; not an API key.
  (setq agent-shell-anthropic-authentication
        (agent-shell-anthropic-make-authentication :login t))
  ;; RET sends the prompt in insert state too (evil-collection already does
  ;; normal state, and also follows links/buttons at point there).
  ;; Bind <return> as well as RET: the GUI Enter key sends <return>, which
  ;; only falls back to RET when nothing binds <return> itself, and
  ;; evil-collection binds insert <return> to `newline' in the parent
  ;; shell-maker-mode-map.
  ;; S-RET or M-RET adds a newline, for multi-line prompts. M-RET normally
  ;; queues/steers a prompt while the agent is busy; that's still on
  ;; M-x agent-shell-submit-override.
  (evil-define-key 'insert agent-shell-mode-map
    (kbd "RET")        #'agent-shell-submit
    (kbd "<return>")   #'agent-shell-submit
    (kbd "S-<return>") #'newline
    (kbd "M-RET")      #'newline
    (kbd "M-<return>") #'newline)
  ;; Proposed-edit diffs take single-key answers (y/n/...), so open them in
  ;; Emacs state; C-z switches back to evil if needed. (In normal state,
  ;; evil-collection offers gy/gn to accept/reject and q to quit.)
  (add-hook 'agent-shell-diff-mode-hook #'evil-emacs-state))

;;;; Emacs Lisp
(use-package elisp-mode
  :ensure nil                          ; built in
  :preface
  (defun my/load-library-for-symbol (sym)
    "Load the library named by the longest prefix of SYM.
E.g. `evil-org-set-key-theme' tries evil-org-set-key-theme,
evil-org-set-key, evil-org-set, then evil-org, which exists."
    (let ((parts (split-string (symbol-name sym) "-")))
      (catch 'done
        (while parts
          (let ((lib (string-join parts "-")))
            (when (locate-library lib)
              (unless (featurep (intern lib))
                (load lib nil t))
              (throw 'done lib)))
          (setq parts (butlast parts))))))
  (defun my/describe-symbol-at-point ()
    "Show the *Help* page for the symbol at point.
If Emacs doesn't know the symbol yet because its package isn't
loaded, load the package first."
    (when-let* ((sym (symbol-at-point)))
      (unless (or (fboundp sym) (boundp sym) (facep sym))
        (my/load-library-for-symbol sym))
      (describe-symbol sym)))
  (defun my/elisp-lookup-setup ()
    "Make evil's K describe the symbol at point."
    (setq-local evil-lookup-func #'my/describe-symbol-at-point))
  :hook (emacs-lisp-mode . my/elisp-lookup-setup))

;;;; Rust
;; Open .rs files in the tree-sitter mode (grammar comes from Nix).
(use-package rust-ts-mode
  :ensure nil
  :mode "\\.rs\\'")

(use-package eglot
  :ensure nil
  :hook (rust-ts-mode . eglot-ensure)    ; start rust-analyzer automatically
  :init
  ;; Make room for the code-action indicator (emoji are 2 columns wide).
  ;; In :init, not :config: eglot only loads partway through opening the
  ;; first Rust file, too late to add to the hook that's already running.
  (defun my/rust-left-margin ()
    "Reserve one margin column for eglot's code-action indicator."
    (setq left-margin-width 1))
  (add-hook 'rust-ts-mode-hook #'my/rust-left-margin)
  :custom
  (eglot-code-action-indications '(eldoc-hint margin))  ; margin instead of fringe
  (eglot-code-action-indicator "\U000F0336")
  (eglot-autoshutdown t)                 ; stop the server when its last buffer closes
  (eglot-events-buffer-config '(:size 0)) ; don't log every message (faster)
  :config
  ;; Settings sent to rust-analyzer: run clippy instead of `cargo check'.
  (setq-default eglot-workspace-configuration
                '(:rust-analyzer (:check (:command "clippy"))))

  ;; Format on save, but only while eglot manages the buffer. This hook
  ;; runs on both start and stop, so remove the save hook on stop;
  ;; otherwise saving fails with "no server" after a crash or shutdown.
  (defun my/eglot-format-on-save ()
    "Format on save only while eglot manages this buffer."
    (if (eglot-managed-p)
        (add-hook 'before-save-hook #'eglot-format-buffer nil t)
      (remove-hook 'before-save-hook #'eglot-format-buffer t)))
  (add-hook 'eglot-managed-mode-hook #'my/eglot-format-on-save)

  ;; Code bindings, active only where eglot is running.
  (evil-define-key 'normal eglot-mode-map
    (kbd "<leader>ca") #'eglot-code-actions
    (kbd "<leader>cr") #'eglot-rename
    (kbd "<leader>cf") #'eglot-format-buffer
    (kbd "<leader>cd") #'consult-flymake           ; list all diagnostics
    (kbd "<leader>cu") #'xref-find-references      ; usages
    (kbd "K")          #'eldoc-doc-buffer          ; docs for symbol at point
    (kbd "]d")         #'flymake-goto-next-error
    (kbd "[d")         #'flymake-goto-prev-error))

;; Eldoc uses markdown-mode (when installed) to render the Markdown that
;; rust-analyzer sends, so hover docs get headings, code blocks, etc.
(use-package markdown-mode)

;;;; Org
(use-package org
  :ensure nil
  :init
  ;; In :init so the keys exist before Org loads (they're what load it).
  (defun my/org-search ()
    "Search .org files under ~/org/ with ripgrep (consult, live preview)."
    (interactive)
    ;; Read when consult-ripgrep starts, so a let-binding is enough.
    ;; The default value is one string, and `append' on a string splits it
    ;; into characters, so wrap it in a list first (consult splits strings).
    (let ((consult-ripgrep-args (append (ensure-list consult-ripgrep-args)
                                        '("--glob=*.org"))))
      (consult-ripgrep "~/org/")))
  (defun my/org-find-file ()
    "Find .org files under ~/org/ (recursively) with fd (consult, live preview)."
    (interactive)
    ;; consult-fd reads these args when it starts, so a let-binding is enough.
    (let ((consult-fd-args (append consult-fd-args '("-e org"))))
      (consult-fd "~/org/")))
  (evil-define-key '(normal visual motion) 'global
    (kbd "<leader>oa") #'org-agenda      ; SPC o a = "org agenda"
    (kbd "<leader>oc") #'org-capture     ; SPC o c = "org capture"
    (kbd "<leader>of") #'my/org-find-file ; SPC o f = "org file"
    (kbd "<leader>os") #'my/org-search)  ; SPC o s = "org search"
  :custom
  (org-directory "~/org")
  ;; ~/org/calendars/ holds read-only Google Calendar mirrors, rewritten every
  ;; 30 min by org-cal-sync (nix/org-cal-sync.sh, scheduled in nix/home.nix;
  ;; macOS launchd label org.nix-community.home.org-cal-sync).
  ;; A directory entry pulls in every .org file inside it.
  ;; Everything lives in tasks.org; new captures land under its "Inbox" heading.
  (org-agenda-files '("~/org/tasks.org" "~/org/calendars/"))
  (org-log-done 'time)                   ; CLOSED: timestamp when marked DONE
  (org-agenda-use-time-grid nil)         ; no 8:00/10:00/... lines in the agenda
  ;; SPC o a u: open TODOs with no SCHEDULED or DEADLINE, i.e. the ones that
  ;; never show up on the day/week agenda and are easy to forget about.
  ;; todo "" = every not-done state; the skip function drops dated entries.
  (org-agenda-custom-commands
   '(("u" "Unscheduled TODOs"
      todo ""
      ((org-agenda-skip-function
        '(org-agenda-skip-entry-if 'scheduled 'deadline))
       (org-agenda-overriding-header "Unscheduled TODOs")))))
  (org-capture-templates
   '(("t" "Task" entry (file+headline "tasks.org" "Inbox")
      "* TODO %?\n%U")
     ;; Same, plus %a: a link back to where you were when you hit SPC o c.
     ("l" "Task with link" entry (file+headline "tasks.org" "Inbox")
      "* TODO %?\n%U\n%a")))
  ;; Only tasks.org, not org-agenda-files: anything refiled into the calendar
  ;; mirrors would be wiped on the next sync. Level 1 = the sections (Tasks,
  ;; Recurring, ...), level 2 = projects/tasks inside them.
  (org-refile-targets '(("~/org/tasks.org" :maxlevel . 2)))
  ;; One file, so the "tasks.org/" prefix is noise: show "Tasks/Foo" paths.
  (org-refile-use-outline-path t)
  (org-outline-path-complete-in-steps nil)
  ;; Typing a path that doesn't exist yet (e.g. "Tasks/New Project") offers
  ;; to create the missing heading, instead of failing.
  (org-refile-allow-creating-parent-nodes 'confirm)
  ;; Don't offer Inbox itself (or anything under it) as a refile destination.
  (org-refile-target-verify-function
   (lambda () (not (member "Inbox" (org-get-outline-path t)))))
  (org-startup-indented t)        ; turn on org-indent-mode in every Org buffer
  (org-hide-emphasis-markers t)   ; hide the *, /, ~ around emphasis
  (org-return-follows-link t)     ; RET on a link opens it
  ;; org-habit (required in :config): consistency graph for STYLE: habit tasks.
  (org-habit-graph-column 50)     ; start graph past long titles
  (org-habit-show-habits-only-for-today t) ; keep future agenda days uncluttered
  :config
  (require 'org-habit)
  ;; Date prompt: steer the calendar with C-hjkl. This keymap only
  ;; exists once Org has loaded, hence :config.
  (keymap-set org-read-date-minibuffer-local-map "C-h" #'org-calendar-backward-day)
  (keymap-set org-read-date-minibuffer-local-map "C-l" #'org-calendar-forward-day)
  (keymap-set org-read-date-minibuffer-local-map "C-j" #'org-calendar-forward-week)
  (keymap-set org-read-date-minibuffer-local-map "C-k" #'org-calendar-backward-week)
  (add-hook 'org-agenda-finalize-hook #'my/org-agenda-color-calendars))

;; Make Google Calendar events stand out from tasks in the agenda: each
;; mirror file in ~/org/calendars/ gets its own colour, and all are bold.
;; Keys are the file names (= the "caitlin:" category shown in the agenda);
;; values are ef-themes palette names, so the colours follow the theme.
(defvar my/calendar-colors
  '(("caitlin"  . magenta-cooler)
    ("celtics"  . green-cooler)
    ("holidays" . yellow-warmer))
  "Alist of calendar file base name -> ef-themes palette colour.")

(defun my/org-agenda-color-calendars ()
  "Bold agenda lines from ~/org/calendars/, coloured per `my/calendar-colors'.
Runs from `org-agenda-finalize-hook', i.e. after the agenda is built."
  (let ((cal-dir (expand-file-name "calendars/" org-directory)))
    (save-excursion
      (goto-char (point-min))
      (while (not (eobp))
        ;; Agenda lines carry a marker back to the entry they came from;
        ;; day headers and blank lines don't, so they're skipped.
        (when-let* ((marker (get-text-property (point) 'org-marker))
                    (file (buffer-file-name (marker-buffer marker)))
                    ((string-prefix-p cal-dir file)))
          (let* ((color (alist-get (file-name-base file) my/calendar-colors
                                   nil nil #'equal))
                 ;; Unlisted calendars still get bold, just no colour.
                 (face (if color
                           `(:weight bold :foreground
                             ,(ef-themes-get-color-value color))
                         '(:weight bold))))
            (add-face-text-property (line-beginning-position)
                                    (line-end-position) face)))
        (forward-line 1)))))

;; Vim-style keys for Org: >>/<< on headings, text objects.
;; Agenda keys come from evil-collection (it loads after evil-org and wins).
(use-package evil-org
  :after org
  :hook (org-mode . evil-org-mode)
  :config
  (evil-org-set-key-theme '(navigation insert textobjects additional calendar return)))
;; Show hidden emphasis/link markup when point is on it.
(use-package org-appear
  :hook (org-mode . org-appear-mode)
  :custom
  (org-appear-autolinks t))       ; also reveal [[link][desc]] markup at point

;; Pretty heading stars; maintained successor to org-bullets.
(use-package org-superstar
  :hook (org-mode . org-superstar-mode))

(with-eval-after-load 'calendar
  (evil-define-key 'normal calendar-mode-map
    (kbd "RET") #'org-calendar-goto-agenda))   ; RET on a day = open agenda there

;;; init.el ends here
