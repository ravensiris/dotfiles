;; Setup font
(setq doom-font (font-spec :family "VictorMono Nerd Font" :size 18))

;; Setup lsp for nix
(after! lsp-clients
        (add-to-list 'lsp-language-id-configuration '(nix-mode . "nix"))
        (lsp-register-client
                (make-lsp-client :new-connection (lsp-stdio-connection '("rnix-lsp"))
                                :major-modes '(nix-mode)
                                :server-id 'nix)))
