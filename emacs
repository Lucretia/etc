(load-file "/usr/share/emacs/site-lisp/cedet/common/cedet.el")
(load (expand-file-name "~/etc/slime-helper.el"))
(setq inferior-lisp-program "sbcl")

; Autocomplete
(add-to-list 'load-path "~/.emacs.d/")
(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories "~/.emacs.d/ac-dict")
(ac-config-default)

; Paste and indent
(dolist (command '(yank yank-pop))
  (eval `(defadvice ,command (after indent-region activate)
           (and (not current-prefix-arg)
                (member major-mode '(emacs-lisp-mode lisp-mode
                                                     clojure-mode    scheme-mode
                                                     haskell-mode    ruby-mode
                                                     rspec-mode      python-mode
                                                     c-mode          c++-mode
                                                     objc-mode       latex-mode
                                                     plain-tex-mode))
                (let ((mark-even-if-inactive transient-mark-mode))
                  (indent-region (region-beginning) (region-end) nil))))))

; Color Theme
(add-to-list 'load-path "~/.emacs.d/color-theme-6.6.0")
(require 'color-theme)
(eval-after-load "color-theme"
  '(progn
     (color-theme-initialize)
     (color-theme-clarity)
     (set-face-background 'default "gray15")))

(load-file "~/.emacs.d/color-theme-almost-monokai.el")
(color-theme-almost-monokai)

; Backups
(setq make-backup-files t)
(setq version-control t)
(setq backup-directory-alist (quote ((".*" . "~/.emacs_backups/"))))

; ECB

(add-to-list 'load-path "~/.emacs.d/ecb-snap/")
(require 'ecb)

; Omit things
(setq inhibit-startup-screen t)
(setq inhibit-startup-buffer-menu t)

; Enable syntax highlighting
(require 'font-lock)

; Cycle through buffers
(global-set-key (kbd "C-`") 'bury-buffer)

; Geiser
(load-file "~/.emacs.d/geiser/build/elisp/geiser-load.el")
(setq geiser-active-implementations '(racket))

; Paren and minor stuff
(setq scheme-program-name "mit-scheme")
(add-hook 'scheme-mode-hook '(lambda ()
                             (local-set-key (kbd "RET") 'newline-and-indent)))
(load-file "~/.emacs.d/ada-gpr.el")
(show-paren-mode 1)
(global-linum-mode 1)
(setq column-number-mode t)
(setq line-number-mode t)
;(setq linum-format "%d ")
(require 'ido)
(require 'uniquify)
(setq uniquify-buffer-name-style 'forward)
(setq-default indent-tabs-mode nil)

; Maxima mode
 (add-to-list 'load-path "/usr/share/maxima/5.27.0/emacs")
 (autoload 'maxima-mode "maxima" "Maxima mode" t)
 (autoload 'imaxima "imaxima" "Frontend for maxima with Image support" t)
 (autoload 'maxima "maxima" "Maxima interaction" t)
 (autoload 'imath-mode "imath" "Imath mode for math formula input" t)
 (setq imaxima-use-maxima-mode-flag t)

; W3M
 (setq browse-url-browser-function 'w3m-browse-url)
 (autoload 'w3m-browse-url "w3m" "Ask a WWW browser to show a URL." t)
 ;; optional keyboard short-cut
 (global-set-key "\C-xm" 'browse-url-at-point)

; Ruby
 (require 'rails)
 (require 'snippet)
 (add-hook 'ruby-mode-hook
      (lambda()
        (add-hook 'local-write-file-hooks
                  '(lambda()
                     (save-excursion
                       (untabify (point-min) (point-max))
                       (delete-trailing-whitespace)
                       )))
        (set (make-local-variable 'indent-tabs-mode) 'nil)
        (set (make-local-variable 'tab-width) 2)
        (imenu-add-to-menubar "IMENU")
        (define-key ruby-mode-map "\C-m" 'newline-and-indent) ;Not sure if this line is 100% right!
        (require 'ruby-electric)
        (ruby-electric-mode t)
        ))

 (add-to-list 'load-path (expand-file-name "~/.emacs.d"))
 (autoload 'scss-mode "scss-mode")
 (add-to-list 'auto-mode-alist '("\\.scss\\'" . scss-mode))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ido-enable-flex-matching t)
 '(ido-enable-regexp t)
 '(ido-everywhere t)
 '(rails-ws:default-server-type "thin")
 '(scroll-bar-mode nil)
 '(show-paren-mode t)
 '(tool-bar-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :background "#121212" :foreground "#F8F8F2" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 101 :width normal :foundry "xos4" :family "Terminus"))))
 '(cursor ((t (:background "white"))))
 '(mode-line ((t (:background "gray" :foreground "black" :box (:line-width -1 :style released-button))))))

(defvar shit-face 'shit-face)
(defface shit-face '((t :foreground "green")) t)
(setq shit-rules
	(list
	 (regexp-opt '("=") t)
	 (cons (regexp-opt '("+" "-" "*" "/" "(" ")") t)
				 'shit-face)))

(defun add-shit-highlight ()
	(interactive)
	(if (null font-lock-defaults)
			(setq font-lock-defaults
						'((shit-rules)))
		(push 'custom-shit (nth 0 font-lock-defaults)))
	(font-lock-refresh-defaults))

(add-hook 'text-mode-hook 'add-shit-highlight)

