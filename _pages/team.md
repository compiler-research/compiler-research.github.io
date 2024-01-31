---
title: "Compiler Research - Team"
layout: gridlay
excerpt: "Compiler Research: Team members"
sitemap: false
permalink: /team/
---

# Group Members

<div class="clearfix">

{% assign active_contrib = site.data.contributors | where: "active", "1" %}
{% assign past_contrib = site.data.contributors | where_exp: "item", "item.active == nil" %}

{% for member in active_contrib %}
{% assign even_odd = forloop.index0 | modulo: 2 %}

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
  <h4>{{ member.name }}</h4>
  <i>{{ member.info }}</i><br>
{% if member.email %}
  <i>email: <{{ member.email }}></i>
{% endif %}
  {% if member.photo == "rock.jpg" %}
  </div>
     {% continue %}
  {% endif %}
{% if member.education %}
  <p> <strong>Education:</strong> {{ member.education }} </p>
{% endif %}  
  {% for project in member.projects %}
  <p class="text-justify">
    <strong> {{ project.status }} project:</strong>
    <i>{{ project.title }}</i><br/>{{ project.description }}
  </p>
  <p>
    <strong>Project Proposal:</strong>
    <a href="{{ project.proposal }}" target=_blank >URL</a>
  </p>
{% if project.report and project.report.size>3 %}
  <p>
    <strong>Project Reports:</strong>
    {{ project.report | markdownify | remove: '<p>' | remove: '</p>' | strip_newlines}}
  </p>
{% endif %}  
  <p> <strong>Mentors:</strong> {{ project.mentors }} </p> 
  {% endfor %}
</div>

{% if even_odd == 1 %}
</div>
{% endif %}

{% endfor %}
</div>

<hr />

### Alumni

<div class="clearfix">


{% for member in past_contrib %}
{% assign even_odd = forloop.index0 | modulo: 2 %}

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
  <h4><a href="{{ site.url }}{{ site.baseurl }}/team/{{ member.name | remove: " " }}">{{ member.name }}</a></h4>
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
