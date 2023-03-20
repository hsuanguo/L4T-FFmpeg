
#clone
git clone git://source.ffmpeg.org/ffmpeg.git -b release/4.2 --depth=1 ffmpeg4.2
git clone git://source.ffmpeg.org/ffmpeg.git -b release/4.4 --depth=1 ffmpeg4.4
git clone git://source.ffmpeg.org/ffmpeg.git -b release/6.0 --depth=1 ffmpeg6.0

#copy data
cp -r ./4.2/* ffmpeg4.2/
cp -r ./4.4/* ffmpeg4.4/
cp -r ./6.0/* ffmpeg6.0/
cp -r ./common/* ./ffmpeg4.2/
cp -r ./common/* ./ffmpeg4.4/
cp -r ./common/* ./ffmpeg6.0/

#
cd 4.2
git add -A
git diff --cached > ../ffmpeg_patches/ffmpeg4.2_nvmpi.patch
cd ..

#
cd 4.4
git add -A
git diff --cached > ../ffmpeg_patches/ffmpeg4.4_nvmpi.patch
cd ..

cd 6.0
git add -A
git diff --cached > ../ffmpeg_patches/ffmpeg6.0_nvmpi.patch
cd ..
