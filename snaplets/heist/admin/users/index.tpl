<apply template='_application'>

  <bind tag='pageHeader'>
    <a href="admin/users/new" class="btn btn-success pull-right">Create New User</a>
    Users
  </bind>

  <bind tag='pageTagline'>
    Manage your users here.
  </bind>


  <bind tag='contentSecondary'>
    <apply template='admin/_sidebar'/>
  </bind>

  <bind tag='contentMain'>

    <table class="table table-striped userList">
      <thead>
        <tr>
          <th>Login</th>
          <th>Email</th>
          <th>Logins</th>
          <th>Last Login</th>
          <th>Last IP</th>
        </tr>
      </thead>
      <tbody>
        <userListing>
          <tr>
            <td><a href="${usersItemShowPath}"><userLogin/></a></td>
            <td><userEmail/></td>
            <td><userLoginCount/></td>
            <td><userLastLoginAt/></td>
            <td><userLastLoginIP/></td>
          </tr>
        </userListing>
      </tbody>
    </table>

    <script >
      $(function() {
      $("table.userList").tablesorter({ sortList: [[0,0]] });
      });
    </script>

  </bind>

</apply>


