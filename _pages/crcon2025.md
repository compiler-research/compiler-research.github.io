---
title: "CompilerResearchCon"
layout: gridlay
excerpt: "CompilerResearchCon"
sitemap: false
permalink: /crcon2025/
---

# CompilerResearchCon

Compiler Research Conferences are focused events that bring together members and 
contributors to share progress and insights on specific initiatives. These 
virtual gatherings provide an opportunity to present completed work, discuss 
outcomes, and explore the impact of research efforts in compiler technology 
and related areas. Such conferences typically feature presentations from contributors, 
including participants in programs like Google Summer of Code, showcasing 
developments in automatic differentiation, interpretative C/C++/CUDA, and 
other compiler infrastructure projects. These events promote knowledge exchange 
and celebrate the collaborative achievements of our research community.

<i>If you are interested in our work you can join our
[compiler-research-announce google groups forum](https://groups.google.com/g/compiler-research-announce)
or follow us on [LinkedIn](https://www.linkedin.com/groups/9579649/).</i>

{% assign sorted_crcon = site.data.crconlist2025 | sort: "date" | reverse %}

{% for crcon in sorted_crcon %}

<div class="row">
<span id="{{crcon.label}}">&nbsp;</span>
<div class="clearfix">
<div class="well" style="padding-left: 20px; padding-right: 20px">
  <a style="text-decoration:none;" href="#{{crcon.label}}">
    {{ crcon.name }} -- {{ crcon.date | date_to_long_string }} at {{crcon.time_cest}} Geneva (CH) Time
  </a>
<div>Connection information: {{crcon.connect}} <br />
</div><div>
  Agenda:
  <ul>{% for item in crcon.agenda %}
    <li><strong>{{item.time_cest}}
      {% if item.speaker %}
      {% if item.speaker.first %}
        {{ item.speaker.name }}
      <br>“{{item.title}}”</strong>
      {% else %}
        ({{item.speaker}})
      {% endif %}
      {% endif %}
      {% if item.description %}
        <br /> <i>Abstract:</i>{{item.description | markdownify }}
      {% endif %}
      {% if item.slides %}
      <a style="text-decoration:none;" href="{{item.slides}}">Slides</a>
      {% endif %}
      {% if item.video %}
      <a style="text-decoration:none;" href="{{item.video}}">Video</a>
      {% endif %}
      {{ item.link }}
    </li>
    {% endfor %}</ul>
</div>
</div>
</div>

</div>

{% endfor %} 

