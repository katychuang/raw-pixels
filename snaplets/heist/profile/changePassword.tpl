<apply template='_application'>

  <bind tag='pageHeader'>
    Change Password
  </bind>

  <bind tag='contentSecondary'>
    <apply template="profile/_sidebar"/>
  </bind>

  <bind tag='contentMain'>
    <passwordForm role="form" action="/profile/changePassword" method="POST">
      <dfErrorList ref=""/>

      <div class="form-group">
      <dfLabel class="control-label" ref="old_pass">Current Password</dfLabel>
      <dfInputPassword class="form-control" ref="old_pass" />
      <dfErrorList ref="old_pass"/>
      </div>

      <div class="form-group">
      <dfLabel class="control-label" ref="pass1">New Password</dfLabel>
      <dfInputPassword class="form-control" ref="pass1" />
      <dfErrorList ref="pass1"/>
      </div>

      <div class="form-group">
      <dfLabel class="control-label" ref="pass2">New Password Confirmation</dfLabel>
      <dfInputPassword class="form-control" ref="pass2" />
      <dfErrorList ref="pass2"/>
      </div>

      <div class="form-actions">
        <dfInputSubmit class="btn btn-success" value="Save"/>
        <a href="/profile" class="btn">Cancel</a>
      </div>
    </passwordForm>
  </bind>

</apply>

