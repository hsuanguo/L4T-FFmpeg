#!/bin/bash

set -e
set -u
set -o pipefail

script_dir=$(
  cd "$(dirname "$0")"
  pwd
)

cd "${script_dir}"

# remove ffmpeg4.2, ffmpeg4.4, ffmpeg6.0 if exist
if [ -d ffmpeg4.2 ]; then
  rm -rf ffmpeg4.2
fi

if [ -d ffmpeg4.4 ]; then
  rm -rf ffmpeg4.4
fi

if [ -d ffmpeg6.0 ]; then
  rm -rf ffmpeg6.0
fi

#clone
git clone git://source.ffmpeg.org/ffmpeg.git -b n4.2.7 --depth=1 ffmpeg4.2
git clone git://source.ffmpeg.org/ffmpeg.git -b n4.4.2 --depth=1 ffmpeg4.4
git clone git://source.ffmpeg.org/ffmpeg.git -b release/6.0 --depth=1 ffmpeg6.0

#copy data
source copy_files.sh

#
cd ./ffmpeg4.2
git add -A .
git diff --cached > ../../ffmpeg_patches/ffmpeg4.2_nvmpi.patch
cd ..

#
cd ./ffmpeg4.4
git add -A .
git diff --cached > ../../ffmpeg_patches/ffmpeg4.4_nvmpi.patch
cd ..

cd ./ffmpeg6.0
git add -A .
git diff --cached > ../../ffmpeg_patches/ffmpeg6.0_nvmpi.patch
cd ..
