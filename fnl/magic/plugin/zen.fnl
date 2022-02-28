(module magic.plugin.zen
  {autoload {nvim aniseed.nvim
             a aniseed.core
             u magic.utils
             z zen-mode}})

(z.setup {})

(u.mapkey "n" "<leader><leader>z" ":ZenMode<CR>")
