#!/bin/bash

mount /dev/sda /home/root/memcard

if [ -f /home/root/memcard/wikipedia.zim ]; then
  /usr/bin/kiwix-serve --port=8000 /home/root/memcard/wikipedia.zim
else
  /usr/bin/kiwix-serve --port=8000 /home/root/wikipedia_en_simple_all_nopic_2019-05.zim
fi