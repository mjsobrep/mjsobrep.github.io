---
layout: guide
title:  "Raspberry Pi"
updated:   2015-06-25
categories: guides
tags:
- raspberry pi
- RPi
- Pi
- code
- programming
- physical computing
---

[cool pinout](http://pi.gadgetoid.com/pinout/pin21_gpio9)

[Adafruit Guides](https://learn.adafruit.com/category/learn-raspberry-pi)

### SETUP AND ACCESS:
* [Setup WIFI](https://learn.adafruit.com/adafruits-raspberry-pi-lesson-3-network-setup/setting-up-wifi-with-occidentalis)
* [SSH](https://learn.adafruit.com/adafruits-raspberry-pi-lesson-6-using-ssh/overview)
* VNC:
    * Currently Running stuff:
        * `startx`
        * `x11vnc -display :0 -q`
    * New Desktop:
        `vncserver :1`

* Video Out:
    * [PAL/NTSC Setup](https://learn.adafruit.com/using-a-mini-pal-ntsc-display-with-a-raspberry-pi/configure-and-test)
    * [TFT](https://learn.adafruit.com/user-space-spi-tft-python-library-ili9341-2-8)
    * [Amazon Screen](http://www.amazon.com/review/R2SWCZHX0PXU3T/ref=cm_cr_dp_title?ie=UTF8&ASIN=B006MPRFJQ&nodeID=1077068&store=car)
{% highlight python %}
    /boot/config.txt settings for edge to edge beauty:
    sdtv_mode=0 #for NTSC
    sdtv_aspect=3 #for 16:9
    framebuffer_width=480
    framebuffer_height=272
    disable_overscan=1 #non-intuitive but the overscan_scale does the work
    overscan_scale=1 #currently undocumented but works
    overscan_left=16
    overscan_right=16
    overscan_top=8
    overscan_bottom=8
{% endhighlight %}



### GPIO:
* GPIO Setup:
    * WiringPi:
        * `git clone git://git.drogon.net/wiringPi`
        * `cd wiringPi`
        * `./build`
        * Python Wrappers:
            * `sudo apt-get install python-dev`
            * `sudo apt-get install python-setuptools`
            * `git clone https://github.com/Gadgetoid/WiringPi2-Python.git `
            * `cd WiringPi2-Python`
            * `sudo python setup.py install`
    * [ADC](https://learn.adafruit.com/reading-a-analog-in-and-controlling-audio-volume-with-the-raspberry-pi/script)
    * setup:
        * wire to pin and ground
        * Setup global mode:
            * `GPIO.setmode(GPIO.BCM)`
        * Setup Specific pin:
            * `GPIO.setup(14, GPIO.IN, GPIO.PUD_UP)`

#### [Screen Blanking](https://learn.adafruit.com/raspi-animated-gif-picture-frame/making-changes):

* `sudo nano /etc/kbd/config`
    * change: `BLANK_TIME=30`
    * to: `BLANK_TIME=0`

* `sudo nano /etc/X11/xinit/xinitrc`
    * after first line, add:
        * `xset s off`
        * `xset -dpms`
        * `xset s noblank`

* `sudo nano /etc/lightdm/lightdm.conf
    * `[SeatDefaults]`
    * `xserver-command=X -s 0 -dpms`

* `sudo nano /etc/xdg/lxsession/LXDE/autostart
    * `# @xscreensaver -no-splash` <-make it commmented out
        * add:
            * `@xset s off`
            * `@xset -dpms`
            * `@xset s noblank`

### Starting stuff at startup:
* [http://www.instructables.com/id/Raspberry-Pi-Launch-Python-script-on-startup/?ALLSTEPS](http://www.instructables.com/id/Raspberry-Pi-Launch-Python-script-on-startup/?ALLSTEPS)
* [http://www.raspberrypi.org/learning/tweeting-babbage/worksheet2/](http://www.raspberrypi.org/learning/tweeting-babbage/worksheet2/)

* Post XWindows Start:
    * EDIT: `/etc/xdg/lxsession/LXDE-pi/autostart`
        * at end add: `@/usr/bin/python /home/pi/...<file.py>`

    * To run as superuser:
        * EDIT: `/etc/xdg/lxsession/LXDE-pi/autostart`
            * at end add: `@/usr/bin/sudo /home/pi/...<file.py>`
        * EDIT: `<file.py>`
            * first line add: `#!/usr/bin/env python`
        * In terminal:
            * `sudo chmod +x <file.py>`

## Making images of SD card
Here is a great [guide to pulling the image and shrinking it](http://www.aoakley.com/articles/2015-10-09-resizing-sd-images.php)
