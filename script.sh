#!/bin/bash 

#Colors
white="\e[97m"
red="\e[31m"
green="\e[32m"
blue="\e[34m"
bold="\e[1m"


#Starting message
echo -e "  
██████╗░░██████╗██╗░░░██╗░█████╗░██╗░░██╗███████╗██████╗░███████╗██╗░░░░░██╗░█████╗░
██╔══██╗██╔════╝╚██╗░██╔╝██╔══██╗██║░░██║██╔════╝██╔══██╗██╔════╝██║░░░░░██║██╔══██╗
██████╔╝╚█████╗░░╚████╔╝░██║░░╚═╝███████║█████╗░░██║░░██║█████╗░░██║░░░░░██║██║░░╚═╝
██╔═══╝░░╚═══██╗░░╚██╔╝░░██║░░██╗██╔══██║██╔══╝░░██║░░██║██╔══╝░░██║░░░░░██║██║░░██╗
██║░░░░░██████╔╝░░░██║░░░╚█████╔╝██║░░██║███████╗██████╔╝███████╗███████╗██║╚█████╔╝
╚═╝░░░░░╚═════╝░░░░╚═╝░░░░╚════╝░╚═╝░░╚═╝╚══════╝╚═════╝░╚══════╝╚══════╝╚═╝░╚════╝░
"
printf "\nStarting tool...Please WAIT :)" 
sleep 3  # sleeping for 3 seconds

printf '\n'

#Reading entered domain
echo -e "${green}${bold}Enter domain to enumerate subdomains:- ${white}" ;
read domain ;

#Creating directory
if [ ! -d "${domain}" ];then
	mkdir $domain
fi

#using assetfinder
echo -e "${blue}[+] Harvesting using assetfinder..." ;
assetfinder --subs-only  ${domain} >  $domain/assets.txt; 

#using subfinder
echo -e "[+] Harvesting using subfinder..." ;
subfinder -silent -d ${domain} > $domain/subfinder.txt; 

#combining results
cat $domain/assets.txt $domain/subfinder.txt > $domain/temp.txt
sort -u $domain/temp.txt > $domain/final.txt
rm $domain/temp.txt

#fetching alive domains
echo "[+] Gathering alive domains..."
cat $domain/final.txt | httprobe > $domain/alive.txt

#scanning for posts using nmap
echo -e "[+] Scanning for open ports..."
nmap -iL $domain/alive.txt -T4 -oA $domain/scanned.txt