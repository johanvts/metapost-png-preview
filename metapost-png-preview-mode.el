;;; metapost-png-preview-mode.el

(require 'image-mode)

;;;; Internal variables

(defvar metapost-prev-outputformat
  nil
  "The outputformat originally specified by the user.")

(defvar metapost-prog-mpost
  (executable-find "mpost")
  "The mpost executable path.")

(defun metapost-regex-find-first-match (regex-pattern num)
  (setq detected (search-forward-regexp regex-pattern nil t 1))
  (setq pattern-match nil)
  (if (not detected)
      (setq detected (search-backward-regexp regex-pattern nil t 1)))
  (if detected (setq pattern-match (match-string-no-properties num)))
  pattern-match)
    
(defun metapost-outputformat-set (new-outputformat)
  (message "in set")
  (let* ((regex-pattern "\\(outputformat:=\"\\([a-zA-Z]+\\)\";*\\)")
	(new-formatcommand (format "outputformat:=\"%s\";" new-outputformat))
	(tmp-point (point))
	(pattern-match (metapost-regex-find-first-match regex-pattern 1)))
    (if pattern-match
	(progn
	  (message "got match %s" pattern-match)
	  (setq metapost-prev-outputformat (match-string-no-properties 2))
	  (replace-match new-formatcommand)
	  (goto-char tmp-point))
      (save-excursion
	    (progn
	      (goto-char (point-min))
	      (message "opening ten lines")
	      (open-line 1)
	      (insert new-formatcommand)
	      (setq metapost-prev-outputformat nil)      
	      )))))

(defun metapost-outputformat-remove ()
  (let* ((regex-pattern "\\(outputformat:=\".*\";*\\)")
	(tmp-point (point))
	(pattern-match (metapost-regex-find-first-match regex-pattern 1)))
      (if pattern-match
	  (progn
	    (replace-match "")
	    (if (looking-at "[[:space:]]*$")
		(kill-whole-line))
	    (goto-char tmp-point)))))

(defun metapost-outputformat-restore (old-outputformat)
  (if old-outputformat
      (progn
	(message "restoring format %s" old-outputformat)
	(metapost-outputformat-set old-outputformat))
    (metapost-outputformat-remove)))

(defun metapost-compile-buffer ()
  "Compile current buffer with metapost."
  (let* ((curbuf-fname (file-name-nondirectory  buffer-file-name))
         (output-buffer (metapost-prepare-buffer curbuf-fname "*metapost: %s*")))
    (call-process metapost-prog-mpost nil output-buffer nil curbuf-fname)
    output-buffer))

(defun metapost-prepare-buffer (buffer-name &optional buffer-name-format)
  (let* ((buffer-string (if buffer-name-format
                            (format buffer-name-format buffer-name)
                             buffer-name))
         (old-buffer (get-buffer buffer-string)))
    (if old-buffer
        (progn
	  (setq old-window (get-buffer-window old-buffer))
	  (quit-window t old-window)))
    (get-buffer-create buffer-string)))

(defun metapost-locate-figure-no ()
  "This function will locate which figure's body your cursor is
in, and return it as the figure no next to be previewed. If your
cursor is out of any figure's body, such as in the
begining/ending of .mp file, it will return the first/last
figure."
  ;;(interactive)
  (let* ((beginfig-pattern "beginfig\\([ \t]*\\)(\\(.*\\))")
         (old-point (point)))
    ;; first we assume already inside some figure's body
    (re-search-backward beginfig-pattern nil t 1)
    (let* ((figure-no-start (match-beginning 2))
           (figure-no-end (match-end 2)))
      (if (not (and figure-no-start figure-no-end))
          ;; now try forward, may be at the begining of file
          (progn (re-search-forward beginfig-pattern nil t 1)
                 (setq figure-no-start (match-beginning 2))
                 (setq figure-no-end (match-end 2))))
      (if (and figure-no-start figure-no-end)
          (progn (goto-char old-point)
                  (buffer-substring-no-properties (match-beginning 2) (match-end 2)))))))

(defun metapost-png-preview ()
  "View current figure by opening the png output in image-view mode"
  ;; (interactive)
  (let* ((curbuf-fname-full (buffer-file-name))
         (curbuf-fname-nodirext
          (file-name-sans-extension (file-name-nondirectory curbuf-fname-full)))
         (curbuf-dir (file-name-directory curbuf-fname-full))
         (curbuf-figure-name (concat curbuf-fname-nodirext "." (metapost-locate-figure-no)))
	 (metapost-mode+-current-source-buffer (current-buffer)))
    (if (not (get-buffer curbuf-figure-name))
      (progn (find-file-other-window curbuf-figure-name)
	     (image-mode)
	     (toggle-read-only)
	     (auto-revert-mode)
	     (switch-to-buffer-other-window metapost-mode+-current-source-buffer)))))

(defun metapost-png-next ()
  "(1) detect changes and prompt to save. (2) set png header (3)try to compile.
(4) revert header changes. (5) Show preview."
  (interactive)
  (setq ok-to-preview t)
  (if (buffer-modified-p)
      (if (y-or-n-p (format "Save %s to preview the figure?" (buffer-file-name)))
          (save-buffer)
        (setq ok-to-preview nil)))
  (if ok-to-preview
    (progn (message "calling set")(metapost-outputformat-set "png" )(save-buffer)))
  (if ok-to-preview
          (progn (setq output-buffer (metapost-compile-buffer))
                 (metapost-png-preview)
                 (metapost-outputformat-restore metapost-prev-outputformat)
                 (save-buffer)
                 (display-buffer-below-selected output-buffer ()))))

;;;; metapost-png-preview keymap

(add-hook 'metapost-mode-hook
          (lambda ()
            (define-key meta-mode-map "\C-c\C-c" 'metapost-png-next)))

;;;

(provide 'metapost-png-preview-mode)

;;; metapost-png-preview-mode.el ends here
