# jetson-ffmpeg
L4T Multimedia API for ffmpeg

## Preparing

**1. Install L4T Multimedia API(Host)**

```bash
sudo apt install nvidia-l4t-jetson-multimedia-api
```
Note that you would need to install the `nvidia-l4t-jetson-multimedia-api` on host if you plan to build ffmpeg with docker, then make sure you mount the `/usr/src/jetson_multimedia_api` to the container.

**2. Install Dependencies**

Install the following in environment where you plan to build ffmpeg.

```bash
sudo apt install frei0r-plugins-dev libgnutls28-dev ladspa-sdk libchromaprint-dev libaom-dev liblilv-dev libiec61883-dev libraw1394-dev libraw1394-tools libavc1394-dev libavc1394-tools libcaca-dev libbs2b-dev libbs2b0 libass-dev libbluray-dev libbluray-doc libbluray-bin libdc1394-22-dev libcodec2-dev libgme-dev libdrm-dev libflite1 libgsm1-dev libmp3lame-dev libmysofa-dev libopenjp2-7-dev libopenmpt-dev libopus-dev libpulse-dev librsvg2-dev librubberband-dev libshine-dev libsnappy-dev libsoxr-dev libssh-dev libspeex-dev libtheora-dev libtwolame-dev libvidstab-dev libzmq3-dev libzvbi-dev libopenal-dev libvo-aacenc-dev libvo-amrwbenc-dev libvorbis-dev libvpx-dev libwavpack-dev libwebp-dev libx264-dev libx265-dev libxvidcore-dev libomxil-bellagio-dev libjack-dev libsdl2-dev flite1-dev
```

Note that you might need to install more dependencies as something could(must) be missing, you will figure it out :).


## Building 

**1.build and install library**

    git clone https://github.com/Keylost/jetson-ffmpeg.git
    cd jetson-ffmpeg
    mkdir build
    cd build
    cmake ..
    make
    sudo make install
    sudo ldconfig
	
**2.patch ffmpeg and build**

    clone one of supported ffmpeg versions
    git clone git://source.ffmpeg.org/ffmpeg.git -b release/4.2 --depth=1
    or
    git clone git://source.ffmpeg.org/ffmpeg.git -b release/4.4 --depth=1
    or
    git clone git://source.ffmpeg.org/ffmpeg.git -b release/6.0 --depth=1
    cd ffmpeg
    get and apply patch for your ffmpeg version
    wget -O ffmpeg_nvmpi.patch https://github.com/Keylost/jetson-ffmpeg/raw/master/ffmpeg_patches/ffmpeg4.2_nvmpi.patch
    or
    wget -O ffmpeg_nvmpi.patch https://github.com/Keylost/jetson-ffmpeg/raw/master/ffmpeg_patches/ffmpeg4.4_nvmpi.patch
    or
    wget -O ffmpeg_nvmpi.patch https://github.com/Keylost/jetson-ffmpeg/raw/master/ffmpeg_patches/ffmpeg6.0_nvmpi.patch
    git apply ffmpeg_nvmpi.patch
    ./configure --enable-nvmpi --enable-gpl --disable-stripping --enable-avresample --disable-filter=resample --enable-avisynth --enable-gnutls --enable-ladspa --enable-libaom --enable-libass --enable-libbluray --enable-libbs2b --enable-libcaca --enable-libcodec2 --enable-libflite --enable-libfontconfig --enable-libfreetype --enable-libfribidi --enable-libgme --enable-libgsm --enable-libjack --enable-libmp3lame --enable-libmysofa --enable-libopenjpeg --enable-libopenmpt --enable-libopus --enable-libpulse --enable-librsvg --enable-librubberband --enable-libshine --enable-libsnappy --enable-libsoxr --enable-libspeex --enable-libssh --enable-libtheora --enable-libtwolame --enable-libvidstab --enable-libvorbis --enable-libvpx --enable-libwavpack --enable-libwebp --enable-libx265 --enable-libxml2 --enable-libxvid --enable-libzmq --enable-libzvbi --enable-lv2 --enable-omx --enable-openal --enable-opengl --enable-sdl2 --enable-libdc1394 --enable-libdrm --enable-libiec61883 --enable-chromaprint --enable-frei0r --enable-libx264 --enable-shared --prefix=${install_dir}
    make

**3.using**

### Supports Decoding
  - MPEG2
  - H.264/AVC
  - HEVC
  - VP8
  - VP9
  
**example**

    ffmpeg -c:v h264_nvmpi -i input_file -f null -
	
### Supports Encoding
  - H.264/AVC
  - HEVC
  
**example**

    ffmpeg -i input_file -c:v h264_nvmpi <output.mp4>
