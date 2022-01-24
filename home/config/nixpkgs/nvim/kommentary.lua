for _, lang in ipairs({
	"typescriptreact",
	"lua",
	"vim",
	"css",
	"scss",
}) do
	require("kommentary.config").configure_language(lang, {
		single_line_comment_string = "auto",
		multi_line_comment_strings = "auto",
		hook_function = function()
			require("ts_context_commentstring.internal").update_commentstring()
		end,
	})
end
