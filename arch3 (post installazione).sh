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
dialog --title "Informazioni" --backtitle "Informazioni" --msgbox "Copyright(c) 2021 Giulio Sorrentino\nNessun diritto riservato.\nTutti gli scripts vengono dati senza nessuna garanzia, sono usati a vostro rischio e pricolo.\nSe ti piace considera una donazione su github.\nDedicati a tutti i lavoratori del birdys bakery di vico belle donne a chiaia e portici via bella vista." 40 60
dialog --title "Informazioni" --backtitle "Informazioni" --msgbox "Impostiamo il fuso orario su Roma." 40 60
ln -sf /usr/share/zoneinfo/Italy/Rome /etc/localtime
timedatectl set-local-rtc 1 --adjust-system-clock
timedatectl set-timezone Europe/Rome

dialog --title "Informazioni" --backtitle "Informazioni" --msgbox "Abilitiamo la rete" 40 60
systemctl enable NetworkManager
systemctl start NetworkManager
dialog --title "Informazioni" --backtitle "Informazioni" --msgbox "Staccare e riattaccare il cavo di rete" 40 60

dialog --title "Informazioni" --backtitle "Informazioni" --msgbox "Abilitiamo il firewall ricordatevi che se si è connessi col cavo parte prima la connessione e poi il firewall.\n IL firewall si basa su iptables-persistent." 40 60

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

dialog --title "Informazioni" --backtitle "Informazioni" --msgbox "Inmpostiamo la tastiera italiana" 40 60
localectl set-x11-keymap it pc105 winkeys
localectl set-keymap it


dialog --ascii-lines --title "Informazioni" --backtitle "Informazioni" --msgbox "Adesso verrà abilitato lightdm." 40 60
hwclock --systohc
systemctl enable cronie atd ntpd lightdm
systemctl start cronie atd ntpd lightdm
