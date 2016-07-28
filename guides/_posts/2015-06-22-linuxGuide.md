---
layout: guide
title:  "Linux"
updated:   2015-06-22
categories: guides
tags:
- linux
---

#### Restart Network System:
* `sudo service network-manager restart`

### Setup

#### GIT
* http://www.ubuntumanual.org/posts/393/how-to-setup-and-use-github-in-ubuntu

#### .bashrc

##### load posh git
`source ~/Documents/posh-git-sh/git-prompt.sh`
`PROMPT_COMMAND='__git_ps1 "\u@\h:\w" "\\\$ ";'$PROMPT_COMMAND`

##### load autojump
`. /usr/share/autojump/autojump.sh`
