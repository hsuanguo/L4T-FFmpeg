#!/usr/bin/env bash

set -e
set -o pipefail
set -u

repo_dir=$(
  cd "$(dirname "$0")"
  pwd
)

cd "${repo_dir}"

install_dir=${repo_dir}/build/install/usr/local

# build mpi
if [ -d build ]; then
  rm -rf build
fi
mkdir -p ${install_dir}

cd build

cmake ..
make -j$(nproc)
sudo make install

# build ffmpeg
git clone git://source.ffmpeg.org/ffmpeg.git -b release/4.4 --depth=1
cd ffmpeg
cp ${repo_dir}/ffmpeg_patches/ffmpeg4.4_nvmpi.patch ./ffmpeg_nvmpi.patch
git apply ffmpeg_nvmpi.patch
./configure --enable-nvmpi --enable-shared --prefix=${install_dir}
make -j$(nproc)
make install
