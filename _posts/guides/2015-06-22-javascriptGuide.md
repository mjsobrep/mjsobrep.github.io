---
layout: guide
title:  "Javascript"
date:   2015-06-22
categories: guides
tags:
- code
- programming
- javascript
- web development
---

* logging output: `console.log();`

##JSDoc cheat sheet
* `@author - author`
* `@method - put on the constructor`
* `@param - the arguments`
* `@returns - the returns`
* `@throws - what does this throw`
* `@version - the version`
* `@todo - things todo`

http://fabricjs.com/hovering/

`const ME = 0` //defines a constant variable

####Literals:
* Array: `var coffees = ["French Roast", "Colombian", "Kona"];` // can have empty spots (best to do this with {undefined})
* Boolean: `var bob = true; var sue = false;`
* Int: (decimal: `105` -> no leading zero) (octal: `017` -> leading zero) (hex: `0x1DA7` -> leading 0x)
* Floating Point: must have `(num)(decimal)(num)` or `(num)(E(+/-)(num))`
* Object: `var car = { myCar: "Saturn", getCar: CarTypes("Honda"), special: Sales };`
* String: `autoboxing. use either "" or ''`

####function pointers:
* `var square = function(number) {return number * number};`
* `var x = square(4)` //x gets the value 16
* could pass square as an argument

####iterating:
* `array.forEach(function(args))`   //will call function for all args
* `array.forEach(function(args){function body})`
* classic `for(int i = 0;i<array.length;i++)`

####Arrays:
* `pop()` //removes and returns last element
* `push()` //adds element to end and returns length
* `shift()` //removes and returns first element
* `unshift()` //adds element to the front and returns length

####Comparator:
* `var sortFn = function(a, b){body}`
    * if a is less than b by the sorting system, return -1 (or any negative number)
    * if a is greater than b by the sorting system, return 1 (or any positive number)
    * if a and b are considered equivalent, return 0.
* `array.sort(sortFn);`

####Inheritance:
{% highlight javascript %}
    function ClassName(args){
        SuperClassName.call(this,Superargs)
    }
{% endhighlight %}
