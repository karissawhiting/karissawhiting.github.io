```{=html}
<ol class="publication-list">
<% for (const item of items) { %>
  <li class="publication-entry"><%= item.citation %><% if (item.link) { %> <a href="<%= item.link %>" target="_blank" rel="noopener" class="publication-link" aria-label="Link to publication">&#128279;</a><% } %></li>
<% } %>
</ol>
```
