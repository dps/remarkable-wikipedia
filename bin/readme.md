# Note - You modify the internal system of your reMarkable at your own risk! This might brick your tablet.
# I accept no responsibility if it does.

The prebuilt binaries have been updated to use the new version of the reMarkable toolchain: `https://remarkable.engineering/oecore-x86_64-cortexa9hf-neon-toolchain-zero-gravitas-1.8-23.9.2019.sh`
This is current as of April 25th 2020.

# Binaries compiled for reMarkable

`draft` --> `/usr/bin/draft`<br/>
`draft-config/draft.service` --> `/lib/systemd/system/draft.service`<br/>
`draft-config/extra-files/...` --> `/etc/draft/...`<br/>
`button-capture` --> `/usr/bin/button-capture`<br/>
`zimserver` --> `/usr/bin/zimserver`<br/>
`qtwikipedia` --> `/usr/bin/qtwikipedia`<br/>

download (https://download.kiwix.org/zim/wikipedia/wikipedia_en_simple_all_novid_2019-05.zim)   --> `/home/root/wikipedia_en_simple_all_novid_2019-05.zim`

# Instructions

## Automatic
* set your reMarkable's IP address in the environment variable `REMARKABLE_IP`
  * e.g. `export REMARKABLE_IP=10.11.99.1`
* run the install script `./install.sh`

## Manual
Distilled from [draft instructions](https://github.com/dixonary/draft-reMarkable)
* copy all the files as above
```
systemctl disable xochitl
systemctl enable draft
systemctl enable kiwix
```
* reboot

# Building from source
`zimserver` comes from [https://github.com/tim-st/go-zim](https://github.com/tim-st/go-zim).
Building for reMarkable is quite simple:
`GOARCH=arm GOOS=linux go build github.com/tim-st/go-zim`

For `draft` see here [draft instructions](https://github.com/dixonary/draft-reMarkable)

For `qywikipedia` see the `README.md` file in `../qtwikipedia`

