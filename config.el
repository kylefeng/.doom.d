;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!

(setq mac-option-modifier 'meta)

(add-to-list 'auto-mode-alist '("\\.groovy\\|Jenkinsfile\\'" . groovy-mode))
(add-to-list 'auto-mode-alist '("\\.graphql\\|.graphqls\\'" . graphql-mode))

(setq company-global-modes '(not sh-mode org-mode))

;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "kylefeng"
      user-mail-address "kylefeng@live.cn")

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
;;

;; 窗口最大化
(pushnew! initial-frame-alist '(width . 120) '(height . 45))
(setq doom-font (font-spec :family "等距更纱黑体 T SC" :size 14))

(+global-word-wrap-mode +1)

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/development/org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)


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

;; Configurations for Go development
(setq lsp-gopls-staticcheck t)
(setq lsp-eldoc-render-all t)
(setq lsp-gopls-complete-unimported t)

(use-package! lsp-mode
  :ensure t
  :commands (lsp lsp-deferred)
  :hook (go-mode . lsp-deferred))

(defun lsp-go-install-save-hooks ()
  (add-hook 'before-save-hook #'lsp-format-buffer t t)
  (add-hook 'before-save-hook #'lsp-organize-imports t t))
(add-hook 'go-mode-hook #'lsp-go-install-save-hooks)

(use-package! company
  :ensure t
  :config
  (setq company-idle-delay 0)
  (setq company-minimum-prefix-length 1))

(use-package! yasnippet
  :ensure t
  :commands yas-minor-mode
  :hook (go-mode . yas-minor-mode))

(use-package! lsp-ui
  :ensure t
  :commands lsp-ui-mode)

(use-package! lsp-mode
  :config
  (setq lsp-auto-guess-root nil)
  (setq lsp-ui-doc-enable nil)
  (setq lsp-ui-sideline-enable nil)
  (setq lsp-prefer-flymake :none)
  (setq lsp-diagnostics-provider :none))

(use-package! org-download
  :config
  (setq-default org-download-image-dir "/Users/kylefeng/development/org/images/")
  (setq org-download-method 'directory))

;; org-roam
(setq org-roam-directory "/Users/kylefeng/development/org/roam")
(use-package! org-roam
  :after org
  :commands
  (org-roam-buffer
   org-roam-setup
   org-roam-capture
   org-roam-node-find)
  :config
  (org-roam-setup))

;; org-mode
(use-package! org
  :config
  (setq org-tags-column -128)
  (setq org-startup-indented t)

  (setq org-agenda-files '("/Users/kylefeng/development/org"
                           "/Users/kylefeng/development/org/notebooks"))
  (setq org-todo-keywords '((sequence "TODO(t!)" "ACTING(a!)" "|" "DONE(d!)" "CANCELED(c @/!)")))

  (defvar org-agenda-dir "gtd org files location")
  (setq-default org-agenda-dir "/Users/kylefeng/development/org")
  (setq org-agenda-file-note (expand-file-name "notes.org" org-agenda-dir))
  (setq org-agenda-file-task (expand-file-name "task.org" org-agenda-dir))
  (setq org-agenda-file-calendar (expand-file-name "calendar.org" org-agenda-dir))
  (setq org-agenda-file-finished (expand-file-name "finished.org" org-agenda-dir))
  (setq org-agenda-file-canceled (expand-file-name "canceled.org" org-agenda-dir))

  (setq org-capture-templates
        '(
         ("t" "Todo" entry (file+headline org-agenda-file-task "Work")
          "* TODO [#B] %?\n  %i\n"
          :empty-lines 1)
         ("l" "Tolearn" entry (file+headline org-agenda-file-task "Learning")
          "* TODO [#B] %?\n  %i\n"
          :empty-lines 1)
         ("h" "Toplay" entry (file+headline org-agenda-file-task "Hobbies")
          "* TODO [#C] %?\n  %i\n"
          :empty-lines 1)
         ("I" "Inbox" entry (file+headline org-agenda-file-task "Inbox")
          "* TODO [#C] %?\n  %i\n"
          :empty-lines 1)
         ("o" "Todo_others" entry (file+headline org-agenda-file-task "Others")
          "* TODO [#C] %?\n  %i\n"
          :empty-lines 1)
         ("n" "notes" entry (file+headline org-agenda-file-note "Quick notes")
          "* %?\n  %i\n %U"
          :empty-lines 1)
         ("i" "ideas" entry (file+headline org-agenda-file-note "Quick ideas")
          "* %?\n  %i\n %U"
          :empty-lines 1)
         ))
  (setq org-agenda-custom-commands
        '(
          ("w" . "任务安排")
          ("wa" "重要且紧急的任务" tags-todo "+PRIORITY=\"A\"")
          ("wb" "重要且不紧急的任务" tags-todo "-weekly-monthly-daily+PRIORITY=\"B\"")
          ("wc" "不重要且紧急的任务" tags-todo "+PRIORITY=\"C\"")
          ("W" "Weekly Review"
           ((stuck "") ;; review stuck projects as designated by org-stuck-projects
            (tags-todo "daily")
            (tags-todo "weekly")
            (tags-todo "work")
            (tags-todo "blog")
            (tags-todo "book")
            ))
          ))

  (setq org-refile-targets  '((org-agenda-file-finished :maxlevel . 1)
                              (org-agenda-file-note :maxlevel . 1)
                              (org-agenda-file-canceled :maxlevel . 1)
                              (org-agenda-file-task :maxlevel . 1)
                              ))
  )


;; pomodoro
(use-package! org-pomodoro
  :config
  (setq org-pomodoro-length 45)
  (setq org-pomodoro-short-break-length 10)
  (setq org-pomodoro-long-break-length 20)
  )

;; deft
(use-package! deft
  :config
  (setq deft-directory "/Users/kylefeng/development/org/notebooks")
  (setq deft-recursive t)
  (setq deft-extensions '("org"))
  )


;; feature-mode
(require 'feature-mode)
(add-to-list 'auto-mode-alist '("\.feature$" . feature-mode))
(defun native-comp-available-p nil)
