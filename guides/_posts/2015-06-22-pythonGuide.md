---
layout: guide
title:  "Python"
updated:   2015-06-25
categories: guides
tags:
- python
- code
- programming
---
###debug:
* `import pdb`
* breakpoint : `pdb.set_trace()`
* step in : s
* step over : n
* return out of function : r
* next breakpoint : c

###LAMBDA:
{% highlight python %}
>>>g = lambda x: x*2  1
>>>g(3)
6
>>>(lambda x: x*2)(3) 2
6
{% endhighlight %}

####INSTALL SETUP TOOLS:
* IN POWERSHELL : `(Invoke-WebRequest https://bootstrap.pypa.io/ez_setup.py).Content | python -`

####INSTALL PACKAGES:
* PackageManager (PIP): `sudo apt-get install python-pip`
* Serial: `pip install pyserial`
