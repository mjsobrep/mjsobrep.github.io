---
layout: guide
title:  "Node"
updated:   2015-06-25
categories: guides
tags:
- web development
- code
- programming
- node
- javascript
---

####Arguments:
* `args = process.argv;`

####Loading Global Libraries:
* `var <lib> = require('<lib>');`

###syncronous file I/O:
* uses fs library:
* `<buffer>=readFileSync(<path>);`
* Buffer:
    * `<string>=<buffer>.toString();`
