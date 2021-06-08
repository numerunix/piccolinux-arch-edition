!#/bin/bash
#autore: Giulio Sorrentino <gsorre84@gmail.com>
#Concesso in licenza sotto la gplv3
function notRoot {
if [[ $EUID -ne 0 ]]; then
	echo "Lo script deve essere avviato da root"
   	exit 1
fi
}

function installPrerequisites {
pacman -Sy
pacman -S dialog 
}

notRoot
installPrerequisites

dialog --ascii-lines --title "Informazioni" --backtitle "Informazioni" --msgbox "Verrà impostato l'italiano come lingua di tastiera nella sessione e verrà abilitato l'orario via rete." 40 60

loadkeys it
timedatectl set-ntp true

dialog --title "Informazioni" --backtitle "Informazioni" --msgbox "Adesso partizionare e fare in modo che il sistema di partizioni sia montato sotto /mnt, tutte vuote, a parte /boot/efi, poi eseguire arch1.sh." 40 60

