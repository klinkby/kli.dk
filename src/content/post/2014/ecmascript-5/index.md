---
author: "@klinkby"
keywords:
- javascript
date: "2014-03-18T23:00:00Z"
description: ""
draft: false
slug: ecmascript-5
tags:
- javascript
title: EcmaScript 5
---


<span>Application development is changing: Whether they are PHP or ASP.NET, your server side controls are legacy. The
last couple of years the big buzz has been s</span><span>ingle page HTML5 apps running in the browser, and the
frameworks to help you build them have become much more mature and useful.</span>

The bold[ Atwood's law](http://blog.codinghorror.com/the-principle-of-least-power/)<span>states "Any application that
can be written in JavaScript, will eventually be wriitten in JavaScript" is no longer a far fetched
dream.</span><span>  
</span>

<span>With this blog post I'll give my 5 cent on practices when implementing JavaScript applications.</span>

## Standards

First of all: Java is to JavaScript what Ham is to Hamster.

While s<span>ome keywords are the same JavaScript is a dynamic interpreted language standardized by ECMA and ISO, Java
is a static compiled language maintained solely by Oracle Corporation.</span>

ECMAScript is the name of <span>standardized J</span><span>avaScript</span><span>. The latest version</span><span>5 was
revised in 2009 and is fully implemented by Firefox 4, Chrome 19, IE 10 (IE9 actually has all the language additions,
just does not handle strict, ahm strict). As of 2014 that includes more than 90% of the browsers in use.</span>

<span>That ultimately means that you can propably start using the new language feaures in your client side applications
today.</span>

<span>In the following I will present some pragmatic ideas that will help you build better applications in
JavaScript.</span>

## <span>Don't litter</span>

<span>When you write an application in C# (or whatever) you package your classes and modules in specific namespaces to
avoid name clashing by reducing scope and improve readability by ordering modules hierarchically. Still today I meet
many developers that think that doesn't apply to JavaScript so they happily define functions in the global
namespace.</span>

Well, it does.

The global namespace (this) in a browser is the window object that itself defines lots of members that allows you to
control the view and behavior of the browser. Make it a habit to always start your JavaScript files with the following:

```JS
 (function () {
    // your code goes here
 }()); 
 ```

It is a self invoking function, which means your code gets its own scope and will not litter all your variables and
methods in the global namespace.

<span>Of course when you build libraries, modules you will need to export members from your script so other modules can
use them. Add a single field e.g. named after your company, and build your namespace hierachy in there.</span>

The first line in the example below adds a new empty object to a field called acme on the window object. Think of this
as your own root namespace.

The second line adds a your new calculator object (that has an add method) to your acme object. And you can add all
kinds of advanced application modules in this way without every getting in conflict with 3rd party libraries.

```JS
 window.acme = window.acme || {}; window.acme.calculator = {
     add: function (a, b) {
        return a + b;
     }
 }; 
 ```

One of the worst examples of not doing this is SharePoint, that defines more than 2000 global members.

<span>You can check this by opening the browser dev console on</span> [ a SP site](http://www.wssdemo.com/) <span>and
run:</span>

```JS
 Object.keys(window).length 
 ```

As a consequence SharePoint
2010 [conflicts](http://blogs.msdn.com/b/carloshm/archive/2009/11/18/jquery-and-sharepoint-2010-javascript-conflict.aspx)
with even jQuery.

## Limit your flexibility

  <div>JavaScript is so extremely flexible it's absurd.</div>  <div>Just to name one, as default you don't have to declare any variables, which means if you mistype a variable name, the typing error simply declares the new field! Good luck finding that bug.</div>  

By adding the "use strict", to the top of your scope you intentionally restrict the language capabilities in that scope,
making it much easier to write secure code of higher quality. Any former Visual Basic coder will recognise the strict
option like [meeting an old friend](http://msdn.microsoft.com/en-us/library/zcd4xwzs.aspx).

```JS
 (function () {
    "use strict";
     // your quality code goes here
 }()); 
 ```

[This MDN article](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Functions_and_function_scope/Strict_mode?redirectlocale=en-US&redirectslug=JavaScript%2FReference%2FFunctions_and_function_scope%2FStrict_mode)
tells exactly what *use strict* does.<span>Tools like</span>[ JsLint](http://jslint.com/)<span>can analyse your code
against dogmas that prevents common mistakes in your code.</span>

<span>JavaScript-compilers like</span> [ CoffeeScript](http://coffeescript.org/) <span>
and</span> [ TypeScript](http://www.typescriptlang.org/)<span>languages are other examples of intentionally limiting
your flexibility within</span><span>JavaScript. But do think about it carefully before locking in to a new rarely used
vendor specific programming language. Personally I'm not a big fan of these, and see them as stepping stones towards the
upcoming ECMAScript 6.</span>

# <span>Equality</span>

  <div>Did you know in JavaScript the operators <code>==</code> and <code>!=</code> will perform implicit type conversions, which can lead to unexpected results?  
 </div>  

```JS
 1 != "1" // false  
 0 == ""  // true 
 ```

  <div>What you propably meant was to compares values without performing type conversion, i.e.<span> the operators <code>===</code> and !==</span> <span>so make it a habit to use those by default:</span></div>  <div> 

```JS
 1 !== "1" // false  
 0 === ""  // true 
 ```

 </div>  

## Polyfills

JavaScript was born back in 1995, and a lot of browsers have seen the light of day since then. Be very specific on what
browsers and versions you are going to support.

<span>Supporting old browsers is hard work and lots of workarounds. Time spent that could be otherwise invested in new
cool features for your app.</span>

A year ago jQuery released a [fork of itself that](http://blog.jquery.com/2013/04/18/jquery-2-0-released/) only supports
IE9 and newer browsers. T<span>he next version of popular AngularJS toolset
will [no longer support IE8](http://blog.angularjs.org/2013/12/angularjs-13-new-release-approaches.html), and three
months
ago [G](googleappsupdates.blogspot.com/2013/11/end-of-support-for-internet-explorer-9.html)</span><span>[oogle Apps dropped even IE9](http://jsperf.com/get-elements-by-class-name-vs-jquery/5)
in november 2013.</span>

<span>Should you decide to support old IEs, stop for a minute before you start implement</span> <span>all kinds of
browser specific workarounds throughout your code. Because JavaScript is dynamicaly typed you can simply add the missing
bits and pieces with so-called polyfills. For instance the Array.indexOf() method is missing from IE8,
but [this MDN reference article](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/indexOf)
has a snippet that adds it to the Array object. You will find sites that
collect [all kinds of polyfills](https://github.com/Modernizr/Modernizr/wiki/HTML5-Cross-browser-Polyfills) for legacy
browsers.</span><span></span>

## jQuery rehab

You can argue that jQuery is a polyfill. Among lots of other things, it's a very popular API for manilupating the DOM.
Though it saved me many hours of writing workaround for supporting old IE browsers, it's not an important component for
modern browsers as their DOM API all implement the W3 standard.

In fact if you always use jQuery instead of accessing the DOM directly your application performance will suffer by an
order of magnutude. You will propably never notice that on your development Core i7 workstation, but smartphones running
your web application will.<span>Here is an example:</span>

```JS
 $('.test') // jQuery version  
// vs  
document.getElementsByClassName('test') // DOM version 
```

The jQuery-version is around [90% slower](https://twitter.com/__DavidFlanagan "@__DavidFlanagan") that simply calling
getElementsByClassName.

<span>Of course jQuery has other cool tricks up it's sleeve than just copying DOM functions e.g. like $.Deferred() and
the amazing range of</span><span>available</span><span>plug-ins. So I'm not trying to argue that jQuery is evil,
b</span><span>ut do think about when it's necessary.</span> <span>Particularly if you include other frameworks like
AngularJS that already have many of jQuerys features built in.</span>

## Implementing objects

ECMAScript 5 adds some goodies to the Object object.

The following code shows a Vehicle base type that is inherited by the Car type. The *topSpeed* property defines a
getter. You no longer have to implement get_topSpeed(), it's built in.<span>The *color* property is like a standard
field which it can be set.</span>

<span>The Car type makes sure to call be base constructor, then adds the read-only property *brand*.</span>

<span>The line with *Object.create* is almost like callinng *new Vehicle*except it doesn't call the constructor, it just
sets Vehicle as the prototype. The new constructor is set in the line below.</span>

```JS
function Vehicle(topSpeed) {
     var topSpeed;
     Object.defineProperties(this, {
         "topSpeed": {
               get: function () {
                 return topSpeed + " km/h";
             }
         },
         "color": { writable: true }
     });
     this.drive = function () {
         console.log("I'm driving");
     }
 }
 function Car(topSpeed, brand) {
     Vehicle.call(this, topSpeed);
     Object.defineProperties(this, {
         "brand": { value: brand }
     }); 
 }
 Car.prototype = Object.create(Vehicle); 
 Car.prototype.constructor = Car;
 var c = new Car(250, "Porsche");
 c.color = "magenta";
 c.drive(); 
 ```

There are other many new helpful features in the ECMAScript 5 specification that you would expect to find in a
programming language today. See e.g [@__DavidFlanagan](https://twitter.com/__DavidFlanagan)'
s [JavaScript: The Definitive Guide](http://www.amazon.com/gp/product/B00IG2CS04/ref=as_li_qf_sp_asin_tl?ie=UTF8&camp=1789&creative=9325&creativeASIN=B00IG2CS04&linkCode=as2&tag=klinkby-20)
for an in depth coverage of the new language features.

## Inline scripts

Dont. Just don't.

And yes, that includes

```HTML
 <img onclick="pictureSelected()" src="funnyfeline.jpg" /> 
 ```

and

```HTML
 <a href="javascript:goOn()" class="acme-next">Next</a> 
 ```

Because you want the view to describe a document, not an interactive process. It's simply separation of concerns.<span>
Instead bind your event handlers from script by referenceing element class names:</span>

$(window).load(<span class="kwrd">function</span><span>() {</span>  <span>$(document.getElementsByClassName("
acme-next")).on("click", goOn); });</span>

One notable exception to this is if you use a two way databinding framework - read on...

## Databinding

<span>You have propably seen some ugly (jQuery-based?) JavaScript examples where every other line is like get value of
that dom element, and bind event handler to this and that element, toggle a class on that element. It's a bloddy
mess.</span>

<span>Any application that includes more than absolute basic UI-logic or view manipulation will benefit from using a
templating and databinding framework like</span> [ Knockout](http://knockoutjs.com/),[ Ember](http://emberjs.com/)
or[ AngularJS](http://www.angularjs.org/).<span>While the latter does a lot more, they all</span><span>provide is an
implementetion</span><span>of a</span>[ MVC](https://en.wikipedia.org/wiki/Model-view-controller)<span>or</span><span>
a</span>[ MVVM](https://en.wikipedia.org/wiki/Model_View_ViewModel)<span>pattern that</span> <span>essentially provide
the glue that separates the view (HTML) from the model (code).</span><span></span>

<span>A view template is written using a kind of augmented HTML markup. The following simple example shows a label and
an input field, and below that is a line of text that automatically will be updated by the framework as the user fills
in her name. The "name" value can be a field on your JavaScript object, as is the save() function.</span>

```HTML
 <div>
  <label>Enter your name:label>
  <input type="text" ng-model="name" />
 div>
 <div>Your name is {{name}}div>
 <input type="button" ng-click="save()" value="Save"  /> 
 ```

It may not seem like a big deal in this example. But the real power of this becomes apparent if underlying model is more
complex, event based, the view<span>may have a few sub-forms</span><span></span> <span>and need to load data
asynchronous from a server endpoint.</span>

<span>The code stays clean by never referencing anything in the DOM, while the view declaratively references named
values and events.</span>

<span>The frameworks listed above all have excellent introductions to get started.</span>

# Loading

<span>When your browser load a web page it parses the tags for external resources, top to bottom, and loads these using
the</span> <span>HTTP1.1 protocol, that prevents the browser from retrieving more than two resources simultaneous from
each web server. When the browser see a script element, that code must be loaded and executed before processing
continues. It's blocking.</span>

You can then add the defer" attribute to your script tags. It means it can load the script in the background and
postpone the execution until the DOM has been fully loaded (think $(document).ready()). Note that the browsers doesn't
agree on the execution order of deferred (inline) scripts.
  <div> 

<span>The optimal solution to add an "async" attribute to script tags, which will prevent the blocking, by telling the
browser it can load the script in the background and execute it whenever it like. You will gain the same effect by
including a script with a:</span>

```JS
document.write('<script type="text/javascript" src="foo.js"></script>');
```

  <div>If you have several scripts that loads, or your script uses the DOM you have a potential race condition. The scripts load out-of-order, and they may execute before the DOM is fully </div>  <div>loaded. So some synchronization is propably needed if you would like to take full advantage of async loading. <span>For example you add this to your html file:</span></div>  <div>  
 </div>   

```HTML
 <script src="lib/jquery.js" async />
 <script src="myapp.js" async />
 ```

  <div>You can be absolutely sure that jQuery will NOT be available every time your script executes.</div>  <div>To take care of that the<span> </span> [ asynchronous module definition](https://en.wikipedia.org/wiki/Asynchronous_Module_Definition)<span> </span> <span>(AMD) enables each javascript files to specify its dependencies, and a module loader like</span><span> </span> [ RequireJS](http://www.requirejs.org/)<span> </span> <span>will make sure they are executed in correct order. </span></div>  

## Epilogue

There are just so many aspects to building client side applications. I will save the whole resource sandbox and
cross-origin loading story for a future blog post.

This post got way too long anyway.  
<span>Sorry about that if you made it all the way.</span>
  <div>I hope you can use some of the tips.</div>  <div>  
 </div> </div>

