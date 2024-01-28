---
title: "Project Meetings"
layout: gridlay
excerpt: "Project Meetings"
sitemap: false
permalink: /meetings/
---

# Project Meetings

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
        ({{item.speaker}})
      {% endif %}
      {% if item.description %}
        <br/> <i>Abstract:</i>{{item.description | markdownify }}
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
