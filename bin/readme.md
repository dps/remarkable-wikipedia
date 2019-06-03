(Note - You modify the internal system of your reMarkable at your own risk! This might brick your tablet.)


# Binaries compiled for reMarkable

`draft` --> `/usr/bin/draft`<br/>
`draft-config/draft.service` --> `/lib/systemd/system/draft.service`<br/>
`draft-config/extra-files/...` --> `/etc/draft/...`<br/>
`button-capture` --> `/usr/bin/button-capture`<br/>
`kiwix-serve` --> `/home/root/kiwix-serve`<br/>
`qtwikipedia` --> `/opt/qtwikipedia/bin/qtwikipedia`<br/>

download (https://download.kiwix.org/zim/wikipedia/wikipedia_en_simple_all_nopic_2019-05.zim)   --> `/home/root/wikipedia_en_simple_all_nopic_2019-05.zim`

# Instructions
Distilled from [draft instructions](https://github.com/dixonary/draft-reMarkable)
* copy all the files as above
```
systemctl disable xochitl
systemctl enable draft
systemctl enable kiwix
```
* reboot
