;; normal ppl OS X keybindings
(global-set-key [(meta a)] 'mark-whole-buffer)
(global-set-key [(meta v)] 'yank)
(global-set-key [(meta c)] 'kill-ring-save)
;; this conflicts with M-X, which we'll alias as space bar in evil
(global-set-key [(meta x)] 'kill-region)
(global-set-key [(meta s)] 'save-buffer)
;; (global-set-key [(meta l)] 'goto-line)
(global-set-key [(meta o)] 'find-file)
(global-set-key [(meta f)] 'isearch-forward)
(global-set-key [(meta g)] 'isearch-repeat-forward)
(global-set-key [(meta q)] 'save-buffers-kill-emacs)
;; (global-set-key [(meta w)]
;;                 (lambda () (interactive) (kill-buffer (current-buffer))))
(global-set-key [(meta w)] 'delete-window)

;; packages, lots of them
(require 'package)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.milkbox.net/packages/") t)
;; (add-to-list 'package-archives
;;              '("marmalade" . "http://marmalade-repo.org/packages/") t)

;; among other things, package-initialize fills the list of installed packages
(package-initialize)

(add-to-list 'load-path "~/.emacs.d/use-package")
(require 'use-package)

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
    ;; (powerline-default-theme)
    (powerline-center-evil-theme)))

(use-package color-theme-sanityinc-tomorrow
  :ensure t
  :init
  (progn
    ;; no need to enable it. only theme so far so got it by default
    ;; at least I think that's what's happening
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

(use-package golden-ratio
  :ensure t
  :init
  (progn
    (golden-ratio-mode 1)))

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

;; language-specific
;; js

;; TODO: check if all we need here is the minor mode for syntax checks
(use-package js2-mode
  :ensure t
  :init
  (progn
    (add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))
    (add-to-list 'auto-mode-alist '("\\.jsx\\'" . js2-mode))
    (add-to-list 'auto-mode-alist '("\\.json\\'" . js2-mode))
    (add-to-list 'interpreter-mode-alist '("node" . js2-mode))))

;; http://ergoemacs.org/emacs/elisp_run_current_file.html
(defun run-node-on-current-file ()
  (interactive)
  (save-buffer)
  (progn
    (message "Running…")
    (shell-command
     (concat "node" " \"" (buffer-file-name) "\"")
     "*xah-run-current-file output*")))

(add-hook 'js2-mode-hook
          (lambda ()
            (evil-leader/set-key "RET" 'run-node-on-current-file)))

;; just doesn't work well for some reason
;; (use-package js-comint
;;   :ensure t
;;   :init
;;   (progn
;;     (setq inferior-js-program-command "node --interactive")
;;     ;; http://stackoverflow.com/questions/13862471/using-node-js-with-js-comint-in-emacs
;;     (setenv "NODE_NO_READLINE" "1")
;;     ;; emacs ask confirmation for killing processes before exit. annoying. kill
;;     (add-hook 'comint-exec-hook
;;       (lambda ()
;;         (set-process-query-on-exit-flag (get-buffer-process (current-buffer)) nil)))
;;     (add-hook 'js2-mode-hook
;;       (lambda ()
;;         (evil-leader/set-key "RET" 'js-send-buffer)))))

;; (use-package nodejs-repl
;;   :ensure t
;;   :init
;;   (progn
;;     ;; emacs ask confirmation for killing processes before exit. annoying. kill
;;     (add-hook 'comint-exec-hook
;;       (lambda ()
;;         (set-process-query-on-exit-flag (get-buffer-process (current-buffer)) nil)))))


;; lisps

;; (defun my-paredit-map ()
;;   (progn
;;     (local-set-key "(" 'paredit-open-round)
;;     (local-set-key ")" 'paredit-close-round)
;;     (local-set-key "M-)" 'paredit-close-round-and-newline)
;;     (local-set-key "[" 'paredit-open-square)
;;     (local-set-key "]" 'paredit-close-square)
;;     (local-set-key "{" 'paredit-open-curly)
;;     (local-set-key "}" 'paredit-close-curly-and-newline)
;;     (local-set-key "\"" 'paredit-doublequote)
;;     (local-set-key "M-\"" 'paredit-meta-doublequote)
;;     (local-set-key "\\" 'paredit-backslash)
;;     (local-set-key ";" 'paredit-semicolon)
;;     (local-set-key "M-;" 'paredit-comment-dwim)))

(defun enable-lisp-stuff ()
  (enable-paredit-mode)
  (evil-leader/set-key "RET" 'eval-region)
  )

(defun enable-custom-paredit ()
  (enable-paredit-mode)
  
  ;; don't override my preferred keybindings
  (define-key paredit-mode-map (kbd "M-s") nil)
  (define-key paredit-mode-map (kbd "M-q") nil)
  ;; (local-set-key (kbd "M-sasd") 'paredit-splice-sexp)
  
  ;; I like these bindings better
  (local-set-key "RET" 'paredit-newline)

  ;; (my-paredit-map)
  )

(use-package paredit
  :ensure t
  :init
  (progn
    (add-hook 'emacs-lisp-mode-hook 'enable-lisp-stuff)
    (add-hook 'js2-mode-hook
              (lambda ()
                (enable-custom-paredit)
                ;; js2-mode overrides this I think. paredit has it better
                (local-set-key "{" 'paredit-open-curly)
                (local-set-key "}" 'paredit-close-curly-and-newline)))))

;; Prevent the cursor from blinking
(blink-cursor-mode 0)
;; Don't use messages that you don't read
(setq initial-scratch-message "")
(setq inhibit-startup-message t)
;; kill audio/visual alarm when erroring
(setq ring-bell-function 'ignore)

(tool-bar-mode 0)
(global-linum-mode 1)
(set-fringe-mode 0)
;; this needs to go before (show-paren-mode). it highlights the parens without delay
(setq show-paren-delay 0)
(show-paren-mode 1)
;; delect a selection by typing (why is this not the default?)
(delete-selection-mode 1)
;; don't show current line in bar. i use powerline in the packages above so this doesn't work
;; (line-number-mode 0)
;; window size & position
(add-to-list 'default-frame-alist '(height . 999))
(add-to-list 'default-frame-alist '(width . 160))
(add-to-list 'default-frame-alist '(top . 0))
(add-to-list 'default-frame-alist '(left . 0))
;; white scroll bar. not sure how to change color. ugly
(scroll-bar-mode 0)


;; sublime texty & common sense stuff

;; window management
(global-set-key [(meta \{)] (lambda () (interactive)
  (previous-multiframe-window)
  (golden-ratio)))
(global-set-key [(meta \})] (lambda () (interactive)
  (next-multiframe-window)
  (golden-ratio)))
(global-set-key [(meta n)] 'split-window-right)
;; command palette
(global-set-key [(meta shift p)] 'execute-extended-command)
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)
;; preserve cursor position when scrolling...
(setq scroll-preserve-screen-position t)
;; tab: use 2 spaces
;; setq-default allows it to be overridden
(setq-default indent-tabs-mode nil)
(setq tab-width 2)

;; visual aliases sugar
(global-prettify-symbols-mode 1)
(add-hook 'js2-mode-hook
  (lambda ()
    (push '("function" . ?λ) prettify-symbols-alist)
    (push '("return" . ?←) prettify-symbols-alist)
    (push '("<=" . ?≤) prettify-symbols-alist)
    (push '(">=" . ?≥) prettify-symbols-alist)))

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
