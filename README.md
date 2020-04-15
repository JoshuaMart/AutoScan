# AutoScan
![Banner](https://zupimages.net/up/20/16/xkuf.png)![Maintenance](https://img.shields.io/badge/Maintained%3F-yes-green.svg) ![made-with-bash](https://img.shields.io/badge/Made%20with-Bash-1f425f.svg)  ![MIT license](https://img.shields.io/badge/License-MIT-blue.svg)

## Tools used
- [Nuclei](https://github.com/projectdiscovery/nuclei) : Configurable targeted scanning based on templates
- [Hakrawler](https://github.com/hakluke/hakrawler) : Simple, fast web crawler
- [ParamSpider](https://github.com/devanshbatham/ParamSpider) : Mining parameters from dark corners of Web Archives
- [Ffuf](https://github.com/ffuf/ffuf) : Discovery content (with some usage from [ffufplus](https://github.com/dark-warlord14/ffufplus)
- [JSScanner](https://github.com/dark-warlord14/JSScanner) : Scanning JS Files for Endpoints and Secrets

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
![Usage](https://zupimages.net/up/20/16/rf43.png)