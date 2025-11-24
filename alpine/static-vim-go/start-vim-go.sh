#!/bin/sh
export PATH="/go/bin:/usr/local/go/bin:$PATH"
export GOPATH="/go"
vim -u /vim/config/vimrc "$@"
