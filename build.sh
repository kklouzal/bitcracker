#!/usr/bin/env bash

set -euo pipefail

mkdir -p ./build

printf "\n====== Build BitCracker Hash Extractor ======\n"
make -C src_HashExtractor clean bitcracker_hash
mv src_HashExtractor/bitcracker_hash build 2> /dev/null

printf "\n====== Build BitCracker Recovery Password generator ======\n"
make -C src_RPGenerator clean bitcracker_rpgen
mv src_RPGenerator/bitcracker_rpgen build 2> /dev/null

printf "\n====== Build BitCracker CUDA version ======\n"
make -C src_CUDA clean bitcracker_cuda
mv src_CUDA/bitcracker_cuda build 2> /dev/null

if [[ "${SKIP_OPENCL:-0}" == "1" ]]; then
	printf "\n====== Skip BitCracker OpenCL version ======\n"
else
	printf "\n====== Build BitCracker OpenCL version ======\n"
	make -C src_OpenCL clean all
	mv src_OpenCL/bitcracker_opencl build 2> /dev/null
fi

printf "\n====== Executables in build directory ======\n"
ls -lh build
