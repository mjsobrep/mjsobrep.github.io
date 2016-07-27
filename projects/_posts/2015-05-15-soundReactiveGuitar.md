---
layout: post
title:  "Sound Reactive Guitar"
date:   2015-05-15
categories: projects
imageDir: soundReactiveGuitar
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
thumb: "soundReactiveGuitar/WP_20150515_001.jpg"
summary: I helped a friend add frequency reactive lighting to some guitars which he was building
---
_Update: You can buy the guitars I was working on from [Gallo Guitars](http://www.gallo.guitars/)_

I met [Jose Gallo](http://www.josegallo.com/) at [The Engineer Guy](http://www.theengineerguy.com/). I was with my Senior Design team and was wearing a GT shirt. So he approached us and asked if any of us have experience with microcontrollers and electronics, which I do. He showed us a guitar he was working on which had LEDs within the body and asked if I could help him to make it react to the sound being played. I agreed to help him and got to work. I ended up using a Teensy microcontroller because of its very solid audio library. I set it up to perform an FFT and create a number of visualizations, selectable by a push button. In the end I was very pleased with the results and learned a good bit in the process. Jose was also pretty excited.

####Design
* [My electronics design](\otherFiles\projects\soundReactiveGuitar\electronics layout Rev 1.2.pdf)
* [My code](https://github.com/mjsobrep/soundReactiveGuitar)

<br/>

{% include iframe.html src="'https://www.youtube.com/embed/gcfAp47YGyA'" width=100 ratio=56.25 %}
{% include iframe.html src="'https://www.youtube.com/embed/jTJkhRjVaus'" width=100 ratio=56.25 %}
{% include iframe.html src="'https://www.youtube.com/embed/Xse8pVynuTU'" width=100 ratio=56.25 %}
{% include iframe.html src="'https://www.youtube.com/embed/qmZ0__i1iVQ'" width=50 ratio=177.7777777777778 %}
{% include iframe.html src="'https://www.youtube.com/embed/KpZX_1y0OSo'" width=100 ratio=56.25 %}
