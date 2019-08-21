---
layout: guide
title:  "Javascript"
updated:   2015-06-22
categories: guides
tags:
- code
- programming
- javascript
- web development
---

* logging output: `console.log();`

## JSDoc cheat sheet
* `@author - author`
* `@method - put on the constructor`
* `@param - the arguments`
* `@returns - the returns`
* `@throws - what does this throw`
* `@version - the version`
* `@todo - things todo`

http://fabricjs.com/hovering/

`const ME = 0` //defines a constant variable

#### Literals:
* Array: `var coffees = ["French Roast", "Colombian", "Kona"];` // can have empty spots (best to do this with {undefined})
* Boolean: `var bob = true; var sue = false;`
* Int: (decimal: `105` -> no leading zero) (octal: `017` -> leading zero) (hex: `0x1DA7` -> leading 0x)
* Floating Point: must have `(num)(decimal)(num)` or `(num)(E(+/-)(num))`
* Object: `var car = { myCar: "Saturn", getCar: CarTypes("Honda"), special: Sales };`
* String: `autoboxing. use either "" or ''`

#### function pointers:
* `var square = function(number) {return number * number};`
* `var x = square(4)` //x gets the value 16
* could pass square as an argument

#### iterating:
* `array.forEach(function(args))`   //will call function for all args
* `array.forEach(function(args){function body})`
* classic `for(int i = 0;i<array.length;i++)`

#### Arrays:
* `pop()` //removes and returns last element
* `push()` //adds element to end and returns length
* `shift()` //removes and returns first element
* `unshift()` //adds element to the front and returns length

#### Comparator:
* `var sortFn = function(a, b){body}`
    * if a is less than b by the sorting system, return -1 (or any negative number)
    * if a is greater than b by the sorting system, return 1 (or any positive number)
    * if a and b are considered equivalent, return 0.
* `array.sort(sortFn);`

#### Inheritance:
{% highlight javascript %}
    function ClassName(args){
        SuperClassName.call(this,Superargs)
    }
{% endhighlight %}

## Working in Vim + React
Ale is used for most of this. Best practice for javascript seems to be to keep 
the linters and stuff defined with the project. So go to where your project is
(I am assuming that dependencies are handled by npm) and run: 
```bash
npm i -D eslint babel-eslint eslint-plugin-react prettier eslint-config-pretterier eslint-plugin-prettier
eslint --init
```
Then answer the questions. For React, I prefer to use:
- check syntax, find problems, enforce style
- javascript modules
- react
- browser
- pop style guide
- the airbnb style
- JSON

But all of those are usage specific. I like airbnb because I like semicolons and it
works with React. 

Make sure to add eslint to your ale fixers and linters in your vimrc, something like this:

```vim
let g:ale_fix_on_save = 1
let g:ale_fixers = {
            \ '*': ['remove_trailing_lines', 'trim_whitespace'],
            \ 'python': ['autopep8'],
            \ 'javascript': ['eslint'],
            \}
let g:ale_linters = {
            \'python':['flake','pylint'],
            \'latex':['alex','chktex','proselint','lacheck'],
            \'javascript': ['eslint'],
            \}
            
nmap <silent> <leader>a :ALENext<cr>
nmap <silent> <leader>A :ALEPrevious<cr>
let g:airline#extensions#ale#enabled = 1

let g:ale_echo_msg_format = '[%linter%] %s'
```
you can also see that I have a message format that shows where the linting is coming
from, the linter is shown in my airline toolbar, the fixers auto fix the document on 
save, and I have some shortcuts to jump through errors. 
