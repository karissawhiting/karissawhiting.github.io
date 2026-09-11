```{=html}
<%
const MONTHS = ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"];
const mainItems = items.filter(function (item) { return !item.misc; });
const miscItems = items.filter(function (item) { return item.misc; });
%>
<ul class="software-list">
<% for (const item of mainItems) { %>
<%
  const d = new Date(item.date);
  const dateDisplay = (item.date_display && item.date_display.length)
    ? item.date_display
    : MONTHS[d.getUTCMonth()] + " " + d.getUTCFullYear();
  const primaryUrl = item.website_url || item.slides_url || item.video_url || item.github_url || item.paper_url || "";
%>
  <li class="software-entry">
    <div class="software-line">
      <span class="software-title"><% if (primaryUrl.length) { %><a href="<%= primaryUrl %>" target="_blank"><strong><% if (item.role && item.role.length) { %><%= item.role %>, <% } %><%= item.title %></strong></a><% } else { %><strong><% if (item.role && item.role.length) { %><%= item.role %>, <% } %><%= item.title %></strong><% } %></span>
      <span class="software-type-label software-type-<%= item.type.toLowerCase() %>"><%= item.type %></span>
    </div>

    <div class="software-venue"><%= item.venue %>, <%= dateDisplay %></div>

    <div class="software-links">
      <% if (item.website_url && item.website_url.length) { %>
        <a class="software-badge" href="<%= item.website_url %>" target="_blank"><i class="bi bi-globe"></i> Website</a>
      <% } %>
      <% if (item.github_url && item.github_url.length) { %>
        <a class="software-badge" href="<%= item.github_url %>" target="_blank"><i class="bi bi-github"></i> GitHub</a>
      <% } %>
      <% if (item.slides_url && item.slides_url.length) { %>
        <a class="software-badge" href="<%= item.slides_url %>" target="_blank"><i class="bi bi-file-earmark-slides"></i> Slides</a>
      <% } %>
      <% if (item.video_url && item.video_url.length) { %>
        <a class="software-badge" href="<%= item.video_url %>" target="_blank"><i class="bi bi-camera-video"></i> Recording</a>
      <% } %>
      <% if (item.paper_url && item.paper_url.length) { %>
        <a class="software-badge" href="<%= item.paper_url %>" target="_blank"><i class="bi bi-file-earmark-text"></i> Paper</a>
      <% } %>
    </div>
  </li>
<% } %>
</ul>
<% if (miscItems.length) { %>
<details class="presentations-misc">
  <summary>Other Presentations</summary>
  <ul class="software-list">
  <% for (const item of miscItems) { %>
<%
  const d = new Date(item.date);
  const dateDisplay = (item.date_display && item.date_display.length)
    ? item.date_display
    : MONTHS[d.getUTCMonth()] + " " + d.getUTCFullYear();
  const primaryUrl = item.website_url || item.slides_url || item.video_url || item.github_url || item.paper_url || "";
%>
  <li class="software-entry">
    <div class="software-line">
      <span class="software-title"><% if (primaryUrl.length) { %><a href="<%= primaryUrl %>" target="_blank"><strong><% if (item.role && item.role.length) { %><%= item.role %>, <% } %><%= item.title %></strong></a><% } else { %><strong><% if (item.role && item.role.length) { %><%= item.role %>, <% } %><%= item.title %></strong><% } %></span>
      <span class="software-type-label software-type-<%= item.type.toLowerCase() %>"><%= item.type %></span>
    </div>

    <div class="software-venue"><%= item.venue %>, <%= dateDisplay %></div>

    <div class="software-links">
      <% if (item.website_url && item.website_url.length) { %>
        <a class="software-badge" href="<%= item.website_url %>" target="_blank"><i class="bi bi-globe"></i> Website</a>
      <% } %>
      <% if (item.github_url && item.github_url.length) { %>
        <a class="software-badge" href="<%= item.github_url %>" target="_blank"><i class="bi bi-github"></i> GitHub</a>
      <% } %>
      <% if (item.slides_url && item.slides_url.length) { %>
        <a class="software-badge" href="<%= item.slides_url %>" target="_blank"><i class="bi bi-file-earmark-slides"></i> Slides</a>
      <% } %>
      <% if (item.video_url && item.video_url.length) { %>
        <a class="software-badge" href="<%= item.video_url %>" target="_blank"><i class="bi bi-camera-video"></i> Recording</a>
      <% } %>
      <% if (item.paper_url && item.paper_url.length) { %>
        <a class="software-badge" href="<%= item.paper_url %>" target="_blank"><i class="bi bi-file-earmark-text"></i> Paper</a>
      <% } %>
    </div>
  </li>
  <% } %>
  </ul>
</details>
<% } %>
```
