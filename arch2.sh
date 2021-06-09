!!#/bin/bash
#Autore: Giulio Sorrentino <gsorre64@gmail.com>
#Concesso in licenza sotto la GPL v3
function notRoot {
if [[ $EUID -ne 0 ]]; then
	echo "Lo script deve essere avviato da root"
   	exit 1
fi
}

function installPrerequisites {
pacman -S dialog 
}

function isArch {
os=`cat /etc/os-release | grep -w "NAME" | cut -d = -f 2`; 
if [[ $os != \""Arch Linux"\" ]]; then         
echo "non sei su arch linux";  
exit 1
fi;
}
notRoot
isArch
installPrerequisites

pacman -S nano
dialog --ascii-lines --title "Informazioni" --backtitle "Informazioni" --msgbox "Adesso verrà mostratata la lista dei linguaggi, in ordine alfabetico. Decommentare \"it_IT.UTF-8\" e salvare" 40 60
nano /etc/locale.gen
locale-gen

echo "LANG=it_IT.UTF-8" > /etc/locale.conf
echo "KEYMAP=it" > /etc/vconsole.conf
echo "archlinux" > /etc/hostname


dialog --title "Informazioni" --backtitle "Informazioni" --msgbox "Indicare la password di root." 40 60
passwd
dialog --ascii-lines --title "Informazioni" --backtitle "Informazioni" --msgbox "Adesso bisogna installare il boot loader e configurare la rete. Il boot loader dovrà essere inserito a mano nel bios. La rete si configura in maniwra automatica" 40 60
pacman -S refind networkmanager
dialog --ascii-lines --title "Informazioni" --backtitle "Informazioni" --msgbox "Adesso verrà installato cinnamon, lightdm, xorg, firefox, thunderbird, parcellite, keeepass, libreoffice, tilix e il driver per accedere alle partizioni ntfs" 40 60
pacman -S cinnamon lightdm lightdm-gtk-greeter xorg-server xorg-server-common firefox thunderbird parcellite keepass libreoffice ntfs3g fuse tilix 
dialog --ascii-lines --title "Informazioni" --backtitle "Informazioni" --msgbox "Adesso verrà installato l'oxccorrente per l'utilizzo dei reopsitory AUR" 40 60
pacman -S --needed base-devel
dialog --ascii-lines --title "Informazioni" --backtitle "Informazioni" --msgbox "Al riavvio non verrà ancora mostrata l'intrefaccia grafica e la rete sarà disabilitata. Avviatele con arch3.sh" 40 60

