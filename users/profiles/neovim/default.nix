{ config, lib, pkgs, ... }:
let
  nvim-ayu = pkgs.vimUtils.buildVimPluginFrom2Nix {
    version = "2023.03.03";
    pname = "neovim-ayu";
    src = pkgs.fetchFromGitHub {
      owner = "Shatur";
      repo = "neovim-ayu";
      rev = "0eb91afe11f1763a477655965684269a545012e1";
      sha256 = "sha256-SQzGMbTmmRWsQhGzx7sGxfyEpQ6QGJcxkEJkiqj3Cto=";
    };
    meta.homepage = "https://github.com/Shatur/neovim-ayu";
  };

  vim-denops = pkgs.vimUtils.buildVimPluginFrom2Nix {
    version = "2023.03.03";
    pname = "denops.vim";
    src = pkgs.fetchFromGitHub {
      owner = "vim-denops";
      repo = "denops.vim";
      rev = "8f3899de3d3add07105221262dca90a31c4c2d4c";
      sha256 = "sha256-OXeVB2qZ9V1c9nizenDCEtAQxNW4cJGzhdVJGFgtEfI=";
    };
    meta.homepage = "https://github.com/vim-denops/denops.vim";
  };

  vim-ddc = pkgs.vimUtils.buildVimPluginFrom2Nix {
    version = "2023.03.03";
    pname = "ddc-vim";
    src = pkgs.fetchFromGitHub {
      owner = "Shougo";
      repo = "ddc.vim";
      rev = "bbcdc2b8bb928599cc671ed0346f571bd16c9366";
      sha256 = "sha256-ALDfyAOqiNvyPbMqk+FeijWejDyT/AZh/7VPXUKuZjs=";
    };
    meta.homepage = "https://github.com/Shougo/ddc.vim";
  };

  vim-ddc-ui-native = pkgs.vimUtils.buildVimPluginFrom2Nix {
    version = "2023.03.03";
    pname = "ddc-ui-native";
    src = pkgs.fetchFromGitHub {
      owner = "Shougo";
      repo = "ddc-ui-native";
      rev = "5ff6a1b887c26b3ad9d5085941e6472716703a5e";
      sha256 = "sha256-jhd+0Ll5kaZ7LEfCqVbIELEHjamqUqJ3U0ABHBOhr0M=";
    };
    meta.homepage = "https://github.com/Shougo/ddc-ui-native";
  };

in
{
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    plugins = with pkgs.vimPlugins; [
      {
        plugin = (nvim-treesitter.withPlugins (
          plugins: with plugins; [
            tree-sitter-elixir
            tree-sitter-heex
            tree-sitter-eex
          ]
        ));
        type = "lua";
        config = builtins.readFile (./tree_sitter.lua);
      }
      vim-nix
      vim-elixir
      {
        plugin = ale;
        config = ''
          call ale#linter#Define('elixir', {
          \ 'name': 'elixir-lsp',
          \ 'lsp': 'stdio',
          \ 'executable': 'elixir-ls',
          \ 'command': '%e',
          \ 'project_root': function('ale#handlers#elixir#FindMixUmbrellaRoot'),
          \})

          let g:ale_linters = {
          \   'elixir': ['elixir-lsp', 'credo'],
          \}

          let g:ale_fixers = {
          \   'elixir': ['mix_format'],
          \}

          let g:ale_completion_enabled = 1
          let g:ale_sign_error = '✘'
          let g:ale_sign_warning = '⚠'
          let g:ale_lint_on_enter = 0
          let g:ale_lint_on_text_changed = 'never'
          highlight ALEErrorSign ctermbg=NONE ctermfg=red
          highlight ALEWarningSign ctermbg=NONE ctermfg=yellow
          let g:ale_linters_explicit = 1
          let g:ale_lint_on_save = 1
          let g:ale_fix_on_save = 1

          noremap <Leader>ad :ALEGoToDefinition<CR>
          nnoremap <leader>af :ALEFix<cr>
          noremap <Leader>ar :ALEFindReferences<CR>

          "Move between linting errors
          nnoremap ]r :ALENextWrap<CR>
          nnoremap [r :ALEPreviousWrap<CR>
        '';
      }
    ] ++ [
      {
        plugin = nvim-ayu;
        type = "lua";
        config = ''
          vim.cmd.colorscheme('ayu-mirage')
        '';
      }
      vim-denops
      vim-ddc
      {
        plugin = vim-ddc-ui-native;
        config = ''
          call ddc#custom#patch_global('ui', 'native')
        '';
      }
    ];
    extraConfig = ''
      " <TAB>: completion.
      inoremap <silent><expr> <TAB>
      \ pumvisible() ? '<C-n>' :
      \ (col('.') <= 1 <Bar><Bar> getline('.')[col('.') - 2] =~# '\s') ?
      \ '<TAB>' : ddc#map#manual_complete()

      " <S-TAB>: completion back.
      inoremap <expr><S-TAB>  pumvisible() ? '<C-p>' : '<C-h>'

      call ddc#custom#patch_filetype(['ex'], 'sources', ['ale'])

      " Use ddc.
      call ddc#enable()
    '';
  };

  home.packages = with pkgs; [
    tree-sitter
    deno
  ];
}
