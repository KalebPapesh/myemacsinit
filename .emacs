;;remove default start-up buffer
(setq inhibit-startup-message t)

;;implement colour coding
(global-font-lock-mode t)

;;turn off menu bar if in CLI
(cond
    ((eq window-system 'x)
     (menu-bar-mode 1))
    (t
     (menu-bar-mode 0)))
  
;;stop annoying backup files
(setq make-backup-files nil)

;;change buffering search system
;;(iswitchb-mode 1)

;;change yes or no to y or p
(fset `yes-or-no-p `y-or-n-p)

;; Set Linum-Mode on
(global-linum-mode t)
 
;; Linum-Mode and add space after the number
(setq linum-format "%d ")

;;suppress symbolic link warnings
(setq find-file-visit-truename t)

;;show matching parens
(show-paren-mode 1)

;;Add slime if exists
(if
	(file-exists-p "~/quicklisp/slime-helper.el")
	(load (expand-file-name "~/quicklisp/slime-helper.el"))
	(setq inferior-lisp-program "sbcl"))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(put 'scroll-left 'disabled nil)

;;make foreground green in gui
(add-to-list 'default-frame-alist '(foreground-color . "#00FF00"))

;;make background black in gui
(when (display-graphic-p) (set-background-color "black"))

;;save scripts as executable upon save
(add-hook 'after-save-hook
	  #'(lambda ()
	      (and (save-excursion
		     (save-restriction
		       (widen)
		       (goto-char (point-min))
		       (save-match-data
			 (looking-at "^#!"))))
		   (not (file-executable-p buffer-file-name))
		   (shell-command (concat "chmod +x " buffer-file-name))
		   (message
		    (concat "Saved as script: " buffer-file-name)))))

;;insert templates for known file types
(auto-insert-mode) ;;adds hook to find-files-hook
(setq auto-insert-directory "~/.myemacsprogrammingtemplates/") ;;specifies template dir. Trailing slash is important!
(setq auto-insert-query nil) ;;don't prompt before insertion
;;template sections
(define-auto-insert "\.sh" "my-sh-template.sh")

;;overwrite the selected region after marking and yanking. ie cut and paste
(delete-selection-mode 1)

;;auto update buffer if changes are made to file
(global-auto-revert-mode t)

(defun save-macro (name)                  
    "save a macro. Take a name as argument
     and save the last defined macro under 
     this name at the end of your .emacs"
     (interactive "SName of the macro: ")  ; ask for the name of the macro    
     (kmacro-name-last-macro name)         ; use this name for the macro    
     (find-file user-init-file)            ; open ~/.emacs or other user init file 
     (goto-char (point-max))               ; go to the end of the .emacs
     (newline)                             ; insert a newline
     (insert-kbd-macro name)               ; copy the macro 
     (newline)                             ; insert a newline
     (save-buffer)                         ; save buffery
     (switch-to-buffer nil))               ; switch back to original buffer

(fset 'removeline
   (lambda (&optional arg) "Keyboard macro." (interactive "p") (kmacro-exec-ring-item (quote ([1 11 backspace 14] 0 "%d")) arg)))
