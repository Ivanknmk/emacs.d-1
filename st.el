;; http://ergoemacs.org/emacs/emacs_copy_cut_current_line.html
(defun copy-line-or-region ()
  "Copy current line, or text selection.
When `universal-argument' is called first, copy whole buffer (but respect `narrow-to-region')."
  (interactive)
  (let (p1 p2)
    (if (null current-prefix-arg)
        (progn (if (use-region-p)
                   (progn (setq p1 (region-beginning))
                          (setq p2 (region-end)))
                 (progn (setq p1 (line-beginning-position))
                        (setq p2 (line-end-position)))))
      (progn (setq p1 (point-min))
             (setq p2 (point-max))))
    (kill-ring-save p1 p2)))

(defun cut-line-or-region ()
  "Cut current line, or text selection.
When `universal-argument' is called first, cut whole buffer (but respect `narrow-to-region')."
  (interactive)
  (let (p1 p2)
    (if (null current-prefix-arg)
        (progn (if (use-region-p)
                   (progn (setq p1 (region-beginning))
                          (setq p2 (region-end)))
                 (progn (setq p1 (line-beginning-position))
                        (setq p2 (line-beginning-position 2)))))
      (progn (setq p1 (point-min))
             (setq p2 (point-max))))
    (kill-region p1 p2)))

;; normal ppl OS X keybindings
(global-set-key [(meta a)] 'mark-whole-buffer)
(global-set-key [(meta v)] 'yank)
(global-set-key [(meta c)] 'copy-line-or-region)
;; this conflicts with M-X, which we'll alias as space bar in evil
; (global-set-key [(meta x)] 'cut-line-or-region)
(global-set-key [(meta s)] 'save-buffer)
;; (global-set-key [(meta l)] 'goto-line)
;; see fiplr
;; (global-set-key [(meta o)] 'find-file)
(global-set-key [(meta f)] 'isearch-forward)
(global-set-key [(meta g)] 'isearch-repeat-forward)
(global-set-key [(meta q)]
                (lambda () (interactive) (do-auto-save) (kill-emacs)))
(global-set-key [(meta w)]
                (lambda () (interactive) (kill-buffer (current-buffer))))
; (global-set-key [(meta w)] 'delete-window)

(setq make-backup-files nil) ; stop creating backup~ files

;; http://stackoverflow.com/questions/4477376/some-emacs-desktop-save-questions-how-to-change-it-to-save-in-emacs-d-emacs
;; Automatically save and restore sessions
(setq desktop-dirname             "~/.emacs.d/desktop/"
      desktop-base-file-name      "emacs.desktop"
      desktop-base-lock-name      "lock"
      desktop-path                (list desktop-dirname)
      desktop-save                t
      desktop-load-locked-desktop nil)
(desktop-save-mode 1)

;; http://superuser.com/questions/122119/locate-all-emacs-autosaves-and-backups-in-one-folder
;; Put autosave files (ie #foo#) in one place, *not*
;; scattered all over the file system!
;; TODO: haven't figured out how to auto recover files on startup
(defvar autosave-dir (concat "~/.emacs.d/autosaves/"))

(make-directory autosave-dir t)

(defun auto-save-file-name-p (filename)
  (string-match "^#.*#$" (file-name-nondirectory filename)))

(defun make-auto-save-file-name ()
  (concat autosave-dir
          (if buffer-file-name
              (concat "#" (file-name-nondirectory buffer-file-name) "#")
            (expand-file-name
             (concat "#%" (buffer-name) "#")))))

;; when file changes on disk, auto reload
(global-auto-revert-mode t)

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
;; TODO: doesn't work with backspace. I think I screwed up something
(delete-selection-mode 1)

;; window size & position
(add-to-list 'default-frame-alist '(height . 999))
(add-to-list 'default-frame-alist '(width . 160))
(add-to-list 'default-frame-alist '(top . 0))
(add-to-list 'default-frame-alist '(left . 0))
;; white scroll bar. not sure how to change color. ugly
(scroll-bar-mode 0)

;; window management
(global-set-key [(meta \{)] (lambda () (interactive)
                              (previous-multiframe-window)))
(global-set-key [(meta \})] (lambda () (interactive)
                              (next-multiframe-window)))

(global-set-key [(meta n)] 'split-window-right)
;; command palette to helm M-x. see it in its config in use-package helm
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)
;; preserve cursor position when scrolling...
(setq scroll-preserve-screen-position t)
;; setq-default allows it to be overridden
(setq-default indent-tabs-mode nil)
;; tab: use 2 spaces
(setq tab-width 2)
;; delete trailing whitespace on save
(add-hook 'write-file-hooks 'delete-trailing-whitespace)
;; somehow doesn't show visually but that's ok I guess
;; TODO: doesn't work for now
;; (require-final-newline t)

;; duplicate line
(defun duplicate-line()
  (interactive)
  (move-beginning-of-line 1)
  (kill-line)
  (yank)
  (open-line 1)
  (next-line 1)
  (yank))
(global-set-key (kbd "M-D") 'duplicate-line)

;; swap lines
(defun move-line-up ()
  "Move up the current line."
  (interactive)
  (transpose-lines 1)
  (forward-line -2)
  (indent-according-to-mode))

(defun move-line-down ()
  "Move down the current line."
  (interactive)
  (forward-line 1)
  (transpose-lines 1)
  (forward-line -1)
  (indent-according-to-mode))
(global-set-key [(meta shift j)] 'move-line-down)
(global-set-key [(meta shift k)] 'move-line-up)
