# scan image
scanimage --resolution 300 --mode Color --device pixma > out.pnm
pnmtojpeg out.pnm > out.jpeg

# decrypt pdf
qpdf -decrypt -password=coldplay input.pdf output.pdf

# merge pdfs
pdftk part1.pdf part2.pdf cat output merged.pdf

# extract jpegs from pdf
pdfimages -j file.pdf ./

# delete garbage metadata
find . -iname thumbs.db -delete -o -iname desktop.ini -delete -o -iname .ds_store -delete -o -iname folder.jp*g -delete -o -iname albumart*.jp*g -delete

# backup
# trailing slashes are REQUIRED
rsync --human-readable --archive --verbose --delete-after --progress --dry-run /data/music/ /media/viren/ntfs-passport/music/
rsync --human-readable --archive --verbose --progress --dry-run /data/photos/ /media/viren/ntfs-passport/photos/

# convert to gif
ffmpeg -i input -pix_fmt rgb8 output

# gpg
gpg --import key
gpg --fingerprint
gpg --list-keys
gpg --encrypt --armor --recipient name
gpg --decrypt file
gpg --clearsign file

# sort processes by cpu usage
ps aux | sort -n -r -k 3

# ssh tunnel
ssh -D 8080 root@159.89.170.20
