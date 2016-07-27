---
layout: guide
title:  "Jekyll"
updated:   2015-06-25
categories: guides
tags:
- blogging
- jekyll
- code
- programming
- web development
---


####_config.yml:
* encoding: utf-8
* highlighter: pygments

###Building:
* on windows:
    * may need jekyll serve --force_polling
    * if all goes to hell: jekyll serve --no-watch
* jekyll build
* jekyll build --watch
* jekyll build -w
* jekyll serve
* jekyll serve --watch
* jekyll serve -w

####change console encoding:
* chcp 65001

###My Publishing Script:
This is done in powershell. I work on my working branch.
{% highlight powershell %}Function publishmichaelsobrepera{
    cd /;
    cd C:\;
    cd C:\GIT\mjsStaticSite;
    git checkout master;
    git reset --hard working;
    jekyll build;
    Get-ChildItem C:\GIT\mjsStaticSite -Exclude _site -Recurse | Where {$_ -notlike 'C:\GIT\mjsStaticSite\_site\*'} | select -ExpandProperty FullName | sort Length -Descending | Remove-Item -force;
    xcopy C:\GIT\mjsStaticSite\_site C:\GIT\mjsStaticSite /v /s /e ;
    Get-ChildItem C:\GIT\mjsStaticSite\_site -Recurse | select -ExpandProperty FullName | sort Length -Descending | Remove-Item -Force;
    Remove-Item C:\GIT\mjsStaticSite\_site -Force;
    git add *;
    git commit -a -m 'automated commit to publish';
    git push gitHub master --force;
    git checkout working;
}{% endhighlight %}

[liquld](https://docs.shopify.com/themes/liquid-documentation/basics)  

[Liquid Cheat Sheet](http://cheat.markdunkley.com/)
