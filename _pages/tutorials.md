---
title: "Tutorials"
layout: gridlay
excerpt: "Tutorials"
sitemap: false
permalink: /tutorials/
---

# Related Tutorials

{::nomarkdown}

<style>
  .tutorial-card {
    background: #fcfcfc;
    border: 1px solid #e1e4e8;
    border-left: 6px solid #004481;
    border-radius: 8px;
    padding: 18px 22px;
    margin-bottom: 20px;
  }
  .tutorial-card h3 {
    margin: 0 0 6px 0;
    font-size: 1.25em;
    font-weight: 700;
  }
  .tutorial-card h3 a { color: #004481; text-decoration: none; }
  .tutorial-card h3 a:hover { text-decoration: underline; }
  .tutorial-meta {
    color: #777;
    font-size: 0.9em;
    margin-bottom: 10px;
  }
  .tutorial-card .abstract p { margin-bottom: 8px; }
  .tutorial-links { margin-top: 6px; font-weight: bold; }
</style>

{% assign sorted_tutorials = site.data.tutorialslist | sort: "date" | reverse %}

{% for tutorial in sorted_tutorials %}

{% assign author_list = tutorial.author %}
{% assign sep_string = "," %}
{% assign split_auth = author_list | split:sep_string %}

{% if split_auth.size > 4 %}
{% assign author_list = split_auth[0] | append: ", " | append: split_auth[1] |append: ", " |  append: split_auth[2] |append: ", " |  append: split_auth[3] %}
{% assign author_list = author_list | append: ", " | append: " et. al." %}
{% endif %}

<div class="tutorial-card">
  <h3><a href="{{ tutorial.url }}">{{ tutorial.title }}</a></h3>
  <div class="tutorial-meta">{{ author_list }} &middot; {{ tutorial.date | date: "%B %-d, %Y" }}</div>
  {% if tutorial.abstract.size > 7 %}
  <div class="abstract">{{ tutorial.abstract | markdownify }}</div>
  {% endif %}
  {% if tutorial.artifacts.size > 7 %}
  <div class="tutorial-links">{{ tutorial.artifacts | markdownify }}</div>
  {% endif %}
</div>

{% endfor %}

{:/}
