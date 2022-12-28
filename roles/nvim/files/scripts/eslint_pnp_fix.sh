#!/usr/bin/env bash

# For Yarn PnP, if `pnpEnableEsmLoader` is enabled, then node won't be able to 
# resolve `vscode-eslint-language-server` without the `.cjs` file extension.


MASON="$HOME/.local/share/nvim/mason"

mv "$MASON/packages/eslint-lsp/node_modules/vscode-langservers-extracted/bin/vscode-eslint-language-server" "$MASON/packages/eslint-lsp/node_modules/vscode-langservers-extracted/bin/vscode-eslint-language-server.cjs"

rm "$MASON/bin/vscode-eslint-language-server"
ln -s "$MASON/packages/eslint-lsp/node_modules/vscode-langservers-extracted/bin/vscode-eslint-language-server.cjs" "$MASON/bin/vscode-eslint-language-server"
