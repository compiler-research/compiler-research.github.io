---
title: "Open Projects"
layout: textlay
permalink: /open_projects
---

# Open Projects

<nav markdown="1">
#### Table of Contents
* TOC
{:toc}
</nav>

{% assign active_projects = site.data.openprojectlist | where_exp: "item", "item.status == nil" %}
{% include filter_widget.html items=active_projects label="Filter by technology" %}

<div id="project-list-container" class="filterable-list" markdown="0">
{% for project in site.data.openprojectlist %}
{% if project.status %}{% continue %}{% endif %}
<div class="filter-item well" data-tags="{{ project.tags | join: ',' }}" markdown="0">
<div class="post-content" markdown="1">
## {{ project.name }}
{: #{{ project.name | slugify }} }

<div class="project-tags" markdown="0">
{% for tag in project.tags %}<span class="tag-badge" onclick="applyTagFilter('{{ tag }}')">#{{ tag }}</span>{% endfor %}
</div>

{{ project.description | markdownify }}

#### Task ideas and expected results
{:.no_toc}

{{ project.tasks | markdownify }}
</div>

{% if project.banner_image %}
<div class="thumbnail-container" markdown="0">
<img src="{{ project.banner_image }}" class="thumbnail-image" alt="{{ project.name }}" />
</div>
{% endif %}
</div>
<hr class="filter-item">
{% endfor %}
</div>
