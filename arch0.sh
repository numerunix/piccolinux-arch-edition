!#/bin/bash
#autore: Giulio Sorrentino <gsorre84@gmail.com>
#Concesso in licenza sotto la gplv3
function notRoot {
if [[ $EUID -ne 0 ]]; then
	echo "Lo script deve essere avviato da root"
   	exit 1
fi
}

function isArch {
os=`cat /etc/os-release | grep -w "NAME" | cut -d = -f 2`; 
if [[ $os != \""Arch Linux"\" ]]; then         
echo  "non sei su arch linux";   
exit 1
fi;
}


function installPrerequisites {
pacman -Sy
pacman -S dialog 
}

notRoot
isArch

dialog --ascii-lines --title "Informazioni" --backtitle "Informazioni" --msgbox "Alziamo il firewall." 40 60
iptables -A INPUT -i enp31s0 -j DROP
iptables -A FORWARD -i enp31s0 -j DROP
iptables -A INPUT -i wlp37s0 -j DROP
iptables -A FORWARD -i wlp37s0 -j DROP
installPrerequisites

dialog --ascii-lines --title "Informazioni" --backtitle "Informazioni" --msgbox "Verrà impostato l'italiano come lingua di tastiera nella sessione e verrà abilitato l'orario via rete." 40 60

loadkeys it
timedatectl set-ntp true

dialog --title "Informazioni" --backtitle "Informazioni" --msgbox "Adesso partizionare e fare in modo che il sistema di partizioni sia montato sotto /mnt, tutte vuote, a parte /boot/efi, poi eseguire arch1.sh." 40 60

