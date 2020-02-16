---
title: Rewriting the generator in PureScript
description: This took way longer than I expected
date: 2020-01-23
---

The [Go](https://golang.org) generator I first built for this blog was... okay.
It did what it needed to do, it was fast and it was very small. But I wasn't
happy with it — HTML templates are brittle, and so is CSS. Having a bit of
experience with [Elm](https://elm-lang.org), I really wanted something like
it's [`Html`](https://package.elm-lang.org/packages/elm/html/latest/) package.
_However_ I find Elm to be an overkill for a simple blog, and I don't find the
options for static Elm pages very compelling, either. After thinking a bit and
pondering my options, I decided to go with PureScript.

## Why?

I've been reading about Haskell _a lot_ recently, and I initially tried to
build the blog using [Hakyll](https://jaspervdj.be/hakyll/), but I ran out of
RAM several times when attempting to compile one of it's dependencies
([Pandoc](https://pandoc.org/)). I also knew about PureScript,
[`purescript-smolder`](https://pursuit.purescript.org/packages/purescript-smolder/7.0.0)
and
[`purescript-css`](https://pursuit.purescript.org/packages/purescript-css/4.0.0),
which essentially meant I could have an entirely type-safe generator,
where broken HTML and CSS would produce a compiler error rather than a
funny-looking page, which was exactly what I wanted.

## The process

Writing the Go generator took little more than two days because I was familiar
with the language and the paradigm. However, this was my first contact with
PureScript and it's build tools, and my FP background is very limited, only
having done a couple of Elm toy projects. Sometimes I would get stuck for half
an hour or more with a single compiler error, and I have to admit I don't yet
understand how all of this works. It was, however, a wonderful experience, and
I'm slowly starting to feel some things "click".

Overall it took about 14 days to get this generator to be as capable as the
old one (even though the old one did not provide type-safety for HTML nor CSS).

It still needs a lot of work though — the error handling is non-existing,
I'm probably abusing do notation and there are likely better, terser ways of
doing most of what I'm doing in it.

## Should you do something like this?

Probably not. There are [a lot](https://www.staticgen.com/) of static site
generators out there that might be more than enough for your needs. However,
it's a great project for learning how a static site generator works, and if you
suffer from [NIH syndrome](https://en.wikipedia.org/wiki/Not_invented_here)
like me, this is definitely the way to go. You'd be in complete control of the
markup and the whole process that turns it into your page.

Hopefully one day it'll become useful enough for other people to use it.
