#!/bin/bash

mount /dev/sda /home/root/memcard

if [ -f /home/root/memcard/wikipedia.zim ]; then
  #/usr/bin/kiwix-serve --port=8000 /home/root/memcard/wikipedia.zim
  /usr/bin/zimserver -port 8081 -filename /home/root/memcard/wikipedia.zim
else
  #/usr/bin/kiwix-serve --port=8000 /home/root/wikipedia_en_simple_all_novid_2019-05.zim
  /usr/bin/zimserver -port 8081 -filename /home/root/wikipedia_en_simple_all_nopic_2020-04.zim
fi
