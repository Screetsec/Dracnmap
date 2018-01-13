#!/usr/bin/env bash

#============================================================================================================
#                         Dracnmap for dracos
#
#                      Welcome and dont disclaimer
#              Dracnmap Author By Edo -maland- a.k.a screetsec
#                     Tested On Kali Linux and Dracos
#       contact me in screetsec@gmail.com or screetsec@dracos-linux.org
#          OS Penetration From Indonesia : https://dracos-linux.org/
#============================================================================================================


#This colour
cyan='\e[0;36m'
green='\e[0;34m'
okegreen='\033[92m'
lightgreen='\e[1;32m'
white='\e[1;37m'
red='\e[1;31m'
yellow='\e[1;33m'
BlueF='\e[1;34m'


#Variable
Version='2.1'
Codename='Redline'
xterm='xterm -hold -fa monaco -fs 13 -bg black -e nmap'

# Author of changes: trimstray (contact@nslab.at, https://github.com/trimstray)
#   - added _init_name variable
#   - added _init_directory variable
# Store the name of the script and directory call.
readonly _init_name="$(basename "$0")"
readonly _init_directory="$(dirname "$(readlink -f "$0")")"

# Author of changes: trimstray (contact@nslab.at, https://github.com/trimstray)
#   - added _src_directory variable
# Directory structure.
readonly _src_directory="${_init_directory}/src"

# Author of changes: trimstray (contact@nslab.at, https://github.com/trimstray)
#   - added _functions_directory variable
#   - added _functions_stack array
#   - separated functions into files
readonly _functions_directory="${_src_directory}/functions"

readonly _functions_stack=("scanoutput" "brutense" "auth" "brd" \
                           "exploit" "fuzzer" "malware" "vuln")

for _fname in "${_functions_stack[@]}" ; do

  _filename="$_fname"
  _fpath="${_functions_directory}/${_filename}"

  if [[ ! -z "$_fpath" ]] && [[ -e "$_fpath" ]] ; then

    # If the file exists is loaded.
    . "$_fpath"

  elif [ -z "$_fpath" ] ; then

    printf "incorrectly loaded '$_fpath' file (incorrect filename)"
    exit 1

  else

    printf "incorrectly loaded '$_fpath' file (does not exist?)"
    exit 1

  fi

done

trap ctrl_c INT
ctrl_c() {
clear
echo -e $red"[*] (Ctrl + C ) Detected, Trying To Exit ..."
sleep 1
echo ""
echo -e $yellow"[*] Thank You For Using Dracnmap  =)."
echo ""
echo -e $yellow"[*] Check Dracos Linux LFS, Penetration OS From Indonesia  =P."
exit
}

#Bebeku
if [[ $EUID -ne 0 ]]; then
	echo "ERROR! Run this script with root user!"
	exit 1
fi

if [ -z "${DISPLAY:-}" ]; then
    echo -e "\e[1;31mThe script should be executed inside a X (graphical) session."$transparent""
    exit 1
fi
resize -s 50 84 > /dev/null

###############################################
# Checking gaannss
###############################################
clear
echo -e $okegreen ""
echo -e $okegreen "    .___                     _______                         $red       ________  ";
echo -e $okegreen "  __| _/___________    ____  \      \   _____ _____  ______  $red ___  _\_____  \ ";
echo -e $okegreen " / __ |\_  __ \__  \ _/ ___\ /   |   \ /     \\__  \ \____  \ $red \  \/ //  ____/  ";
echo -e $okegreen "/ /_/ | |  | \// __ \\  \___/     |    \  Y Y  \/ __ \|  |_> >$red  \   //       \  ";
echo -e $okegreen "\____ | |__|  (____  /\___  >____|__  /__|_|  (____  /   __/ $red/\ \_/ \_______ \ ";
echo -e $okegreen "     \/            \/     \/        \/      \/     \/|__|    $red\/             \/ ";
echo
echo -e $okegreen"-------------------------------------------------------------------------------"
echo -e $lightgreen'-- -- +=[(c) 2016-2017 | dracos-linux.org | Linuxsec.org | Pentester Indonesia '
echo -e $cyan'-- -- +=[ Author: Screetsec < Edo Maland >  ]=+ -- -- '
echo -e " "

if [ $(id -u) != "0" ]; then

      echo [!]::[Check Dependencies] ;
      sleep 2
      echo [✔]::[Check User]: $USER ;
      sleep 1
      echo [x]::[not root]: you need to be [root] to run this script.;
      echo ""
   	  sleep 1
	  exit


else

   echo [!]::[Check Dependencies]: ;
   sleep 1
   echo [✔]::[Check User]: $USER ;

fi

  ping -c 1 google.com > /dev/null 2>&1
  if [ "$?" != 0 ]

then

    echo [✔]::[Internet Connection]: DONE!;
    echo [x]::[warning]: This Script Needs An Active Internet Connection;
    sleep 2

else

    echo [✔]::[Internet Connection]: connected!;
    sleep 2
fi

# check nmap if exists
      which nmap > /dev/null 2>&1
      if [ "$?" -eq "0" ]; then
      echo [✔]::[nmap]: installation found!;
else

   echo [x]::[warning]:this script require Nmap ;
   echo ""
   echo [!]::[please wait]: please install .... ;
   apt-get update
   apt-get install nmap
   echo ""
   sleep 2
   exit
fi
sleep 2
# check urxvt if exists
      which xterm > /dev/null 2>&1
      if [ "$?" -eq "0" ]; then
      echo [✔]::[xterm]: installation found!;
else

   echo [x]::[warning]:this script require xterm ;
   echo ""
   echo [!]::[please wait]: please install .... ;
   apt-get update
   apt-get install xterm
   echo ""
   sleep 2
   exit
fi
sleep 2

function nse	() {
clear
echo -e $okegreen " "
echo "    )   *           (      (         (   (   (            ";
echo " ( /( (  \     (     )\ )   )\ )  (   )\ ))\ ))\ )  *   )  ";
echo " )\()))\))(   )\   (()/(  (()/(  )\ (()/(()/(()/(\  )  /(  ";
echo "((_)\((_)()((((_)(  /(_))  /(_)|((_) /(_))(_))(_))( )(_)) ";
echo " _((_|_()((_)\ _ )\(_))   (_)) )\___(_))(_))(_)) (_(_())  ";
echo "| \| |  \/  (_)_\(_) _ \  / __((/ __| _ \_ _| _ \|_   _|  ";
echo "| .\ | |\/| |/ _ \ |  _/  \__ \| (__|   /| ||  _/  | |    ";
echo "|_|\_|_|  |_/_/ \_\|_|    |___/ \___|_|_\___|_|    |_|    ";
echo "                                                          ";
echo -e $red"  Nmap Script Engine - Advanced Scanning with Nmap Script "

				echo -e $white " "
				echo -e $white"	[$okegreen"01"$white]$cyan  auth-category  "
				echo -e $white"	[$okegreen"02"$white]$cyan  broadcast-category "
				echo -e $white"	[$okegreen"03"$white]$cyan  brute-category "
				echo -e $white"	[$okegreen"04"$white]$cyan  exploit-category "
				echo -e $white"	[$okegreen"05"$white]$cyan  fuzzer-category "
				echo -e $white"	[$okegreen"06"$white]$cyan  malware-category "
				echo -e $white"	[$okegreen"07"$white]$cyan  vuln-category "
				echo -e $white"	[$okegreen"08"$white]$cyan  back to menu "
				echo
				echo -n -e $red'  \033[4mScreetsec@nse:\033[0m>> '; tput sgr0 #insert your choice
		      	read ceh
		          if test $ceh == '1'
		          	then
								clear
								auth
		          	elif test $ceh == '2'
		           		then
		           		clear
									brd
		              elif test $ceh == '3'
		                then
										clear
										brutense
		              elif test $ceh == '4'
		                then
											clear
											exploit
		            elif test $ceh == '5'
		                then
											clear
											fuzzer
										elif test $ceh == '6'
		                	then
		                	echo
											clear
											malware
										elif test $ceh == '7'
											then
											echo
											clear
											vuln
									elif test $ceh == '8'
										then
										 menu
									else
											echo ""
											echo -e $okegreen " Incorrect Number"
										fi
											 echo ""
											 echo ""
											 echo -n -e $red " Back to Last Menu? ( Yes / No ) :"
									read back
									if [ $back != 'n' ] && [ $back != 'N' ] && [ $back != 'no' ] && [ $back != 'No' ]
											then
											clear
											menu
									elif [ $back != 'y' ] && [ $back != 'Y' ] && [ $back != 'yes' ] && [ $back != 'Yes' ]
											then
											nse
									fi
						}

################################################
# PING PING BEBEB
################################################
function pingbebeb() {
  echo -e $okegreen " "
  clear
  echo " "
  echo "                "
  echo ""
  echo "          \|/  "
  echo "         .-*-   "
  echo "        / /|\     "
  echo "       _L_         "
  echo "     ,     .         "
  echo -e $okegreen" (\ /  O O  \ /)  $red ______ _______ _______ _______      __ __      "
  echo -e $okegreen"  \|    _    |/   $red |   __ \_     _|    |  |     __|    |  |  |     "
  echo -e $okegreen"    \  (_)  /     $red |    __/_|   |_|       |    |  |    |__|__|   "
  echo -e $okegreen"    _/.___,\_     $red |___|  |_______|__|____|_______|    |__|__|    "
  echo -e $okegreen"   (_/ alf \_)         "
    echo -e $white " "
    echo -e $white"	[$okegreen"01"$white]$cyan  BROADCAST PING  "
    echo -e $white"	[$okegreen"02"$white]$cyan  TCP SYN PING SCANS "
    echo -e $white"	[$okegreen"03"$white]$cyan  TCP ACK PING SCANS "
    echo -e $white"	[$okegreen"04"$white]$cyan  UDP PING SCANS "
    echo -e $white"	[$okegreen"05"$white]$cyan  ICMP PING SCANS "
    echo -e $white"	[$okegreen"06"$white]$cyan  IP PROTOCOL PING SCANS "
    echo -e $white"	[$okegreen"07"$white]$cyan  BACK  "
    echo -e " "
    echo -n -e $red'  \033[4mScreetsec@PING!:\033[0m>> '; tput sgr0 #insert your choice
             read DrS

           if test $DrS == '1'
        	  then
                  echo -e $cyan""
                  echo -n "  What is your IP Target or Host: " ; tput sgr0
           	  read ip
          	  $xterm --script broadcast-ping --script-args broadcast-ping.num_probes=5 $ip &
                  pingbebeb
           elif test $DrS == '2'
               	  then
                  echo -e $cyan""
                  echo -n "  What is your IP Target or Host: " ; tput sgr0
           	  read ip
          	  $xterm -sP -PS $ip &
                  pingbebeb
           elif test $DrS == '3'
                  then
                  echo -e $cyan""
                  echo -n "  What is your IP Target or Host: " ; tput sgr0
                  read ip
                  $xterm -sP -PA $ip &
                  pingbebeb
            elif test $DrS == '4'
                  then
                  echo -e $cyan""
                  echo -n "  What is your IP Target or Host: " ; tput sgr0
                  read ip
                  $xterm -sP -PU $ip &
                  pingbebeb
            elif test $DrS == '5'
            		then
                  echo -e $cyan""
                  echo -n "  What is your IP Target or Host: " ; tput sgr0
                  read ip
                  $xterm -sP -PE $ip &
                  pingbebeb
            elif test $DrS == '6'
               	  then
                  echo -e $cyan""
                  echo -n "  What is your IP Target or Host: " ; tput sgr0
                  read ip
                  $xterm  -sP -PO --packet-trace $ip  &
                  pingbebeb
            elif test $DrS == '7'
              then
              menu
       			else
                echo ""
       			  	echo -e $okegreen " Incorrect Number"
        			fi
              echo ""
              echo ""
        			echo -n -e $cyan " Back to Last Menu? ( Yes / No ) :"
       			read back
       			if [ $back != 'n' ] && [ $back != 'N' ] && [ $back != 'no' ] && [ $back != 'No' ]
       					then
       					clear
       					menu
       			elif [ $back != 'y' ] && [ $back != 'Y' ] && [ $back != 'yes' ] && [ $back != 'Yes' ]
       					then
       					pingbebeb
       			fi
       }



###############################################
# ZENMAP
###############################################
function zenmapscript() {
clear
clear
echo ""
echo -e $okegreen" ===================================================================="
echo -e $cyan""
echo "           +--^----------,--------,-----,--------^-, "
echo -e "           | $red |||||||||   --------      |         O "
echo -e $cyan"           +---------------------------^----------| "
echo -e $cyan"            \_,---------,---------,--------------' "
echo -e "              / $red"XXXXXX"$cyan /'|       /' "
echo -e "             / $red"XXXXXX"$cyan /   \    /' "
echo -e "            / $red"XXXXXX"$cyan / _______/ "
echo -e "           / $red"XXXXXX"$cyan / "
echo -e "           / $red"XXXXXX"$cyan / "
echo "           (________(   "
echo -e "            ------'        $red DOUBLE KILL !! GO GO GO !!  "
echo ""
echo -e $okegreen" ====================================================================="
echo -e $cyan "       Scanning Target with $red'advanced command  ( Zenmap Command )  "
echo -e $okegreen" ====================================================================="
echo ""
echo ""
  echo -e $white"	[$okegreen"01"$white]$cyan  ITENSE SCAN"
  echo -e $white"	[$okegreen"02"$white]$cyan  ITENSE SCAN + UDP "
  echo -e $white"	[$okegreen"03"$white]$cyan  ITENSE SCAN ALL TCP PORTS "
  echo -e $white"	[$okegreen"04"$white]$cyan  QUICK SCAN  "
  echo -e $white"	[$okegreen"05"$white]$cyan  QUICK SCAN PLUS PLUS "
  echo -e $white"	[$okegreen"06"$white]$cyan  QUICK TRACEROUT   "
  echo -e $white"	[$okegreen"07"$white]$cyan  COMPREHENSIVE SCAN [BEST]  "
  echo -e $white"	[$okegreen"08"$white]$cyan  BACK  "
	echo -e 	" "
  echo -n -e $red'  \033[4mScreetsec@Headshot:\033[0m>> '; tput sgr0 #insert your choice
      read Scanning
			if test $Scanning == '1'
				then
				echo
				echo -ne $okegreen " What is your IP Target or Host: " ; tput sgr0
 				read ip
				$xterm -T4 -A -v $ip &
			elif test $Scanning == '2'
				then
				echo
				echo -ne $okegreen " What is your IP Target or Host: " ; tput sgr0
 				read ip
				$xterm -sS -sU -T4 -A -v $ip &
			elif test $Scanning == '3'
				then
				echo
				echo -ne  $okegreen" What is your IP Target or Host: " ; tput sgr0
 				read ip
				$xterm -p 1-65535 -T4 -A -v $ip &
			elif test $Scanning == '4'
				then
				echo
				echo -ne  $okegreen" What is your IP Target or Host: "; tput sgr0
 				read ip
				$xterm -T4 -F $ip &
			elif test $Scanning == '5'
				then
				echo
				echo -ne  $okegreen" What is your IP Target or Host: "; tput sgr0
 				read ip
				$xterm -sV -T4 -O -F --version-light $ip &
			elif test $Scanning == '6'
				then
				echo
				echo -ne $okegreen " What is your IP Target or Host: "; tput sgr0
 				read ip
				$xterm -sn --traceroute $ip &
			elif test $Scanning == '7'
				then
				echo
				echo -ne $okegreen " What is your IP Target or Host: " ; tput sgr0
 				read ip
				$xterm -sS -sU -T4 -A -v -PE -PP -PS80,443 -PA3389 -PU40125 -PY -g 53 --script "default or (discovery and safe)" $ip &
      			elif test $Scanning == '8'
        			then
        			menu
     			else
     			    echo ""
     			    echo -e $okegreen " Incorrect Number"
     			  fi
     			  echo ""
     			  echo ""
     			  echo -n -e $red " Back to Last Menu? ( Yes / No ) :"
     			read back
     			if [ $back != 'n' ] && [ $back != 'N' ] && [ $back != 'no' ] && [ $back != 'No' ]
     			    then
     			    clear
     			    menu
     			elif [ $back != 'y' ] && [ $back != 'Y' ] && [ $back != 'yes' ] && [ $back != 'Yes' ]
     			    then
     			    zenmapscript
     			fi
 }

################################################
# PSCANNING FOR WEB SERVICE
################################################
function WebService() {
  clear
echo -e $cyan ""
echo ""
  echo -e $red " __      __      ___.       _________                  .__              ";
  echo "/  \    /  \ ____\_ |__    /   _____/ ______________  _|__| ____  ____  ";
  echo "\   \/\/   // __ \| __ \   \_____  \_/ __ \_  __ \  \/ /  |/ ___\/ __ \ ";
  echo " \        /\  ___/| \_\ \  /        \  ___/|  | \/\   /|  \  \__\  ___/ ";
  echo "  \__/\  /  \___  >___  / /_______  /\___  >__|    \_/ |__|\___  >___  >";
  echo -e $okegreen
  echo " -----------------------------------------------------------------------"
  echo ""
    echo -e $white"	[$okegreen"01"$white]$cyan  DETECTING WEB APPLICATION FIREWALLS  "
    echo -e $white"	[$okegreen"02"$white]$cyan  DETECTING POSSIBLE XST VULNERABILITIES "
    echo -e $white"	[$okegreen"03"$white]$cyan  DETECTING OPEN RELAYS "
    echo -e $white"	[$okegreen"04"$white]$cyan  DETECTING BACKDOOR SMTP SERVERS "
    echo -e $white"	[$okegreen"05"$white]$cyan  DETECTING CROSS SITE SCRIPTING VULNERABILITIES  "
    echo -e $white"	[$okegreen"06"$white]$cyan  ENUMERATING USERS IN AN SMTP SERVER "
    echo -e $white"	[$okegreen"07"$white]$cyan  DETECTING WEB SERVERS VULNERABLE TO SLOWLORIS DDOS  "
    echo -e $white"	[$okegreen"08"$white]$cyan  FINDING SQL INJECTION VULNERABILITIES  "
    echo -e $white"	[$okegreen"09"$white]$cyan  CHECK IP GEOLOCATION WITH NSE  "
    echo -e $white"	[$okegreen"10"$white]$cyan  GATHERING INFORMATION FROM WHOIS (NSE)  "
    echo -e $white"	[$okegreen"11"$white]$cyan  COLLECTING VALID EMAIL ADDRES  "
    echo -e $white"	[$okegreen"12"$white]$cyan  BACK  "
    echo -e " "
    echo -n -e $red'  \033[4mScreetsec@WebService:\033[0m>> '; tput sgr0 #insert your choice
    read Scanning
    if test $Scanning == '1'
      then
      echo
      echo -ne $okegreen " What is your IP Target or Host: " ; tput sgr0
      read ip
      $xterm --script firewall-bypass --script-args firewall-bypass.helper="ftp", firewall-bypass.targetport=22 $ip &
    elif test $Scanning == '2'
      then
      echo
      echo -ne $okegreen " What is your IP Target or Host: " ; tput sgr0
      read ip
      nmap -sS -sU -T4 -A -v $ip
      $xterm -p80 --script http-methods,http-trace --script-args http-methods.retest $ip &
    elif test $Scanning == '3'
      then
      echo
      echo -ne  $okegreen" What is your IP Target or Host: " ; tput sgr0
      read ip
      $xterm -sV --script smtp-open-relay -v $ip &
    elif test $Scanning == '4'
      then
      echo
      echo -ne  $okegreen" What is your IP Target or Host: "; tput sgr0
      read ip
      $xterm nmap -sn $ip
      echo -e ""
      $xterm -sV --script smtp-strangeport $ip &
    elif test $Scanning == '5'
      then
      echo
      echo -ne  $okegreen" What is your IP Target or Host: "; tput sgr0
      read ip
      $xterm -p80 --script http-phpself-xss,http-unsafe-output-escaping $ip &
    elif test $Scanning == '6'
      then
      echo
      echo -ne $okegreen " What is your IP Target or Host: "; tput sgr0
      read ip
      $xterm -p25 –script smtp-enum-users $ip &
    elif test $Scanning == '7'
      then
      echo
      echo -ne $okegreen " What is your IP Target or Host: " ; tput sgr0
      read ip
      $xterm -p80 --script http-slowloris --max-parallelism 300 $ip &
    elif test $Scanning == '8'
      then
      echo
      echo -ne $okegreen " What is your IP Target or Host: " ; tput sgr0
      read ip
      $xterm -p80 --script http-sql-injection $ip &
		elif test $Scanning == '9'
      then
      echo
      echo -ne $okegreen " What is your IP Target or Host: " ; tput sgr0
      read ip
      $xterm -Pn -p80 --script ip-geolocation-* $ip &
		elif test $Scanning == '10'
      then
      echo
      echo -ne $okegreen " What is your IP Target or Host: " ; tput sgr0
      read ip
      $xterm -sn --script whois-ip --script-args whois.whodb=nocache $ip &
		elif test $Scanning == '11'
      then
      echo
      echo -ne $okegreen " What is your IP Target or Host: " ; tput sgr0
      read ip
      $xterm -p80 --script http-google-email,http-email-harvest $ip &
    elif test $Scanning == '12'
      then
      menu
    else
        echo ""
        echo -e $okegreen " Incorrect Number"
      fi
      echo ""
      echo ""
      echo -n -e $red " Back to Last Menu? ( Yes / No ) :"
    read back
    if [ $back != 'n' ] && [ $back != 'N' ] && [ $back != 'no' ] && [ $back != 'No' ]
        then
        clear
        menu
    elif [ $back != 'y' ] && [ $back != 'Y' ] && [ $back != 'yes' ] && [ $back != 'Yes' ]
        then
        WebService
    fi
}


#######################################################
# CREDITS
#######################################################
function credits {
clear
echo -e "
\033[31m##########################################################################\033[m
		             Credits To
\033[31m##########################################################################\033[m"
echo
echo -e $white "Special thanks to:"
echo
echo -e $red "Dracos Linux ( www.dracos-linux.org )"
echo
echo -e $okegreen "Offensive Security for the awesome OS"
echo
echo -e $green "http://www.offensive-security.com/"
echo
echo -e $yellow "http://www.kali.org/"
echo
echo -e $cyan "http://www.kitploit.com/"
echo
echo -e $white "http://www.linuxsec.org/"
echo
echo -e $okegreen "My Friend for helpme ( Boy Suganda )"
echo
echo -e $red "Big Thanks to : http://www.github.com/"
echo

}

###################################################
# Function Menu
#####################################################
function menu() {
clear
echo -e $red ""
echo "             80G08        "
echo "                8G#G@8  "
echo "                  8##0  "
echo "                   0##G8    "
echo "                     ####08 "
echo "                      8#####8   "
echo "                        G#####8   "
echo "                         8G#####8   "
echo "      #8#########0         #######8   "
echo "          8#######0          0#88#####    "
echo "            8G####8         8 8#8@@8###   "
echo "               8###        G8   8@G######   "
echo "                8##88       8     8######8    "
echo "                  G##088          80G##G080   "
echo "                    88000000008880#      000    "
echo "                          9               0 "
echo -e $okegreen"       .___                     _______                         ";
echo "     __| _/___________    ____  \      \   _____ _____  ______  ";
echo "    / __ |\_  __ \__  \ _/ ___\ /   |   \ /     \\__  \ \____  \ ";
echo "   / /_/ | |  | \// __ \\  \___/     |    \  Y Y  \/ __ \|  |_> >";
echo "   \____ | |__|  (____  /\___  >____|__  /__|_|  (____  /   __/ ";
echo "        \/            \/     \/        \/      \/     \/|__|    ";
echo ""
echo -e $cyan"    Script by           $white":" $red Edo Maland ( Screetsec ) "
echo -e $cyan"    Version             $white":" $red $Version  "
echo -e $cyan"    Codename            $white":" $red $Codename "
echo -e $cyan"    Follow me on Github $white":" $red @Screetsec "
echo -e $cyan"    Dracos Linux        $white":" $red dracos-linux.org "
echo -e $cyan ""
echo -e $okegreen"    =========================================================    ";
		echo -e $white " "
		echo -e $white"	[$okegreen"01"$white]$cyan  REGULER SCAN "
    echo -e $white"	[$okegreen"02"$white]$cyan  SCAN MULTIPLE IP ADDRESS "
		echo -e $white"	[$okegreen"03"$white]$cyan  SCAN OS VERSION AND TRACEROUTE "
    echo -e $white"	[$okegreen"04"$white]$cyan  FIND OUT IF A HOST IS PROTECTED FIREWALL  "
		echo -e $white"	[$okegreen"05"$white]$cyan  EVADING FIREWALLS "
    echo -e $white"	[$okegreen"06"$white]$cyan  PING PING !!   "
    echo -e $white"	[$okegreen"07"$white]$cyan  WEB SERVICES"
		echo -e $white"	[$okegreen"08"$white]$cyan  NMAP SCRIPT ENGINE - ADVANCED   "
		echo -e $white"	[$okegreen"09"$white]$cyan  ADVANCED NMAP SCANNINGS ( ZENMAP COMMAND ) "
		echo -e $white"	[$okegreen"10"$white]$cyan  SCANNING TARGET WITH OUTPUT FILES"
		echo -e $white"	[$okegreen"11"$white]$cyan  CREDITS  "
		echo -e $white"	[$okegreen"12"$white]$cyan  EXIT  "
		echo -e " "
		echo -n -e $red'  \033[4mScreetsec@dracmap-v2:\033[0m '; tput sgr0 #insert your choice
		read Dracnmap
		if test $Dracnmap == '1'
      then
    echo -e $cyan""
    echo -ne "  What is your IP Target or Host: " ; tput sgr0
    read ip
    $xterm  $ip &

		elif test $Dracnmap == '2'
 			then
    echo ""
    echo -ne $okegreen"  What is your IP Target or Host (1): " ; tput sgr0
    read ip1
    echo ""
    echo -ne $okegreen " What is your IP Target or Host (2): " ; tput sgr0
    read ip2
    echo ""
    echo -ne $okegreen " What is your IP Target or Host (3): " ; tput sgr0
    read ip3
    echo ""
    $xterm  $ip1 $ip2 $ip3  &

		elif test $Dracnmap == '3'
			then
        echo -e $cyan""
        echo -ne "  What is your IP Target or Host: " ; tput sgr0
        read ip
        $xterm -sV -T4 -O -F --version-light 1  $ip &


		elif test $Dracnmap == '4'
			then
        echo -e $cyan""
        echo -ne "  What is your IP Target or Host: " ; tput sgr0
        read ip
        $xterm nmap -sA $ip &

		elif test $Dracnmap == '5'
			then
      echo -e $cyan""
      echo -ne "  What is your IP Target or Host: " ; tput sgr0
      read ip
			$xterm -sS -P0 $ip &

    elif test $Dracnmap == '6'
      then
      pingbebeb

		elif test $Dracnmap == '7'
			then
			WebService

		elif test $Dracnmap == '8'
 			then
 			nse

		elif test $Dracnmap == '9'
 			then
      zenmapscript

		elif test $Dracnmap == '10'
	     then
       scanoutput

		elif test $Dracnmap == '11'
 			then
      credits

    elif test $Dracnmap == '12'
      then
        clear
				sleep 1
				echo ""
				echo -e $yellow"[*] Thank You For Using Dracnmap  =)."
				echo ""
				echo -e $yellow"[*] Check Dracos Linux LFS, Penetration OS From Indonesia  =P."
        exit

 		else
			echo -e "  Incorrect Number"
			fi
			echo -n -e "  Do you want exit? ( Yes / No ) :"
			read back
			if [ $back != 'n' ] && [ $back != 'N' ] && [ $back != 'no' ] && [ $back != 'No' ]
					then
					clear
					exit
			elif [ $back != 'y' ] && [ $back != 'Y' ] && [ $back != 'yes' ] && [ $back != 'Yes' ]
					then
					menu
  fi

}

####################################################
# BANNER
####################################################
clear
echo -e $red ""
echo "             80G08        "
echo "                8G#G@8  "
echo "                  8##0  "
echo "                   0##G8    "
echo "                     ####08 "
echo "                      8#####8   "
echo "                        G#####8   "
echo "                         8G#####8   "
echo "      #8#########0         #######8   "
echo "          8#######0          0#88#####    "
echo "            8G####8         8 8#8@@8###   "
echo "               8###        G8   8@G######   "
echo "                8##88       8     8######8    "
echo "                  G##088          80G##G080   "
echo "                    88000000008880#      000    "
echo "                          9               0 "
echo -e $okegreen"       .___                     _______                         ";
echo "     __| _/___________    ____  \      \   _____ _____  ______  ";
echo "    / __ |\_  __ \__  \ _/ ___\ /   |   \ /     \\__  \ \____  \ ";
echo "   / /_/ | |  | \// __ \\  \___/     |    \  Y Y  \/ __ \|  |_> >";
echo "   \____ | |__|  (____  /\___  >____|__  /__|_|  (____  /   __/ ";
echo "        \/            \/     \/        \/      \/     \/|__|    ";
echo ""
echo -e $cyan"    Script by           $white":" $red Edo Maland ( Screetsec ) "
echo -e $cyan"    Version             $white":" $red $Version  "
echo -e $cyan"    Codename            $white":" $red $Codename "
echo -e $cyan"    Follow me on Github $white":" $red @Screetsec "
echo -e $cyan"    Dracos Linux        $white":" $red dracos-linux.org "
echo -e $cyan ""
echo -e $okegreen"    =========================================================    ";
		echo -e $white " "
		echo -e $white"	[$okegreen"01"$white]$cyan  REGULER SCAN "
    echo -e $white"	[$okegreen"02"$white]$cyan  SCAN MULTIPLE IP ADDRESS "
		echo -e $white"	[$okegreen"03"$white]$cyan  SCAN OS VERSION AND TRACEROUTE "
    echo -e $white"	[$okegreen"04"$white]$cyan  FIND OUT IF A HOST IS PROTECTED FIREWALL  "
		echo -e $white"	[$okegreen"05"$white]$cyan  EVADING FIREWALLS "
    echo -e $white"	[$okegreen"06"$white]$cyan  PING PING !!   "
    echo -e $white"	[$okegreen"07"$white]$cyan  WEB SERVICES"
		echo -e $white"	[$okegreen"08"$white]$cyan  NMAP SCRIPT ENGINE - ADVANCED   "
		echo -e $white"	[$okegreen"09"$white]$cyan  ADVANCED NMAP SCANNINGS ( ZENMAP COMMAND ) "
		echo -e $white"	[$okegreen"10"$white]$cyan  SCANNING TARGET WITH OUTPUT FILES"
		echo -e $white"	[$okegreen"11"$white]$cyan  CREDITS  "
		echo -e $white"	[$okegreen"12"$white]$cyan  EXIT  "
		echo -e " "
		echo -n -e $red'  \033[4mScreetsec@dracmap-v2:\033[0m '; tput sgr0 #insert your choice
		read Dracnmap
		if test $Dracnmap == '1'
      then
    echo -e $cyan""
    echo -ne "  What is your IP Target or Host: " ; tput sgr0
    read ip
    $xterm  $ip &

		elif test $Dracnmap == '2'
 			then
    echo ""
    echo -ne $okegreen"  What is your IP Target or Host (1): " ; tput sgr0
    read ip1
    echo ""
    echo -ne $okegreen " What is your IP Target or Host (2): " ; tput sgr0
    read ip2
    echo ""
    echo -ne $okegreen " What is your IP Target or Host (3): " ; tput sgr0
    read ip3
    echo ""
    $xterm  $ip1 $ip2 $ip3 &

		elif test $Dracnmap == '3'
			then
        echo -e $cyan""
        echo -ne "  What is your IP Target or Host: " ; tput sgr0
        read ip
        $xterm -sV -T4 -O -F --version-light 1  $ip &


		elif test $Dracnmap == '4'
			then
        echo -e $cyan""
        echo -ne "  What is your IP Target or Host: " ; tput sgr0
        read ip
        $xterm nmap -sA $ip &

		elif test $Dracnmap == '5'
			then
      echo -e $cyan""
      echo -ne "  What is your IP Target or Host: " ; tput sgr0
      read ip
			$xterm -sS -P0 $ip &

    elif test $Dracnmap == '6'
      then
      pingbebeb

		elif test $Dracnmap == '7'
			then
			WebService

		elif test $Dracnmap == '8'
 			then
 			nse

		elif test $Dracnmap == '9'
 			then
      zenmapscript

		elif test $Dracnmap == '10'
	     then
       scanoutput

		elif test $Dracnmap == '11'
 			then
      credits

    elif test $Dracnmap == '12'
      then
        clear
				sleep 1
				echo ""
				echo -e $yellow"[*] Thank You For Using Dracnmap  =)."
				echo ""
				echo -e $yellow"[*] Check Dracos Linux LFS, Penetration OS From Indonesia  =P."
        exit

 		else
			echo -e "  Incorrect Number"
			fi
			echo -n -e "  Do you want exit? ( Yes / No ) :"
			read back
			if [ $back != 'n' ] && [ $back != 'N' ] && [ $back != 'no' ] && [ $back != 'No' ]
					then
					clear
					exit
			elif [ $back != 'y' ] && [ $back != 'Y' ] && [ $back != 'yes' ] && [ $back != 'Yes' ]
					then
					menu
fi
