---
title: "Support for constexpr and consteval in Clad"
layout: post
excerpt: "A GSoC 2024 project with the goal of adding support for constant expressions to Clad"
sitemap: false
author: Mihail Mihov
permalink: blogs/gsoc24_mihail_mihov_introduction_blog/
banner_image: /images/blog/gsoc-banner.png
date: 2024-06-05
tags: gsoc clad clang c++
---

### Introduction

I am Mihail Mihov, a student during the 2024 Google Summer of Code. I will be
working on the project "Add support for consteval and constexpr functions in
clad".

**Mentors**: Vaibhav Thakkar, Vassil Vassilev, Petro Zarytskyi


### Briefly about Clad

In mathematics and computer algebra, automatic differentiation (AD) is a set of
techniques to numerically evaluate the derivative of a function specified by a
computer program. Automatic differentiation is an alternative technique to
Symbolic differentiation and Numerical differentiation (the method of finite
differences). Clad is based on Clang which provides the necessary facilities
for code transformation. The AD library can differentiate non-trivial
functions.

### Personal Motivation

I have always liked mathematics and I also have some experience with compilers
and find them very interesting, so when I found this project I knew that I
would enjoy it. It combines many things that I like and I believe that doing
something that I enjoy makes it much more likely that I will do well. C++ is
also the first programming language that I learned so it will forever be more
special to me.

### Importance of this project

Not having support for constexpr or consteval functions could be a deal-breaker
to many projects, as these keywords have been around for some time now and the
number of projects that use them will only increase. Also working on this
project will require investigating what can and can't be compile-time evaluated
and I think that we could learn something new about the already existing
code-generation that can be improved.

### Goals of the project

The main goal of this project is to support differentiating functions that are
marked as constexpr and consteval and to possibly keep the same guarantees for
the generated derivatives.

At the end of the project Clad should work on most constexpr and consteval
functions from the C++ standard library and most other functions that a user
could pass in.

### Implementation Details and Plans

Implementing this project will be mainly split into doing it for forward and for
reverse mode, as these are the two options that Clad has for differentiating a
function. For each of these parts I will have to look into both constexpr and
consteval as they do have some differences that need to be solved separately.


Implementing this project will need to start at clad's CladFunction which is
the function type that Clad generates and is what in the end should be
compile-time evaluated if possible. The cases where keeping the constexpr
properties might not be possible is when loops are involved and we would need
to implement good diagnostics in such cases, to inform the user that the code
may not be evaluated as they would expect.

### Conclusion

This project should be very useful for Clad, by allowing a wider range of projects
to use it. Along the way it's possible that there will be interesting findings which
can be used to further improve Clad.

### Related Links

- [Clad repository](https://github.com/vgvassilev/clad.git)
- [Clad documentation](https://clad.readthedocs.io)
- [My GitHub Profile](https://github.com/mihailmihov)


