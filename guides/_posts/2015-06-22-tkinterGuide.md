---
layout: guide
title:  "Tkinter"
updated:   2015-06-25
categories: guides
tags:
- python
- code
- programming
- gui
- tkinter
- tk
---
### STARTUP:
* `from Tkinter import *`
* `import ttk`
* `root = Tk()`

### WIDGETS:
* instantiation:
    * `button = ttk.Button(<parent>, text = '<some text>')`
    * `label = ttk.label(<parent>, text = '<some text>')`
* adding:
    * `button.pack()`
* changing values:
    * `button['text'] = '<some text>'`
    * `button.config(text = '<some text>')`
* viewing configuration options:
    * `button.config()`
* Geometry Mgmnt:
    * Pack -> you left, right, blah
    * Grid -> its a gird
    * Place -> absolute positioning
* Deleting:
    * `<widget>.destroy()`

* EVENT HANDLERS:
    * command callbacks -> for obvious stuff
    * event bindings -> for custom stuff

### windows:
* zoom to max:
    * `window.state('zoomed')`
* configuration:
    * `root.config(background = 'black')`

* Text Display:
    * text widget

### CANVAS:
* `canvas = Canvas(<parent>)`
* `canvas.config(width = <>, height = <>)`
* `line = canvas.create_line(<x1>,<y1>,<x2>,<y2>,fill = '<color>',width = <width>)`
* `canvas.itemconfigure(line, fill='<color>')`
* `canvas.coords(line)`
* CAN BE POLYLINE::
    * `canvas.coords(line,<x1>,<y1>,<x2>,<y2>,<x3>,<y3>,<x4>,<y4>)`
    * smmoth:
        * `canvas.itemconfigure(line, smooth = True)`
        * `canvas.itemconfigure(line,splinesteps = <numsteps>)`
* Delete items:
    * `canvas.delete(<item>)`
    * `canvas.delete(all)`
* `rect = canvas.create_rectangle(<x1>,<y1>,<x2>,<y2>)`
* `oval = canvas.create_oval(<x1>,<y1>,<x2>,<y2>)`
* `arc = canvas.create_arc(<x1>,<y1>,<x2>,<y2>)`
* `text = canvs.create_text(<x1>,<y1>, text = '<text>',font = (<name>,<fontsize>,<bold>))`
* changing order:
    * `canvas.lift(<item>)`
    * `canvas.lower(<item>)`
* adding a widget:
    * `canvas.create_window(<x1>,<y1>,window = <widget>)`
* TAGS:
    * `canvas.itemconfigure(<item>,tag=(<tag1>,<o: other tags>))`
    * `canvas.gettags(<item>)`

### STYLES:
* `<item>.winfo_class() <-returns style`
* `style.configure('<stylename>',<paramater>=<val>)`
* new style: `
    * `style.configure('<newname>.<inherit>',<paramater>=<val> )`
* `<item>.config(style = '<style>')`
* `style.layout('<style>')`
* `style.lookup('<style>','<property>')`


[a nice resource](http://effbot.org/tkinterbook/widget.htm)
