---
layout: gridlay
title: "CppJIT, ROOT and the Higgs Analysis"
excerpt: "Live JupyterHub for the SC26 session 'CppJIT, ROOT and the Higgs
          Analysis' -- call ROOT from Python with CppJIT and fit the Higgs
          peak on CMS open data, in the browser."
sitemap: false
permalink: /tutorials/sc26/cppjit-root/
redirect_from:
  - /sc26/cppjit-root/
date: 2026-11-16
# The one place the hub address lives. Final home: https://sc26-higgs.compiler-research.org
# (switch once the certificate for that subdomain is issued).
hub_url: https://jupyterhub.jonasrembser.com
---

{::nomarkdown}

{% include tutorial-hero-style.html %}

<style>
  .live-bar {
    display: flex;
    flex-wrap: wrap;
    align-items: center;
    gap: 0.75rem 1.5rem;
    margin: 1rem 0;
  }
  .live-bar .btn-launch {
    background: #004481;
    color: white !important;
    font-weight: bold;
    padding: 0.6rem 1.4rem;
    border-radius: 4px;
    text-decoration: none;
  }
  .live-bar .btn-launch:hover { background: #0a5fa8; }
  .live-frame {
    width: 100%;
    height: calc(100vh - 140px);
    min-height: 600px;
    border: 2px solid #004481;
    background: #f8faff;
  }
  .live-note { font-size: 0.9em; color: #555; margin-top: 0.5rem; }
</style>

<div class="hero-box">
  <span class="status-badge">★ SC26 TUTORIAL · CPPJIT · ROOT · HIGGS</span>
  <h1 style="color: #004481; font-weight: 800; margin-top: 0; font-size: 2.2em;">
    CppJIT, ROOT and<br>the Higgs Analysis
  </h1>
  <p class="lead" style="margin-bottom: 0;">Domain-science session of the
  <a href="/tutorials/sc26/">SC26 tutorial</a> · Monday, November 16, 2026 ·
  Room W185a, McCormick Place, Chicago, IL</p>
</div>

{:/}

CppJIT is a Python kernel with a C++ compiler inside it: it reads ROOT's
headers the way Clang does and lets Python call what it finds, with no
bindings to generate. In this session we use it to drive ROOT from Python
and fit the Higgs boson mass peak on CMS open data. The JupyterHub below has
ROOT and CppJIT installed; log in, start your server, and open the notebook.
Nothing to install on your laptop.

{::nomarkdown}

<div class="live-bar">
  <a class="btn-launch" href="{{ page.hub_url }}" target="_blank" rel="noopener">Open the workspace in a new tab &rarr;</a>
</div>

<iframe class="live-frame" src="{{ page.hub_url }}" title="CppJIT, ROOT and the Higgs Analysis JupyterHub"
        allow="clipboard-read; clipboard-write" referrerpolicy="no-referrer-when-downgrade"></iframe>

<p class="live-note">If the workspace does not appear above, your browser blocked the embedded
login. Use the button to open it in its own tab; everything works the same way there.</p>

{:/}

<i>If you are interested in our work you can join our
[compiler-research-announce google groups forum](https://groups.google.com/g/compiler-research-announce)
or follow us on [LinkedIn](https://www.linkedin.com/groups/9579649/).</i>
