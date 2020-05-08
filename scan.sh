## VARIABLES
ResultsPath="/root/Recon/Scan"
ToolsPath="/root/Tools"

FfufDiscoveryWordlist="/root/Tools/Wordlists/dicc.txt"

## FUNCTION
die() {
    printf '%s\n' "$1" >&2
    exit 1
}

help() {
  banner
  echo -e "Usage : ./recon.sh -d domain.tld
      -d  | --domain      (required) : Domain in domain.tld format
  "
}

banner() {
  echo -e "
█████╗ ██╗   ██╗████████╗ ██████╗ ███████╗ ██████╗ █████╗ ███╗   ██╗
██╔══██╗██║   ██║╚══██╔══╝██╔═══██╗██╔════╝██╔════╝██╔══██╗████╗  ██║
███████║██║   ██║   ██║   ██║   ██║███████╗██║     ███████║██╔██╗ ██║
██╔══██║██║   ██║   ██║   ██║   ██║╚════██║██║     ██╔══██║██║╚██╗██║
██║  ██║╚██████╔╝   ██║   ╚██████╔╝███████║╚██████╗██║  ██║██║ ╚████║
╚═╝  ╚═╝ ╚═════╝    ╚═╝    ╚═════╝ ╚══════╝ ╚═════╝╚═╝  ╚═╝╚═╝  ╚═══╝
 "
}

scan() {
  banner
  
	echo -e "Scan is in \e[31mprogress\e[0m, take a coffee"

	## Nuclei
	echo -e ">> \e[36mNuclei\e[0m is in progress"
	echo -e $domain | httprobe -p http:81 -p https:81 -p https:8443 -p http:8080 -p https:8080 > $ResultsPath/$domain/httprobe.txt
  nuclei -l $ResultsPath/$domain/httprobe.txt -t "$ToolsPath/nuclei-templates/all/*.yaml" -o $ResultsPath/$domain/nuclei.txt > /dev/null 2>&1

	## Hawkraler
	echo -e ">> \e[36mHakrawler\e[0m is in progress"
	echo -e $domain | hakrawler -forms -js -linkfinder -plain -robots -sitemap -usewayback -outdir $ResultsPath/$domain/hakrawler | kxss >> $ResultsPath/$domain/kxss.txt

	## ParamSpider
	echo -e ">> \e[36mParamSpider\e[0m is in progress"
	cd $ToolsPath/ParamSpider/
	python3 paramspider.py --domain $domain --exclude woff,css,js,png,svg,jpg -o paramspider.txt > /dev/null 2>&1
	mv ./output/paramspider.txt $ResultsPath/$domain/

  ## GF
  echo -e ">> \e[36mGF\e[0m is in progress"
  mkdir $ResultsPath/$domain/GF

	echo -e "\n\n=== GF XSS ===" >> $ResultsPath/$domain/gf.txt
	gf xss $ResultsPath/$domain/paramspider.txt >> $ResultsPath/$domain/GF/xss.txt

	echo -e "\n\n=== GF POTENTIAL ===" >> $ResultsPath/$domain/gf.txt
	gf potential $ResultsPath/$domain/paramspider.txt >> $ResultsPath/$domain/GF/potential.txt

  echo -e "\n\n=== GF DEBUG_LOGIC ===" >> $ResultsPath/$domain/gf.txt
  gf debug_logic $ResultsPath/$domain/paramspider.txt >> $ResultsPath/$domain/GF/debug_logic.txt

  echo -e "\n\n=== GF IDOR ===" >> $ResultsPath/$domain/gf.txt
  gf idor $ResultsPath/$domain/paramspider.txt >> $ResultsPath/$domain/GF/idor.txt

  echo -e "\n\n=== GF LFI ===" >> $ResultsPath/$domain/gf.txt
  gf lfi $ResultsPath/$domain/paramspider.txt >> $ResultsPath/$domain/GF/lfi.txt

  echo -e "\n\n=== GF RCE ===" >> $ResultsPath/$domain/gf.txt
  gf rce $ResultsPath/$domain/paramspider.txt >> $ResultsPath/$domain/GF/rce.txt

  echo -e "\n\n=== GF Redirect ===" >> $ResultsPath/$domain/gf.txt
  gf redirect $ResultsPath/$domain/paramspider.txt >> $ResultsPath/$domain/GF/redirect.txt

  echo -e "\n\n=== GF SQLI ===" >> $ResultsPath/$domain/gf.txt
  gf sqli $ResultsPath/$domain/paramspider.txt >> $ResultsPath/$domain/GF/sqli.txt

  echo -e "\n\n=== GF SSRF ===" >> $ResultsPath/$domain/gf.txt
  gf ssrf $ResultsPath/$domain/paramspider.txt >> $ResultsPath/$domain/GF/ssrf.txt

  echo -e "\n\n=== GF SSTI ===" >> $ResultsPath/$domain/gf.txt
  gf ssti $ResultsPath/$domain/paramspider.txt >> $ResultsPath/$domain/GF/ssti.txt

	## Ffuf Discovery
	echo -e ">> \e[36mFfuf\e[0m is in progress"
	ffuf -mc all -c -H "X-Forwarded-For: 127.0.0.1" -H "User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:72.0) Gecko/20100101 Firefox/72.0" -u "https://$domain/FUZZ" -w $FfufDiscoveryWordlist -D -e js,php,bak,txt,asp,aspx,jsp,html,zip,jar,sql,json,old,gz,shtml,log,swp,yaml,yml,config,save,rsa,ppk -ac -o $ResultsPath/$domain/result_dir.tmp > /dev/null 2>&1
	cat $ResultsPath/$domain/result_dir.tmp | jq '[.results[]|{status: .status, length: .length, url: .url}]' | grep -oP "status\":\s(\d{3})|length\":\s(\d{1,7})|url\":\s\"(http[s]?:\/\/.*?)\"" | paste -d' ' - - - | awk '{print $2" "$4" "$6}' | sed 's/\"//g' > $ResultsPath/$domain/ffuf_discovery.txt
	rm $ResultsPath/$domain/result_dir.tmp

	## JSScanner
	echo -e ">> \e[36mJSScanner\e[0m is in progress"
	echo -e "https://$domain" > $ToolsPath/JSScanner/alive.txt
	cd $ToolsPath/JSScanner/
  bash script.sh > /dev/null 2>&1
	mkdir $ResultsPath/$domain/JSScanner
	mv js $ResultsPath/$domain/JSScanner/ && mv db $ResultsPath/$domain/JSScanner/

	echo -e "=========== Scan is \e[32mfinish\e[0m ==========="
}

while :; do
    case $1 in
        -h|-\?|--help)
            help
            exit
            ;;
        -d|--domain)
            if [ "$2" ]; then
                domain=$2
                shift
            else
                die 'ERROR: "--domain" requires a non-empty option argument.'
            fi
            ;;
        --domain=)
            die 'ERROR: "--domain" requires a non-empty option argument.'
            ;;
        --)
            shift
            break
            ;;
        -?*)
            printf 'WARN: Unknown option (ignored): %s\n' "$1" >&2
            ;;
        *)
            break
    esac

    shift
done

if [ -z "$domain" ]
then
  help
  die 'ERROR: "--domain" requires a non-empty option argument.'
else
  if [ ! -d "$ResultsPath/$domain" ];then
    mkdir -p $ResultsPath/$domain
  fi
  scan
fi