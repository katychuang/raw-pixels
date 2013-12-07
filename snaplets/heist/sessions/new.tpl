<apply template="_base">

  <bind tag='pageHeader'>Snap Template - Login</bind>

  <div class="container">

    <div class="flash row">
      <flash type='warning'/>
      <flash type='error'/>
      <flash type='success'/>
      <flash type='info'/>
    </div>

    <loginForm action="/sessions" method="POST">
      <h2 class="form-signin-heading">Please sign in</h2>
      <apply template="_cg">
        <bind tag="ref">email</bind>
        <bind tag="lbl">Username</bind>
        <bind tag="val"><dfInputText ref="email" /></bind>
      </apply>

      <apply template="_cg">
        <bind tag="ref">pass</bind>
        <bind tag="lbl">Password</bind>
        <bind tag="val"><dfInputPassword ref="pass"/></bind>
      </apply>

      <div class="control-group">
        <dfInputCheckbox ref="remember" class="form-inline"/>
        <dfLabel ref="remember">
          Remember me on this computer
        </dfLabel>
      </div>

      <div class="control-group">
        <dfInputSubmit class="btn btn-primary" 
                       value="Sign in"
                       data-disable-with="Signing in..."/>
      </div>
      <a href="/admin/users/new">Create account</a>
    </loginForm>

  </div> <!-- /container -->

</apply>
