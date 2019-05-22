# Remarkable wikipedia notes

SSH Access to reMarkable: https://remarkablewiki.com/tech/ssh

List of projects: https://github.com/reHackable/awesome-reMarkable

best repo to build on (I got this working easily)
https://github.com/merovius/srvfb

new launcher UI:
https://github.com/dixonary/draft-reMarkable

Plato eReader:
https://www.reddit.com/r/RemarkableTablet/comments/bkbps9/how_to_install_plato_reader_and_add_it_to_draft/?st=jvp0mqus&sh=0651e353

Source code of the port:
https://github.com/darvin/plato

Needs QT Creator to build from source. This is probably the best thing to start hacking into a wikipedia reader UI.

# Offline wikipedia notes

* First time around, I downloaded and processed all of wikipedia on a large server. This might be useful if you decide to go down that route: https://blog.singleton.io/posts/2012-06-19-parsing-huge-xml-files-with-go/

* Then I discovered 
https://en.wikipedia.org/wiki/ZIM_(file_format)
and
https://www.kiwix.org/en/downloads/

here's the actual wikipedia download:
https://wiki.kiwix.org/wiki/Content_in_all_languages

It's 35G with no images and 79G with no video
```
wikipedia (English)	en	35G	2018-09	all nopic
wikipedia (English)	en	79G	2018-10	all novid
```

Here's how to build a zim file extracting webserver:
https://github.com/kiwix/kiwix-tools/blob/master/README.md

I think that plus a UI that fetches the content locally and renders in plato is likely the full solution!

The reMarkable only has about 6.5 GB internal storage. I think a USB-otg cable plus sdcard might work.
*update*
confirmed that this should work:
```
[   28.969911] ci_hdrc ci_hdrc.0: EHCI Host Controller
[   28.974832] ci_hdrc ci_hdrc.0: new USB bus registered, assigned bus number 1
[   29.001642] ci_hdrc ci_hdrc.0: USB 2.0 started, EHCI 1.00
[   29.009871] hub 1-0:1.0: USB hub found
[   29.019532] hub 1-0:1.0: 1 port detected
[   29.341644] usb 1-1: new high-speed USB device number 2 using ci_hdrc
[   29.498532] usb-storage 1-1:1.0: USB Mass Storage device detected
[   29.507247] scsi host0: usb-storage 1-1:1.0
[   30.513081] scsi 0:0:0:0: Direct-Access     Lexar    microSD RDR      0815 PQ: 0 ANSI: 6
[   30.861919] sd 0:0:0:0: [sda] 124735488 512-byte logical blocks: (63.9 GB/59.5 GiB)
[   30.870522] sd 0:0:0:0: [sda] Write Protect is off
[   30.875358] sd 0:0:0:0: [sda] Mode Sense: 23 00 00 00
[   30.879929] sd 0:0:0:0: [sda] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[   30.898892]  sda: sda1
[   30.908340] sd 0:0:0:0: [sda] Attached SCSI removable disk
[  387.157818] usb 1-1: USB disconnect, device number 2
[  387.442193] usb 1-1: new high-speed USB device number 3 using ci_hdrc
[  387.598722] usb-storage 1-1:1.0: USB Mass Storage device detected
[  387.606932] scsi host1: usb-storage 1-1:1.0
[  387.773963] usb 1-1: USB disconnect, device number 3
[  387.798539] ci_hdrc ci_hdrc.0: remove, state 1
[  387.803032] usb usb1: USB disconnect, device number 1
[  387.824825] ci_hdrc ci_hdrc.0: USB bus 1 deregistered
```

It looks like the remarkable supports EXT4 for the internal drive:
```
[    7.553171] EXT4-fs (mmcblk1p7): mounted filesystem with ordered data mode. Opts: (null)
```
!(sdcard.jpg)