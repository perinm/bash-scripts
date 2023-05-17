for file in /mnt/c/Users/lucas/Videos/*.mkv; do
    ffmpeg -i "$file" -c:v hevc_nvenc -preset p7 -tune hq -rc vbr -cq 0 -qmin:v 25 -qmax:v 28 -c:a copy "${file%.mkv}.mp4";
    # ffmpeg -i "/mnt/c/Users/lucas/Videos/2023-05-04 11-27-11.mkv" -c:v hevc_nvenc -preset p7 -tune hq -rc vbr -cq 0 -qmin:v 25 -qmax:v 28 -c:a copy "/mnt/c/Users/lucas/Videos/2023-05-04 11-27-11.mp4";
    # sudo rm -i "$file";
    # ffmpeg -i 2023-05-05\ 12-02-09.mkv -c:v hevc_nvenc -preset medium -qp 28 -c:a copy 2023-05-05\12-02-09.mp4
done