(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

;;* Appearance
(menu-bar-mode -1)
(toggle-scroll-bar -1)
(tool-bar-mode -1)
(blink-cursor-mode -1)
 
;;** Fonts
(set-face-attribute 'default nil :family "Input Mono Narrow")
(set-face-attribute 'default nil :height 140)
(set-fontset-font t 'hangul (font-spec :name "NanumGothic"))

;;* Straight
(straight-use-package 'use-package)
(setq straight-use-package-by-default t)

;;** Packages
(use-package no-littering
  :demand t
  :config
  (require 'recentf)
  (add-to-list 'recentf-exclude no-littering-var-directory)
  (add-to-list 'recentf-exclude no-littering-etc-directory)
  (setq auto-save-file-name-transforms
	`((".*" ,(no-littering-expand-var-file-name "auto-save/") t)))
  (setq custom-file
	(no-littering-expand-etc-file-name "custom.el")))

(use-package general
  :init
  (general-define-key
   "s-s" 'save-buffer
   "s-C" 'count-words
   "s-w" 'kill-current-buffer)
  (general-define-key
   :keymaps 'minibuffer-local-map
   [escape] 'keyboard-escape-quit))

(use-package which-key
  :init (which-key-mode))

(use-package evil
  :general ("s-z" 'undo-tree-undo
	    "s-Z" 'undo-tree-redo)
  :init
  (setq evil-disable-insert-state-bindings t)
  (evil-mode t))

(use-package lispy
  :hook ((emacs-lisp-mode clojure-mode clojurescript-mode cider-repl-mode)
	 . lispy-mode)
  :diminish lispy-mode
  :general (:keymaps 'lispy-mode-map
		     "DEL" 'lispy-backward-delete
		     "[" 'lispy-brackets
		     "{" 'lispy-braces))

(use-package elisp-slime-nav
  :hook (emacs-lisp-mode . elisp-slime-nav-mode)
  :general (:states 'normal :keymaps 'emacs-lisp-mode-map
		    "K" 'elisp-slime-nav-describe-elisp-thing-at-point))

(use-package lispyville
  :hook (lispy-mode . lispyville-mode)
  :diminish lispyville-mode
  :general
  ([remap evil-normal-state] 'lispyville-normal-state)
  (:keymaps 'lispyville-mode-map
	    [M-down] 'lispyville-drag-forward
	    [M-up] 'lispyville-drag-backward)
  :init
  (setq lispyville-key-theme '(operators c-w escape slurp/barf-cp wrap escape)
	lispyville-barf-stay-with-closing t))

(use-package ivy
  :init
  (ivy-mode 1)
  :config
  (setq ivy-use-virtual-buffers t
	enable-recursive-minibuffers t
	search-default-mode #'char-fold-to-regexp
	ivy-re-builders-alist '((t . ivy--regex-fuzzy))))

(use-package ivy-hydra)

(use-package counsel
  :general
  ("s-e" 'counsel-recentf
   "s-o" 'find-file))

;;** Langs
(use-package clojure-mode)

(use-package cider
  :config
  (setq cider-promt-save-file-on-load nil
	cider-repl-use-clojure-font-lock t
	cider-repl-pop-to-buffer-on-connect nil))

;;* Keybindings
(setq mac-command-modifier 'super
      mac-option-modifier 'meta)
