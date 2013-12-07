<apply template="_base">
  <apply template="_navbar"/>
  <div class="container">
    <div class="row">

      <div class="col-lg-2 col-md-2 col-sm-6 col-xs-12">
        <div class='sidecol sidebar-nav'>
          <contentSecondary/>
        </div>
      </div>

      <div class="col-lg-10 col-md-10 col-sm-6 col-xs-12">
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
    <div id="footer" class="row">
            <div class="col-md-12">
              <footer>
                <p>&copy; Kat Chuang</p>
              </footer>
            </div>
          </div>
  </div>
</apply>
