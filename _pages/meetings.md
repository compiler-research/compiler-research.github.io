---
title: "Project Meetings"
layout: gridlay
excerpt: "Project Meetings"
sitemap: false
permalink: /meetings/
---

# Project Meetings

The project meetings serve as a place to gain insights into the ongoing
activities conducted by our group, exploring the intersection of compiler
research and data science. The project meetings are virtual and typically take
place the first Thursday of the month. While our current emphasis is on
automatic differentiation, interpretative C/C++/CUDA, and C++ language
interoperability with Python, we are equally dedicated to promoting the research
and applications of programming languages infrastructure in various
domains. Additionally, these meetings often feature invited speakers,
contributing diverse perspectives and enriching discussions, fostering a
collaborative environment for the exchange of knowledge and ideas.

<i>If you are interested in our work you can join our
[compiler-research-announce google groups forum](https://groups.google.com/g/compiler-research-announce)
or follow us on [LinkedIn](https://www.linkedin.com/groups/9579649/).</i>

{% assign sorted_meetings = site.data.meetinglist | sort: "date" | reverse %}

{% for meeting in sorted_meetings %}

<div class="row">
<span id="{{meeting.label}}">&nbsp;</span>
<div class="clearfix">
<div class="well" style="padding-left: 20px; padding-right: 20px">
  <a style="text-decoration:none;" href="#{{meeting.label}}">
    {{ meeting.name }} -- {{ meeting.date | date_to_long_string }} at {{meeting.time_cest}} Geneva (CH) Time
  </a>
<div>Connection information: {{meeting.connect}} <br />
</div><div>
  Agenda:
  <ul>{% for item in meeting.agenda %}
    <li><strong>{{item.title}}</strong>
      {% if item.speaker %}
      {% if item.speaker.first %}
        ({{ item.speaker.name }})
      {% else %}
        ({{item.speaker}})
      {% endif %}
      {% endif %}
      {% if item.description %}
        <br /> <i>Abstract:</i>{{item.description | markdownify }}
      {% endif %}
      {% if item.speaker and item.speaker.first %}
        <div class="row">
          <div class="col-md-1">
            <img style="width: 72px; height: 72px; border-radius: 50%; object-fit: cover"  class="shadow-4-strong" alt="{{item.speaker.name}}" src="{{item.speaker.image}}" />
          </div>
          <div class="col-md-11">
            <i>{{item.speaker.bio}}</i>
          </div>
        </div>
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
