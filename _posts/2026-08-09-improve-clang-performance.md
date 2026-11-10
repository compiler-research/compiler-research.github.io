---
title: "Improve Clang Performance"
layout: post
excerpt: |
  A CppAlliance Fellowship 2026 project to systematically improve Clang's performance:
  benchmarking real-world codebases across releases to find compile-time and memory
  regressions, tracing them to the upstream changes that caused them, and upstreaming
  targeted, data-driven fixes.
sitemap: true
author: Ezzeldin Ibrahim
permalink: blogs/cppalliance26_ezzeldin_ibrahim_improve_clang_performance/
thumbnail_image: /images/cppalliance-logo.svg
date: 2026-08-09
tags: [cppalliance, clang, performance, benchmarking, memory-optimization, codegen]
---

{% include dual-banner.html
left_logo="/images/cppalliance-logo.svg"
right_logo="/images/cr-logo_old.png"
caption=""
height="20vh" %}

So yeah, this summer I am a compiler research fellow with [cppalliance](https://compiler-research.org/blogs/cppalliance_fellowships_2026/), where I need to somehow improve the performance of clang???!!

At first I was very lost on where to actually start.
Diving deep directly into clang to find an area to improve didn't seem like the best idea. In fact, I did it a few weeks ago and was kinda grilled by the reviewers (:

So another idea was, instead of trying to do something entirely new, let's look into the gaps between the work of clang maintainers.
Of course, the clang people won't leave any obvious slowdown, and most PRs are already optimized, and if there are any big regressions they are caught really fast. So we are even looking into more hidden gaps, but I was kinda hopeful with this idea and more scared of the first one.

## How to actually find regressions?
If we are gonna look for regressions, we need targets. At first I tried SQLite and got good results, but my mentor quickly recommended I use Boost.MPL, and it was one of the best targets.
Out of the 20 regressions I have found during my search, MPL was affected noticeably by 8 of them.

And for clang, I decided to look for regressions within clang 18 up to clang 23.
I don't exactly know where a regression may be located, so I try a number of commits within each version and measure (At first I used wall clock, which was really stupid, and I quickly switched to using Ir instructions using valgrind.) how much each version of clang costs on the targets,
then focus on that range to try to find what commit exactly caused that slowdown, slowly bisecting each range.

## First fixable regression found

So so far I had found a couple of regressions, but they were either intrinsic to how clang works now or already solved in trunk.
But finally, finally, after three weeks of searching, I found an actual fixable one.

Looks like when the Swift team's fork upstreamed the [API Notes](https://clang.llvm.org/docs/APINotes.html) feature, they didn't notice that it also always runs even when there's no need for it, for every project. `Sema::ProcessAPINotes` was being called on *every single declaration*, whether or not the file had any API Notes files loaded at all (which, for basically most projects, is never).
And this had remained unnoticed in clang for about two years.

So I filed an issue: [#202214 — Sema::ProcessAPINotes runs on every decl even when API Notes aren't used](https://github.com/llvm/llvm-project/issues/202214).

And it was fixed quite simply too, instead of running the API-notes lookup multiple times, just run it once and reuse the value, then also cache whether API Notes are needed at all so the per-decl work is skipped entirely.

So together that's roughly a **−0.2%** improvement in clang.

It seems very minuscule, but like I said, we are looking through the gaps and these very small easy to fix regressions accumulate over time and cause actual slowness.

## The ManyClangs Project!
The [manyclangs](https://github.com/elfshaker/manyclangs) project saved this project a huge amount of time. One of the bottlenecks of the project was that compiling a commit of clang took so long, about 40 minutes for each one even with the help of ccache.
So with the manyclangs, after downloading 5GBs of data, it does some compressing and version-control magic, and I can access the binary of any clang commit in seconds. This lets me do sweeps at much larger scales at incredible speed.

## Benchmarking projects

| project | language | what it stresses in clang |
|---|---|---|
| SQLite | C | the C frontend over one giant amalgamation, parsing and sema on a huge TU |
| Boost.MPL | C++ | heavy template instantiation / template metaprogramming |
| Boost.Hana | C++ | modern metaprogramming, constexpr mixed with templates |
| Boost.Spirit | C++ | expression-template EDSLs and deep template nesting |
| range-v3 | C++ | ranges and heavily constrained templates |
| fmt | C++ | templates plus constexpr |
| kernel headers | C | the preprocessor and parser (tons of macros) |
| Eigen | C++ | expression templates (linear algebra) |
| stdexec | C++20 | concepts and constraint satisfaction |
| mp-units | C++23 | concepts plus non-type template parameters (a units library) |

I tried, when adding new projects, to make sure they test a new part of clang, and so far each has helped in finding some regressions.

## How is the work so far

So far I've landed a bunch of these small fixes upstream. Here's every PR, what it fixed, and how much it bought:

|#| PR | fix | local benchmarks | LLVM tracker |
|-|---|---|---|---|
| 1| [#202727](https://github.com/llvm/llvm-project/pull/202727) | APINotes: early return when no apinotes files are loaded |  -0.4% MPL | **−0.11%** |
| 2| [#203710](https://github.com/llvm/llvm-project/pull/203710) | APINotes: skip per-decl work when no notes are active | (follow-up to above) | **−0.07%** |
| 3| [#204926](https://github.com/llvm/llvm-project/pull/204926) | only record lexer check-points when colors are enabled | part of a +0.3% step | +0.07% |
| 4| [#209355](https://github.com/llvm/llvm-project/pull/209355) | fix check-point recording under default colors | fixes a regression **#204926 caused** | **−0.20%** |
| 5| [#208862](https://github.com/llvm/llvm-project/pull/208862) | skip macro source-location check for names that can't warn | −0.7% kernel, −0.3% MPL | ~0% |
| 6| [#208139](https://github.com/llvm/llvm-project/pull/208139) | compute current instantiation less often in `lookupInBases` | ~99% of a +0.4% step | **−0.03%** |
| 7| [#209694](https://github.com/llvm/llvm-project/pull/209694) | no typo-correction suggestions for disabled diagnostics | **−1.2% MPL**, −0.2% kernel | **−0.28%** |
| 8| [#206363](https://github.com/llvm/llvm-project/pull/206363) | don't add doc comments to the AST if not requested | −5% on comment-heavy TUs | **−0.24%** |
| 9| [#212213](https://github.com/llvm/llvm-project/pull/212213) | cache the analysis-based warning policy instead of recomputing it per body | **−0.3% MPL**, −0.5% fmt | **−0.11%** |
|10| [#213790](https://github.com/llvm/llvm-project/pull/213790) | avoid quadratic pack-indexing instantiation | O(N²)→O(N): **~14.6× faster, ~31× less memory** at N=8k | ~0% |

*tracker = llvm-compile-time-tracker.com, geomean `instructions:u`*

Overall I made clang faster by a whole 1.25%! All with very small and simple changes.

For context, a 1% improvement in Clang's compilation speed may seem modest, but its cumulative impact is enormous. Clang is one of the world's most widely used C and C++ compilers, powering software development across operating systems, browsers, mobile platforms, cloud infrastructure, game engines, and embedded devices. Every day, millions of developers and continuous integration systems invoke Clang countless times. As a result, even a 1% reduction in compilation time translates into millions of CPU-hours saved annually worldwide, reducing energy consumption, lowering infrastructure costs, and enabling developers to receive build feedback more quickly. In a tool used at such global scale, seemingly small performance gains compound into substantial economic and productivity benefits, making a 1% improvement a real achievement.

Most of them were fixed with a few lines consisting of:

A. Caching with a simple boolean so we don't recalculate a heavy computation [#203710](https://github.com/llvm/llvm-project/pull/203710), [#208139](https://github.com/llvm/llvm-project/pull/208139), [#212213](https://github.com/llvm/llvm-project/pull/212213)

B. Reorder some conditions so that the heavy computation is stopped early if it's not needed [#202727](https://github.com/llvm/llvm-project/pull/202727), [#208862](https://github.com/llvm/llvm-project/pull/208862)

C. Something ran when it shouldn't, like how the computations for some of the diagnostics ran even though warnings were disabled [#204926](https://github.com/llvm/llvm-project/pull/204926), [#209355](https://github.com/llvm/llvm-project/pull/209355), [#209694](https://github.com/llvm/llvm-project/pull/209694), [#206363](https://github.com/llvm/llvm-project/pull/206363)

## A few of these up close

1. **Skip the macro source-location check for names that can't warn ([#208862](https://github.com/llvm/llvm-project/pull/208862)).** Every time clang sees a macro name it was doing a source-location lookup to decide whether to warn about it, but most macro names can't ever trigger that warning, so the lookup was pure waste. The fix checks the cheap "can this name even warn?" condition first and skips the lookup otherwise. That's worth −0.7% on kernel headers (which are basically all macros) and −0.3% on MPL.

2. **Don't add doc comments to the AST if not requested ([#206363](https://github.com/llvm/llvm-project/pull/206363)).** clang was collecting doc comments into the AST even when nothing was going to use them, no `-Wdocumentation`, nobody asking for them. On comment-heavy files that's a lot of parsing and allocation for nothing. The fix only keeps the comments when something actually asked for them, which is up to −5% on comment-heavy TUs.

3. **Only record lexer check-points when colors are enabled ([#204926](https://github.com/llvm/llvm-project/pull/204926)).** clang records "check-points" while lexing that are only needed to render colored diagnostics, so I gated recording them behind the colors-enabled check. Unfortunately, mid-PR another related PR got merged, so after fixing the merge conflicts, merging it caused my first clang regression, and it was quickly fixed with a follow-up.

4. **No typo-correction suggestions for disabled diagnostics ([#209694](https://github.com/llvm/llvm-project/pull/209694)).** When clang sees something it doesn't recognize, like an unknown attribute or a misspelled preprocessor directive, it runs an edit-distance search to suggest "did you mean X ?". The problem is it was doing that search even when the warning that would show the suggestion is turned off. On Boost.MPL and the kernel headers that's a huge pile of wasted scans, since the system headers trip it constantly, so only running it when the diagnostic is actually enabled is worth −1.2% on MPL and −0.2% on the kernel.

## AI Usage in finding regressions
AI agents really helped in this project. Here are some points where AI was heavily utilised:
1. I don't really care about how MPL is built, or any of the 10 other projects, so agents helped set up the environments, dependencies, etc.
2. A lot of utility and helper scripts that are used in the benchmarking and the sweeps were made with the help of agents.
3. Agents were always monitoring the bisecting process, documenting interesting results as it goes, and intervening if there were any problems.
4. If it found a particular jump in the sweeps, it would continue focusing until it found the first bad commit.
5. Search the reviews and issues if the found regression is mentioned anywhere, or if the overhead was known when reviewing.
6. Check if the regression is still live on trunk and it wasn't fixed or reverted already.

And since I am touching a lot of unfamiliar parts of clang it helped and misled me a lot of times when trying to understand related clang code, I avoided using it to directly make fixes if the fix is not super obvious.

## What is next

Currently I have done a sweep on clangs with different options (`-fsyntax-only`, `-Wdocumentation`, `-Wall -Wextra`, `-std=c++20`, `-O2`, `-emit-llvm-only`)
and mostly focused on benchmarking for Ir.
Out of the 20 regressions found, only 8 were fixable so far.
Most of them were already solved, or intrinsic, or too complicated to know if they are actually intrinsic or if they could possibly be improved.
Currently I am making a sweep on peak-heap / total memory to hopefully find areas to improve, and will try other possible measurements.
There are some issues that I have also put in my to-do. I will at least try to bisect the cause.
