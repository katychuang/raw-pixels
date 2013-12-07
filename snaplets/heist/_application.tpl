<apply template="_base">
  <apply template="_navbar"/>
  <div class="container">
    <div class="row">

      <div class="col-md-3">
        <div class='sidecol well sidebar-nav'>
          <contentSecondary/>
        </div>
      </div>

      <div class="col-md-9">
        <div class='content'>
          <div class='row'>
            <div class="page-header">
              <h1> 
                <pageHeader/>
                <small> <pageTagline/> </small>
              </h1>
            </div>
          </div>

          <div class="row">
            <flash type='warning'/>
            <flash type='error'/>
            <flash type='success'/>
            <flash type='info'/>
          </div>

          <div class="row">
            <div class="col-md-12">
              <apply-content/>
              <contentMain/>
            </div>
          </div>
        </div>
      </div>

    </div>
  </div>
</apply>
