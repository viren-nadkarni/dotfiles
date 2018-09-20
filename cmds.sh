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
git reset HEAD~     # undo last commit

nmcli con add type wifi con-name 'SGS-Student' ssid 'SGS-Student' -- wifi-sec.key-mgmt wpa-eap 802-1x.eap ttls 802-1x.identity '503002303' 802-1x.private-key-password '4JGi1OxV' ifname wlp2s0 802-1x.phase2-auth mschapv2
