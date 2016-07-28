---
layout: post
title:  "Distraction Tester"
date:   2014-12-01
categories: projects
tags:
- code
- javascript
- firebase
- web
- games
- testing
- no-sql
summary: A system I made to test the effects of distractions on a person's reaction time
---
For the instrumentation lab within BME at Georgia Tech, for our final project, we were required to use game hardware to design a test of some sort. My team (Maria Diaz Ortiz, Kelsey Roberts, Gabby Nortey) and I decided to use a regular computer (that is after all one of the top most used pieces of gaming hardware, I would guess second to the smart phone). We decided to make a game to test peoples reaction times with various other present distractions. The inspiration for this was lights changing color in traffic, while driving. This could represent stop lights, break lights, or some other form of indicators. Often times when driving there are many distractors in the environment, and we were curious to see how the number of distractors would affect the response time of a subject to a notification of importance.  


##Test
I handled the design and development of the testing system. I used a firebase backend to capture all of the data and wrote the test in javascript. You can take a look at the game/test and play through it as well as view the data here:

####[distraction tester](https://3110.firebaseapp.com/)

##Paper
We wrote a [paper]({% post_url 2014-12-01-distractionTester-paper %}) summarizing our results.

##Video
We also had to make a video introduction for our project. You can take a look at it here:
{% include iframe.html src="'https://www.youtube.com/embed/BX06rBJEyDU'" width=100 ratio=56.25 %}
