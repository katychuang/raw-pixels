<apply template='_application'>

  <bind tag='pageHeader'>
    Tenant Details
  </bind>


  <bind tag='contentSecondary'>
    <apply template='admin/_sidebar'/>
  </bind>


  <bind tag='contentMain'>
  <tenantView>

    <div class="row">
      <div class="col-md-6">

        <h2 class="shead">Tenant Info</h2>

        <h4>Name</h4>
        <p><tenantName/></p>

        <h4>Subdomain</h4>
        <p><tenantSubdomain/></p>

        <h4>Active?</h4>
        <p><tenantActive/></p>

        <h4>Created at</h4>
        <p><tenantCreated/></p>

        <h4>Updated at</h4>
        <p><tenantUpdated/></p>
      </div>

    </div>

    <div class="form-actions">
      <a href="${tenantsItemEditPath}" class="btn btn-success">Edit This Tenant</a>

      <a href="/admin/tenants" class="btn">Return To Listing</a>
    </div>



  </tenantView>
  </bind>

</apply>


