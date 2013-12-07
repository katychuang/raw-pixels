<apply template='_application'>

  <bind tag='pageHeader'>
    Edit User
  </bind>

  <bind tag='contentSecondary'>
    <apply template='admin/_sidebar'/>
  </bind>

  <bind tag='contentMain'>
    <userView>
    <userForm by="id" action="${usersItemShowPath}" method="POST">
      <apply template="admin/users/_form"/>
    </userForm>
    </userView>

  </bind>

</apply>


