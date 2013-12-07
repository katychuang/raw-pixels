<apply template='_application'>

  <bind tag='contentSecondary'>
    <apply template="profile/_sidebar"/>
  </bind>

    <bind tag='pageHeader'>
      User Profile
    </bind>

    <bind tag='contentMain'>
      <div class="well">
        <currentUser>
        <h4>Username</h4>
        <p><userLogin/></p>
        <h4>Email</h4>
        <p><userEmail/></p>
        <h4>You last logged in at</h4>
        <p><userLastLoginAt/></p>
        <h4>From IP address</h4>
        <p><userLastLoginIP/></p>
        </currentUser>
      </div>
    </bind>

</apply>
