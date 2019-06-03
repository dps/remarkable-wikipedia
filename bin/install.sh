#!/bin/bash
IP=${REMARKABLE_IP:?Must provide REMARKABLE_IP.}

REMARKABLE_SW_VERSION=`ssh root@$IP "cat /proc/version"`
if [ -z "$REMARKABLE_SW_VERSION" ]; then
    echo Could not ssh to reMarkable - is passwordless ssh set up and IP address correct?
    exit 1
fi
echo $REMARKABLE_SW_VERSION


if [ -f wikipedia_en_simple_all_nopic_2019-05.zim ]; then
  echo Found simple wikipedia file.
else
    read -r -p "Do you want to download Simple wikipedia? [y/N] " response
    case "$response" in
        [yY][eE][sS]|[yY]) 
            curl -L -o wikipedia_en_simple_all_nopic_2019-05.zim http://download.kiwix.org/zim/wikipedia/wikipedia_en_simple_all_nopic_2019-05.zim
            ;;
        *)
            echo Skipping simple wikipedia download.
            ;;
    esac
fi

echo Making mount point...
MK_MOUNT_POINT=`ssh root@$IP "mkdir /home/root/memcard"`

echo Copying draft files
scp draft root@$IP:/usr/bin/draft
scp draft-config/draft.service root@$IP:/lib/systemd/system/draft.service
ssh root@$IP "mkdir -p /etc/draft"
scp -r draft-config/extra-files/* root@$IP:/etc/draft
ssh root@$IP "mkdir -p /opt/qtwikipedia/bin"
scp qtwikipedia root@$IP:/opt/qtwikipedia/bin/qtwikipedia
scp button-capture root@$IP:/usr/bin/button-capture

echo Copying kiwix-serve
scp kiwix-serve root@$IP:/usr/bin/kiwix-serve
scp start-kiwix.sh root@10.11.99.1:/home/root/start-kiwix.sh
scp kiwix.service /lib/systemd/system/kiwix.service

if [ -f wikipedia_en_simple_all_nopic_2019-05.zim ]; then
    echo Copying simple wikipedia
    scp wikipedia_en_simple_all_nopic_2019-05.zim root@$IP:/home/root/wikipedia_en_simple_all_nopic_2019-05.zim
else

echo Enabling draft launcher and kiwix.
ssh root@$IP "systemctl disable xochitl"
ssh root@$IP "systemctl enable draft"
ssh root@$IP "systemctl enable kiwix"

echo Rebooting reMarkable...
ssh root@$IP "reboot"
