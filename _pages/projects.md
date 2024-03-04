---
title: "Compiler Research Projects"
layout: gridlay
excerpt: "Notable Projects by Compiler Research Group"
sitemap: false
permalink: /projects/
---

<nav>
  <h4>Table of Contents</h4>
  * this unordered seed list will be replaced by toc as unordered list
  {:toc}
</nav>

---

Following are some notable projects, organized based on the [Area of Research]
that they belong to.


## Automatic Differentiation

{% for project in site.data.projects %}
  {% if project.category == "Automatic Differentiation" %}

### {{ project.name }}

{{ project.description | markdownify }}

For more details, please browse to this <a href="{{ project.link }}">link to the project</a>

{% endif %}
{% endfor %}

---

## Compiler-As-A-Service

{% for project in site.data.projects %}
  {% if project.category == "Compiler-As-A-Service" %}

### {{ project.name }}

{{ project.description | markdownify }}

For more details, please browse to this <a href="{{ project.link }}">link to the project</a>

{% endif %}
{% endfor %}

---

## Interactive C++

{% for project in site.data.projects %}
  {% if project.category == "Interactive C++" %}

### {{ project.name }}

{{ project.description | markdownify }}

For more details, please browse to this <a href="{{ project.link }}">link to the project</a>

{% endif %}
{% endfor %}

---

## Language Interoperability

{% for project in site.data.projects %}
  {% if project.category == "Language Interoperability" %}

### {{ project.name }}

{{ project.description | markdownify }}

For more details, please browse to this <a href="{{ project.link }}">link to the project</a>

{% endif %}
{% endfor %}

[Area of Research]: https://compiler-research.org/research/