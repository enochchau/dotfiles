#!/bin/bash

FENNEL_COMPILE=true nvim --headless -c "FnlCompile $1" +q
