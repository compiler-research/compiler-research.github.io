---
layout: gridlay
title: "CppAlliance Fellowship @ Compiler Research"
permalink: /careers/cppalliance-fellowship/
sidebar:
  nav: "careers"
author_profile: false
---

{% include dual-banner.html
  left_logo="/images/cppalliance-logo.svg"
  right_logo="/images/cr-logo_old.png"
  caption="CppAlliance Fellowship @ Compiler-Research"
  height="20vh" %}

{::nomarkdown}

<style>
  /* --- Brand Theme Sync --- */
  :root {
    --brand-blue: #004481;
    --brand-gold: #d4a017;
    --light-bg: #f8faff;
  }

  .fellowship-container {
    line-height: 1.6;
    color: #333;
    padding: 10px 0;
  }
  
  /* Hero Box - Mobile Optimized */
  .hero-box {
    position: relative;
    text-align: left;
    padding: 2.5rem 1.5rem;
    background: var(--light-bg);
    border: 1px solid #e1e4e8;
    border-left: 8px solid var(--brand-blue);
    border-radius: 8px;
    margin-bottom: 2rem;
    box-shadow: 0 4px 15px rgba(0, 68, 129, 0.08);
  }

  .status-badge {
    position: absolute;
    top: -12px;
    right: 15px;
    background: var(--brand-blue);
    color: white;
    padding: 4px 12px;
    border-radius: 20px;
    font-weight: bold;
    font-size: 11px;
    letter-spacing: 0.5px;
    z-index: 10;
    box-shadow: 0 2px 4px rgba(0,0,0,0.1);
  }

  .section-header {
    border-left: 5px solid var(--brand-blue);
    padding-left: 12px;
    margin-top: 35px;
    margin-bottom: 20px;
    color: var(--brand-blue);
    font-weight: bold;
    text-transform: uppercase;
    letter-spacing: 1px;
    font-size: 1.25em;
  }

  /* List Style */
  .highlight-list li {
    margin-bottom: 15px;
    display: flex;
    align-items: flex-start;
  }
  .highlight-list span.glyphicon {
    color: var(--brand-blue);
    margin-right: 12px;
    margin-top: 4px;
    font-size: 1.1em;
    min-width: 20px;
  }

  /* Timeline Table */
  .table-fellowship {
    border: 1px solid #eee;
    background: white;
    font-size: 0.95em;
  }
  .table-fellowship thead {
    background: var(--brand-blue);
    color: white;
  }
  .highlight-row {
    background-color: #fffdf5 !important;
    border-left: 4px solid var(--brand-gold);
    font-weight: bold;
  }

  /* Panels */
  .stipend-panel, .apply-panel {
    background-color: #fcfcfc;
    border: 1px solid #e1e4e8;
    border-left: 8px solid var(--brand-blue);
    padding: 20px;
    border-radius: 8px;
    margin-top: 20px;
  }

  .apply-panel {
    border-color: var(--brand-blue);
    background-color: #f8faff;
  }

  .btn-brand {
    background: var(--brand-blue);
    color: white !important;
    font-weight: bold;
    text-transform: uppercase;
    border: none;
    padding: 12px 25px;
    transition: 0.2s;
    display: inline-block;
    border-radius: 4px;
    text-decoration: none !important;
  }

  /* --- Mobile Specific Overrides --- */
  @media (max-width: 767px) {
    .hero-box {
      padding: 2rem 1rem;
      border-left-width: 6px;
    }
    .hero-box h1 {
      font-size: 1.8em;
      margin-top: 10px;
    }
    .status-badge {
      position: relative;
      display: inline-block;
      top: 0;
      right: 0;
      margin-bottom: 15px;
    }
    .mobile-border-none {
      border-left: none !important;
      padding-left: 0 !important;
      margin-left: 0 !important;
      margin-top: 20px;
    }
    .section-header {
      font-size: 1.1em;
    }
    .btn-brand {
      width: 100%;
      text-align: center;
    }
    .stipend-panel .col-sm-4 {
      margin-top: 20px;
      padding-top: 20px;
      border-top: 1px solid #eee;
    }
  }
</style>

<div class="fellowship-container">

  <div class="hero-box">
    <div class="status-badge">★ APPLICATIONS OPEN: MAR 15 – MAY 1</div>
    <h1 style="color: var(--brand-blue); font-weight: 800;">Build the parts of Clang<br><small style="color: #666;">that matter next.</small></h1>
    <p class="lead">A remote, mentor-driven fellowship focusing on high-impact upstream contributions to the LLVM project.</p>
  </div>

  <div class="row">
    <div class="col-xs-12">
      <p>Clang is one of the most widely used compilers in the world. The <strong>CppAlliance Fellowship</strong> provides a structured environment for contributors to land production-quality code in the LLVM main branch, supported by experienced maintainers.</p>
    </div>
  </div>

  <h2 class="section-header">Program & Project Highlights</h2>
  <div class="row">
    <div class="col-md-6">
      <ul class="list-unstyled highlight-list">
        <li><span class="glyphicon glyphicon-globe"></span> <div><strong>Global & Remote:</strong> Open worldwide with flexible participation.</div></li>
        <li><span class="glyphicon glyphicon-ok"></span> <div><strong>Upstream First:</strong> Real contributions merged into Clang and clang-tidy.</div></li>
        <li><span class="glyphicon glyphicon-user"></span> <div><strong>Mentor-Driven:</strong> Direct guidance from LLVM maintainers.</div></li>
      </ul>
    </div>
    <div class="col-md-6 mobile-border-none" style="border-left: 1px solid #eee; padding-left: 30px;">
      <p style="font-weight: bold; color: var(--brand-gold);">Technical Scope:</p>
      <ul class="list-unstyled highlight-list">
        <li><span class="glyphicon glyphicon-bookmark"></span> <div>Language & Standards support (C++20/23/26).</div></li>
        <li><span class="glyphicon glyphicon-flash"></span> <div>Compiler performance and memory scalability.</div></li>
        <li><span class="glyphicon glyphicon-wrench"></span> <div>Diagnostics and developer experience.</div></li>
      </ul>
    </div>
  </div>

  <div style="margin-top: 30px;">
    <a href="{{ '/open_projects?tag=cppalliance-fellow-26' | relative_url }}" class="btn btn-brand">Explore Projects List</a>
  </div>

  <h2 class="section-header">Program Timeline</h2>
  <div class="table-responsive" style="border: none;">
    <table class="table table-fellowship">
      <thead>
        <tr>
          <th>Phase</th>
          <th>Dates</th>
          <th>Description</th>
        </tr>
      </thead>
      <tbody>
        <tr><td>Applications</td><td>Mar 15 – May 1</td><td>Proposal submission</td></tr>
        <tr class="highlight-row"><td>Selection</td><td>May 1 – May 3</td><td>Technical review and final selection</td></tr>
        <tr><td>Community Bonding</td><td>May 4 – May 24</td><td>Project planning</td></tr>
        <tr class="highlight-row"><td><strong>Coding Period 1</strong></td><td>May 25 – Jul 26</td><td>Active development</td></tr>
        <tr><td>Midterm Evaluation</td><td>Jul 27 – Aug 2</td><td>Progress review and first stipend milestone</td></tr>
        <tr class="highlight-row"><td><strong>Coding Period 2</strong></td><td>Aug 3 – Oct 25</td><td>Final implementation</td></tr>
        <tr><td><strong>Final Evaluation</strong></td><td>Aug 3 – Oct 25</td><td>Final implementation</td></tr>
      </tbody>
    </table>
  </div>

  <h2 class="section-header">Stipends and Support</h2>
  <div class="stipend-panel">
    <div class="row">
      <div class="col-sm-8">
        <p>We provide a stipend to support focused technical work, calculated using the <strong>GSoC GDP-adjusted tables</strong> to ensure fair compensation relative to your location.</p>
        <ul class="highlight-list list-unstyled">
          <li><span class="glyphicon glyphicon-calendar"></span> <div><strong>Disbursement:</strong> Paid in two 50% installments.</div></li>
          <li><span class="glyphicon glyphicon-check"></span> <div><strong>Milestones:</strong> Released upon passing Midterm and Final evaluations.</div></li>
        </ul>
      </div>
      <div class="col-sm-4 text-center mobile-border-none" style="border-left: 1px solid #eee;">
        <h3 style="margin-top: 0; color: var(--brand-blue); font-weight: 800;">6 Months</h3>
        <p class="small">Equivalent Effort</p>
      </div>
    </div>
  </div>

  <div class="apply-panel">
    <div class="row">
      <div class="col-md-8">
        <h2 style="margin-top:0; color: var(--brand-blue); font-weight: 800;">How to Apply</h2>
        <p>Submit a technical proposal via email. Reference a project from our list and include your plan for implementation and testing.</p>
        <p>
          <a href="https://discord.gg/Vkv3ne4zVK" style="font-weight: bold; color: var(--brand-blue);">
            <span class="glyphicon glyphicon-comment"></span> Questions? Ask on Discord
          </a>
        </p>
      </div>
      <div class="col-md-4 text-center" style="padding-top: 10px;">
        <a href="mailto:vvasilev@cern.ch" class="btn btn-brand" style="background: #d9534f;">Submit Proposal</a>
      </div>
    </div>
  </div>

  <hr>
  <div class="text-center text-muted" style="font-size: 0.9em;">
    <p>Part of the <a href="/">Compiler Research</a> initiative in collaboration with <a href="https://cppalliance.org/">CppAlliance</a>.</p>
  </div>
</div>

{:/}
