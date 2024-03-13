return {
	"nvimtools/none-ls.nvim",
	config = function()
		local null_ls = require("null-ls")
		null_ls.setup({
			sources = {
				null_ls.builtins.formatting.stylua,
				null_ls.builtins.formatting.prettier,
        null_ls.builtins.code_actions.gitsigns.with({
          config = {
            filter_actions = function(title)
              return title:lower():match("blame") == nil -- filter out blame actions
            end,
          },
        }),
        null_ls.builtins.code_actions.refactoring,
        null_ls.builtins.diagnostics.clazy,
        null_ls.builtins.diagnostics.mdl,
        null_ls.builtins.diagnostics.pylint,
        null_ls.builtins.diagnostics.revive,
        --null_ls.builtins.diagnostics.sqlfluff.with({
          --extra_args = { "--dialect", "postgres" }, -- change to your dialect
        --}),
        null_ls.builtins.diagnostics.staticcheck,
        null_ls.builtins.diagnostics.tidy,
        null_ls.builtins.formatting.black,
        null_ls.builtins.formatting.buf,
        null_ls.builtins.formatting.clang_format,
        -- null_ls.builtins.formatting.fourmolu,
        null_ls.builtins.formatting.gofumpt,
        null_ls.builtins.formatting.goimports_reviser,
        null_ls.builtins.formatting.isort,
        -- null_ls.builtins.formatting.lua_format,
        null_ls.builtins.formatting.ocamlformat,
        null_ls.builtins.formatting.pg_format,
        null_ls.builtins.formatting.prismaFmt,
        null_ls.builtins.formatting.remark,
        null_ls.builtins.formatting.scalafmt,
--        null_ls.builtins.formatting.sqlfluff.with({
--          extra_args = { "--dialect", "postgres" }, -- change to your dialect
--        }),
        null_ls.builtins.formatting.yamlfmt,
        null_ls.builtins.formatting.rustywind
			},
		})

		vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, {})
	end,
}
