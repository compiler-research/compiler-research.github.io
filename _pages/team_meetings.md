---
title: "Team Meetings"
layout: gridlay
excerpt: "Team Meetings"
sitemap: false
permalink: /team_meetings/
---

# Team Meetings

{% assign standing_meetings = site.data.standing_meetings %}

{% for smeeting in standing_meetings %}

<div class="row">
<span id="{{meeting.label}}">&nbsp;</span>

<div class="clearfix">
<div class="well" style="padding-left: 20px; padding-right: 20px">
  <a style="text-decoration:none;" href="#{{smeeting.label}}">
    {{ smeeting.name }} -- {{ smeeting.date }} at {{smeeting.time_cest}} Geneva (CH) Time
  </a>
<div>
  Connection information: {{smeeting.connect}} <br />
</div><div>
  Agenda:
  <ul>
    {% for item in smeeting.agenda %}
    <li><strong>{{item.title}}</strong>
      {% if item.speaker %}
        ({{item.speaker}}) [{{item.date|date: "%b %-d, %Y"}}]
      {% endif %}
      {{item.link | markdownify}}
    </li>
    {% endfor %}
   </ul>
</div>
</div>
</div>

</div>

{% endfor %} 
