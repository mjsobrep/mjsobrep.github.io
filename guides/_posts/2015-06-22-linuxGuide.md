---
layout: guide
title:  "Linux"
updated:   2017-05-03
categories: guides
tags:
- linux
---

## Useful Snippets

#### Restart Network System:
* `sudo service network-manager restart`

## Setup

### GIT
* http://www.ubuntumanual.org/posts/393/how-to-setup-and-use-github-in-ubuntu

### .bashrc

#### load virtualenv stuff

{% highlight bash %}
# virtualenv and virtualenvwrapper
export WORKON_HOME=$HOME/.virtualenvs
source /usr/local/bin/virtualenvwrapper.sh
{% endhighlight %}

#### load posh git
{% highlight bash %}
NC='\033[0m' # No Color

# Regular Colors
Black='\033[0;30m'        # Black
Red='\033[0;31m'          # Red
Green='\033[0;32m'        # Green
Yellow='\033[0;33m'       # Yellow
Blue='\033[0;34m'         # Blue
Purple='\033[0;35m'       # Purple
Cyan='\033[0;36m'         # Cyan
White='\033[0;37m'        # White

source ~/Dropbox/ConfigFiles/Linux/posh-git/git-prompt.sh
PROMPT_COMMAND='__posh_git_ps1 "\u@\h:\w" "${Cyan}`basename \"$VIRTUAL_ENV\"`${NC}\\\$ ";'$PROMPT_COMMAND
{% endhighlight %}

#### load autojump
`. /usr/share/autojump/autojump.sh`
