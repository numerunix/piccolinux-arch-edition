#!/bin/bash
#Autore: Giulio Sorrentino <gsorre64@gmail.com>
#Concesso in licenza sotto la GPL v3
function notRoot {
if [[ $EUID -ne 0 ]]; then
	echo "Lo script deve essere avviato da root"
   	exit 1
fi
}

function installPrerequisites {
pacman -Sy dialog 
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


dialog --title "Informazioni" --backtitle "Informazioni" --msgbox "Indicare la password di root. A sistema avviato sarà possibile aggiungere altri utenti." 40 60
passwd
dialog --ascii-lines --title "Informazioni" --backtitle "Informazioni" --msgbox "Adesso verrà installato xfce, lightdm, xorg, firefox, thunderbird, parcellite, keeepass, libreoffice, tilix e il driver per accedere alle partizioni ntfs e al cellulare" 40 60
pacman -S xfce4 xfce4-goodies lightdm lightdm-gtk-greeter xorg-server xorg-server-common firefox thunderbird parcellite keepass libreoffice ntfs-3g fuse tilix  gvfs gvfs-mtp vlc galculator atril eog man-db gedit file-roller gnome-disk-utility gparted cups netcat cron at ntp logrotate
dialog --ascii-lines --title "Informazioni" --backtitle "Informazioni" --msgbox "Adesso verrà installato l'occorrente per l'utilizzo dei reopsitory AUR" 40 60
pacman -S --needed base-devel vi
dialog --ascii-lines --title "Informazioni" --backtitle "Informazioni" --msgbox "Per configurare sudo digitare visudo a sistema avviato e decommentare la riga\n\"%wheel ALL=(ALL) ALL\"" 40 60
dialog --ascii-lines --title "Informazioni" --backtitle "Informazioni" --msgbox "Adesso bisogna installare il boot loader e configurare la rete." 40 60
pacman -S grub bootefimgr networkmanager
grub-install --target=x86_64-efi --efi-directory=/boot/efi/ --bootloader-id=grub
grub-mkconfig -o /boot/grub/grub.cfg
dialog --ascii-lines --title "Informazioni" --backtitle "Informazioni" --msgbox "Al riavvio non verrà ancora mostrata l'intrefaccia grafica e la rete sarà disabilitata. Avviatele con arch3.sh" 40 60
