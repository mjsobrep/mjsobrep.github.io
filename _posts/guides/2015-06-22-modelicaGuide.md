---
layout: guide
title:  "Modelica"
date:   2015-06-25
categories: guides
tags:
- modelica
- code
- programming
- modeling
---

* Evaluate Cell: shift+enter
* Insert Input Cell: Ctrl+Shift+I
* Insert New Cell of type above: Alt+Enter

####Identifier:
* constant
* input
* output

####Assignment: done via `:=`

####Equation: done via `=` 

###Variables:
* Base Types:
    * `Integer`
    * `Real(unit = "<unit>" ~ opt, min = <min> ~ opt, max = <max> ~ opt)`
    * `Boolean`

* Variability:
    * constant - never changes
    * parameter - changes between simulations
    * discrete - changes on events

* Starting Value:
    * `<type> <var>(start = <val>);`

* Visibility:
    * `public`
    * `protected`

    * treated as headers, all variables after a visibility statement and before another control statement will have that visibility 


###Libraries:
* loadModel(<library>);
* Standard Library: Modelica

###Classes:
Nested (local) classes are allowed

* Special words to replace "class":
    * `model`: intended for models; cannot be used for connections
    * `record`: intended for data structures; cannot have equations, cannot be used for connections
    * `type`: intended to introduce new types; must extend another type, record, or be an array
    * `connector`: defines connections; no equations
    * `block`: data flow of variables is known; all variables must be declared with "input" or "output" * followed by a type or class; no connections
    * `function`: defines inputs and outputs, no equation, exactly one algorithm(`<output var>:=<computation>`)
        * `calling`: <function name>(<input1>,...)
* Define:
    * `class <classname>`
        * public
            * `parameter <type> <var> = <val ~ opt>;`
    * end `<classname - to instantiate>`;

    * `type <classname> = <sourceClass to instantiate>`

* Container Classes:
    * `class <container classname>`
        * `<contained classname> <thisname>(<paramater ~ opt>=<val>,...);`
    * end `<container classname>`

* Drilling Down:
    * `<classname>.<classname...>.<parameter>`
    * `<classname>(<paramater1>,<paramater2>,...)`

* View flattened class:
    * `instantiateModel(<class>)`

* Inheritance:
    * `class <name>`
        * `extends <super>;`
    ...Standard class stuff

* Generics:
    * prefix type with keyword : "replaceable" :: `replaceable <type> <name>;`
    * Declaring:
        * `class <name> = <c lass type>(redeclare <type> <name>,...)`

* Partial Classes:
    * may be extended, but not instantiated
    * `partial class <classname>`

* Package:
    * Organizes classes of all types and constants
{% highlight modelica %}
    package <name>
        <stuff>
    end <name>;
{% endhighlight %}
* if importing other packages, prevent conflicts by using encapsulated package:
{% highlight modelica %}
    encapsulated package <PackageName>
        import <import>
        ...
    end <PackageName>;
{% endhighlight %}

    * `import <packageName>;`
    * `import <alias>=<packageName>;`

* Simulation:
    * `simulate(<class>)`   

* Visualization:
    * Plot:
        * `plot(<args>)`

* Arrays:
    * Declaration:
        * `<type>[<dim1,...>] <name>;`
        * OR
        * `<type> <name>[<dim1,...>];`

        * Can initialize with declaration:
            * `<type>[<dim1,...>] <name> = {x,y,z};`
            * OR
            * `<type> <name>[<dim1,...>] = \{\{x,y\},\{f,g\}\};`

    * Multiplication:
        * `*`
        * is element wise

* Matrices:
    * Declaration:
        * `<type> <name>[<dim1,...>] = [<v>,<v>;...];`
    * Multiplication:
        * `*`
        * `is matrix multiplication`

* Algorithms:
    * start with keyword "algorithm"
    * are the only place where traditional procedural command flow exists:
{% highlight modelica %}
        while <bool> loop
            <body>
        end while;
{% endhighlight %}

{% highlight modelica %}
        if <bool> then
            <body>
        elseif <bool> then
            <body>
        else
            <body>
        end if;
{% endhighlight %}

* `reinit(<var>,<new val>)` : reinitializes variable, useful in while loop
