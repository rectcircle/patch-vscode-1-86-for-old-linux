#!/usr/bin/env bash
set -ex

# constant
glibc_prefix=/opt/patch-vscode-1-86-for-old-linux
build_root=$(pwd)
glibc_name=glibc-2.35
patchelf_version=0.18.0

# clean and prepare directory
rm -rf dist $glibc_name/ $glibc_name.tar.gz $glibc_prefix patchelf.tar.gz patchelf/
mkdir -p patchelf/ dist/lib dist/bin

# compile glibc
apt update && apt install -y gcc make gdb texinfo gawk bison sed python3-dev python3-pip zlib1g libstdc++6
wget http://ftp.gnu.org/gnu/glibc/$glibc_name.tar.gz
tar -zxvf $glibc_name.tar.gz
cd $glibc_name/
mkdir -p build && cd build
../configure --prefix=$glibc_prefix
make -j4
make install
cd $build_root

# cp glibc
cp -rfP $glibc_prefix/lib/*.so* dist/lib

# cp libcxx
cp /usr/lib/x86_64-linux-gnu/libstdc++.so.6.0.* dist/lib/
ln -s $(basename $(ls dist/lib/libstdc++.so.6.0.*)) dist/lib/libstdc++.so.6

# cp libgcc_s and libz
cp /usr/lib/x86_64-linux-gnu/libgcc_s.so.1 dist/lib/
cp -rfP /lib/x86_64-linux-gnu/libz.so.* dist/lib/

# install patchelf
wget https://github.com/NixOS/patchelf/releases/download/$patchelf_version/patchelf-$patchelf_version-x86_64.tar.gz -O patchelf.tar.gz
tar -zxvf patchelf.tar.gz -C patchelf/
cp patchelf/bin/patchelf dist/bin/
