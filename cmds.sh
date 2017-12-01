# scan image
scanimage --resolution 300 --mode Color --device pixma > out.pnm
pnmtojpeg out.pnm > out.jpeg

# decrypt pdf
qpdf -decrypt -password=coldplay input.pdf output.pdf

# delete garbage metadata
find . -iname thumbs.db -delete -o -iname desktop.ini -delete -o -iname .ds_store -delete -o -iname folder.jp*g -delete -o -iname albumart*.jp*g -delete

# backup
# trailing slashes are REQUIRED
rsync --human-readable --archive --verbose --delete-after --progress --dry-run /data/music/ /media/viren/ntfs-passport/music/
rsync --human-readable --archive --verbose --progress --dry-run --progress -n /data/photos/ /media/viren/ntfs-passport/photos/

# convert to gif
ffmpeg -i input -pix_fmt rgb8 output
