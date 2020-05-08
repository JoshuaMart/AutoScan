# AutoScan
![Banner](https://zupimages.net/up/20/16/xkuf.png)![Maintenance](https://img.shields.io/badge/Maintained%3F-yes-green.svg) ![made-with-bash](https://img.shields.io/badge/Made%20with-Bash-1f425f.svg)  ![MIT license](https://img.shields.io/badge/License-MIT-blue.svg)

## Tools used
- [Httprobe](https://github.com/tomnomnom/httprobe) : Take a list of domains and probe for working HTTP and HTTPS servers
- [Nuclei](https://github.com/projectdiscovery/nuclei) : Configurable targeted scanning based on templates
- [Hakrawler](https://github.com/hakluke/hakrawler) : Simple, fast web crawler
- [ParamSpider](https://github.com/devanshbatham/ParamSpider) : Mining parameters from dark corners of Web Archives
- [Gf](https://github.com/tomnomnom/gf) : A wrapper around grep, to help you grep for things
	- With somes GF profiles from [Gf-Patterns](https://github.com/1ndianl33t/Gf-Patterns) and [ParamSpider](https://github.com/devanshbatham/ParamSpider/tree/master/gf_profiles)
- [Ffuf](https://github.com/ffuf/ffuf) : Discovery content (with some usage from [ffufplus](https://github.com/dark-warlord14/ffufplus)
- [JSScanner](https://github.com/dark-warlord14/JSScanner) : Scanning JS Files for Endpoints and Secrets

![Workflow](https://zupimages.net/up/20/19/t490.png)

## Installation
- Installation & Recon tested on Debian 10

Run installer :
```bash
./install.sh
```

## Usage

```bash
./scan.sh -d domain.tld
```
![Usage](https://zupimages.net/up/20/19/ep9p.png)