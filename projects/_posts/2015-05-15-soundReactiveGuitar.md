---
layout: post
title:  "Sound Reactive Guitar"
date:   2015-05-15
categories: projects
tags:
- electronics
- electronics design
- electronics prototyping
- digital signal processing
- DSP
- microcontroller
- teensy
- LED
- music
- art
thumb: https://c6.staticflickr.com/9/8314/28565885061_b25d66ed81_n.jpg
summary: I helped a friend add frequency reactive lighting to some guitars which he was building
---
_Update: You can buy the guitars I was working on from [Gallo Guitars](http://www.gallo.guitars/)_

I met [Jose Gallo](http://www.josegallo.com/) at [The Engineer Guy](http://www.theengineerguy.com/). I was with my Senior Design team and was wearing a GT shirt. So he approached us and asked if any of us have experience with microcontrollers and electronics, which I do. He showed us a guitar he was working on which had LEDs within the body and asked if I could help him to make it react to the sound being played. I agreed to help him and got to work. I ended up using a Teensy microcontroller because of its very solid audio library. I set it up to perform an FFT and create a number of visualizations, selectable by a push button. In the end I was very pleased with the results and learned a good bit in the process. Jose was also pretty excited.

#### Design
* [My electronics design](\otherFiles\projects\soundReactiveGuitar\electronics layout Rev 1.2.pdf)
* [My code](https://github.com/mjsobrep/soundReactiveGuitar)

<br/>

{% include iframe.html src="'https://www.youtube.com/embed/gcfAp47YGyA'" width=100 ratio=56.25 %}
{% include iframe.html src="'https://www.youtube.com/embed/jTJkhRjVaus'" width=100 ratio=56.25 %}
{% include iframe.html src="'https://www.youtube.com/embed/Xse8pVynuTU'" width=100 ratio=56.25 %}
{% include iframe.html src="'https://www.youtube.com/embed/qmZ0__i1iVQ'" width=50 ratio=177.7777777777778 %}
{% include iframe.html src="'https://www.youtube.com/embed/KpZX_1y0OSo'" width=100 ratio=56.25 %}

{::nomarkdown}
{% include flickr.html
        src="https://www.flickr.com/photos/138686863@N06/albums/72157670919837312"
        title="sound reactive guitar"
        img="https://c8.staticflickr.com/9/8857/28028214663_0cf1fce1b7_z.jpg"
        width=640
        height=360
        %}
{:/nomarkdown}

