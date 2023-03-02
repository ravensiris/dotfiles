;; Setup font
(setq doom-font (font-spec :family "VictorMono Nerd Font" :size 18))

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

(define-hostmode poly-elixir-hostmode :mode 'elixir-mode)
(define-innermode poly-heex-component-innermode
  :mode 'web-mode
  :head-matcher (rx line-start (* space) "~H" (= 3 (char "\"'")) line-end)
  :tail-matcher (rx line-start (* space) (= 3 (char "\"'")) line-end)
  :head-mode 'host
  :tail-mode 'host
  :allow-nested nil
  :keep-in-mode 'host
  :fallback-mode 'host)
(define-polymode poly-elixir-web-mode
  :hostmode 'poly-elixir-hostmode
  :innermodes '(poly-heex-component-innermode))

(setq web-mode-engines-alist '(("elixir" . "\\.ex\\'")))
(add-to-list 'auto-mode-alist '("\\.ex\\'" . poly-elixir-web-mode))
