local status, lsp = pcall(require, 'lsp-zero')
if (not status) then return end

local null_ls = require("null-ls")
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

local null_opts = lsp.build_options('null-ls', {
  on_attach = function(client, bufnr)
    if client.supports_method("textDocument/formatting") then
      vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = augroup,
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.format({ bufnr = bufnr })
        end,
      })
    end
  end,
})

null_ls.setup({
  on_attach = null_opts.on_attach,
  sources = {
    null_ls.builtins.formatting.stylua,
    null_ls.builtins.diagnostics.eslint.with {
      condition = function(utils)
        return utils.root_has_file({ ".eslintrc.js", ".eslintrc.json" })
      end
    },
    -- null_ls.builtins.completion.spell,
    null_ls.builtins.formatting.gofmt,
    null_ls.builtins.formatting.jq,
    null_ls.builtins.formatting.eslint.with {
      condition = function(utils)
        return utils.root_has_file({ ".eslintrc.js", ".eslintrc.json" })
      end
    },
    null_ls.builtins.formatting.rustfmt,
    null_ls.builtins.formatting.prettier.with {
      filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue", "css", "scss", "less",
        "html", "json", "jsonc", "yaml", "markdown", "markdown.mdx", "graphql", "handlebars", "astro", "svelte" }
    }
  },
})
