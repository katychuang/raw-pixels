<tabs class="nav navbar-nav">
  <tab url="/browse" match="Prefix">
    Food
  </tab>
  <tab url="/nutrition" match="Prefix">
    Nutrition
  </tab>
  <tab url="/lifeline" match="Prefix">
    Lifeline
  </tab>
  <tab url="/config" match="Prefix">
    Config
  </tab>
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
