(require 'use-package)

(defun enable-lisp-stuff ()
  (enable-custom-paredit)
  (evil-leader/set-key "RET" 'eval-region))

(defun enable-custom-paredit ()
  (enable-paredit-mode)

  ;; don't override my preferred keybindings
  (define-key paredit-mode-map (kbd "M-s") nil)
  (define-key paredit-mode-map (kbd "M-q") nil)
  (define-key paredit-mode-map (kbd "M-J") nil)
  (define-key paredit-mode-map (kbd "M-d") nil)
  ;; (local-set-key (kbd "M-sasd") 'paredit-splice-sexp)

  ;; I like these bindings better
  (local-set-key "RET" 'paredit-newline)
  )

(defun paredit-space-for-delimiter-predicates-scheme (endp delimiter)
  "Do not automatically insert a space when a '#' precedes parentheses."
  (or endp
      (cond ((eq (char-syntax delimiter) ?\()
             (not (looking-back "#\\|#hash")))
            (else t))))

(use-package paredit
  :ensure t
  :init
  (progn
    (add-hook 'emacs-lisp-mode-hook 'enable-lisp-stuff)
    (add-hook 'js2-mode-hook
              (lambda ()
                (enable-custom-paredit)
                (add-to-list (make-local-variable 'paredit-space-for-delimiter-predicates)
                             'paredit-space-for-delimiter-predicates-scheme)
                ;; js2-mode overrides this I think. paredit has it better
                (local-set-key "{" 'paredit-open-curly)
                (local-set-key "}" 'paredit-close-curly-and-newline)))))
