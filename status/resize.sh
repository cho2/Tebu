#!/bin/bash
#Height and Width
H=96
W=96
#prefix
PR="resized"
#default dpi is 90
DPI=90
#pt to px
xH=$(((H*72)/DPI));
xW=$(((W*72)/DPI));



function Go {
	cd scalable
	mkdir symlink
	find . -maxdepth 1 -type l -exec mv {} symlink/ \;
	a="`date '+%F-%H-%M-%S'`"
	b="$PR-$a"
	mkdir $b
	mkdir symb
	mv *symbolic* symb/
	c=0
	for file in $(ls *svg)
	do
		name=${file%%.svg}
		rsvg-convert $name.svg -o $b/$name.svg -f svg -w $xW 
		#rsvg-convert $name.svg -o $b/$name.svg -f svg -w $xW -h $xH
		c=$((c+1))
	done
	mv $b/* .
	mv symb/*symbolic* .
	rm -rf symb
	rm -rf $b
	
	cd symlink
	find . -maxdepth 1 -type l -exec mv {} .. \;
	cd ..
	rmdir symlink
	echo " $c SVG file has been resized."
}
if [ -a "/usr/bin/rsvg-convert" ]; then
	Go
else
	sudo apt-get install  librsvg2-bin
	Go
fi




