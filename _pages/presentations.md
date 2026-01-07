---
title: "Presentations"
layout: gridlay
excerpt: "Presentations"
sitemap: false
permalink: /presentations/
---


# Related Presentations

{% assign sorted_pres = site.data.preslist | sort: "date" | reverse %}

{% assign number_printed = 0 %}
{% for presi in sorted_pres %}

{% assign even_odd = number_printed | modulo: 2 %}
{% if presi.highlight == 1 %}

{% if even_odd == 0 %}
<div class="row">
{% endif %}

<div class="col-sm-12">
 <div id="{{presi.id}}" class="well text-justify clearfix" style="scroll-margin-top: 80px;">
 <pubtit>
    <a style="text-decoration:none;" href="#{{presi.id}}"> {{ presi.title }},
      {{ presi.location | markdownify | remove: '<p>' | remove: '</p>' | strip_newlines }},
      <em>{{ presi.speaker }}</em>,
      {{ presi.date | date: "%-d %B %Y" }},
      {{ presi.artifacts | markdownify | remove: '<p>' | remove: '</p>' | strip_newlines }}
    </a>
  </pubtit>
  <img src="{{ site.url }}{{ site.baseurl }}/images/pubpic/{{ presi.id }}.gif"
       class="img-responsive"
       style="border-radius:2px; max-width:512px; min-height:200px; float: left;" />
  <img src="{{ site.url }}{{ site.baseurl }}/images/pubpic/{{ presi.id }}.png"
       class="gif-animated-static img-responsive "
       style="border-radius:2px; max-width:512px; min-height:200px; float: left;" />
  {{ presi.description | markdownify }}
 </div>
</div>

{% assign number_printed = number_printed | plus: 1 %}

{% if even_odd == 1 %}
</div>
{% endif %}

{% endif %}
{% endfor %}

{% assign even_odd = number_printed | modulo: 2 %}
{% if even_odd == 1 %}
</div>
{% endif %}

<p> &nbsp; </p>


# Full list of presentations


<div style="padding-left: 40px;">

{% for pres in sorted_pres %}
  <div id="{{ pres.id }}" style="scroll-margin-top: 80px; margin-bottom: 10px;">
    <b>{{ pres.title }}</b> <br />
    <em>{{ pres.speaker }} </em> at the {{pres.location}} ({{ pres.date | date: '%-d %B %Y' }}) {{ pres.artifacts }}
  </div>
{% endfor %}
</div>
