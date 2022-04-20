PHONY: fmt-lua fmt-fnl fmt

fmt: fmt-lua fmt-fnl

fmt-lua:
	stylua .

fmt-fnl:
	find . -type f -iname "*.fnl" -exec fnlfmt --fix {} \;
