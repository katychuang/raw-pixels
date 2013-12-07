<apply template="_base">
  <apply template="_navbar"/>
  <div class="container">
    <div class="row">

      <div class="col-md-12">
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
            </div>
          </div>

          <div id="footer" class="row">
            <footer>
              <p>&copy; Public Domain</p>
            </footer>
          </div>
        </div>
      </div>

    </div>


  </div> <!-- /container -->
</apply>
