<apply template="base">
  <head>
    <script src="/js/d3.v3.min.js"></script>
    <script src="http://code.highcharts.com/highcharts.js"></script>
    <script src="http://code.highcharts.com/modules/exporting.js"></script>
  </head>

<div class="container">
  <div id="jawbonebackground"></div>
  <h1 class="page-header">Jawbone Up Lifeline</h1>
  <!--
  Example of D3 chart of jawbone data
  https://gist.github.com/robu3/6141560
  -->

  <div class="row">
    <div class="col-lg-12 col-md-12">
      <p>My (in)activity over the past 30 days. Each day is a point on the spiral, with the points closest to the center being the most recent. Color indicates activity and size indicates the number of hours slept on that day.</p>
      <div id="exampleLifeline"></div>
      <div id="canvas"></div>
    </div>


  </div>
</div>
<script type='text/javascript' src='/js/up.js'></script>
<!-- <script src="/js/custom.js" type="text/javascript"></script> -->
<!-- <script src="/js/custom2.js" type="text/javascript"></script> -->
</apply>
