(module magic.init
  {autoload {plugin magic.plugin
             nvim aniseed.nvim
             a aniseed.core
             u magic.utils}})

;; ---
;; Hello, this is a Neovim config specialized for writing-centric activities;
;; it will host little-to-no programming language support or related niceties.
;; ---


;;; Introduction

;; Aniseed compiles this (and all other Fennel files under fnl) into the lua
;; directory. The init.lua file is configured to load this file when ready.

;; We'll use modules, macros and functions to define our configuration and
;; required plugins. We can use Aniseed to evaluate code as we edit it or just
;; restart Neovim.

;; You can learn all about Conjure and how to evaluate things by executing
;; :ConjureSchool in your Neovim. This will launch an interactive tutorial.


;;; Generic configuration

(set nvim.o.termguicolors true)
(set nvim.o.mouse "a")
(set nvim.o.updatetime 500)
(set nvim.o.timeoutlen 500)
(set nvim.o.sessionoptions "blank,curdir,folds,help,tabpages,winsize")
(set nvim.o.inccommand :split)

(nvim.ex.set :spell)
(nvim.ex.set :list)


;;; Mappings

(set nvim.g.mapleader " ")
(set nvim.g.maplocalleader ",")


;;; Plugins

;; Run script/sync.sh to update, install and clean your plugins.
;; Packer configuration format: https://github.com/wbthomason/packer.nvim

;; The `plugin.use` function will map the table belonging to a plugin-name to
;; the typical format Packer will expect, for example:
;;
;;   the option `:requires ["someone/some-other-plugin" "me/my-own-plugin"]`
;;   will map to `requires = {"someone/some-other-plugin", "me/my-own-plugin"}`
;;
;; However, there is a particular little "extra" provided: the `mod` option.
;; Providing the option `:mod :<name>` will see Packer take the contents of
;; `fnl/magic/plugin/<name>`, and use them as if they were specified in the
;; `config` element for that plugin, with a layer of error-tolerance added on
;; top, so that everything won't come crashing down if your config is a little
;; scuffed.
;;
;; See `magic/plugin.fnl` for the function definition and further details.

(plugin.use
  ;; Criticals
  :Olical/aniseed {}
  :Olical/conjure {}

  ;; Preloadeds
  :airblade/vim-gitgutter {}
  :folke/which-key.nvim {}
  :hrsh7th/nvim-cmp {}
  :itchyny/lightline.vim {}
  :jiangmiao/auto-pairs {:mod :auto-pairs}
  :junegunn/fzf {}
  :junegunn/fzf.vim {}
  :liuchengxu/vim-better-default {:mod :better-default}
  :mbbill/undotree {}
  :radenling/vim-dispatch-neovim {}
  :srcery-colors/srcery-vim {}
  :tpope/vim-abolish {}
  :tpope/vim-commentary {}
  :tpope/vim-fugitive {}
  :tpope/vim-repeat {}
  :tpope/vim-sleuth {}
  :tpope/vim-surround {}
  :tpope/vim-unimpaired {}
  :tpope/vim-vinegar {}

  ;; Colorschemes
  :Th3Whit3Wolf/space-nvim {:mod :space-nvim}
  :elianiva/gitgud.nvim {}
  :shaunsingh/solarized.nvim {:mod :solarized}
  :rose-pine/neovim {:as :rose-pine
                     :tag "v1.*"
                     :mod :rosepine}

  ;; Customizations
  :lewis6991/impatient.nvim {}
  :goolord/alpha-nvim {:mod :alpha-nvim
                       :requires ["kyazdani42/nvim-web-devicons"]}
  :axelf4/vim-strip-trailing-whitespace {}
  :kyazdani42/nvim-web-devicons {:mod :devicons}
  :ggandor/lightspeed.nvim {}
  :nvim-lua/plenary.nvim {}
  :tami5/sqlite.lua {}
  :nvim-telescope/telescope-fzf-native.nvim {:run "make"}
  :nvim-telescope/telescope.nvim {:mod :telescope
                                  :requires ["nvim-lua/plenary.nvim"
                                             "nvim-telescope/telescope-fzf-native.nvim"]}
  :nvim-telescope/telescope-frecency.nvim {:mod :frecency
                                           :requires ["tami5/sqlite.lua"]}
  :nvim-treesitter/nvim-treesitter {:mod :treesitter
                                    :run ":TSUpdate"}
  :ahmedkhalf/project.nvim {:mod :project-nvim}

  ;; Generic Lang Support
  ;:janet-lang/janet.vim {}

  ;; Writing-Focused Plugins
  :ellisonleao/glow.nvim {:run ":GlowInstall"} ; md preview
  :folke/zen-mode.nvim {:mod :zen}
  :folke/twilight.nvim {:mod :twi}
  ;latex support to follow..

  :wbthomason/packer.nvim {})



;;; After-plugin configs

(def toggle-background
  #(let [bg nvim.o.background]
    (if (not= "dark" bg) ;; check for a `not` in the case of an unset background
      (set nvim.o.background :dark)
      (set nvim.o.background :light))))

(u.mapkey "n" "<leader>b" toggle-background)

;; Set our theme dependent on what machine we're on.
(def hostname (vim.loop.os_gethostname))

;; TODO: Ideally source this table from another file?
(def host-themes
  {:slt440s #(let [sol (require :solarized)]
               (sol.set)
               (set nvim.o.background :light))})

(def set-default-theme
  #(do (nvim.ex.colorscheme :space-nvim)
       (set nvim.o.background :dark)))

(let [set-theme-func (. host-themes hostname)]
  (if (a.nil? set-theme-func)
    (set-default-theme)
    (set-theme-func)))
