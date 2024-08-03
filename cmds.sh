# scan image
scanimage --resolution 300 --mode Color --device pixma > out.pnm
pnmtojpeg out.pnm > out.jpeg

# decrypt pdf
qpdf -decrypt -password=coldplay input.pdf output.pdf

# merge pdfs
pdftk part1.pdf part2.pdf cat output merged.pdf

# remove passwords from pdf
pdftk INPUT.pdf input_pw PASSWORD output OUTPUT.pdf

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
gpg --import public.key
gpg --allow-secret-key-import --import private.key
gpg --fingerprint
gpg --list-keys
gpg --list-secret-keys
gpg --encrypt --armor --recipient name
gpg --decrypt file
gpg --clearsign file
gpg --edit-key ABCDEF
  > key 1
  > expire
  > save
  > passwd
  > save
gpg --send-keys --keyserver hkps://hkps.pool.sks-keyservers.net 9CCF7D6898E84F1926CDC01DDD2870265E495EAB
gpg --export -a name > public.asc
gpg --export-secret-keys -a name > private.asc && gpg2 --import private.asc

# sort processes by cpu usage
ps aux | sort -n -r -k 3

# ssh tunnel
ssh -D 8080 root@159.89.170.20

# wireless
wpa_passphrase <ssid> <passphrase> > /etc/wpa_supplicant/wireless.conf
wpa_supplicant -i <interface> -c /etc/wpa_supplicant/wireless.conf -D wext
dhclient <interface>
nmcli radio wifi on
nmcli dev status
nmcli dev wifi list
nmcli dev wifi connect <ssid> password <passphrase>

# mount options
sudo mount -o remount,rw /partition/identifier /mount/point	# remount as rw
sudo mount -o uid=$USER,gid=$GROUPS,dmask=022,fmask=133 /dev/sdb1 /media/viren/ntfs-hd

# fix borked up perms
find ./path -type d -exec chmod 775 '{}' \;
find ./path -type f -exec chmod 664 '{}' \;

# git
git reset HEAD~n        # undo last n commits
git branch -m new-name  # rename branch
git submodule add url dest
git submodule foreach --recursive git checkout .  # fix dirty submodules
git submodule update --recursive --remote  # update submodules
git commit --amend --no-edit --author "Viren Nadkarni <viren.nadkarni@gmail.com>"
# deinit submodules
git submodule deinit -f -- dir/submod
rm -rf .git/modules/dir/submod
git rm -f dir/submod

# qr
qrencode -t SVG "upi://pay?cu=INR&pa=UPIHANDLE&pn=PAYEE%20NAME&am=200" -o output.svg
zbarimg input.png

# metadata
exiftool photo.jpg  # view
exiftool -all= -overwrite_original photo.jpg  # remove

# pass
pass init <user>
git clone <remote> ~/.password-store
