<apply template='_application'>

  <bind tag='pageHeader'>
    <a href="/admin/tenants/new" class="btn btn-success pull-right">Create New Tenant</a>
    Tenants
  </bind>

  <bind tag='pageTagline'>
    Manage your tenants here.
  </bind>


  <bind tag='contentSecondary'>
    <apply template='admin/_sidebar'/>
  </bind>

  <bind tag='contentMain'>

    <table class="table table-striped userList">
      <thead>
        <tr>
          <th>Name</th>
          <th>Subdomain</th>
          <th>Active?</th>
          <th>Created at</th>
          <th>Updated at</th>
        </tr>
      </thead>
      <tbody>
        <tenantListing>
          <tr>
            <td><a href="${tenantsItemShowPath}"><tenantName/></a></td>
            <td><tenantSubdomain/></td>
            <td><tenantActive/></td>
            <td><tenantCreated/></td>
            <td><tenantUpdated/></td>
          </tr>
        </tenantListing>
      </tbody>
    </table>

    <script >
      $(function() {
      $("table.userList").tablesorter({ sortList: [[0,0]] });
      });
    </script>

  </bind>

</apply>


