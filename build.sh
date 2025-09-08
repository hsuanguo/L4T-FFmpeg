#!/usr/bin/env bash

set -e
set -o pipefail
set -u

repo_dir=$(
  cd "$(dirname "$0")"
  pwd
)

cd "${repo_dir}"

ffmpeg_major_version=${1:-"7.1"}
enable_gpl=${2:-"false"}
system_install=${3:-"false"}

extra_options=()
case "${ffmpeg_major_version}" in

  "4.2")
    readonly ffmpeg_tag="n4.2.7"
    patch_file="none"
    extra_options=(
      --enable-avresample
      --disable-filter=resample
      --enable-libwavpack
    )
    ;;
  "4.4")
    readonly ffmpeg_tag="n4.4.2"
    patch_file="none"
    extra_options=(
      --enable-avresample
      --disable-filter=resample
    )
    ;;
  "6.0")
    readonly ffmpeg_tag="n6.0.1"
    patch_file="none"
    ;;
  "6.1")
    readonly ffmpeg_tag="n6.1.1"
    patch_file="libavcodec-librsvgdec.patch"
    ;;
  "7.0")
    readonly ffmpeg_tag="n7.0.2"
    patch_file="libavcodec-librsvgdec.patch"
    ;;
  "7.1")
    readonly ffmpeg_tag="n7.1"
    patch_file="none"
    ;;
  "8.0")
    readonly ffmpeg_tag="n8.0"
    patch_file="ffmpeg-8.0-nvmpi.patch"
    ;;

esac

echo "Building ffmpeg ${ffmpeg_major_version} with tag ${ffmpeg_tag}...."

# Get the os_arch, dpkg-architecture is not available, then use aarch64-linux-gnu as default
os_arch=$(dpkg-architecture -qDEB_HOST_GNU_TYPE) || os_arch="aarch64-linux-gnu"


if [ -d build ]; then
  rm -rf build
fi

# build mpi
echo "Building mpi library...."
mkdir build
cd build
cmake -DCMAKE_INSTALL_PREFIX="/usr"  ..
make -j$(nproc)
sudo make install

# build ffmpeg
echo "Building ffmpeg...."
git clone git://source.ffmpeg.org/ffmpeg.git -b "${ffmpeg_tag}" --depth=1
cp -r ${repo_dir}/ffmpeg_dev/${ffmpeg_major_version}/* ffmpeg/
cp -r ${repo_dir}/ffmpeg_dev/common/* ffmpeg/
cd ffmpeg

# Apply patches
if [ "${patch_file}" != "none" ]; then
  echo "Applying patch ${patch_file} ...."
  git apply ./patches/${patch_file}
fi

base_options=(
  --enable-nvmpi
  --disable-stripping
  --enable-gnutls
  --enable-ladspa
  --enable-libaom
  --enable-libass
  --enable-libbluray
  --enable-libbs2b
  --enable-libcaca
  --enable-libcodec2
  --enable-libflite
  --enable-libfontconfig
  --enable-libfreetype
  --enable-libfribidi
  --enable-libgme
  --enable-libgsm
  --enable-libjack
  --enable-libmp3lame
  --enable-libmysofa
  --enable-libopenjpeg
  --enable-libopenmpt
  --enable-libopus
  --enable-libpulse
  --enable-libshine
  --enable-libsnappy
  --enable-libsoxr
  --enable-libspeex
  --enable-libssh
  --enable-libtheora
  --enable-libtwolame
  --enable-libvorbis
  --enable-libvpx
  --enable-libwebp
  --enable-libxml2
  --enable-libzmq
  --enable-libzvbi
  --enable-librsvg
  --enable-lv2
  --enable-openal
  --enable-opengl
  --enable-sdl2
  --enable-libdc1394
  --enable-libdrm
  --enable-libiec61883
  --enable-chromaprint
  --enable-shared
  --libdir=/usr/lib/${os_arch}
  --incdir=/usr/include/${os_arch}
  --prefix=/usr
)

# if enable_gpl is true, then enable gpl
if [ "${enable_gpl}" = "true" ]; then
  base_options+=(
    --enable-gpl
    --enable-librubberband
    --enable-libvidstab
    --enable-libx265
    --enable-libxvid
    --enable-omx
    --enable-frei0r
    --enable-libx264
  )
fi

# To enable --enable-avisynth, you need to install the avisynth package
# From: https://github.com/AviSynth/AviSynthPlus

# Add extra options
base_options+=("${extra_options[@]}")

./configure "${base_options[@]}"

make -j$(nproc)

dest_pkg_dir="${repo_dir}/installed/${ffmpeg_tag}"

# create dest_pkg_dir if not exist
if [ ! -d "${dest_pkg_dir}" ]; then
  mkdir -p "${dest_pkg_dir}"
fi

DESTDIR=${dest_pkg_dir} make install
cp ${repo_dir}/build/libnvmpi.so* ${dest_pkg_dir}/usr/lib/ 
cp ${repo_dir}/build/libnvmpi.a ${dest_pkg_dir}/usr/lib/ 

cd "${dest_pkg_dir}"
tar zcvf "ffmpeg-${ffmpeg_major_version}.tar.gz" usr/

cpu_arch=$(uname -m) || cpu_arch="aarch64"

# calculate sha256sum, and change the file name to ffmpeg-${ffmpeg_major_version}-${cpu_arch}-<hash-first8>.tar.gz
hash_tag=$(sha256sum "ffmpeg-${ffmpeg_major_version}.tar.gz" | cut -d ' ' -f 1)
hash_tag=${hash_tag:0:8}
mv "ffmpeg-${ffmpeg_major_version}.tar.gz" "ffmpeg-${ffmpeg_major_version}-${cpu_arch}-${hash_tag}.tar.gz"

# Install to the system
if [ "${system_install}" = "true" ]; then
  echo "Installing ffmpeg to /usr ...."
  cd "${repo_dir}/build/ffmpeg"
  sudo make install
fi

echo "FFMPeg build completed successfully, package is available at ${dest_pkg_dir}/ffmpeg-${ffmpeg_major_version}-${cpu_arch}-${hash_tag}.tar.gz"
