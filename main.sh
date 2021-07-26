#!/bin/bash

height=15
width=40
choice_height=5

function install_ssh(){
    # install depen
    apt update; apt upgrade -y
    apt install dropbear stunnel4 nano openssl curl cmake make gcc -y

    echo "/bin/false" >> /etc/shells

    # disable ipv6
    bash <(curl -Ls https://raw.githubusercontent.com/mboxjem/SSH-Tunnel/main/other/ipv6.sh)

    # install dropbear
    bash <(curl -Ls https://raw.githubusercontent.com/mboxjem/SSH-Tunnel/main/dropbear/dropbear.sh)

    # install stunnel
    bash <(curl -Ls https://raw.githubusercontent.com/mboxjem/SSH-Tunnel/main/stunnel/stunnel.sh)

    #install badvpn
    bash <(curl -Ls https://raw.githubusercontent.com/mboxjem/SSH-Tunnel/main/badvpn/badvpn.sh)

    sysctl -p
    systemctl restart dropbear.service
    systemctl restart stunnel4.service
    systemctl start badvpn.service
    systemctl enable badvpn.service
}

function install_addons(){
    
}

function add_user(){
    username=$(dialog --clear --inputbox "Username" $height $width 3>&1 1>&2 2>&3)
    password=$(dialog --clear --passwordbox "Password" $height $width 3>&1 1>&2 2>&3)

    exitstatus=$?
    if [ $exitstatus = 0 ]; then
        if [ -n "$username" ] && [ -n "$password" ]; then
            useradd -s /bin/false -M "$username"
            echo "$username:$password" | chpasswd
            dialog --msgbox "add user success" $height $width
        else
            dialog --msgbox "username or password cannot be empty" $height $width
        fi
    fi
}

function remove_user(){
    username=$(dialog --clear --inputbox "Username" $height $width 3>&1 1>&2 2>&3)

    exitstatus=$?
    if [ $exitstatus = 0 ]; then
        if [ -n "$username" ]; then
            userdel -r "$username"
            dialog --msgbox "remove user success" $height $width
        else
            dialog --msgbox "username cannot be empty" $height $width
        fi
    fi
}

function check_user(){
    username=$(dialog --clear --inputbox "Username" $height $width 3>&1 1>&2 2>&3)

    exitstatus=$?
    if [ $exitstatus = 0 ]; then
        if [ "$(id -u "$username" 2>/dev/null || echo -1)" -ge 0 ]; then 
            dialog --msgbox "user $username found" $height $width
        else
            dialog --msgbox "user $username not found" $height $width
        fi
    fi
}

dialog --backtitle "Caution" --title "Caution" --clear --msgbox "I am not responsible for any damages on your machine\n\nScript by Jemjem" $height $width
clear

options=(1 "Install ssh tunnel"
         2 "Install Addons"
         3 "Add user"
         4 "remove user"
         5 "check user")

while true ; do choice=$(dialog --backtitle "Simple Bash Script for Install SSH Tunnel" --title "SSH TUNNEL TOOLS" --cancel-label "Exit" --menu "Choose one of the following options:" $height $width $choice_height "${options[@]}" 2>&1 >/dev/tty)
    clear
    case $choice in
        1)
            install_ssh 2>&1 | dialog --programbox $height $width
        ;;
        2)
            install_addons
        ;;
        3)
            add_user
        ;;
        4)
            remove_user
        ;;
        5)
            check_user
        ;;
        *)
        exit
    esac
done
