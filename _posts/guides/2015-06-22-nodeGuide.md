---
layout: guide
title:  "Node"
date:   2015-06-22
categories: guides
---

Node Cheat Sheet

Arguments:
	args = process.argv;

Loading Global Libraries:
	var <lib> = require('<lib>');

syncronous file I/O:
	uses fs library:
	<buffer>=readFileSync(<path>);
	Buffer:
		<string>=<buffer>.toString();