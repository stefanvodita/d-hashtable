#!/bin/bash

run_dir = $PWD;

# deps
# apt-get install curl git make g++ libcurl4-openssl-dev

# clone
mkdir ~/dlang
cd ~/dlang/
git clone https://github.com/dlang/dmd
git clone https://github.com/dlang/druntime
git clone https://github.com/dlang/phobos
git clone https://github.com/dlang/tools

# build
cd ~/dlang/dmd/
make -f posix.mak -j8 AUTO_BOOTSTRAP=1
cd ~/dlang/phobos/
make -f posix.mak -j8

# make command
echo "alias custdmd='~/dlang/dmd/generated/linux/release/64/dmd'" >> ~/.bashrc

# run
cd $run_dir
