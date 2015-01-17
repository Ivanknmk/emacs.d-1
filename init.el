;; emacs daemon
(server-start)

;; packages, lots of them
(require 'package)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.milkbox.net/packages/") t)
(add-to-list 'package-archives
             '("marmalade" . "http://marmalade-repo.org/packages/") t)

;; among other things, package-initialize fills the list of installed packages
(package-initialize)

(add-to-list 'load-path "~/.emacs.d/use-package")
(require 'use-package)

(load-file "~/.emacs.d/st.el")

(use-package linum-relative
  :ensure t
  :init
  (progn
    ;; not sure if this is necessary; apparently not
    ;; (setq linum-format 'linum-relative)
    ;; https://github.com/coldnew/linum-relative/issues/7
    (setq linum-relative-format "%3s ")
    ;; display current line instead of 0
    (setq linum-relative-current-symbol "")))

(use-package powerline
  :ensure t
  :init
  (progn
    (powerline-center-evil-theme)))

(use-package multiple-cursors
  :ensure t
  :init
  (progn
    (global-set-key [(meta shift l)] 'mc/edit-lines)
    (global-set-key (kbd "M-d") 'mc/mark-next-like-this)
    ;; (global-set-key (kbd "M-D") 'mc/mark-previous-like-this)
    (global-set-key [(meta shift g)] 'mc/mark-all-like-this)))

(use-package color-theme-sanityinc-tomorrow
  :ensure t
  :init
  (progn
    ;; (color-theme-sanityinc-tomorrow-night)
    ))

(use-package rainbow-identifiers
  :ensure t
  :init
  ;; (rainbow-identifiers-mode 1) doesn't work. have to set it up as a hoook
  (progn
    (add-hook 'prog-mode-hook 'rainbow-identifiers-mode)
    (setq rainbow-identifiers-choose-face-function 'rainbow-identifiers-cie-l*a*b*-choose-face
          rainbow-identifiers-cie-l*a*b*-lightness 70
          rainbow-identifiers-cie-l*a*b*-saturation 30
          rainbow-identifiers-cie-l*a*b*-color-count 20
          ;; override theme faces
          rainbow-identifiers-faces-to-override '(highlight-quoted-symbol
                                                  font-lock-variable-name-face
                                                  font-lock-function-name-face
                                                  font-lock-type-face
                                                  js2-function-param
                                                  js2-external-variable
                                                  js2-instance-member
                                                  js2-private-function-call))))

(use-package rainbow-delimiters
  :ensure t
  :init
  (progn
    (add-hook 'prog-mode-hook 'rainbow-delimiters-mode)))

(use-package aggressive-indent
  :ensure t
  :init
  (progn
    (global-aggressive-indent-mode 1)))

(use-package indent-guide
  :ensure t
  :init
  (progn
    (indent-guide-global-mode)
    (setq indent-guide-recursive t)))

;; this doesn't seem to work for now. i want cursor to stay put when I scroll past it
;; (use-package scroll-restore
;;   :ensure t
;;   :init
;;   (progn
;;     (scroll-restore-mode 1)
;;     ;; Allow scroll-restore to modify the cursor face
;;     (setq scroll-restore-handle-cursor t)
;;     ;; Make the cursor invisible while POINT is off-screen
;;     (setq scroll-restore-cursor-type nil)
;;     ;; Jump back to the original cursor position after scrolling
;;     (setq scroll-restore-jump-back t)
;;     ;; Toggle scroll-restore-mode with the Scroll Lock key
;;     (global-set-key (kbd "<Scroll_Lock>") 'scroll-restore-mode)))

;; vim-related tuff
(use-package evil
  :ensure t
  :init
  (evil-mode 1))
(use-package evil-surround
  :ensure t
  :init
  (progn
    (global-evil-surround-mode 1)
    (global-set-key [(meta z)] 'undo-tree-undo)
    (global-set-key [(meta shift z)] 'undo-tree-redo)))
;; this one bugs for js?
(use-package evil-matchit
  :ensure t
  :init
  (global-evil-matchit-mode 1))
(use-package evil-nerd-commenter
  :ensure t
  :init
  (progn
    (evilnc-default-hotkeys)
    ;; default binding is M-;
    (global-set-key (kbd "M-/") 'evilnc-comment-or-uncomment-lines)))
(use-package evil-leader
  :ensure t
  :init
  (progn
    (global-evil-leader-mode 1)
    (evil-leader/set-leader "SPC")))
(use-package ace-jump-mode
  :ensure t
  :init
  (progn
    (evil-leader/set-key "SPC" 'evil-ace-jump-char-mode)))

;; TODO: check evil-exchange, evil-snipe, evil-lisp-state, evil-escape

(global-set-key [(meta ctrl j)] 'transpose-lines)

(defun duplicate-line()
  (interactive)
  (move-beginning-of-line 1)
  (kill-line)
  (yank)
  (open-line 1)
  (next-line 1)
  (yank))
(global-set-key (kbd "M-D") 'duplicate-line)

;; git-related
(use-package git-messenger
  :ensure t
  :init
  (progn
    (evil-leader/set-key "m" 'git-messenger:popup-message)
    ;; not sure why define-key
    (define-key git-messenger-map (kbd "<escape>") 'git-messenger:popup-close)
    ;; show all the details
    (setq git-messenger:show-detail t)))

;; doesn't seem to work well with relative line
(use-package git-gutter
  :ensure t
  :init
  (progn
    (global-git-gutter-mode t)
    (git-gutter:linum-setup)))

(use-package git-timemachine
  :ensure t
  :init
  (progn
    (git-timemachine-mode t)))

;; ST real fuzzy matching for finding files in project
(use-package helm
  :ensure t
  :init
  (progn
    (helm-mode 1)
    (global-set-key [(meta shift p)] 'helm-M-x)
    ;; I don't even know what half of these do. but why the heck don't emacs ppl get ST's fuzzy match
    (setq helm-recentf t
          ;; see fiplr below
          helm-M-x-fuzzy-match t
          helm-buffers-fuzzy-matching t
          helm-locate-fuzzy-match t
          helm-semantic-fuzzy-match t
          helm-imenu-fuzzy-match t
          helm-apropos-fuzzy-match t
          helm-lisp-fuzzy-completion t)
    ))

;; currently this is better than helm's, since it actually lists all files, and doesn't hide them behind folders
(use-package fiplr
  :ensure t
  :init
  (progn
    (global-set-key [(meta o)] 'fiplr-find-file)
    (setq fiplr-ignored-globs '((directories (".git" ".svn" "node_modules" "build"))
                                (files ("*.jpg" "*.png" "*.zip" "*~"))))))


;; language-specific
(load-file "~/.emacs.d/js.el")
(load-file "~/.emacs.d/lisp.el")

;; emacs generated stuff
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes (quote (sanityinc-tomorrow-night)))
 '(custom-safe-themes
   (quote
    ("06f0b439b62164c6f8f84fdda32b62fb50b6d00e8b01c2208e55543a6337433a" default)))
 '(js2-basic-offset 2))

;; rainbow-identifiers already overrides most of the colors. Tweak the theme a
;; bit more here
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(font-lock-builtin-face ((t (:foreground nil))))
 '(font-lock-comment-delimiter-face ((t (:foreground "#969896" :slant normal))))
 '(font-lock-comment-face ((t (:foreground "#969896" :slant normal))))
 '(font-lock-constant-face ((t (:foreground nil))))
 '(font-lock-doc-face ((t nil)))
 '(font-lock-keyword-face ((t (:foreground nil))))
 '(font-lock-negation-char-face ((t (:foreground nil))))
 '(font-lock-string-face ((t (:foreground "khaki"))))
 '(js2-function-param ((t nil))))
