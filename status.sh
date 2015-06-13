#!/bin/bash

function Go {
	icon="status"
	size[0]='16'
	size[1]='22'
	size[2]='24'
	
	jumlah=0
	pwd=$('pwd')
	
	source=$pwd/${icon}/scalable
	cd $source
	
	mkdir -p symlink && find . -maxdepth 1 -type l -exec mv {} symlink/ \; #backup symlink
	
	loc=$(pwd)
	echo $loc
	for x in 0 1 2
	do
		#Height and Width
		H=${size[x]}
		W=${size[x]}
		#default dpi is 90
		DPI=90
		#pt to px
		xH=$(((H*72)/DPI));
		xW=$(((W*72)/DPI));
		
		target=$pwd/${icon}/${size[x]} 
		mkdir -p $target ##make folder size
		rm -rf $target/*
		cp -r $source/symlink/ $target/symlink/
		cd $source

		for file in $(ls *svg)
		do
			name=${file%%.svg}
			rsvg-convert $name.svg -o $target/$name.svg -f svg -w $xW -h $xH
			jumlah=$((jumlah+1))
		done
		
		mkdir $target/backup && mv $target/*.svg backup
		cd $target && mv symlink/* .
		SAVEIF=$IFS
		IFS=$(echo -en "\n\b")
		for file in $(ls *svg)
		do
			names=${file%%.svg}
			sym=`readlink "${names}.svg" | sed "s/scalable/${size[x]}/g ; s/\.\./xxxxx/g ; s/\.\///g ; s/xxxxx/\.\./g"`
			echo "ln -s ${sym} ${names}.svg"
			ln -s ${sym} "${names}.svg"
		done	
		rm -rf $target/symlink
		rm -rf $target/backup
		rm -rf $target/ap*.svg
		rm -rf $target/stock*.svg
		
	done
	cd $source
	cd symlink && find . -maxdepth 1 -type l -exec mv {} .. \; && cd .. && rmdir symlink #restore symlink
	cd $pwd

	echo "Berhasil. $jumlah ikon telah dihasilkan."
}
if [ -a "/usr/bin/rsvg-convert" ]; then
	Go
else
	sudo apt-get install  librsvg2-bin
	Go
fi




