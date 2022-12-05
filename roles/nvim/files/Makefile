SHELL := /bin/bash

FNL_FILES := $(shell find . -name '*.fnl' -not -path './lua/bulb/*' -type f | sort)
LUA_FILES := $(patsubst %.fnl,%.lua,$(FNL_FILES))

STYLUA_IGNORE := plugin/packer_compiled.lua lua/bulb/fennel.lua $(subst ./,,$(LUA_FILES)) 

null :=
space := $(null) #

.PHONY: all
all: $(LUA_FILES) .styluaignore

# build lua files
%.lua: %.fnl
	FENNEL_COMPILE=true nvim --headless -c 'FnlCompile $< $@' +q

.styluaignore: $(STYLUA_IGNORE)
	echo -e "$(subst  $(space),\n,$(STYLUA_IGNORE))" > .styluaignore

# clean lua files
.PHONY: clean
clean:
	rm $(LUA_FILES) .styluaignore

# format lua and fennel files
.PHONY: fmt
fmt:
	stylua .; $(foreach file,$(FNL_FILES),echo "Formatting " $(file); fnlfmt --fix $(file);)

# fetch notepad ++ quotes
.PHONY: quotes.json
quotes.json:
	./scripts/nppp_quotes.sh

# update fennel version to latest
.PHONY: update_fennel
update_fennel:
	./scripts/update_fennel.sh
