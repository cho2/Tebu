#!/bin/sh
echo "actions | apps | categories | devices | emblems  "
echo "extras  | io   | mimetypes  | places  | status  |  stock    "

echo -n "Masukan Nama Folder [ENTER]: "
read icon	
echo -n "Masukan Nama Ikon Sumber (tambahkan ektensi *.png) [ENTER]: "
read sumber
echo -n "Masukan Nama Ikon Target (tambahkan ektensi *.png) [ENTER]: "
read target

pwd=$('pwd')
name=hexchat 
for x in 16 22 24 32 48 64 96
do
	cd $pwd/$icon/$x/ && ln -s $sumber $target && cd $pwd
done
