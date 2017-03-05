---
layout: guide
title:  "PowerShell"
updated:   2017-02-20
categories: guides
tags:
- windows
- code
- programming
- powershell
- ps
---
* scoop -> to install stuff
* PSget -> to install stuff
* concfg -> to configure stuff
* chocolatey -> package manager
* PowerShellGallery-> to install stuff

## Setting up:
- Open administator powershell
- `Set-ExecutionPolicy RemoteSigned`
- `iwr https://chocolatey.org/install.ps1 -UseBasicParsing | iex`
- `choco install ConEmu`
- `choco install git`
- `choco install poshgit`
- `Install-Module -Name ZLocation`
- `choco install visualstudiocode`
- `choco install python3`
- `choco install python2`
- `choco install mingw`
- `choco install cmake`
- `choco install doxygen`
- `choco install miktex`
- `choco install texstudio`
- `choco install googlechrome`
- `choco install firefox`
- `choco install dropbox`   
- `choco install sumatrapdf`
- `choco install slack`

### some less useful stuff:
- `choco install gimp`
- `choco install inkscape` 
- `choco install wireshark`
- `choco install audacity`

#### Via PSget:
* PSColor : adds coloring
* [posh-git](https://github.com/dahlbyk/posh-git) -> to have git in powershell
* out-diff : for reading diff files from git
* <del>jump-location : for navigating about the file directory</del>

#### Via Scoop:
* vim
* git
* concfg : configuration
* openssh

#### Chocolatey

#### PowerShell Gallery
* [Z-Location](https://github.com/vors/ZLocation)

## Using SSH 
Once you have putty installed, just use the plink command. 

