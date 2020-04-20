#!/usr/bin/env bash

### ### ###
### TODO:
###   * Become better at math and flesh out custom baseColors palette input handling.
###      + perhaps simplifying integration with other utilities, such as pywal.
###      * currently seems to work fine with  4 <= ${#baseColors[@]} <= ?*
###   * Make the exhibition .gif... better
###   * notify-send at {9,6,3}%
###   * set color of Bracket[{1,2}] according to whether battery is actually taking a charge or not.
##
#

adapterInfo="$(acpi -a)"
batteryInfo="$(acpi -b)"

## Mouse click actions.
case ${BLOCK_BUTTON} in
[1-2])
	## Show status/info notification
	# (1) Left-click
	# (2) Middle-click
	notify-send "${adapterInfo}"$'\n'"${batteryInfo}"
	;;
[3-6])
	## To simplify testing custom color schemes;
	##  drops a (demu-based) menu down from which to select a battery charge-level to temporarily simulate.
	##   (automatically goes back to normal at next refresh interval, or by left/middle-clicking.)
	#   (3) Right-click
	# (3<n) Extra buttons
	Charge=$(dmenu -l 110 < <(for i in {01..09} {0..100} ; do echo ${i}; done))
esac

###for ((a=1;a<=${#};a++)); do
###	case ${!a} in
###	*[a-fA-F0-9]????[a-fA-F0-9]*) baseColors[${#baseColors[@]}]="${!a/\#/}" ;;
###	\-*[bB]|\-*[cC][hH][aA][rR][gG][eE]) ((++a)) && Charge=${!a} ;;
###	*) continue
###	esac
###done

adapterState="${adapterInfo##*\:\ }"
batteryLevel="${batteryInfo##*\,\ }"
batteryState="${batteryInfo##*\:\ }" && batteryState="${batteryState%%\,*}"

### "Read Modes" ###
###   alternative sources from which to set the 'Charge' variable (for testing and exhibitory .gif production)
## Eventual default:
# Charge=${batteryLevel/\%/}
## Testing (battery level simulation; for checking color schemes/custom transitions, etc):
[[ -n ${Charge} ]] || Charge=${1:-${batteryLevel}}
## For creating the exhibition .gif
#Charge=$(cat ~/.config/i3blocks/scripts/Charge.txt)

Charge=${Charge/\%/}
Blox[0]="□"
Blox[1]="■"
[[ -n ${baseColors[@]} && ${#baseColors[@]} -ge 4 ]] ||
	baseColors=( '141821' 'F92772' 'FB666B' 'C38933' 'A9B93F' '66B333' '459939' '33BE3F' '21AF66' '00FBBF' '45DFED' )

_Diff() { echo $((${1}>=${2:-${1}}?(${1}-${2:-${1}}):(${2:-${1}}-${1}))); }
_Dec_RGB() {
	printf '%02d\n' "0x${1::2}"
	printf '%02d\n' "0x${1:2:2}"
	printf '%02d\n' "0x${1:4}"
}
_Criment() {
	echo "${1}"
	DIF=$(_Diff ${1} ${2})
	for ((n=1;n<=${3:-${CRIMENT}};n++)); do
		(( Tranz = DIF != 0 ? (( ${2} > ${1} ? (${1} + ((DIF / ${3:-${CRIMENT}}) * n)) : (${1} - ((DIF / ${3:-${CRIMENT}}) * n)) )) : ${1} ))
		echo $(( Tranz < 0 ? (Tranz + 256) : (( Tranz < 256 ? Tranz : (Tranz - 256) )) ))
	done
	echo "${2}"
}
_MidPoint() {
	[[ -z ${MID} ]] || unset MID[*]
	Lower=( $(_Dec_RGB "${1/\#/}") )
	Upper=( $(_Dec_RGB "${2/\#/}") )
	for ((n=0;n<${#Lower[@]};n++)); do
		DIF=$(_Diff ${Lower[n]} ${Upper[n]})
		(( Tranz = DIF != 0 ? (( ${Upper[n]} > ${Lower[n]} ? (${Lower[n]} + (DIF / 2)) : (${Lower[n]} - (DIF / 2)) )) : ${Lower[n]} ))
		(( Tranz = Tranz < 0 ? (Tranz + 256) : (( Tranz < 256 ? Tranz : (Tranz - 256) )) ))
		MID[${#MID[@]}]="$(printf '%02x' ${Tranz})"
	done
	echo "${MID[0]}${MID[1]}${MID[2]}"
}

## Set Palette[1] to corespond with the battery's current charge-level.
if [[ ${Charge} == 0 ]]; then
	Palette[1]="#${baseColors[0]}"
elif [[ ${Charge} == 100 ]]; then
	Palette[1]="#${baseColors[-1]}"
else
	if [[ $(( 100 % (${#baseColors[@]} - 1) )) != 0 ]]; then
		(( CRIMENT = 100 / (${#baseColors[@]} - 2) ))
	else
		(( CRIMENT = 100 / (${#baseColors[@]} - 1) ))
	fi
	(( SECT = Charge / CRIMENT ))
	(( IND = Charge % CRIMENT ))
	lowerBound=( $(_Dec_RGB "${baseColors[SECT]}") )
	upperBound=( $(_Dec_RGB "${baseColors[SECT+1]}") )
	R=( $(_Criment "${lowerBound[0]}" "${upperBound[0]}" ${CRIMENT}) )
	G=( $(_Criment "${lowerBound[1]}" "${upperBound[1]}" ${CRIMENT}) )
	B=( $(_Criment "${lowerBound[2]}" "${upperBound[2]}" ${CRIMENT}) )
	[[ ${IND} -ge ${#R[@]} ]] && Palette[1]=\#"$(printf '%02x' ${R[-1]} ${G[-1]} ${B[-1]})" || Palette[1]=\#"$(printf '%02x' ${R[IND]} ${G[IND]} ${B[IND]})"
fi

## set adapterState to 1 if power adapter is plugged in. then set statLabel and Palette[0] accordingly.
[[ ${adapterState} == 'on-line' ]] && adapterState=1 || adapterState=0
if [[ ${adapterState} == 1 ]]; then
	statLabel=" " && Palette[0]='#AE89FF'
else
	statLabel="⚡ " && Palette[0]='#393633'
fi
## set Palette[2] to be the midpoint of Palette[0] and Palette[1].
Palette[2]=\#"$(_MidPoint "${Palette[0]}" "${Palette[1]}")"

## determine number of charged cells to display.
(( fullCells = Charge / 20 ))
Cells_FULL="$(printf '%*s' ${fullCells})"
Cells_FULL="<span foreground=\"${Palette[1]}\">${Cells_FULL//\ /${Blox[1]}}</span>"

## determine number of drained and/or transient cells, and set each of them respective to the other.
(( emptCells = 5 - fullCells ))
(( Transience = ( Charge % 20 ) / 10 ))
if [[ ${Transience} == 1 ]]; then
	((emptCells = Charge > 79 ? ((Charge < 90 ? 1 : (emptCells - 1))) : (emptCells - 1) ))
	Cells_TRANSIENT="<span foreground=\"${Palette[2]}\"><sup>${Blox[1]}</sup></span>"
fi
if [[ ${emptCells} -gt 0 ]]; then
	Cells_EMPT="$(printf '%*s' ${emptCells})"
	Cells_EMPT="<span foreground=\"${Palette[$((Charge<10?((adapterState==0?1:0)):0))]}\">${Cells_EMPT//\ /${Blox[0]}}</span>"
fi

### set Palette[3] to be the _midPoint of Palette[0] and Palette[2];
###   for coloring the ${statLabel} (Bracket[0]) and indicator "frame" ${Bracket[{1,2}]}.
Palette[3]=\#"$(_MidPoint "${Palette[0]}" "${Palette[2]}")"
Bracket[0]="<span foreground=\"${Palette[$((Charge<=99?3:1))]}\">${statLabel}</span>"
Bracket[1]="<span foreground=\"${Palette[3]}\">[</span>"
Bracket[2]="<span foreground=\"${Palette[3]}\">]</span>"

### Generate output ${message} ###
message="${Bracket[0]}${Bracket[1]}"
[[ -z ${Cells_FULL} ]] || message+="${Cells_FULL}"
[[ -z ${Cells_TRANSIENT} ]] || message+="${Cells_TRANSIENT}"
[[ -z ${Cells_EMPT} ]] || message+="${Cells_EMPT}"
message+="${Bracket[2]}"
echo "${message}"
