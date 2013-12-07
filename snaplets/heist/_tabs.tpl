<tabs class="nav navbar-nav">
  <tab url="/admin" match="Prefix">
    Admin
  </tab>
</tabs>

<ifLoggedIn>
<ul class="nav navbar-nav navbar-right">
  <li><a href="/profile"><loggedInUser/></a></li>
  <li><a href="/sessions/destroy">logout</a></li>
</ul>
</ifLoggedIn>
