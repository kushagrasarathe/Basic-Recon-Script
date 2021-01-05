#!/bin/bash 

#Colors
white="\e[97m"
red="\e[31m"
green="\e[32m"
blue="\e[34m"
bold="\e[1m"


#Starting message
echo -e "  
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
██████╗  ██████╗██╗   ██╗ █████╗ ██╗  ██╗███████╗██████╗ ███████╗██╗	 ██╗ █████╗ 
██╔══██╗██╔════╝╚██╗ ██╔╝██╔══██╗██║  ██║██╔════╝██╔══██╗██╔════╝██║	 ██║██╔══██╗
██████╔╝╚█████╗  ╚████╔╝ ██║  ╚═╝███████║█████╗  ██║  ██║█████╗  ██║	 ██║██║  ╚═╝
██╔═══╝  ╚═══██╗  ╚██╔╝  ██║  ██╗██╔══██║██╔══╝  ██║  ██║██╔══╝  ██║	 ██║██║  ██╗
██║     ██████╔╝   ██║   ╚█████╔╝██║  ██║███████╗██████╔╝███████╗███████╗██║╚█████╔╝
╚═╝     ╚═════╝    ╚═╝    ╚════╝ ╚═╝  ╚═╝╚══════╝╚═════╝ ╚══════╝╚══════╝╚═╝ ╚════╝
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
"
printf "\nStarting tool...Please WAIT :)" 
sleep 1.5  # sleeping for 1.5 seconds

printf '\n'

#Reading entered domain
echo -e "${green}${bold}Enter domain to enumerate subdomains:- ${white}" ;
read domain ;

#Creating directories
if [ ! -d "$domain" ];then
	mkdir $domain
fi
if [ ! -d "$domain/gf" ];then
	mkdir $domain/gf
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

#running waybackurls and filtering the output
echo "[+] Collecting endpoints using waybackurls..."
echo "[+] Filtering the collected endpoints..."
cat $domain/alive.txt | waybackurls  | grep "=" | egrep -iv ".(jpg|js|jpeg|gif|css|tiff|tif|png|ttf|woff2|woff|ico|pdf|svg|txt)" > $domain/filtered.txt

#gathering gf patterns
echo "[+] Collecting gf patterns..."
cat $domain/filtered.txt | gf xss > $domain/gf/xss.txt 
cat $domain/filtered.txt | gf ssrf > $domain/gf/ssrf.txt 
cat $domain/filtered.txt | gf ssti > $domain/gf/ssti.txt 
cat $domain/filtered.txt | gf redirect > $domain/gf/redirect.txt 
cat $domain/filtered.txt | gf rce > $domain/gf/rce.txt 
cat $domain/filtered.txt | gf sqli > $domain/gf/sqli.txt 
cat $domain/filtered.txt | gf lfi > $domain/gf/lfi.txt 
cat $domain/filtered.txt | gf debug_logic > $domain/gf/debug_logic.txt 
cat $domain/filtered.txt | gf idor > $domain/gf/idor.txt 
cat $domain/filtered.txt | gf img-traversal > $domain/gf/img-traversal.txt 
cat $domain/filtered.txt | gf interestingparams > $domain/gf/interestingparams.txt 
cat $domain/filtered.txt | gf interestingsubs > $domain/gf/interestingsubs.txt 
