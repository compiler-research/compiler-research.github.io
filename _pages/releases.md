---
title: "Releases"
layout: textlay
excerpt: "Recent Releases from Compiler Research Group"
sitemap: false
permalink: /releases
---

# Releases


{% for article in site.data.releases %}
<div class='well'>
<p><em><b>{{article.codebase}} - {{article.version}}</b><br>{% include date.html date=article.date %}</em></p>
<div style="padding-left: 20px; padding-right: 20px">
<p>{{article.description}} For details, please see the <a href='{{article.link}}'>release notes</a>.</p>
</div>
</div>
{% endfor %}
