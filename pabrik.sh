#!/bin/bash
echo "actions | apps | categories | devices | emblems  "
echo "extras  | io   | mimetypes  | places  | status  |  stock    "

echo -n "Masukan Nama Folder [ENTER]: "
read icon	


#icon='apps'

size[0]='16'
size[1]='22'
size[2]='24'
size[3]='32'
size[4]='48'
size[5]='64'
size[6]='96'

jumlah=0
pwd=$('pwd')

source=$pwd/${icon}/scalable
cd $source

mkdir -p symlink && find . -maxdepth 1 -type l -exec mv {} symlink/ \; #backup symlink

loc=$(pwd)
echo $loc
for x in 0 1 2 3 4 5 6
do
	
	target=$pwd/${icon}/${size[x]} 
	mkdir -p $target ##make folder size
	rm -rf $target/*
	cp -r $source/symlink/ $target/symlink/
	cd $source
	
	SAVEIF=$IFS
	IFS=$(echo -en "\n\b")
	for file in $(ls *svg)
	do
		name=${file%%.svg}
		inkscape $name.svg --export-png=$target/$name.png --export-height=${size[x]} --export-width=${size[x]}
		jumlah=$((jumlah+1))
	done
	
	cd $target && mv symlink/* .
	SAVEIF=$IFS
	IFS=$(echo -en "\n\b")
	for file in $(ls *svg)
	do
		names=${file%%.svg}
		sym=`readlink "${names}.svg" | sed "s/\.svg/\.png/ ; s/scalable/${size[x]}/g ; s/\.\./xxxxx/g ; s/\.\///g ; s/xxxxx/\.\./g"`
		echo "ln -s ${sym} ${names}.png"
		ln -s ${sym} "${names}.png"
	done	
	rm -rf $target/symlink && rm -rf *.svg
done



cd $source
cd symlink && find . -maxdepth 1 -type l -exec mv {} .. \; && cd .. && rmdir symlink #restore symlink
cd $pwd

echo "Berhasil. $jumlah ikon telah dihasilkan."
