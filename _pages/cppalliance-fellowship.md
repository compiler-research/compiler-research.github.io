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
  :root {
    --brand-blue: #004481;
    --brand-gold: #d4a017;
    --light-bg: #f8faff;
  }

  /* Container & Typography */
  .fellowship-container {
    line-height: 1.6;
    color: #333;
    word-wrap: break-word;
    overflow: visible !important; /* CRITICAL: Allows badge to float outside */
  }

  /* Responsive Hero Box */
  .hero-box {
    position: relative;
    border: 2px solid var(--brand-blue);
    border-left: 10px solid var(--brand-blue) !important;
    background-color: var(--light-bg);
    margin-top: 35px; /* Room for badge */
    padding: 2rem 1.5rem;
    overflow: visible !important;
  }

  .status-badge {
    position: absolute;
    top: -12px;
    right: 15px;
    background: var(--brand-blue);
    color: white;
    padding: 2px 12px;
    border-radius: 10px;
    font-weight: bold;
    font-size: 11px;
    z-index: 10;
    white-space: nowrap;
    box-shadow: 0 2px 4px rgba(0,0,0,0.1);
  }

  .section-header {
    border-left: 5px solid var(--brand-blue);
    padding-left: 12px;
    margin: 40px 0 20px 0;
    color: var(--brand-blue);
    font-weight: bold;
    text-transform: uppercase;
    font-size: 1.2em;
  }

  /* List Styling */
  .highlight-list { padding: 0 0 0 5px; }
  .highlight-list li {
    margin-bottom: 12px;
    display: flex;
    align-items: flex-start;
  }
  .highlight-list .glyphicon {
    color: var(--brand-blue);
    margin-right: 12px;
    margin-top: 4px;
    min-width: 20px;
    flex-shrink: 0; /* Prevents icon from squeezing text */
  }

  /* --- MODERN RESPONSIVE TABLE (THE "STACK" METHOD) --- */
  .table-fellowship { width: 100%; border-collapse: collapse; margin-top: 10px; }
  .table-fellowship thead { background: var(--brand-blue); color: white; }
  .table-fellowship th, .table-fellowship td { padding: 12px; border: 1px solid #eee; }

  @media (max-width: 767px) {
    /* Hide table headers on mobile */
    .table-fellowship thead { display: none; }
    .status-badge {
      right: 5px;
      font-size: 10px;
    }

    .hero-box h1 { font-size: 1.8em; }

    /* Stack Table */
    .table-fellowship thead { display: none; }
    .table-fellowship, .table-fellowship tbody, .table-fellowship tr, .table-fellowship td {
      display: block; width: 100%;
    }
    .table-fellowship tr {
      margin-bottom: 15px;
      border: 1px solid var(--brand-blue);
      border-radius: 8px;
    }
    .table-fellowship td {
      text-align: right;
      padding-left: 45%;
      position: relative;
      border: none;
      border-bottom: 1px solid #eee;
    }
    .table-fellowship td:before {
      content: attr(data-label);
      position: absolute;
      left: 10px;
      width: 40%;
      font-weight: bold;
      text-align: left;
      color: var(--brand-blue);
    }

    .mobile-left-pad { padding-left: 15px !important; margin-top: 20px; }
    .btn-brand { width: 100%; text-align: center; }
  }

  /* Consistent Panels */
  .stipend-panel, .apply-panel {
    background: #fcfcfc;
    border: 1px solid #e1e4e8;
    border-left: 8px solid var(--brand-blue);
    padding: 20px;
    border-radius: 8px;
    margin-top: 20px;
  }

  .btn-brand {
    background: var(--brand-blue);
    color: white !important;
    font-weight: bold;
    text-transform: uppercase;
    padding: 12px 25px;
    display: inline-block;
    border-radius: 4px;
    text-decoration: none !important;
  }
</style>

<div class="fellowship-container">

  <div class="hero-box">
    <span class="status-badge">★ APPLICATIONS OPEN: MAR 15 – MAY 1</span>
    <h1 style="color: var(--brand-blue); font-weight: 800; margin-top: 0; font-size: 2.2em;">
      Build the parts of Clang<br>
      <small style="color: #666;">that matter next.</small>
    </h1>
    <p class="lead">A remote, mentor-driven fellowship focusing on high-impact upstream contributions to the LLVM project.</p>
  </div>

  <div class="row">
    <div class="col-xs-12">
      <p>The <strong>CppAlliance Fellowship</strong> provides a structured environment for contributors to land production-quality code in the LLVM main branch, supported by experienced maintainers.</p>
    </div>
  </div>

  <h2 class="section-header">Program Highlights</h2>
  <div class="row">
    <div class="col-md-6">
      <ul class="list-unstyled highlight-list">
        <li><span class="glyphicon glyphicon-globe"></span> <div><strong>Global & Remote:</strong> Open worldwide with flexible participation.</div></li>
        <li><span class="glyphicon glyphicon-ok"></span> <div><strong>Upstream First:</strong> Real contributions merged into Clang and clang-tidy.</div></li>
        <li><span class="glyphicon glyphicon-user"></span> <div><strong>Mentor-Driven:</strong> Direct guidance from LLVM maintainers.</div></li>
      </ul>
    </div>
    <div class="col-md-6 mobile-left-pad" style="border-left: 1px solid #eee; padding-left: 30px;">
      <p style="font-weight: bold; color: var(--brand-gold);">Technical Scope:</p>
      <ul class="list-unstyled highlight-list">
        <li><span class="glyphicon glyphicon-bookmark"></span> <div>Language & Standards support (C++20/23/26).</div></li>
        <li><span class="glyphicon glyphicon-flash"></span> <div>Compiler performance and memory scalability.</div></li>
        <li><span class="glyphicon glyphicon-wrench"></span> <div>Diagnostics and developer experience.</div></li>
      </ul>
    </div>
  </div>

  <div style="margin-top: 20px;">
    <a href="{{ '/open_projects?tag=cppalliance-fellow-26' | relative_url }}" class="btn btn-brand">Explore Projects List</a>
  </div>

  <h2 class="section-header">Program Timeline</h2>
  <table class="table-fellowship">
    <thead>
      <tr>
        <th>Phase</th>
        <th>Dates</th>
        <th>Description</th>
      </tr>
    </thead>
    <tbody>
      <tr>
        <td data-label="Phase">Applications</td>
        <td data-label="Dates">Mar 1 – May 1</td>
        <td data-label="Description">Proposal submission</td>
      </tr>
      <tr style="background: #fffdf5;">
        <td data-label="Phase"><strong>Bonding</strong></td>
        <td data-label="Dates">May 4 – May 24</td>
        <td data-label="Description">Project planning</td>
      </tr>
      <tr>
        <td data-label="Phase"><strong>Coding 1</strong></td>
        <td data-label="Dates">May 25 – Jul 26</td>
        <td data-label="Description">Active development</td>
      </tr>
      <tr style="background: #fffdf5;">
        <td data-label="Phase"><strong>Midterm</strong></td>
        <td data-label="Dates">Jul 27 – Aug 2</td>
        <td data-label="Description">Progress review</td>
      </tr>
      <tr>
        <td data-label="Phase"><strong>Coding 2</strong></td>
        <td data-label="Dates">Aug 3 – Oct 25</td>
        <td data-label="Description">Final implementation</td>
      </tr>
    </tbody>
  </table>

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
      <div class="col-sm-4 text-center mobile-no-border" style="border-left: 1px solid #eee;">
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
        <a target="_blank" href="https://forms.gle/AYgrJthYCRmBwwFL8" class="btn btn-brand" style="background: #d9534f;">Express Interest</a>
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
