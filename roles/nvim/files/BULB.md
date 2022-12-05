# Nvim bulb fennel compiler

Need to add runtimepaths to fennel.path and fennel.macro-path

1. Look for all fennel files in runtimepath
2. Compile all files then turn them into bytecode with string.dump
3. Generate a cache file that uses package.preload to preload all of these bytecode strings with loadstring.
4. Run the cache file on start

## Optimizations

1. Check timestamps to see if a file needs to be recompiled.
   For this we need a dependency graph for macros.
   We can generate the graph using a compiler plugin like hotpot.
   We can reuse the cache file to store module metadata (deps, modify time) on global object similar to packer.
2. Using luv async functions for fs operations.
3. Using worker threads to do parallel compilation

## TODO

1. handle caching of macro modules
2. Parallel compilation
