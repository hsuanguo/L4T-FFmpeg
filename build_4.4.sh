#!/usr/bin/env bash

set -e
set -o pipefail
set -u

repo_dir=$(
  cd "$(dirname "$0")"
  pwd
)

cd "${repo_dir}"

enable_gpl=${1:-"false"}

# build mpi
if [ -d build ]; then
  rm -rf build
fi

mkdir build
cd build
cmake ..
make -j$(nproc)
sudo make install

# build ffmpeg
readonly ffmpeg_major_version="4.4"
readonly ffmpeg_tag="n4.4.2"
git clone git://source.ffmpeg.org/ffmpeg.git -b "${ffmpeg_tag}" --depth=1
cp -r ${repo_dir}/ffmpeg_dev/${ffmpeg_major_version}/* ffmpeg/
cp -r ${repo_dir}/ffmpeg_dev/common/* ffmpeg/
cd ffmpeg

readonly install_prefix="/usr"

# if enable_gpl is true, then enable gpl
if [ "${enable_gpl}" = "true" ]; then

./configure \
  --enable-nvmpi \
  --disable-stripping \
  --enable-avresample \
  --disable-filter=resample \
  --enable-gnutls \
  --enable-ladspa \
  --enable-libaom \
  --enable-libass \
  --enable-libbluray \
  --enable-libbs2b \
  --enable-libcaca \
  --enable-libcodec2 \
  --enable-libflite \
  --enable-libfontconfig \
  --enable-libfreetype \
  --enable-libfribidi \
  --enable-libgme \
  --enable-libgsm \
  --enable-libjack \
  --enable-libmp3lame \
  --enable-libmysofa \
  --enable-libopenjpeg \
  --enable-libopenmpt \
  --enable-libopus \
  --enable-libpulse \
  --enable-librsvg \
  --enable-libshine \
  --enable-libsnappy \
  --enable-libsoxr \
  --enable-libspeex \
  --enable-libssh \
  --enable-libtheora \
  --enable-libtwolame \
  --enable-libvorbis \
  --enable-libvpx \
  --enable-libwebp \
  --enable-libxml2 \
  --enable-libzmq \
  --enable-libzvbi \
  --enable-lv2 \
  --enable-openal \
  --enable-opengl \
  --enable-sdl2 \
  --enable-libdc1394 \
  --enable-libdrm \
  --enable-libiec61883 \
  --enable-chromaprint \
  --enable-shared \
  --enable-gpl \
  --enable-avisynth \
  --enable-librubberband \
  --enable-libvidstab \
  --enable-libx265 \
  --enable-libxvid \
  --enable-omx \
  --enable-frei0r \
  --enable-libx264 \
  --prefix=${install_prefix}
else

./configure \
  --enable-nvmpi \
  --disable-stripping \
  --enable-avresample \
  --disable-filter=resample \
  --enable-gnutls \
  --enable-ladspa \
  --enable-libaom \
  --enable-libass \
  --enable-libbluray \
  --enable-libbs2b \
  --enable-libcaca \
  --enable-libcodec2 \
  --enable-libflite \
  --enable-libfontconfig \
  --enable-libfreetype \
  --enable-libfribidi \
  --enable-libgme \
  --enable-libgsm \
  --enable-libjack \
  --enable-libmp3lame \
  --enable-libmysofa \
  --enable-libopenjpeg \
  --enable-libopenmpt \
  --enable-libopus \
  --enable-libpulse \
  --enable-librsvg \
  --enable-libshine \
  --enable-libsnappy \
  --enable-libsoxr \
  --enable-libspeex \
  --enable-libssh \
  --enable-libtheora \
  --enable-libtwolame \
  --enable-libvorbis \
  --enable-libvpx \
  --enable-libwebp \
  --enable-libxml2 \
  --enable-libzmq \
  --enable-libzvbi \
  --enable-lv2 \
  --enable-openal \
  --enable-opengl \
  --enable-sdl2 \
  --enable-libdc1394 \
  --enable-libdrm \
  --enable-libiec61883 \
  --enable-chromaprint \
  --enable-shared \
  --prefix=${install_prefix}
fi

make -j$(nproc)

dest_pkg_dir="${repo_dir}/installed/${ffmpeg_tag}"

# create dest_pkg_dir if not exist
if [ ! -d "${dest_pkg_dir}" ]; then
  mkdir -p "${dest_pkg_dir}"
fi

DESTDIR=${dest_pkg_dir} make install
cp ${repo_dir}/build/libnvmpi.so* ${dest_pkg_dir}/usr/lib/ 
cp ${repo_dir}/build/libnvmpi.a ${dest_pkg_dir}/usr/lib/ 

# Install to the system
sudo make install
