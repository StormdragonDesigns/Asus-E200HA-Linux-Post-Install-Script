#Let's get sound working
sudo pacman --noconfirm -Sy unzip yaourt
yaourt --noconfirm -S debtap
wget "https://github.com/Grippentech/Asus-E200HA-Linux-Post-Install-Script/releases/download/0.3/kernel.zip"
unzip kernel.zip
cd kernel
sudo debtap -u
debtap *.deb
tar -xvf chtcx2072x.tar
cd chtcx2072x
sudo mkdir -p /usr/share/alsa/ucm/chtcx2072x/
sudo mv chtcx2072x.conf /usr/share/alsa/ucm/chtcx2072x/
sudo mv HiFi.conf /usr/share/alsa/ucm/chtcx2072x/

#Now cleanup the files
cd ..
cd .. 
sudo rm -r kernel
sudo rm kernel.zip

#Now let's fix Backlight Controls up and down, THIS SEEMS TO BE CAUSING ISSUES> REMOVED TEMPORARILY.
#sudo touch /usr/share/X11/xorg.conf.d/20-intel.conf
#sudo sh -c "{ echo 'Section "Device"
#        Identifier  "card0"
#        Driver      "intel"
#        Option      "Backlight"  "intel_backlight"
#        BusID       "PCI:0:2:0"
#EndSection'; } >> /usr/share/X11/xorg.conf.d/20-intel.conf"

#Now let's take care of Linux Cherry Trail Suspend Issues by disabling Sleep/Hybernation
sudo systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target #Disable Suspend, broken on CherryTrail
sudo sh -c 'echo -e "[Login]\nHandleLidSwitch=ignore\nHandleLidSwitchDocked=ignore" >> /etc/systemd/logind.conf' #Disable Sleep/Hybernate when Lid is Closed

#Let's now install tlp and thermald to save you some battery life
sudo pacman --noconfirm -Sy tlp thermald 
#Change fstab a little bit for better eMMC support, eMMC Conservation settings
sudo sed -i -e 's/errors=remount-ro 0/discard,noatime,errors=remount-ro 0/g' /etc/fstab
sleep 15 #wait 15 seconds
sudo reboot now #Reboot to reenable Trackpad
