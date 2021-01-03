# Basic-Subdomain-Recon
This is a script made for beginners to automate the task of subdomain enumeration and basic recon.

# Installation
1. Clone this repo ```git clone https://github.com/kushagrasarathe/Basic-Subdomain-Recon.git```
2. Navigate to project folder ```cd Basic-Subdomain-Recon/```
3. Add execution permission ```sudo chmod +x script.sh```
4. Run the script ```./script.sh```

# Usage
Simply nagivate to project folder and type ```./script.sh``` 

# Features 
The script uses subfinder and assetfinder to enumerate subdomains, then httprobe collects all alive subdomains and then nmap is used to look for open ports. 
