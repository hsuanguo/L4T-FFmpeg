# L4T-FFmpeg

FFmpeg with NVIDIA Jetson Multimedia API support, this repository is originally from [jetson-ffmpeg](https://github.com/jocover/jetson-ffmpeg) and [Keylost's fork](https://github.com/Keylost/jetson-ffmpeg), however, the upstream repository is no longer maintained as of now, so I decided to keep this repository up-to-date with the latest FFmpeg and bug fixes.

- Supported Jetpack versions: Jetpack 4, Jetpack 5, and Jetpack 6.
- Supported FFmpeg versions: 4.2, 4.4, 6.0, 6.1, 7.0, 7.1, 8.0.

## Preparing

**1. Install L4T Multimedia API(Host)**

```bash
sudo apt install nvidia-l4t-jetson-multimedia-api
```
Note that you would need to install the `nvidia-l4t-jetson-multimedia-api` on host if you plan to build ffmpeg with docker, then make sure you mount the `/usr/src/jetson_multimedia_api` to the container.

**2. Install Dependencies**

Install the following in environment where you plan to build ffmpeg.

```bash
sudo apt install --no-install-recommends frei0r-plugins-dev libgnutls28-dev ladspa-sdk libchromaprint-dev libaom-dev liblilv-dev libavc1394-dev libavc1394-tools libiec61883-dev libraw1394-dev libraw1394-tools libcaca-dev libbs2b-dev libbs2b0 libass-dev libbluray-dev libbluray-doc libbluray-bin libcodec2-dev libgme-dev libdrm-dev libflite1 libgsm1-dev libmp3lame-dev libmysofa-dev libopenjp2-7-dev libopenmpt-dev libopus-dev libpulse-dev librsvg2-dev librubberband-dev libshine-dev libsnappy-dev libsoxr-dev libssh-dev libspeex-dev libtheora-dev libtwolame-dev libvidstab-dev libzmq3-dev libzvbi-dev libopenal-dev libvo-aacenc-dev libvo-amrwbenc-dev libvorbis-dev libvpx-dev libwavpack-dev libwebp-dev libx264-dev libx265-dev libxvidcore-dev libomxil-bellagio-dev libjack-dev libsdl2-dev flite1-dev libiec61883-dev libbluray-dev libdc1394-dev
```

Note that you might need to install more dependencies as something else could be missing, you will figure it out :).

## Building 

**1.build and install library**

Run the building script which corresponds to the version of FFmpeg you want to build:

```bash
build.sh <version> <enable-gpl, true/false> <system-install, true/false>
```

for example, if you want to build FFmpeg 8.0 and install it to system, run the following command:

```bash
./build.sh 8.0 false true
```

once done, you can run `ffmpeg -codecs | grep nvmpi` to check if the NVIDIA Jetson Multimedia API codecs are enabled.
