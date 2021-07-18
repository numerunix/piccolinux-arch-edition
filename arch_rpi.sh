#! /bin/bash
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
if [[ $os != \""Arch Linux ARM"\" ]]; then         
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
installPrerequisites
dialog --title "Informazioni" --backtitle "Informazioni" --msgbox "Copyright(c) 2021 Giulio Sorrentino\nNessun diritto riservato.\nTutti gli scripts vengono dati senza nessuna garanzia, sono usati a vostro rischio e pricolo.\nSe ti piace considera una donazione su github.\nDedicato a ilaria." 40 60


pacman-key --init
pacman-key --populate archlinuxarm
chown -R alarm:alarm /home/alarm
chown root:root /

dialog --ascii-lines --title "Informazioni" --backtitle "Informazioni" --msgbox "Alziamo il firewall." 40 60
# Set default chain policies
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT ACCEPT

# Accept on localhost
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT

# Allow established sessions to receive traffic
iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

iptables-save > /etc/iptables/iptables.rules
systemctl enable iptables

dialog --ascii-lines --title "Informazioni" --backtitle "Informazioni" --msgbox "Verrà impostato l'italiano come lingua di tastiera nella sessione e verrà abilitato l'orario via rete." 40 60

loadkeys it
timedatectl set-ntp true

pacman -S nano
dialog --ascii-lines --title "Informazioni" --backtitle "Informazioni" --msgbox "Adesso verrà mostratata la lista dei linguaggi, in ordine alfabetico. Decommentare \"it_IT.UTF-8\" e salvare" 40 60
nano /etc/locale.gen
locale-gen

echo "LANG=it_IT.UTF-8" > /etc/locale.conf
echo "KEYMAP=it" > /etc/vconsole.conf
echo "archlinux" > /etc/hostname


dialog --title "Informazioni" --backtitle "Informazioni" --msgbox "Indicare la password di root." 40 60
passwd
dialog --title "Informazioni" --backtitle "Informazioni" --msgbox "Indicare la password di alarm." 40 60
passwd alarm
dialog --ascii-lines --title "Informazioni" --backtitle "Informazioni" --msgbox "Adesso bisogna configurare la rete." 40 60
pacman -S networkmanager
systemctl start networkmanager
systemctl enable networkmanager
dialog --ascii-lines --title "Informazioni" --backtitle "Informazioni" --msgbox "Adesso verrà installato xfce, lightdm, xorg, firefox, thunderbird, parcellite, keeepass, libreoffice, tilix e il driver per accedere alle partizioni ntfs e al cellulare" 40 60
pacman -S xfce4 xfce4-goodies lightdm lightdm-gtk-greeter xorg-server xorg-server-common firefox thunderbird parcellite keepass libreoffice ntfs-3g fuse tilix  gvfs gvfs-mtp vlc galculator atril eog man-db gnome-disk-utility gparted cups cron at ntp
dialog --ascii-lines --title "Informazioni" --backtitle "Informazioni" --msgbox "Adesso verrà installato l'occorrente per l'utilizzo dei repository AUR" 40 60
pacman -S --needed base-devel vi
#dialog --ascii-lines --title "Informazioni" --backtitle "Informazioni" --msgbox "Per configurare sudo digitare visudo a sistema avviato e decommentare la riga\n\"%wheel ALL=(ALL) ALL\"\n perché il gestore di utenti di cinnammon imposta l'utente nel gruppo wheel" 40 60
dialog --title "Informazioni" --backtitle "Informazioni" --msgbox "Impostiamo il fuso orario su Roma." 40 60
ln -sf /usr/share/zoneinfo/Italy/Rome /etc/localtime
hwclock --systohc
timedatectl set-local-rtc 1 --adjust-system-clock

dialog --title "Informazioni" --backtitle "Informazioni" --msgbox "Impostiamo la tastiera italiana" 40 60
localectl set-x11-keymap it pc105 winkeys
localectl set-keymap it


dialog --ascii-lines --title "Informazioni" --backtitle "Informazioni" --msgbox "Adesso verrà abilitato lightdm. Ricordatevi di decommentare il gruppo wheel su visudo perché alarm fa parte di quel gruppo." 40 60
systemctl enable lightdm
systemctl start lightdm
