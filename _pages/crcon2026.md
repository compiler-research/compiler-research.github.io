---
title: "CompilerResearchCon"
layout: gridlay
excerpt: "CompilerResearchCon"
sitemap: false
permalink: /crcon2026/
---

# CompilerResearchCon 2026

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

{% assign sorted_crcon = site.data.crconlist2026 | sort: "date" %}

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
    {% if item.speaker.name %}
      {% assign talk_id = item.speaker.name | slugify: "latin" | prepend: "_" | prepend: crcon.label %}
    {% else %}
      {% assign talk_id = forloop.index | prepend: "_" | prepend: crcon.label %}
    {% endif %}
    <li id="{{talk_id}}">
      <a style="text-decoration:none;" href="#{{talk_id}}">{{item.time_cest}}</a>
      {% if item.speaker.first %}
        {% assign speaker_name = item.speaker.name %}
      {% else %}
        {% assign speaker_name = item.speaker %}
      {% endif %}
      {% if item.title %} <strong>"{{item.title}}"</strong>{% endif %}{% if speaker_name %}, <em>{{ speaker_name }}</em>{% endif %}
      {% if item.description %}
        <br /> <i>Abstract:</i>{{item.description | markdownify }}
      {% endif %}
      {% if item.speaker and item.speaker.first %}
        {% comment %} Fall back to the team info when the agenda does not provide an image or a bio. {% endcomment %}
        {% assign member = site.data.contributors | where: "name", item.speaker.name | first %}
        {% assign speaker_image = item.speaker.image %}
        {% if speaker_image == nil and member %}
          {% assign speaker_image = member.photo | default: "defaultDP.png" | prepend: "/images/team/" | prepend: site.baseurl %}
        {% endif %}
        {% assign speaker_bio = item.speaker.bio | default: member.responsibilities %}
        {% if speaker_bio == nil and member %}
          {% capture speaker_bio %}{{ member.info }}{% if member.education %}, {{ member.education }}{% endif %}{% endcapture %}
        {% endif %}
        {% if speaker_image or speaker_bio %}
        <div class="row">
          <div class="col-md-1">
            {% if speaker_image %}
            <img style="width: 72px; height: 72px; border-radius: 50%; object-fit: cover"  class="shadow-4-strong" alt="{{item.speaker.name}}" src="{{speaker_image}}" />
            {% endif %}
          </div>
          <div class="col-md-11">
            <small><i>{{ speaker_bio | markdownify | remove: '<p>' | remove: '</p>' }}</i></small>
          </div>
        </div>
        {% endif %}
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

