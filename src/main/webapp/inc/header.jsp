<div class="navbar navbar-inverse navbar-fixed-top" role="navigation">
	<div class="container-fluid">
		<div class="navbar-header">
			<button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-collapse">
                <span class="sr-only">Toggle navigation</span>
            </button>
            <a class="navbar-brand" href="./">webDB-j -  (<%= request.getParameter("jdbcString")%>)</a>
		</div>
		<div class="navbar-collapse collapse">
			<ul class="nav navbar-nav navbar-right">
                <li>	<a href="#">type: <%= request.getParameter("type") %></a></li>
                <li>	<a href="#">webDB: <%= request.getHeader("Host")%></a></li>
              	<li>	<a href="#">Server: <%= request.getLocalName() %>:<%= request.getLocalPort() %></a>	</li>
			</ul>
		</div>
	</div>
</div>