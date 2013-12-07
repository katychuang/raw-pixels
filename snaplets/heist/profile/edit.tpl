<apply template='_application'>

  <bind tag='pageHeader'>
    User Profile: <login/>
  </bind>

  <bind tag='contentSecondary'>
    <apply template="profile/_sidebar"/>
  </bind>

  <bind tag='contentMain'>
    <profileForm role="form" action="/profile/edit" method="POST">
      <dfErrorList ref=""/>

      <div class="form-group">
      <dfLabel ref="login">Username</dfLabel>
      <dfInputText class="form-control" ref="login" />
      <dfErrorList ref="login"/>
      </div>

      <div class="form-group">
      <dfLabel ref="email">Email</dfLabel>
      <dfInputText class="form-control" ref="email" />
      <dfErrorList ref="email"/>
      </div>

      <div class="form-group">
        <dfInputSubmit class="btn btn-success" value="Save"/>
        <a href="/profile" class="btn">Cancel</a>
      </div>
    </profileForm>
  </bind>

</apply>

