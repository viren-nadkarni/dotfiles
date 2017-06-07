# scan image
scanimage --resolution 300 --mode Color --device pixma > out.pnm
pnmtojpeg out.pnm > out.jpeg

# decrypt pdf
qpdf -decrypt -password=coldplay in.pdf out.pdf

# delete garbage metadata
find . -iname thumbs.db -delete -o -iname desktop.ini -delete -o -iname .ds_store -delete -o -iname folder.jp*g -delete -o -iname albumart*.jp*g -delete

# backup
# trailing slashes are REQUIRED
rsync -hav --delete-after --progress -n /data/music/ /media/viren/ntfs-passport/music/
rsync -hav --progress -n /data/photos/ /media/viren/ntfs-passport/photos/
