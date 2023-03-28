;; Setup font
(setq doom-font (font-spec :family "VictorMono Nerd Font" :size 18))

(set-fontset-font t 'symbol "Noto Color Emoji")
(set-fontset-font t 'symbol "OpenMoji Color" nil 'append)
(set-fontset-font t 'symbol "Twitter Color Emoji" nil 'append)

(use-package! lsp-tailwindcss
  :init
  (setq! lsp-tailwindcss-add-on-mode t))

(add-to-list 'lsp-tailwindcss-major-modes 'heex-ts-mode)

;; Setup lsp for nix
                                        ;(after! lsp-clients
                                        ;       (add-to-list 'lsp-language-id-configuration '(nix-mode . "nix"))
                                        ;       (lsp-register-client
                                        ;               (make-lsp-client :new-connection (lsp-stdio-connection '("rnix-lsp"))
                                        ;                               :major-modes '(nix-mode)
                                        ;                               :server-id 'nix)))

(defun doom-modeline-set-vcs-modeline () 1)

;; (defun lsp-put-elixir-ls-from-executable-find ()
;;    (setq lsp-elixir-local-server-command (executable-find "elixir-ls")))

;; (add-hook 'elixir-mode-hook #'lsp-put-elixir-ls-from-executable-find)

;; (defun elixir-heex-format-on-save()
;;   (interactive)
;;   (when (and (eq major-mode 'web-mode)
;;              (string-match-p "html.heex$" (buffer-file-name)))
;;     (elixir-format)))

;; (add-hook 'before-save-hook #'elixir-heex-format-on-save)

(atomic-chrome-start-server)

(setq ob-mermaid-cli-path (executable-find "mmdc"))

(require 'f)
(unless (and (mapcar #'f-exists? '("~/Documents/References/pubs/doc" "~/Documents/Notes" "~/Documents/References/pubs/bib")))
    (let ((library-path "~/Documents/References/pubs/doc")
          (notes-path "~/Documents/Notes")
          (references-paths (f-files "~/Documents/References/pubs/bib")))
      (setq! bibtex-completion-library-path `(,library-path))
      (setq! bibtex-completion-notes-path notes-path)
      (setq! bibtex-completion-bibliography references-paths)
      (setq! citar-library-paths `(,library-path))
      (setq! citar-notes-paths `(,notes-path))
      (setq! citar-bibliography references-paths)))

(setq citar-symbols
      `((file ,(all-the-icons-faicon "file-o" :face 'all-the-icons-green :v-adjust -0.1) . " ")
        (note ,(all-the-icons-material "speaker_notes" :face 'all-the-icons-blue :v-adjust -0.3) . " ")
        (link ,(all-the-icons-octicon "link" :face 'all-the-icons-orange :v-adjust 0.01) . " ")))
(setq citar-symbol-separator "  ")

(setq projectile-project-search-path '("~/Projects"))

(map! :leader :desc "ripgrep using deadgrep" :n "/" #'deadgrep)

(map! :map deadgrep-mode-map
      :after deadgrep
      :n "n" #'deadgrep-forward-match
      :n "N" #'deadgrep-backward-match
      :n "]" #'deadgrep-forward-filename
      :n "[" #'deadgrep-backward-filename)


(require 'lsp-mode)
(require 'edit-indirect)
(require 'heex-ts-mode)
(require 'elixir-ts-mode)
(require 'uuidgen)
;;(format "%s.html.heex" (uuidgen-4))

(setq lsp-language-id-configuration
           (append (remove '(heex-ts-mode . "elixir") lsp-language-id-configuration)
                   '((elixir-ts-mode . "elixir")
                     (heex-ts-mode . "html"))))

(add-to-list 'auto-mode-alist '("\\.heex\\'" . heex-ts-mode))

(add-hook 'heex-ts-mode-hook #'lsp)
(add-hook 'elixir-ts-mode-hook #'lsp)

;; (lsp-register-client
;;         (make-lsp-client
;;                 :new-connection (lsp-stdio-connection '("tailwindcss-language-server" "--stdio"))
;;                 :major-modes '(heex-ts-mode)
;;                 :add-on? t
;;                 :priority -2
;;                 :server-id 'tailwindcss-ls))



(defun elixir-ts-edit-heex ()
  (interactive)
  (pcase-let ((`(,beg . ,end) (bounds-of-thing-at-point 'defun)))
    (with-current-buffer
        (edit-indirect-region
         (save-excursion
           (search-backward "\"\"\"\n" beg)
           (match-end 0))
         (save-excursion
           (re-search-forward "^\\s-*\"\"\"" end)
           (match-beginning 0)))
      (heex-ts-mode)
      (goto-char (point-min))
      (setq-local buffer-file-name (format "%s.html.heex" (uuidgen-4)))
      ;; (rename-buffer "arst.html.heex")
      (lsp)
      (pop-to-buffer-same-window (current-buffer)))))

(setq! typescript-indent-level 2)
