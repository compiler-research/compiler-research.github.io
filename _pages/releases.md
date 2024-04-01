---
title: "Releases"
layout: textlay
excerpt: "Recent Releases from Compiler Research Group"
sitemap: false
permalink: /releases
---

# Releases

{% for article in site.data.releases %}
<p><em><b>{{article.codebase}} - {{article.version}}</b> ({{ article.date | date: "%-d %B %Y" }})</em></p>
<p>&nbsp;&nbsp;&nbsp;{{article.description}} For details, please see the <a href='{{article.link}}'>release notes</a>.</p>
{% endfor %}
