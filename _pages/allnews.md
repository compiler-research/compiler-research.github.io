---
title: "News"
layout: textlay
excerpt: "Compiler Research"
sitemap: false
permalink: /allnews
---

# News

{% for article in site.data.news %}
<p>{{ article.date }} <br>
<em><a href='{{article.link}}'>{{ article.headline }}</a></em></p>
{% endfor %}
