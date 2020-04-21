#!/usr/bin/env bash

mkdir -p Exhibit

_Discharging() {
	x=0
	for n in {100..0}; do
		echo "0 ${n}" > ~/.config/i3blocks/scripts/Battery.txt
		i3 restart
		Num="$(printf '%03d' ${x})"
		sleep 2
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
		sleep 2
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

_Discharging && _Charging && _Create_GIF
