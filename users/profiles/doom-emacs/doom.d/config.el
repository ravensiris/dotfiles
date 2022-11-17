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

(defun lsp-put-elixir-ls-from-executable-find ()
   (setq lsp-elixir-local-server-command (executable-find "elixir-ls")))

(add-hook 'elixir-mode-hook #'lsp-put-elixir-ls-from-executable-find)

(defun elixir-heex-format-on-save()
  (interactive)
  (when (and (eq major-mode 'web-mode)
             (string-match-p "html.heex$" (buffer-file-name)))
    (elixir-format)))

(add-hook 'before-save-hook #'elixir-heex-format-on-save)
