#!/usr/bin/env bash

_Discharging() {
	x=0
	for n in {100..0}; do
		echo "0 ${n}" > ~/.config/i3blocks/scripts/Battery.txt
		i3 restart
		Num="$(printf '%03d' ${x})"
		sleep 1
		scrot in_${Num}.png -e "convert in_${Num}.png -trim +repage -gravity northeast -crop 64X20+0+0 Exhibit/0_discharging_${Num}.0.png"
		if [[ ${n} == 0 ]]; then
			scrot in_${Num}.png -e "convert in_${Num}.png -trim +repage -gravity northeast -crop 64X20+0+0 Exhibit/0_discharging_${Num}.1.png"
			scrot in_${Num}.png -e "convert in_${Num}.png -trim +repage -gravity northeast -crop 64X20+0+0 Exhibit/0_discharging_${Num}.2.png"
			scrot in_${Num}.png -e "convert in_${Num}.png -trim +repage -gravity northeast -crop 64X20+0+0 Exhibit/0_discharging_${Num}.3.png"
		elif [[ ${n} == 100 ]]; then
			scrot in_${Num}.png -e "convert in_${Num}.png -trim +repage -gravity northeast -crop 64X20+0+0 Exhibit/0_discharging_${Num}.1.png"
			scrot in_${Num}.png -e "convert in_${Num}.png -trim +repage -gravity northeast -crop 64X20+0+0 Exhibit/0_discharging_${Num}.2.png"
			scrot in_${Num}.png -e "convert in_${Num}.png -trim +repage -gravity northeast -crop 64X20+0+0 Exhibit/0_discharging_${Num}.3.png"
			scrot in_${Num}.png -e "convert in_${Num}.png -trim +repage -gravity northeast -crop 64X20+0+0 Exhibit/0_discharging_${Num}.4.png"
			scrot in_${Num}.png -e "convert in_${Num}.png -trim +repage -gravity northeast -crop 64X20+0+0 Exhibit/0_discharging_${Num}.5.png"
			scrot in_${Num}.png -e "convert in_${Num}.png -trim +repage -gravity northeast -crop 64X20+0+0 Exhibit/0_discharging_${Num}.6.png"
			scrot in_${Num}.png -e "convert in_${Num}.png -trim +repage -gravity northeast -crop 64X20+0+0 Exhibit/0_discharging_${Num}.7.png"
		else
			if [[ ${n} -lt 10 ]]; then
				scrot in_${Num}.png -e "convert in_${Num}.png -trim +repage -gravity northeast -crop 64X20+0+0 Exhibit/0_discharging_${Num}.1.png"
			fi
		fi
		((++x))
	done
	rm in_*.png
}
_Charging() {
	for n in {0..100}; do
		echo "1 ${n}" > ~/.config/i3blocks/scripts/Battery.txt
		i3 restart
		Num="$(printf '%03d' ${n})"
		sleep 1
		scrot in_${Num}.png -e "convert in_${Num}.png -trim +repage -gravity northeast -crop 64X20+0+0 Exhibit/1_charging_${Num}.0.png"
		if [[ ${n} == 0 ]]; then
			scrot in_${Num}.png -e "convert in_${Num}.png -trim +repage -gravity northeast -crop 64X20+0+0 Exhibit/1_charging_${Num}.1.png"
			scrot in_${Num}.png -e "convert in_${Num}.png -trim +repage -gravity northeast -crop 64X20+0+0 Exhibit/1_charging_${Num}.2.png"
			scrot in_${Num}.png -e "convert in_${Num}.png -trim +repage -gravity northeast -crop 64X20+0+0 Exhibit/1_charging_${Num}.3.png"
		elif [[ ${n} == 100 ]]; then
			scrot in_${Num}.png -e "convert in_${Num}.png -trim +repage -gravity northeast -crop 64X20+0+0 Exhibit/1_charging_${Num}.1.png"
			scrot in_${Num}.png -e "convert in_${Num}.png -trim +repage -gravity northeast -crop 64X20+0+0 Exhibit/1_charging_${Num}.2.png"
			scrot in_${Num}.png -e "convert in_${Num}.png -trim +repage -gravity northeast -crop 64X20+0+0 Exhibit/1_charging_${Num}.3.png"
			scrot in_${Num}.png -e "convert in_${Num}.png -trim +repage -gravity northeast -crop 64X20+0+0 Exhibit/1_charging_${Num}.4.png"
			scrot in_${Num}.png -e "convert in_${Num}.png -trim +repage -gravity northeast -crop 64X20+0+0 Exhibit/1_charging_${Num}.5.png"
			scrot in_${Num}.png -e "convert in_${Num}.png -trim +repage -gravity northeast -crop 64X20+0+0 Exhibit/1_charging_${Num}.6.png"
			scrot in_${Num}.png -e "convert in_${Num}.png -trim +repage -gravity northeast -crop 64X20+0+0 Exhibit/1_charging_${Num}.7.png"
		else
			if [[ ${n} -lt 10 ]]; then
				scrot in_${Num}.png -e "convert in_${Num}.png -trim +repage -gravity northeast -crop 64X20+0+0 Exhibit/1_charging_${Num}.1.png"
			fi
		fi
	done
	rm in_*.png
}
_Create_GIF() {
	mkdir -p .Converted
	for i in Exhibit/*.png; do
		convert ${i} -size 64x20 xc:black +swap -gravity center -composite .Converted/${i##*\/}
	done
	convert -delay 0 -loop 0 -trim xc:black -gravity center -composite -matte .Converted/*.png exhibit.gif 2>/dev/null
	rm -rf Exhibit .Converted
}
_Ask() {
	clear
	echo ' * Make sure you have uncommented the .gif creation option in the main script before proceeding...'
	echo ""
	echo 'So...'
	echo '   the "easiest" way I have found'
	echo '     - (without having devoted any time to an actually slick/creative solution)'
	echo '   to create the animated .gif file is to have a script automate the following steps:'
	echo '1) simulate each charge level for each adapter state...'
	echo '2) refresh i3...'
	echo '3) take screentshot using scrot - autocropping to the top-right corner on the fly...'
	echo '4) sleep 1, then repeat...'
	echo '5) using ImageMagick; create "exhibit.gif" from the resulting *.png screenshot files'
	echo '6) cleanup the leftover kruft...'
	echo ""
	echo 'The point of this message is to warn you that for the next 200 seconds i3 will reload every 1 second, which might have alarmed you absent this message.'
	echo 'Let it run, while keeping an eye on the top-right corner of the screen.'
	echo 'If your battery indicator is not showing up, or you notice something that needs to be changed, simply ctrl+c to stop the script.'
	echo ' * if you ctrl+c your way out you will need to manually remove the kruft (./Exhibit ./.Converted and ./*.png)'
	echo ""
	read -p "Proceed? [Y/n] " Resp
	if [[ ${Resp} == [yY] ]]; then
		mkdir -p Exhibit
		_Discharging && _Charging && _Create_GIF
	fi
}

_Ask
