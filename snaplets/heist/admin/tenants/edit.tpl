<apply template='_application'>

  <bind tag='pageHeader'>
    Edit Tenant
  </bind>

  <bind tag='contentSecondary'>
    <apply template='admin/_sidebar'/>
  </bind>

  <bind tag='contentMain'>
    <tenantView>
    <tenantForm by="id" action="${tenantsItemShowPath}" method="POST">
      <apply template="admin/tenants/_form"/>
    </tenantForm>
    </tenantView>

  </bind>

</apply>


