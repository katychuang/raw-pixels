<apply template="base">
  <head>
    <script src="http://d3js.org/d3.v3.min.js"></script>

  </head>

<div class="container">

  <h1 class="page-header">Jawbone Up Visualization</h1>
  <!--
  Example of D3 chart of jawbone data
  https://gist.github.com/robu3/6141560
  -->

  <div class="row">
    <div class="col-lg-9 col-md-9">
      <p>My (in)activity over the past 30 days. Each day is a point on the spiral, with the points closest to the center being the most recent. Color indicates activity and size indicates the number of hours slept on that day.</p>
      <div id="canvas"></div>
    </div>
    <div class="col-lg-3 col-md-3">
      <div id="show_off" class="pull-right"></div>
    </div>
    <script type='text/javascript' src='/js/up.js'></script>
  </div>
</div>

</apply>
