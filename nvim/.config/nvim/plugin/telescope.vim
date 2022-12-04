lua << EOF
local actions = require('telescope.actions')
require('telescope').setup {
    defaults = {
        prompt_prefix = ' >',
        color_devicons = true,

        mappings = {
            i = {
                ["<C-x>"] = false,
                ["<C-q>"] = actions.send_to_qflist,
            },
        }
    }
}
EOF

nnoremap <leader>ps :lua require('telescope.builtin').grep_string({ search = vim.fn.input("Grep For >> ")})<CR>
nnoremap <leader>pg :lua require('telescope.builtin').git_files()<CR>
nnoremap <leader>pf :lua require('telescope.builtin').find_files()<CR>
