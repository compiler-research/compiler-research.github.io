---
title: "Releases"
layout: textlay
excerpt: "Recent Releases from Compiler Research Group"
sitemap: false
permalink: /releases
---

# Releases

{% for article in site.data.releases %}
<p>{{ article.date }} <br>
<em><a href='{{article.link}}'>{{article.codebase}} - {{article.version}}</a></em></p>
{% endfor %}
