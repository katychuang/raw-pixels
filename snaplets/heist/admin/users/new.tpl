<apply template='_application'>

  <bind tag='pageHeader'>
    Create New User
  </bind>

  <bind tag='contentSecondary'>
    <apply template='admin/_sidebar'/>
  </bind>

  <bind tag='contentMain'>
    <userForm role="form" action="/admin/users" method="POST">
      <apply template="admin/users/_form"/>
    </userForm>

  </bind>

</apply>


