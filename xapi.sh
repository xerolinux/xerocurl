#!/usr/bin/env bash

for i in 2 30; do
    echo -en "\033]${i};XeroLinux Toolkit\007"
done

##################################################################################################################
# Written to be used on 64 bits computers
# Author 	: 	DarkXero
# Website 	: 	http://xerolinux.xyz
##################################################################################################################
clear
tput setaf 5
echo "#######################################################################"
echo "#          Welcome to XeroLinux Arch Toolkit install script.          #"
echo "#                                                                     #"
echo "# This will add the XeroLinux repository required to install the tool #"
echo "#     AUR helper and more. Just close window if you do not agree.     #"
echo "#######################################################################"
tput sgr0

aur_helpers=("yay" "paru")
echo
aur_helper="NONE"
for i in ${aur_helpers[@]}; do
  if command -v $i; then
    aur_helper="$i"
    echo
echo "AUR Helper detected, shall we proceed ?"
echo ""
echo "y. Yes Please."
echo "n. No thank you."
echo ""
echo "Type y or n to continue."
echo ""

read CHOICE

case $CHOICE in

y)
echo
echo "Adding XeroLinux Repository..."
echo
echo -e '\n[xerolinux]\nSigLevel = Optional TrustAll\nServer = https://repos.xerolinux.xyz/$repo/$arch' | sudo tee -a /etc/pacman.conf
sudo sed -i '/^\s*#\s*\[multilib\]/,/^$/ s/^#//' /etc/pacman.conf
echo
echo "Installing & Starting the Toolkit..."
echo
sudo pacman -Syy --noconfirm xlapit-cli && clear && exec /usr/bin/xero-cli -m
;;

n)
echo
exit 0
;;

esac
  fi
done

if [[ $aur_helper == "NONE" ]]; then
  echo
  echo "No AUR Helper detected, required by the toolkit."
  echo ""
  echo "1 - Yay + Toolkit (Not the best)"
  echo "2 - Paru + Toolkit (Fast/Recommended)"
  echo ""
  read -p "Choose your Helper : " number_chosen

  case $number_chosen in
    1)
      echo
      echo "###########################################"
      echo "           You Have Selected YaY           "
      echo "###########################################"
      echo
      echo "Adding XeroLinux Repository..."
      echo
      sudo cp /etc/pacman.conf /etc/pacman.conf.backup && \
      echo -e '\n[xerolinux]\nSigLevel = Optional TrustAll\nServer = https://repos.xerolinux.xyz/$repo/$arch' | sudo tee -a /etc/pacman.conf
      sudo sed -i '/^\s*#\s*\[multilib\]/,/^$/ s/^#//' /etc/pacman.conf
      sleep 2
      echo
      echo "Installing YaY & Toolkit..."
      echo
      sudo pacman -Syy --noconfirm yay-bin xlapit-cli && yay -Y --devel --save && yay -Y --gendb
      echo
      echo "Launching toolkit..."
      clear && exec /usr/bin/xero-cli -m
    ;;
    2)
      echo
      echo "###########################################"
      echo "          You Have Selected Paru           "
      echo "###########################################"
      echo
      echo "Adding XeroLinux Repository..."
      echo
      sudo cp /etc/pacman.conf /etc/pacman.conf.backup && \
      echo -e '\n[xerolinux]\nSigLevel = Optional TrustAll\nServer = https://repos.xerolinux.xyz/$repo/$arch' | sudo tee -a /etc/pacman.conf
      sudo sed -i '/^\s*#\s*\[multilib\]/,/^$/ s/^#//' /etc/pacman.conf
      sleep 2
      echo
      echo "Installing Paru & Toolkit..."
      echo
      sudo pacman -Syy --noconfirm paru-bin xlapit-cli && paru --gendb
      echo
      echo "Launching toolkit..."
      clear && exec /usr/bin/xero-cli -m
    ;;
    *)
      echo "Invalid option"
    ;;
  esac
fi
