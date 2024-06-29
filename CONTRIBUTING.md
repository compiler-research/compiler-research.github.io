# Contribution Guide for the Compiler Research website

## BootStrap 3.3 Functionalities

The Compiler Research website is based on BootStrap 3.3. 

> Note: Some of the elements available in the latest version of BootStrap may not be available in v3.3 or may have a different name. Please see the [BootStrap 3.3 Components Documentation] to add any new supported elements.

## Home Page Customization

Depending on Jekyll's functionality, the sections shown on the website homepage are either defined in the [home.md] under [pages] or the [homepage layout] under [Layouts].

#### Homepage Layout (homelay)

The website's [homepage layout] currently consists of the following sections:

- Splash Banner ([Jumbotron])
- Cards/ [Thumbnails]
  - Projects
  - Publications
  - Presentations
  - Team
- Wells
  - [Open Projects]
  - [Project Meetings]
  - [Releases]
  - [News]
  > Note that these wells are not fluid. That is, they're made of a fixed pixel size that roughly accommodates 3-5 list items in each category.
- `{{ content }}` Placeholder 
  - Used to render the content available inside the page that is using the "homelay" layout, for example: `home.md`)
- [Blog Widget]

> Please see the [BootStrap 3.3 Components Documentation] to understand better the included elements (Jumbotron, Thumbnails, Wells, etc.).

#### home.md Page

###### Layout/ Masterpage
This is the main page for the Website's homepage, but it pulls a lot of content from the "[Homelay]" Layout, as discussed above. The layout works as a wrapper/Master Page around the content on the homepage (`home.md`). 

All the contents of the homepage (`home.md`) are rendered within the `{{ contents }}` tag within the "[Homelay]" Layout.

###### home.md contents

Everything under the "Recent Content" heading shown on the website's homepage is pulled from this file (except the Blog Widget, which is part of the `homelay` layout.)

- Include [Carousel](/_includes/carousel.html) to show a Carousel of Videos.
- Include [Open Embed script](/_includes/open-embed.html) to enable the functionality of fetching YouTube, etc. videos and embedding them into the webpage.

### Adding a new Project

#### Project Pages vs. Projects List
It is possible to 

- add a new page with a lot of project details (e.g.,
`\_pages\testproject.md`) and then: 
    - add the project excerpt to the projects directory `_data\projects.yml`,

Or, 

- only add the project excerpt to the projects directory `_data\projects.yml`
if there aren't enough details available for the project.

#### Linking to the Project Page

- Use the `link` attribute in the `projects.yml` file to define the link
to the detailed project page (if you created this in the previous step). 
- If there's no dedicated page for that page, then a link to an external website/readme/readthedocs can also be used. 
- If there is no link, then the 'link' parameter can be excluded.

The project excerpt should now automatically show up on the '/Projects/' page
along with the link to the detailed project page.

#### Change Projects Page Layout
To change the layout of the Projects page itself, you can browse to
`_pages\projects.md` and edit the Liquid code as needed.

#### Projects vs. Open Projects

The Projects page exists in parallel to the Open Projects page
(`_pages\open_projects.md`), and you should add your project details where it
makes more sense.

---

## Research

The [Research Areas] page lists the areas of research that Compiler Research Group is focused on. 

#### Excerpt vs. Detailed Page

Please add a short excerpt to introduce the research area. 

It is required to add a hyperlink to the heading of the topic, to link to an internal or external page that further explores the technical details of the Research Area, along with examples and associated projects.

#### Does it qualify as a Research Area?

Before adding a topic to this page, please consider (and discuss with the Compiler Research team) if the topic qualifies as a research area or if it is more of a [Project] that can be linked to an existing Research Area.

---

## Projects

The [Projects Page] is populated by iterating through the [Projects List] YML file. The sequence followed in the YML file is the sequence used to list down the projects on the Projects Page. 

To add a new project, simply update the [Projects List] YML file. The `link` parameter should ideally include the link to the project's GitHub repository.

---

## Results

### Publications

The [Publications Page] iterates and sorts the list of publications saved in the [Publications List] YML file. Simply add a new publication to the YML file and it will be automatically sorted based on the relevant parameters.

### Presentations

The [Presentations Page] iterates and sorts the list of presentations saved in the [Presentations List] YML file. Simply add a new presentation to the YML file and it will be automatically sorted based on the relevant parameters.

### Student Success Stories

The [Student Success Stories] is a simple markdown file. New success stories can be added sequentially to the markdown. 

Please make sure to link the **student's Github profile** and include the relevant mentor/institution names under the **"Credits"** heading.

### Tutorials

The [Tutorials Page] iterates and sorts the list of publications saved in the [Tutorials List] YML file. Simply add an abstract for the tutorial and link to the actual tutorial page in the YML file and it will be automatically sorted based on the relevant parameters. 

If the tutorial page doesn't already exist outside of the Compiler Research website, then it can be created as a markdown file under the `_pages` directory.

### Releases

The [Releases Page] is populated by iterating through the [Releases List] YML file. The sequence followed in the YML file is the sequence used to list down the projects on the Projects Page. 

To add a new release's information, simply update the [Releases List] YML file.

> Note that there is a [Software Releases widget] on the Home Page that lists the **top 5 items** from the `releases.yml` file. This is a static widget with a fixed height of 300 pixels. Each time the [Releases List] is updated, please test the widget on the homepage to make sure that the fetched text doesn't overflow from the widget.

### News

The [News Page] is populated by iterating through the [News List] YML file. The sequence followed in the YML file is the sequence used to list down the projects on the Projects Page. 

To add a new release's information, simply update the [News List] YML file.

> Note that there is a [news widget] on the Home Page that lists the **top 3 items** from the `releases.yml` file. This is a static widget with a fixed height of 300 pixels. Each time the [News List] is updated, please test the widget on the homepage to make sure that the fetched text doesn't overflow from the widget.

---

## Teams

To add yourself to the Teams page, create a PR like [this one]. Simply add relevant details to the [Contributors List] YML file and add a photo in the `images/team` folder.

---

## Join Us

### Careers

The [Careers Page] is a simple markdown file, that can be edited as needed to include new and upcoming career opportunities.

### Project Meetings

The [Project Meetings Page] iterates and sorts the list of project meetings saved in the [Project Meetings List] YML file. Simply add new project meeting details to the YML file and it will be automatically sorted based on the relevant parameters.

Please make sure to **include a PDF of the presentation slides** in the `/assets/presentations` folder and link to it in the `agenda` > `slides` parameter in the `meetinglist.yml` file.

> Note that there is a [project meetings widget] on the Home Page that lists the **top 3 items** from the `meetinglist.yml` file. This is a static widget with a fixed height of 300 pixels. Each time the [Project Meetings List] is updated, please test the widget on the homepage to make sure that the fetched text doesn't overflow from the widget.

### Team Meetings

The [Team Meetings Page] is populated by iterating through the [Team Meetings List] YML file. The sequence followed in the YML file is the sequence used to list the meetings on the Team Meetings Page. 

### Open Projects

The [Open Projects Page] is populated by iterating through the [Open Projects List] YML file. The sequence followed in the YML file is the sequence used to list the meetings on the Team Meetings Page.

Note that if you don't populate the `status` parameter in the YML file, then the project will not be listed on the Open Projects page.

> Note that there is a [open projects widget] on the Home Page that lists the **top 4 items** from the `openprojectlist.yml` file. This is a static widget with a fixed height of 300 pixels. Each time the [Open Projects List] is updated, please test the widget on the homepage to make sure that the fetched text doesn't overflow from the widget.

### Follow Us

This is a static external link to Compiler Research Organization's LinkedIn Group. This should only be updated by admins in case of a change in the LinkedIn group.

---

## Blog

### Blogs List Layout

To update the look and feel of the listed blog, please see the [Blog Post Card] file.

### Add a New Blog Post

##### How to Add a New Blog Post

To add a new Blog post, add a new markdown file under `_posts` and add any referenced images to the `/images/blog` folder, as shown in [PR 219].

> Note that there is a [latest blog widget] on the Home Page that lists the to blog post from the `_posts` directory. This is a static widget with a fixed height of 500 pixels. Each time there is a new blog file (e.g., yyyy-mm-dd-blog-name.md) added to the `_posts` directory, please test the widget on the homepage to make sure that the fetched text, especially the blog excerpt doesn't overflow from the widget.

##### File Naming Conventions

Please note the naming convention of the blog file, for example: `yyyy-mm-yy-full-blog-title.md`.

It is also recommended to name images so they can easily be associated with the blog post, for example: `yyyy-mm-yy-short-blog-title-img1.png` and `yyyy-mm-yy-short-blog-title-img2.png`.

##### Front Matter for Blogs

Please see the sample [Front Matter] below and use as many of the parameters as applicable.

```
---
title: "Your Post Title"
layout: post
excerpt: "A Short Paragraph to Display on Blogs List page"
sitemap: false
author: Your Name
permalink: blogs/blog-keywords/
banner_image: /images/blog/banner-or-other-thumbnail-image.jpg
date: yyyy-mm-dd
tags: ad
---
```

Where,

- title: This title overrides the default Jekyll behavior of using a filename for Blog Titles, using this string instead.
- layout: This should always include the value `post`.
- excerpt: A Short Paragraph to display on the Blogs List page. It should be roughly 2-3 lines. Test on localhost to see how it looks on the `/blog/` page.
- sitemap: This should always include the value `false`.
- author: Your Name
- permalink: This will make the exact link/URL of the blog post. Carefully use keywords that are relevant to the blog's SEO and preferably use 1 to 3 keywords to avoid making the URL too long.
- banner_image: This image will be shown in a square aspect ratio on the Blog List page (`/blog/`). It can be one of the images already included in the article, or preferably, a different one (use websites like pexel.com to get royalty-free, relevant images in low resolution (for a small-sized image that loads quickly)).
- date: This is an important field since blogs are sorted based on this date. If you don't want your post to appear on the top of the blog list, try an older date to move it downwards.
tags: Enter relevant keywords that should be associated with the blog post. These tags are shown as buttons under each blog post and a reader can click on them to view other posts related to that tag. Please see the blogs list page for relevant tags before creating a new one, since each tag and its related posts are listed on the `compiler-research.org/tags/` page, which can become a mess if the number of tags is not kept to a minimum.







[home.md]: /_pages/home.md
[homepage layout]: /_layouts/homelay.html
[pages]: /_pages/
[Layouts]: /_layouts/
[BootStrap 3.3 Components Documentation]: https://getbootstrap.com/docs/3.3/components/
[Jumbotron]: /_includes/jumbotron.html
[Thumbnails]: /_includes/thumbnails.html
[Open Projects]: /_includes/open-projects.html
[open projects widget]: /_includes/open-projects.html
[Project Meetings]: /_includes/project-meetings.html
[Releases]: /_includes/releases.html
[News]: /_includes/news.html
[Blog Widget]: /_includes/blog_widget.html
[Homelay]: /_layouts/homelay.html
[Research Areas]: /_pages/research.md
[Project]: /_data/projects.yml
[Projects Page]: /_pages/projects.md
[Projects List]: /_data/projects.yml
[Publications Page]: /_pages/publications.md
[Publications List]: /_data/publist.yml
[Presentations Page]: /_pages/presentations.md
[Presentations List]: /_data/preslist.yml
[Student Success Stories]: /_pages/stories.md
[Tutorials Page]: /_pages/tutorials.md
[Tutorials List]: /_data/tutorialslist.yml
[Releases Page]: /_pages/releases.md
[Releases List]: /_data/releases.yml
[Software Releases widget]: /_includes/releases.html
[News Page]: /_pages/allnews.md
[News List]: /_data/news.yml
[news widget]: /_includes/news.html
[this one]: https://github.com/compiler-research/compiler-research.github.io/pull/195
[Careers Page]: /_pages/careers.md
[Project Meetings Page]: /_pages/meetings.md
[Project Meetings List]: /_data/meetinglist.yml
[project meetings widget]: /_includes/project-meetings.html
[Team Meetings Page]: /_pages/team_meetings.md
[Team Meetings List]: /_data/standing_meetings.yml
[Blog Post Card]: /_includes/blog-post-card.html
[PR 219]: https://github.com/compiler-research/compiler-research.github.io/pull/219
[Front Matter]: https://jekyllrb.com/docs/front-matter/
[latest blog widget]: /_includes/blog_widget.html