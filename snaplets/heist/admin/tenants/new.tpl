<apply template='_application'>

  <bind tag='pageHeader'>
    Create New Tenant
  </bind>

  <bind tag='contentSecondary'>
    <apply template='admin/_sidebar'/>
  </bind>

  <bind tag='contentMain'>
    <tenantForm action="/admin/tenants" method="POST">
      <apply template="admin/tenants/_form"/>
    </tenantForm>

  </bind>

</apply>


