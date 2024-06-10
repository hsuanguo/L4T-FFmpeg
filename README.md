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
sudo apt install frei0r-plugins-dev libgnutls28-dev ladspa-sdk libchromaprint-dev libaom-dev liblilv-dev libiec61883-dev libraw1394-dev libraw1394-tools libavc1394-dev libavc1394-tools libcaca-dev libbs2b-dev libbs2b0 libass-dev libbluray-dev libbluray-doc libbluray-bin libcodec2-dev libgme-dev libdrm-dev libflite1 libgsm1-dev libmp3lame-dev libmysofa-dev libopenjp2-7-dev libopenmpt-dev libopus-dev libpulse-dev librsvg2-dev librubberband-dev libshine-dev libsnappy-dev libsoxr-dev libssh-dev libspeex-dev libtheora-dev libtwolame-dev libvidstab-dev libzmq3-dev libzvbi-dev libopenal-dev libvo-aacenc-dev libvo-amrwbenc-dev libvorbis-dev libvpx-dev libwavpack-dev libwebp-dev libx264-dev libx265-dev libxvidcore-dev libomxil-bellagio-dev libjack-dev libsdl2-dev flite1-dev libiec61883-dev libbluray-dev libdc1394-dev
```

Note that you might need to install more dependencies as something could(must) be missing, you will figure it out :).


## Building 

**1.build and install library**

```bash
build_4.2.sh
```

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
