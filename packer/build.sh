#!/bin/sh

set -eu

 build () {
   echo "@> 🏭 Building $1"
   cd $1 &&
    packer init . &&
    packer validate . &&
    packer build .
 }

 build 'base'