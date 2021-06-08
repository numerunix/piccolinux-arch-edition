!#/bin/bash
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
notRoot
installPrerequisites

dialog --title "Informazioni" --backtitle "Informazioni" --msgbox "Adesso dinstalliamo il sistema base." 40 60
pacstrap /mnt base linux linux-firmware
dialog --title "Informazioni" --backtitle "Informazioni" --msgbox "Adesso generiamo l'fstab." 40 60
genfstab -U /mnt >> /mnt/etc/fstab
cp arch2.sh /mnt
dialog --title "Informazioni" --backtitle "Informazioni" --msgbox "Eseguire /arch2.sh." 40 60
arch-chroot /mnt
