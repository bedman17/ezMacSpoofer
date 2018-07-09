#!/bin/bash
# Reset
Color_Off='\e[0m'       # Text Reset

# Regular Colors
Black='\e[0;30m'        # Black
Red='\e[0;31m'          # Red
Green='\e[0;32m'        # Green
Yellow='\e[0;33m'       # Yellow
Blue='\e[0;34m'         # Blue
Purple='\e[0;35m'       # Purple
Cyan='\e[0;36m'         # Cyan
White='\e[0;37m'        # White

# Bold
BBlack='\e[1;30m'       # Black
BRed='\e[1;31m'         # Red
BGreen='\e[1;32m'       # Green
BYellow='\e[1;33m'      # Yellow
BBlue='\e[1;34m'        # Blue
BPurple='\e[1;35m'      # Purple
BCyan='\e[1;36m'        # Cyan
BWhite='\e[1;37m'       # White

# Underline
UBlack='\e[4;30m'       # Black
URed='\e[4;31m'         # Red
UGreen='\e[4;32m'       # Green
UYellow='\e[4;33m'      # Yellow
UBlue='\e[4;34m'        # Blue
UPurple='\e[4;35m'      # Purple
UCyan='\e[4;36m'        # Cyan
UWhite='\e[4;37m'       # White

# Background
On_Black='\e[40m'       # Black
On_Red='\e[41m'         # Red
On_Green='\e[42m'       # Green
On_Yellow='\e[43m'      # Yellow
On_Blue='\e[44m'        # Blue
On_Purple='\e[45m'      # Purple
On_Cyan='\e[46m'        # Cyan
On_White='\e[47m'       # White

# High Intensity
IBlack='\e[0;90m'       # Black
IRed='\e[0;91m'         # Red
IGreen='\e[0;92m'       # Green
IYellow='\e[0;93m'      # Yellow
IBlue='\e[0;94m'        # Blue
IPurple='\e[0;95m'      # Purple
ICyan='\e[0;96m'        # Cyan
IWhite='\e[0;97m'       # White

# Bold High Intensity
BIBlack='\e[1;90m'      # Black
BIRed='\e[1;91m'        # Red
BIGreen='\e[1;92m'      # Green
BIYellow='\e[1;93m'     # Yellow
BIBlue='\e[1;94m'       # Blue
BIPurple='\e[1;95m'     # Purple
BICyan='\e[1;96m'       # Cyan
BIWhite='\e[1;97m'      # White

# High Intensity backgrounds
On_IBlack='\e[0;100m'   # Black
On_IRed='\e[0;101m'     # Red
On_IGreen='\e[0;102m'   # Green
On_IYellow='\e[0;103m'  # Yellow
On_IBlue='\e[0;104m'    # Blue
On_IPurple='\e[0;105m'  # Purple
On_ICyan='\e[0;106m'    # Cyan
On_IWhite='\e[0;107m'   # White
#Spinner Animation
spinner() {
    local pid=$1
    local delay=0.75
    local spinstr='|/-\'
    while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
        local temp=${spinstr#?}
        printf " [%c]  " "$spinstr"
        local spinstr=$temp${spinstr%"$temp"}
        sleep $delay
        printf "\b\b\b\b\b\b"
    done
    printf "    \b\b\b\b"
}
#Scan Interface
scan_interface() {
  interface_list=()
  for interface in $(ifconfig -a | cut -d ' ' -f1| tr ':' '\n' | awk NF)
    do
      if [[ $interface == "lo" ]] ; then  #Skip 'lo' interface
        test
      else
        interface_list+=("$interface")
      fi
  done
  select_interface
}
#Title Bar
title() {
  current_mac=$(macchanger -s $selected_interface | grep "Current" | grep -o -E '([[:xdigit:]]{1,2}:){5}[[:xdigit:]]{1,2}')
  permanent_mac=$(macchanger -s $selected_interface | grep "Permanent" | grep -o -E '([[:xdigit:]]{1,2}:){5}[[:xdigit:]]{1,2}')
  clear
  echo -e "${Cyan}#-----------------------------------------------------#"
  echo -e "${Cyan}#${BIWhite}         _____         _____             ___         ${Cyan}#"
  echo -e "${Cyan}#${BIWhite} ___ ___|     |___ ___|  __ |___ ___ ___|  _|___ ___ ${Cyan}#"
  echo -e "${Cyan}#${BIWhite}| -_|- _| | | | .'|  _|__   | . | . | . |  _| -_|  _|${Cyan}#"
  echo -e "${Cyan}#${BIWhite}|___|___|_|_|_|__,|___|_____|  _|___|___|_| |___|_|  ${Cyan}#"
  echo -e "${Cyan}#${BIWhite}                            |_|             ${On_IRed}v0.2.0${Cyan}   #"
  echo -e "${Cyan}#-----------------------------------------------------#"
}
mac_status() {
  echo -e "${White}       ${BIWhite}[${Yellow}@${BIWhite}]${White}Selected interface : ${BIRed}$selected_interface${Color_Off}"
  echo -e "${White}       ${BIWhite}[${Yellow}@${BIWhite}]${White}Current ${BIYellow}MAC${White}        : ${BIWhite}$current_mac${Color_Off}"
  echo -e "${White}       ${BIWhite}[${Yellow}@${BIWhite}]${White}Permanent ${BIYellow}MAC${White}      : ${BIGreen}$permanent_mac${Color_Off}"
  echo -e "${Cyan}#-----------------------------------------------------#"
}
#Interface Selector
select_interface() {
  title
  echo -e "  ${Cyan}No. Status\t\tInterface${Color_Off}"
  for ((i=1; i<=${#interface_list[@]}; i++))
  do
    if ifconfig ${interface_list[$i-1]} | grep -q "UP" ;then
      status="${Green}UP\t${Color_Off}"
    else
      status="${Red}DOWN${Color_Off}"
    fi
    if [[ $i -lt 10 ]] ;then
      echo -e "  0$i. $status\t${interface_list[$i-1]}"
    else
      echo -e "  $i. $status\t${interface_list[$i-1]}"
    fi
  done
  echo -e "  99. ${Yellow}Re-scan${Color_Off}"
  echo -e "  00. ${Red}Exit${Color_Off}"
  echo -e "${Cyan}#-----------------------------------------------------#"
  echo -e "  ${BIWhite}Select an interface..."
  echo -e "${Cyan}#-----------------------------------------------------#"
  echo -e -n "${Red}[${Cyan}ezMacSpoofer${Yellow}@${White}$(hostname)${Red}]-[${Yellow}~${Red}] ${White}"& read answer
  re='^[0-9]+$'
  if [[ $answer =~ $re ]] ;then
    if [[ $answer -le ${#interface_list[@]} && $answer -gt 0 ]] ;then
      echo -e -n "Interface ${interface_list[$answer-1]} has been selected!" && sleep 3.5 &
      spinner "$!"
      selected_interface=${interface_list[$answer-1]}
      mainmenu
    elif [[ $answer == 99 ]] ;then
      scan_interface
    elif [[ $answer == 00 ]] ;then
      exit
    else
      select_interface
    fi
  else
    select_interface
  fi
}
#Main Menu
mainmenu() {
  title
  mac_status
  echo -e "  ${BIWhite}What do you want to do?"
  echo -e "  ${Cyan}1. ${White}Change ${BIYellow}MAC${White} to specific ${BIYellow}MAC"
  echo -e "  ${Cyan}2. ${White}Change ${BIYellow}MAC${White} to random ${BIYellow}MAC"
  echo -e "  ${Cyan}3. ${White}Change interface"
  echo -e "  ${Cyan}4. ${White}Change ${BIYellow}MAC${White} to permanent ${BIYellow}MAC"
  echo -e "  ${Cyan}0. ${BIRed}Exit"
  echo -e "${Cyan}#-----------------------------------------------------#"
  echo -e -n "${Red}[${Cyan}ezMacSpoofer${Yellow}@${White}$(hostname)${Red}]-[${Yellow}~${Red}] ${White}"& read answer
  if [[ $answer == 1 ]] ;then
    number1
  elif [[ $answer == 2 ]] ;then
    number2
  elif [[ $answer == 3 ]] ;then
    number3
  elif [[ $answer == 4 ]] ;then
    number4
  elif [[ $answer == 0 ]] ;then
    exit
  else
    mainmenu
  fi
}
number1() {
    echo -e "${White}Type ${BIYellow}MAC${White} address (format: 'XX:XX:XX:XX:XX:XX'), type 'cancel' to abort"
    echo -e -n "${Red}[${Cyan}ezMacSpoofer${Yellow}@${White}$(hostname)${Red}]-[${Yellow}~${Red}] ${White}"& read answer
    if [[ $answer == "cancel" ]] ;then
      mainmenu
    fi
    ifconfig $selected_interface down
    if macchanger -m $answer $selected_interface | grep -q "New" ;then
      echo -e -n "${BIYellow}MAC${White} address successfully changed!${BIGreen}" && sleep 3.5 &
      spinner "$!"
      ifconfig $selected_interface up
      mainmenu
    else
      number1
    fi
}
number2() {
  ifconfig $selected_interface down
  macchanger -r $selected_interface | grep -q ""
  echo -e -n "${BIYellow}MAC${White} address changed to random ${BIYellow}MAC${BIGreen}"&& sleep 3.5 &
  spinner "$!"
  ifconfig $selected_interface up
  mainmenu
}
number3() {
  scan_interface
}
number4() {
  ifconfig $selected_interface down
  macchanger -p $selected_interface | grep -q ""
  echo -e -n "${BIYellow}MAC${White} address changed to permanent ${BIYellow}MAC${BIGreen}"&& sleep 3.5 &
  spinner "$!"
  ifconfig $selected_interface up
  mainmenu
}
scan_interface
