```{=html}
<ul class="software-list">
<% for (const item of items) { %>
  <li class="software-entry">
    <div class="software-line">
      <span class="software-title"><a href="<%= item.html_url %>" target="_blank"><strong><%= item.title %></strong></a></span><% if (item.role && item.role.length) { %> <span class="software-role">(<%= item.role %>)</span><% } %><% if (item.description && item.description.length) { %> - <span class="software-description"><%= item.description %></span><% } %>
    </div>

    <div class="software-links">
      <% if (item.html_url && item.html_url.length) { %>
        <a class="software-badge" href="<%= item.html_url %>" target="_blank"><i class="bi bi-globe"></i> Docs</a>
      <% } %>
      <% if (item.github_url && item.github_url.length) { %>
        <a class="software-badge" href="<%= item.github_url %>" target="_blank"><i class="bi bi-github"></i> GitHub</a>
      <% } %>
      <% if (item.paper_url && item.paper_url.length) { %>
        <a class="software-badge" href="<%= item.paper_url %>" target="_blank"><i class="bi bi-file-earmark-text"></i> Paper</a>
      <% } %>
    </div>
  </li>
<% } %>
</ul>
```
