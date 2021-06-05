#!/bin/bash

height=15
width=40
choice_height=5

function install_ssh(){
    # install depen
    apt update -y
    apt install stunnel4 dropbear nano openssl curl cmake make gcc -y
    echo "/bin/false" >> /etc/shells

    # install stunnel
    bash <(curl -Ls https://raw.githubusercontent.com/mboxjem/SSH-Tunnel/master/stunnel/stunnel.sh)

    # install dropbear
    bash <(curl -Ls https://raw.githubusercontent.com/mboxjem/SSH-Tunnel/master/dropbear/dropbear.sh)

    #install badvpn
    bash <(curl -Ls https://raw.githubusercontent.com/mboxjem/SSH-Tunnel/master/badvpn/badvpn.sh)
}

function add_user(){
    username=$(dialog --clear --inputbox "Username" $height $width 3>&1 1>&2 2>&3)
    password=$(dialog --clear --passwordbox "Password" $height $width 3>&1 1>&2 2>&3)

    exitstatus=$?
    if [ $exitstatus = 0 ]; then
        if [ ! -z "$username" ] && [ ! -z "$password" ]; then
            useradd -p $password -s /bin/false -M $username
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
        if [ ! -z "$username" ]; then
            userdel -r $username
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
        if [ `id -u $username 2>/dev/null || echo -1` -ge 0 ]; then 
            dialog --msgbox "user found" $height $width
        else
            dialog --msgbox "user not found" $height $width
        fi
    fi
}

dialog --backtitle "Caution" --title "Caution" --clear --msgbox "I am not responsible for any damages on your machine\n\nScript by Jemjem" $height $width
clear

options=(1 "Install ssh tunnel"
         2 "Add user"
         3 "remove user"
         4 "check user")

while [ "$choice -n" ]; do choice=$(dialog --backtitle "Simple Bash Script for Install SSH Tunnel" --title "SSH TUNNEL TOOLS" --cancel-label "Exit" --menu "Choose one of the following options:" $height $width $choice_height "${options[@]}" 2>&1 >/dev/tty)
    clear
    case $choice in
        1)
            install_ssh 2>&1 | dialog --programbox $height $width
        ;;
        2)
            add_user
        ;;
        3)
            remove_user
        ;;
        4)
            check_user
        ;;
        *)
        exit
    esac
done