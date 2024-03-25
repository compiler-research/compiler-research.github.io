---
title: "Compiler Research Projects"
layout: gridlay
excerpt: "Notable Projects by Compiler Research Group"
sitemap: false
permalink: /projects/
---

Following are some notable projects.


{% for project in site.data.projects %}

  <div class="well" style="padding-left: 20px; padding-right: 20px">

  **{{ project.name }}**

  {{ project.description | markdownify }}

  For more details, please browse to this <a href="{{ project.link }}">link to the project</a>

  </div>

{% endfor %}

