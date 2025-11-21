;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
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

;; Work around for the non-posix shell i am using. Set emacs to use bash internally
;; and nushell for virtual terminal emulation.
;; (setq shell-file-name (executable-find "bash"))
;; (setq-default vterm-shell "/run/current-system/sw/bin/nu")
;; (setq-default explicit-shell-file-name "/run/current-system/sw/bin/nu")

(setq doom-font (font-spec :size 22))

(defun dvalinn/copilot-disable-predicate ()
  "When copilot should not automatically show completions."
  (if (company--active-p) t nil))

;; Configuration for GH Copilot
;; accept completion from copilot and fallback to company
(use-package! copilot
  :hook (prog-mode . copilot-mode)
  :after company
  :config
  (add-to-list 'copilot-indentation-alist '(prog-mode 2))
  (add-to-list 'copilot-indentation-alist '(org-mode 2))
  (add-to-list 'copilot-indentation-alist '(text-mode 2))
  (add-to-list 'copilot-indentation-alist '(closure-mode 2))
  (add-to-list 'copilot-indentation-alist '(emacs-lisp-mode 2))
  (progn

    ;; Enable copilot for programming modes
    (add-hook 'prog-mode-hook 'copilot-mode)
    ;; When to show/hide predicates
    (add-to-list 'copilot-disable-predicates #'dvalinn/copilot-disable-predicate)
    ;; Complete using the Tab key
    (define-key copilot-completion-map (kbd "<tab>") #'copilot-accept-completion)
    )
  )

(after! (evil copilot)
  ;; Define the custom function that either accepts the completion or does the default behavior
  (defun dvalinn/copilot-tab-or-default ()
    (interactive)
    (or
     (copilot-accept-completion)
     (indent-for-tab-command)))

  ;; Bind the custom function to <tab> in Evil's insert state
  (evil-define-key 'insert 'global (kbd "<tab>") #'dvalinn/copilot-tab-or-default))

;; Highlight yanked region
(defun dvalinn/evil-yank-highlight-advice (orig-fn beg end &rest args)
  (pulse-momentary-highlight-region beg end)
  (apply orig-fn beg end args))

(advice-add 'evil-yank :around #'dvalinn/evil-yank-highlight-advice)

;; Start Emacs in fullscreen and without decorations
(add-to-list 'default-frame-alist '(undecorated . t))
(add-to-list 'default-frame-alist '(fullscreen . maximized))

;; Org-babel mermaid configuration
(setq ob-mermaid-cli-path "mmdc")
(org-babel-do-load-languages
 'org-babel-load-languages
 '(
   (mermaid . t)
   (scheme . t)
   (org . t)
   )
 )
(setenv "PUPPETEER_EXECUTABLE_PATH" "/usr/bin/google-chrome")

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
