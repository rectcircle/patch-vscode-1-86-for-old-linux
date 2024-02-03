#!/usr/bin/env bash

# constant
glibc_prefix=/opt/patch-vscode-1-86-for-old-linux
mkdir -p $glibc_prefix

patchelf --set-interpreter $glibc/lib/ld-linux-x86-64.so.2 
