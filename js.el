(require 'use-package)

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
