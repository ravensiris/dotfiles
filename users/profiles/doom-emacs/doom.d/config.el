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

(after! format-all (advice-add 'format-all-buffer :around #'envrc-propagate-environment))
