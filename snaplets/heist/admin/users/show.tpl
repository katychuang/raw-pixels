<apply template='_application'>

  <bind tag='pageHeader'>
    User Details
  </bind>


  <bind tag='contentSecondary'>
    <apply template='admin/_sidebar'/>
  </bind>


  <bind tag='contentMain'>
  <userView>

    <div class="row">
      <div class="col-md-6">

        <h2 class="shead">User Info</h2>

        <h4>Login</h4>
        <p><userLogin/></p>

        <h4>Email</h4>
        <p><userEmail/></p>

        <h4>Active?</h4>
        <p><userActive/></p>

        <h4>Login Count</h4>
        <p><userLoginCount/></p>

        <h4>Last Login</h4>
        <p><userLastLoginAt/></p>

        <h4>Last IP</h4>
        <p><userLastLoginIP/></p>
      </div>

    </div>

    <div class="form-actions">
      <a href="${usersItemEditPath}" class="btn btn-success">Edit This User</a>

      <a href="/admin/users" class="btn">Return To Listing</a>
    </div>



  </userView>
  </bind>

</apply>


