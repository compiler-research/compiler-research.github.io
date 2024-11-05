---
title: "LLVM.org Website Redesign Project Wrap Up"
layout: post
excerpt: "The LLVM.org website redesign project, part of GSoC
2024, aimed to modernize and enhance usability of llvm.org website for its community of developers. This initiative will streamline navigation, improve accessibility, and update content, transforming LLVM.org into a more user-friendly resource."
sitemap: false
author: Chaitanya Shahare
banner_image: /images/blog/gsoc-llvm-org-website-redesign-banner.png
permalink: blogs/gsoc24_chaitanya_shahare_introduction_final_blog/
date: 2024-11-04
tags: gsoc llvm website
---

### Introduction  

Hello! I’m Chaitanya, and as part of my Google Summer of Code (GSoC) 2024, I contributed to the LLVM project by redesigning the LLVM.org website. My
project, titled *Improving LLVM.org Website Look and Feel*, focused on creating
a modern, accessible, and efficient user experience for the LLVM community.
Working with Hugo as a static site generator, I aimed to improve content
organization, enhance site flexibility, and make the content management process
more accessible for contributors. 

- **Contributor:** [Chaitanya Shahare](https://github.com/Chaitanya-Shahare)
- **Mentors:** [Tanya Lattner](https://github.com/tlattner), [Vassil Vassilev](https://github.com/vgvassilev)
- **Project:** [Improve LLVM.org Website Look and Feel](https://llvm.org/OpenProjects.html#llvm_www)

### Project Overview

As part of Google Summer of Code 2024, my project focused on revamping the LLVM.org website to deliver a modern, accessible, and user-friendly experience. The project aimed to address key areas for improvement, including a refreshed design, better content organization, and simplified maintainability for developers and contributors. Using the Hugo static site generator, this project established a new modular structure and enhanced configurability for the LLVM website.

### Project Goals

The primary goals of this project included:
- **Creating a New Hugo-Based Theme**: Building a modular, reusable theme with a responsive and accessible design.
- **Improving Content Organization**: Streamlining the site’s structure to simplify navigation and information discovery.
- **Using Yaml Datafiles**: Making the website’s content management accessible, using yaml data files. Separation of data & styles.

### Key Achievements

Over the summer, the following components were developed to create the new LLVM website:

1. **Custom Hugo Theme Development**
   - Developed a reusable theme using Hugo with SCSS, focused on modularity and extendability.
   - Built custom shortcodes for key website features, such as table of contents, project cards, and events, making page creation simple and uniform.

2. **Dynamic Content Pages**
   - Created dynamic, YAML-driven pages for subprojects, GSoC projects, Developer Meetings, and Publications. This setup allows for easy additions or updates directly from YAML files without editing HTML or markdown code.

3. **Comprehensive Documentation**
   - Created extensive documentation for configuring, updating, and maintaining the site, making it easier for future contributors to onboard and extend.
   - Set up and deployed a staging environment for thorough testing and community feedback.

4. **Repository Structure and Configurability**
   - Set up two repositories: one for the main website and another for the Hugo theme, making the theme reusable across other LLVM subprojects, such as Clang.
   - Ensured the website’s key elements, such as the homepage, logo, and footer, are easily configurable via `hugo.yml` and markdown files.

### Impact on the Community

This project is an important step towards providing a more accessible and visually engaging website for the LLVM community. The modular approach with Hugo allows for rapid content updates and new page additions. The new website structure, with improved design and user experience, is expected to better serve LLVM’s diverse user base.

### Challenges and Learning

Throughout the project, there were technical challenges, especially regarding implementing reusable components and ensuring the website remained modular. The learning process involved optimizing the Hugo theme for usability, maintaining code quality, and working with community feedback to refine the designs.

### Future Directions

- **Expanding Content**: Incorporating more LLVM dev meetings pages.
- **Continuous Integration**: Add CI for checking broken links, build status, assets' sizes, etc.
- **Clang Website**: Applying this reusable theme structure to create a website for Clang.
- **Community Contributions**: Engaging with the community to ensure continuous content updates and feedback on the website’s evolving structure.

### Acknowledgements

I am incredibly grateful to my mentors, the LLVM community & the Compiler Research team for their guidance, feedback, and encouragement throughout this project. Their support was invaluable in shaping the project and addressing challenges along the way.

### Project Links

- **New Website Link:** [www-new.llvm.org](https://www-new.llvm.org/)
- **GitHub Repositories:**
    - Website Repo: [llvm/www-new](https://github.com/llvm/www-new)
    - Hugo Theme Repo: [llvm/www-template](https://github.com/llvm/www-template)
- **Personal GSoC Series for detailed logs**: [Project Diary](https://blog.chaitanyashahare.com/series/gsoc/)

This project has been a rewarding journey, and I look forward to seeing the LLVM website continue to evolve and grow with the community's needs. Thank you, Google Summer of Code, LLVM & Compiler Research for this incredible experience!