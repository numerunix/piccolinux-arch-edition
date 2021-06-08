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
dialog --title "Informazioni" --backtitle "Informazioni" --msgbox "Copyright(c) 2021 Giulio Sorrentino\nNessun diritto riservato.\nTutti gli scripts vengono dati senza nessuna garanzia, sono usatia vostro rischio e pricolo.\nDedicati a tutti i lavoratori del birdys bakery di vico belle donne a chiaia e portici via bella vista." 40 60
dialog --title "Informazioni" --backtitle "Informazioni" --msgbox "Impostiamo il fuso orario su Roma." 40 60
ln -sf /usr/share/zoneinfo/Italy/Rome /etc/localtime
hwclock --systohc

dialog --title "Informazioni" --backtitle "Informazioni" --msgbox "Abilitiamo la rete" 40 60
systemctl enable NetworkManager
systemctl start networkManager
dialog --title "Informazioni" --backtitle "Informazioni" --msgbox "Staccare e riattaccare il cavo di rete" 40 60

dialog --title "Informazioni" --backtitle "Informazioni" --msgbox "Abilitiamo il firewall ricordatevi che se si è connessi col cavo parte prima la connessione e poi il firewall" 40 60


echo "#Autore Giulio Sorrentino <gsorre84@gmail.com>
#Concesso in licenza secondo la GPL V3
[Unit]
Description=Firewall
After=networkonline.target

[Service]
ExecStart=/bin/firewall.sh

[Install]
WantedBy=multi-user.target" > /lib/systemd/system/firewall.service

echo "#!/bin/sh
#Autore Giulio Sorentino <gsorre84@gmail.com>
#Concesso in licenza secondo la GPL V3
iptables -A INPUT -i eth0 -j DROP
iptables -A FORWARD -i eth0 -j DROP" > /bin/firewall.sh
chmod +x /bin/firewall.sh

systemctl enable firewall
systemctl start firewall


dialog --title "Informazioni" --backtitle "Informazioni" --msgbox "Inmpostiamo la tastiera italiana" 40 60
localectl set-x11-keymap it pc105 winkeys
localectl set-keymap it


dialog --ascii-lines --title "Informazioni" --backtitle "Informazioni" --msgbox "Adesso verrà abilitato lightdm" 40 60
systemctl enable lightdm
systemctl start lightdm
