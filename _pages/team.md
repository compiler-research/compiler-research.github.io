---
title: "Compiler Research - Team"
layout: gridlay
excerpt: "Compiler Research: Team members"
sitemap: false
permalink: /team/
---

# Group Members

<div class="clearfix">

{% assign members = site.data.contributors %}


{% assign even_odd = -1 %}
{% for member in members %}
{% assign even_odd = even_odd | plus: 1 | modulo: 2 %}
{% assign previndex0 = forloop.index0 | minus: 1 %}

{% if member.active == nil and members[previndex0].active == 1 %}

</div>

{% assign even_odd = 0 %}

<hr />

### Alumni

{% endif %}


{% if even_odd == 0 %}
<div class="row">
{% endif %}

<div class="col-sm-6 clearfix">
{% if member.photo %}
  {% assign member_photo = member.photo %}
{% else %}
  {% assign member_photo = "defaultDP.png" %}
{% endif %}
  <img src="{{ site.url }}{{ site.baseurl }}/images/team/{{ member_photo }}" class="img-responsive" width="25%" style="float: left" />
  <h4>
  {% if member.photo == "rock.jpg" %}
  {{ member.name }}
  {% else %}
  <a href="{{ site.url }}{{ site.baseurl }}/team/{{ member.name | remove: " " }}">{{ member.name }}</a>
  {% endif %}
  </h4>
  <i>{{ member.info }}</i><br>
{% if member.email %}
  <i>email: <{{ member.email }}></i>
{% endif %}
{% if member.education %}
<p> <strong>Education:</strong> {{ member.education }} </p>
{% endif %}
</div>

{% if even_odd == 1 %}
</div>

{% endif %}

{% endfor %}
</div>
