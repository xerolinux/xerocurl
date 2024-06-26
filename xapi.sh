#!/usr/bin/env bash

for i in 2 30; do
    echo -en "\033]${i};XeroLinux Toolkit\007"
done

##################################################################################################################
# Written to be used on 64 bits computers
# Author   :   DarkXero
# Website  :   http://xerolinux.xyz
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

# Function to add the XeroLinux repository if not already added
add_xerolinux_repo() {
    if ! grep -q "\[xerolinux\]" /etc/pacman.conf; then
        echo "Adding XeroLinux Repository..."
        echo
        echo -e '\n[xerolinux]\nSigLevel = Optional TrustAll\nServer = https://repos.xerolinux.xyz/$repo/$arch' | sudo tee -a /etc/pacman.conf
        sudo sed -i '/^\s*#\s*\[multilib\]/,/^$/ s/^#//' /etc/pacman.conf
    else
        echo
        echo "XeroLinux Repository already added."
        echo
    fi
}

# Function to install and start the toolkit
install_and_start_toolkit() {
    sudo pacman -Syy --noconfirm xlapit-cli gum inxi && clear && exec /usr/bin/xero-cli -m
}

aur_helper="NONE"
for helper in "${aur_helpers[@]}"; do
    if command -v "$helper" &> /dev/null; then
        aur_helper="$helper"
        echo
        echo "AUR Helper detected, shall we proceed?"
        echo ""
        echo "y. Yes Please."
        echo "n. No thank you."
        echo ""
        echo "Type y or n to continue."
        echo ""

        read -rp "Enter your choice: " CHOICE

        case $CHOICE in
            y)
                add_xerolinux_repo
                install_and_start_toolkit
                ;;
            n)
                exit 0
                ;;
            *)
                echo "Invalid choice."
                exit 1
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
    read -rp "Choose your Helper: " number_chosen

    case $number_chosen in
        1)
            echo
            echo "###########################################"
            echo "           You Have Selected YaY           "
            echo "###########################################"
            add_xerolinux_repo
            echo
            echo "Installing YaY & Toolkit..."
            echo
            sudo pacman -Syy --noconfirm yay-bin gum inxi xlapit-cli && yay -Y --devel --save && yay -Y --gendb
            install_and_start_toolkit
            ;;
        2)
            echo
            echo "###########################################"
            echo "          You Have Selected Paru           "
            echo "###########################################"
            add_xerolinux_repo
            echo
            echo "Installing Paru & Toolkit..."
            echo
            sudo pacman -Syy --noconfirm paru-bin inxi gum xlapit-cli && paru --gendb
            install_and_start_toolkit
            ;;
        *)
            echo "Invalid option."
            ;;
    esac
fi
