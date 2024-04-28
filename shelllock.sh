#!/bin/bash
KILLER="b2f63f02d4c99d3d49400d91fb4e38b1  -"
CODE="4c3cbcadf7b8a9ae2932afc00560a0d6  -"
#################################################################################
# 
#   ShellLock.sh
# ------------------------
# 
# Datum    : 20.06.2023
# Author   : c3lsior
# Kontakt  : c3lsior@gmail.com
# Version  : 2..0
# Lizenz   : GNU General Public 3.0
# 
# ------------------------
# 
# Website  : https://www.netjeep.de
# Blog     : http://www.linux-freak.org
# GitHub   : https://github.com/c3lsi0r
#  
# Copyright 2023-2023, Black , Celsior
# Copyright 2023-2023, NJ-CySec
# 
# ShellLock.sh comes with ABSOLUTELY NO WARRANTY. This is free software, and you are
# welcome to redistribute it under the terms of the GNU General Public License.
# See LICENSE file for usage of this software.
# 
#################################################################################
# 
#     Discription: ShellLock.sh - Linux Bash Script - 
#
# - Sperrt das Terminal mit einen Passwort - Standard Passwort: "0000"
# - Das Passwort befindet sich oben im Quelltext. (Achtung #chmod 700 ShellLock.sh)
#   Und dort kann es auch geändert werden. Das Passwort selber ist md5sum Verschlüsselt,
#   da solltet ihr drauch achten, damit es nicht im Klartext steht..
#   Passwort ändern,über die konsole. example = $echo PASSWORT| md5sum
#   Passwort kann auch mit,  ./Shell_Lock -p   geändert werden.
# - Bei jeder falschen Eingabe verdoppelt sich die Zeit um Pass wieder
#   ein geben zu können.  
# - Mit ESpeak Sprachausgabe  -
# - Signale strg+c u. strg+z werden abgefangen -
# - Auch bei Abruch mit strg +c verdoppelt sich die Zeit -
# - Mit Uhrzeit und sek anzeige. verbesserte v1.7.2
# - Neue Version 1.8.0 mit Kill Switch, falls Passwort vergessen
#   einfach den KillSwitch ausführen 
#   (kann eine Tasten Kombi sein o. zweites Passwort etc.)
# - Unbefugte Zugriffe,und auch Autorisierte Zugriffen,werden in einer 
#   Versteckten Datei gespeichert.
# - Die Prozeß id wird ebenfalls,in eineer versteckten Datei gespeichert.
# ----------------------------------------------------------------------
# 
#  (c) by C3lsi0r
#################################################################################
# strg+c u. strg+z werden abgefangen und zum exithandler geleitet
VERSION="v2.0"
exec 2>> .error.log.tmp
trap "exithandler" 2 3
trap "exithandler" SIGTSTP 2 3
echo $$ > .ba_lock.pid
#exec 2>> /dev/null
# colors
Z="\e[0m"
BOLD="\e[1m"
Y="\e[33m"
R="\e[31m"
G="\033[0;36m"
B="\033[1;32m"
BB="\033[30;106m"

#COLOUR
cyan='\e[0;36m'
green='\e[0;34m'
okegreen='\033[92m'
lightgreen='\e[1;32m'
white='\e[1;37m'
red='\e[1;31m'
yellow='\e[0;33m'
BlueF='\e[1;34m' #Biru
RESET="\033[00m" #normal
orange='\e[38;5;166m'

BB='\033[1;30m' # Black
BR='\033[1;31m'   # Red
BG='\033[1;32m' # Green
BY='\033[1;33m' # Yellow
BBl='\033[1;34m'  # Blue
BP='\033[1;35m' # Purple
BC='\033[1;36m'  # Cyan
BW='\033[1;37m' # White

# Variablen
UPTIME=`uptime -p`
UPTIME_S=`uptime -s`

path=$(pwd)

# Zeit
zeit=$(date +%H:%M:%S)
ATIME=$(date +"%T")
utc=$(date -u +%H:%M:%S)
datum=$(date +%A\ %d.%m.%Y)
woche=$(date +%V)
zzone="Sommerzeit"
DELAY=1


function kill_switch() {
  #  VERZ=`pwd`
  #echo $$ > .ba_lock.pid
  ba_lock_pid=$(cat .ba_lock.pid)
  sleep 2
  kill -9 $ba_lock_pid #| rm .ba_lock.pid
  trap `rm -f .ba_lock.pid` EXIT
  break
exit
}

exithandler() {
  while true; do
    tput setaf 1
    tput rev
#    tput blink
    `espeak -v de 'Häcken zwecklos' 2> /dev/null`
    tput cup 20 1; printf " - Strg+c und Strg+z zwecklos - "
    tput sgr0
    DELAY=`expr $DELAY \* 2`
    DENY
  done
 }

function SPEAK_ZG() {
`espeak -v de 'Zugriff Gewährt' 2> /dev/null`
`espeak -v de 'Willkommen '$WBI'' 2> /dev/null`
}

function SPEAK_ZV() {
`espeak -v de 'Zugriff Verweigert' 2> /dev/null` 
}

function SPEAK_TG() {
`espeak -v de 'das Terminal wurde gesperrt' 2> /dev/null` 
}


function hinweis() {

   if [ $DELAY -ge "4" ]; then
      SEK=`expr $DELAY \* 2`
      SEK_1=`expr $SEK \* 2`
      tput setaf 3
      tput cup 20 ; tput dl1
      tput cup 21 1; echo " - Hinweis - "
      tput cup 22 1; echo " - Bei jeder Kennwort fehleingabe verdoppelt sich die Zeit - "
      tput cup 23 1; echo " - Jetzt sind es schon $count Sekunden. Das nächste mal $SEK_1 Sek. usw. - "
      tput cup 24 1; echo " - Hacking zwecklos - "
      tput cup 20 ; tput dl1
      tput sgr0
    fi
}

function DENY_SEK(){
  trap 'exithandler' 2 3
# Sekunden Aanzeige bei Pass fehleingabe
hinweis
  while [ "$count" != "-1" ]
    do
      SEK=`expr $DELAY \* 2`
      SEK_1=`expr $SEK \* 2`
      trap '' 2 3 20
      local new=`expr $count - 1`
      #new=${array[$count]}
        for c in  ${new} ; do
        a=$(date +%S)
        sekunden=$(echo $a -0 | bc)
         tput setaf 1
         tput rev
         tput blink
          tput cup 18 45 ; echo " Noch $count Sekunden - "
          tput sgr0
           tput setaf 1
          for((i=$count; i<$SEK ; i++ )); do
              echo -en "*"
          done
          tput sgr0
          sleep 1
        done
      local count=`expr $count - 1`
  
  done
  trap 'exithandler' 2 3
  trap 'exithandler' SIGTSTP 2 3
}

function DENY() {
datum=$(date +%d_%m_%Y_%T)
echo -e "Uberechtigter Zugriff --> Datum: $datum" >> .zugriff_v.log.tmp

  count=`expr $DELAY \* 2`
  #tput clear      # clear the screen
  tput setaf 1
  tput rev
  tput blink
  tput cup 18 19; echo "  - Zufriff Verweigert -  "
  SPEAK_ZV
  tput sgr0
  DENY_SEK
# sleep $DELAY
# DELAY=`expr $DELAY \* 2`   
  MAIN
}

function GRAND() {
  datum=$(date +%d_%m_%Y_%T)
echo -e "Zugriff Gewährt --> Datum: $datum" >> .zugriff_g.log.tmp
  local uid=$(id -u)
  if [ "$uid" = "1001" ]; then
    WBI="Meister"
  else
    WBI=`whoami`
  fi  
  #tput clear      # clear the screen
  tput setaf 2
  tput rev
  tput blink
  tput cup 18 19; echo "  - Zufriff Gewährt -  "
  tput cup 18 40; echo "  - Willkommen $WBI -  "
  SPEAK_ZG
  #sleep $DELAY
  tput sgr0
  #trap 2
  sleep 1
  tput clear
  banner_func
  exit 0
}

function MAIN() {

#DELAY=`expr $DELAY \* 2`
MATCH=""
while [[ "$MATCH" != "$CODE" ]] ;
do
  ATIME=$(date +"%T")
  stty -echo
  stty echo
  tput clear
  #SPEAK_TG
  toilet --metal "Terminal"
  toilet --metal "gerperrt"	
  tput bold ; tput setaf 7
  echo -e "Terminal gesperrt um : $ATIME | Datum: $datum | Uptime: $UPTIME seit $UPTIME_S "
  echo "------------------------------------------------------------------------------------------------------------+"
  stty -echo
  echo -n "Bitte Pin eingeben: "
  IFS='' read -r -s MATCH
 stty echo
  tput sgr0
    DELAY=`expr $DELAY \* 2`
#IFS='' read -r -s MATCH
#[ "$answer" = "$answer" ] && exit
if [ "$CODE" = "$(echo "$MATCH" | md5sum)" ]; then
   GRAND
  elif [ "$KILLER" == "$(echo "$MATCH" | md5sum)" ]; then
    kill_switch
  else
    DENY
fi
  :' # OLD Password Check 
  if [ "$CODE" == "$MATCH" ]; //*then
    GRAND
  elif [ "$KILLER" == "$MATCH" ]; then
    kill_switch
  else
    DENY
  fi
  # END Password Check
'
done

}


pass_new(){
  echo -ne "$okegreen [*]:: - Neues Passwort vergeben -"
  sleep 1 ; echo ""
  sleep 1 ; echo ""
  sleep 1 ; echo ""
  echo -ne "$okegreen [*]:: Aktuelles Passwort eingeben: "
  IFS='' read -r -s MATCH
if [ "$CODE" = "$(echo "$MATCH" | md5sum)" ]; then
  echo "" 
  echo -e $okegreen [!]:: - aktuelles Passwort Verschlüsselt -  ;
  PASS_AKT=`cat $0 |  awk  -F "=" '(NR == 3) {print $2}'`
  echo -e $okegreen [!]:: $PASS_AKT  ;
  sleep 1 ; echo ""
  echo -e "$okegreen [*]:: Neues Passwort eingeben: " 
  IFS='' read -r -s new_pass_one
#  echo ":" ; read new_pass_one
  sleep 1 ; echo ""
  echo -e "$okegreen [*]:: Passwort bestätigen: "  
  IFS='' read -r -s new_pass_two
  #echo ":" ; read new_pass_two
  sleep 1

  if [ "$new_pass_one" == "$new_pass_two" ]; then
    echo ""
    echo -e $okegreen [✔]:: Passwort Klartext - ;
    echo -e $okegreen [✔]:: $new_pass_two ;
    echo -e $okegreen [✔]:: Passwort Verschlüsselt - ;
    PASS_ENC=`echo "$new_pass_two" | md5sum`
    echo -e $okegreen [✔]:: $PASS_ENC ;   
    sleep 1
    echo ""
    echo -e $okegreen [✔]:: Passwort erfolgreich geändert! ;
    echo ""
     
    else
    echo ""
    echo -e $red [!]:: Passwort stimmen nicht überein! - ;
  fi
  else
    echo -e $red [!]:: Passwort stimmt nicht! - 
    echo -e $red [!]:: Bitte das korrekte Passwort eingeben ! -
    exit 0
fi


  



}


function prog_check(){

echo -e $cyan"   ____ _               _    _                   "
echo "  / ___| |__   ___  ___| | _(_)_ __   __ _             "
echo " | |   | '_ \ / _ \/ __| |/ / | '_ \ / _\ |            "
echo " | |___| | | |  __/ (__|   <| | | | | (_| |  _   _   _ "
echo "  \____|_| |_|\___|\___|_|\_\_|_| |_|\__/ | (_) (_) (_)"
echo "                                      |___/    "
echo -e $lightgreen'+-- -- +=[(c) 2024-2024 | Linux-Freak.org | NetJeep.de | CyberSecurity | Ethical Hacking > ]=+ -- --+'
echo -e $cyan'+-- -- +=[ Author: C3lsior < CyberSecurity (B.Sc.)                                       > ]=+ -- --+ '
echo -e $lightgreen'+-- -- +=[ thx for Using | Visit on GitHub: https://github.com/c3lsi0r/                  > ]=+ -- --+'
echo -e " "

# Check espeak if Exists
which espeak > /dev/null 2>&1
  if [ "$?" -eq "0" ]; then
     echo -e $okegreen [✔]::[espeak]: Installation found!;
  else
     echo -e $red [x]::[warning]:this script require Espeak to work ;
     sleep 0.5
     echo -e $red [x]::[warning]:the script will be installed ;
     sleep 0.5
     sudo apt install espeak
    fi
sleep 0.5
# Check bc if Exist
which bc > /dev/null 2>&1
  if [ "$?" -eq "0" ]; then
     echo -e $okegreen [✔]::[Bc]: Installation found!;
  else
     echo -e $red [x]::[warning]:this script require Bc to work ;
     echo ""
     echo -e $red [x]::[warning]:the script will be installed ;
     sleep 0.5
     sudo apt install bc
     sleep 0.5
  fi
sleep 0.5
# Check toilet if Exist
which toilet > /dev/null 2>&1
  if [ "$?" -eq "0" ]; then
     echo -e $okegreen [✔]::[Toilet]: Installation found!;
  else
     echo -e $red [x]::[warning]:this script require Toilet to work ;
     echo ""
     echo -e $red [x]::[warning]:the script will be installed ;
     sleep 0.5
     sudo apt install toilet
  fi
sleep 0.5
echo -e $okegreen [*]::[Installation]: Script Neustart :: Programme sind Installiert ;
sleep 5
$0 --install

sleep 2
exit 0


}

function banner_func(){
echo ""
echo -e $cyan"=================================================================================================="
echo -e $okegreen"        ShellLock a Script to Lock your Terminal THIS VERSION $VERSION  "
echo -e $cyan"=================================================================================================="
echo -e $lightgreen'+-- -- +=[(c) 2023-2024 | CyberSecurity | IT-Security |  Linux Client-/Server        > ]=+ -- --+'
echo -e $cyan'+-- -- +=[ (c)by C3lsior 2023 < CyberSecurity (B.Sc.)                                > ]=+ -- --+ '
echo -e $lightgreen'+-- -- +=[ thx for Using | Visit on GitHub: https://github.com/c3lsi0r/Shell_Lock >    ]=+ -- --+'
echo -e $cyan"==================================================================================================="
echo -e $okegreen"        ShellLock a Script to Lock your Terminal THIS VERSION $VERSION  "
echo -e $cyan"==================================================================================================="
sleep 1
  
  sleep 1
  rm .ba_lock.pid
  #kill_switch
  #clear
exit 0
}

Usage_func_h(){
  local white='\033[1;37m' # White
cat <<EOF
`echo -e $white`
  $(basename "${BASH_SOURCE[0]}") $VERSION
  `echo -e "Usage: $(basename "${BASH_SOURCE[0]}") ARGUMENT "`
  `echo -e "Usage: $(basename "${BASH_SOURCE[0]}") [ --lock || -l ][ --install || -i ][ --check || -c ][ --pass || -p ][ --help || -h ]"`
EOF
}

Usage_func_help(){
cat <<EOF
`echo -e $white`
  $(basename -a "${BASH_SOURCE[0]}") $VERSION

  `echo -e "$BWhite Usage: $(basename "${BASH_SOURCE[0]}") ARGUMENT $Color_Off"`
  `echo -e "Usage: $(basename "${BASH_SOURCE[0]}") [ --lock || -l ][ --install || -i ][ --check || -c ][ --pass || -p ][ --help || -h ]"`

  `echo -e "${BWhite}Du kannst ${UWhite}lange${Color_Off}${BWhite} oder ${UWhite}kurze${Color_Off}${BWhite} Option benutzen. ${Color_Off}"`
  Usage: $(basename "${BASH_SOURCE[0]}") --lock
    Or
  Usage: $(basename "${BASH_SOURCE[0]}") -l

  $(basename "${BASH_SOURCE[0]}") --install -i  Installiert benötigte Programme.
  $(basename "${BASH_SOURCE[0]}") --check   -c  Überprüft ob benötigte Programme vorhanden sind.
  $(basename "${BASH_SOURCE[0]}") --pass    -p  Vergibt ein Neues Passwort. Das Standard Passwort ist 0000.
  $(basename "${BASH_SOURCE[0]}") --lock    -l  Sperrt das Terminal.
  $(basename "${BASH_SOURCE[0]}") --help    -h  Zeigt diese Hilfe.

EOF

}

pass_check(){

echo -e $okegreen [*]:: Um das Terminal zu sperren bitte,  ;
echo ""
echo -n  " [*]:: Aktuelles Passwort eingeben: "
IFS='' read -r -s MATCH
if [ "$CODE" = "$(echo "$MATCH" | md5sum)" ]; then
    echo "" 
    MAIN
    else
    echo ""
    echo -e $red [!]:: Passwort stimmt nicht! - 
    echo -e $red [!]:: Um das Terminaal zu sperren - 
    echo -e $red [!]:: Bitte das korrekte Passwort eingeben ! -
    exit 0
fi
echo $Color_Off
}



case $1 in
  --help | -h )
    Usage_func_help
    exit 0
    ;;
  --install| -i)
    echo -e $okegreen [✔]::[Programme]: Installiert ! ;
    sleep 3
    banner_func 
    ;;
  --check | -c )
    prog_check ; banner_func ; exit 0
    ;;
  --pass | -p )
    pass_new
    echo ""
    sleep 1
    echo -e "$white [*]::[INFO] Teile diese Passwörter niemanden mit und Schreibe sie nicht auf einen Zettel, \n benutze am bester einen Passwort Manager -"
    sleep 1
    #banner_func
    exit 0
    ;;
  --lock | -l )
    pass_check
    ;;
     *)
    sleep 0.5
    echo ""
    Usage_func_h ; exit 0 
    ;;
esac
MAIN

