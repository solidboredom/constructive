
#constructive library/framework for opensccad
A dialect of OpenScad more suitable for complex models,
with many new features. It has been in continous use by myself for few years now.

Compiles directly by OpenScad. No other tools needed. Just include constructive-compiled.scad
in your file that is all.

![screeen](/mount.gif)

still work in progress but very usable and imho essential
see Examples mount-demo.scad for how to use it.
another Example is pulley-demo.scad:
![screeen](/pulley.gif)
The Constructive Library (about 1900 lines of Code) 

it takes a different approach to OpenScad Syntax: you rarely need difference(), for(),intersection() or their one-to-one equivalents, In the library's own dialect a for() block might look like:

pieces(4)  X(every(35)) turnXY(vals(10,25,-15,40))  cube(10);

It is all valid OpenScad, you do need any additional programs, just the OpenScad and the constructive-compiled.scad file.

The Constuctive-Syntax tries to align more with mechanical construction of parts and less with mathematical concepts like arrays, vectors and functions. (but they are heavily used behind the scenes). So it aims to be more concise and fluent for mechanical parts than vanilla OpenScad. It allows you to make holes from Modules and really good deal more.
For about 5 years now i have been working on it and using it a lot. Now I i hope you will find it just as useful, as i do. I am barely writing any vanilla OpenScad any more.

If somebody likes the Ideas, you are welcome to join work on it. It is released under GPL2, and I appreciate additions/discussions/collaboration. Perhaps, some Ideas can be used by the OpenScad itself.

There is barely any documentation yet. I will add it topic-wise, when any questions arise if there will be interest at all.

For a basic introduction to its syntax and some possibilities, look at the explanations inside the example below, or ask me directly. Here is an example with approx 100 lines of actual code  (see also an animated .GIF in the Attachment):

https://github.com/solidboredom/constructive/blob/main/examples/mount-demo.scad

there is also another Example at:

https://github.com/solidboredom/constructive/blob/main/examples/pulley-demo.scad

There are many more features useful for complex models, like its own minimalistic type-subsystem,

basic inheritance of construction parts (still needs improvement), or inverse transformations like in :

g(X(10),Y(15),turnXY(45),X(30))

    g(backwards([X(10),Y(15),turnXY(45),X(30)])

        box(10);

Try it! i hope you will find it as useful as i do.

Peter



