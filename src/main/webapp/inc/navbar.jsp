<div class="col-sm-3 col-md-2 sidebar">
    <ul class="nav nav-sidebar">
        <li><a href="/db/">Select</a></li>
    </ul>
    <ul class="nav nav-sidebar">
        <li><a href="/db/admin/status">webDB Status</a></li>
        <li><a href="/db/admin/ping">webDB Ping</a></li>
    </ul>
    <ul class="nav nav-sidebar">
        <li><a href="/manager/status">Server Status</a></li>
    </ul>
    <% if (request.getParameter("type").equals("MySQL")) { %>
    <ul class="nav nav-sidebar">
        <li><a href="/db/raw/?q=SHOW+PROCESSLIST&amp;version=1">Process List</a></li>
        <li><a href="/db/raw/?q=SHOW+STATUS&amp;version=1">DB Status</a></li>
        <li><a href="/db/raw/?q=SHOW+TABLES&amp;version=1&amp;xsl=tableExplorer">Schema Explorer</a></li>
        <li><a href="/db/raw/?q=SHOW+TABLE+STATUS&amp;version=1">Table Status</a></li>
        <li><a href="/db/raw/?q=SHOW+VARIABLES&amp;version=1">Config</a></li>
        <li><a href="/db/raw/?q=SHOW+OPEN+TABLES&amp;version=1">Open Tables</a></li>
    </ul>
    <% } %>
</div>