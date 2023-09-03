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

{% assign number_printed = 0 %}
{% for member in active_contrib %}
{% assign even_odd = number_printed | modulo: 2 %}

{% if even_odd == 0 %}
<div class="row">
{% endif %}

<div class="col-sm-6 clearfix">

{% if member.photo %}
  {% assign member_photo = member.photo %}
{% else %}

### Alumni

<div class="clearfix">


{% assign number_printed = 0 %}
{% for member in past_contrib %}
{% assign even_odd = number_printed | modulo: 2 %}

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

{% assign number_printed = number_printed | plus: 1 %}

{% if even_odd == 1 %}
</div>

{% endif %}

{% endfor %}
</div>
