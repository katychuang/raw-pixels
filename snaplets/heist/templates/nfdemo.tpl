<apply template="base">
  <head>
    <script src="http://d3js.org/d3.v3.min.js"></script>
    <script src="http://code.highcharts.com/highcharts.js"></script>
    <script src="http://code.highcharts.com/modules/exporting.js"></script>
    <style>

      body {
        font-family: "Helvetica Neue", Helvetica, Arial, sans-serif;
        margin: auto;
        position: relative;
        width: 960px;
      }

      form {
        position: absolute;
        right: 10px;
        top: 10px;
      }

      .node {
        border: solid 1px white;
        font: 10px sans-serif;
        line-height: 12px;
        overflow: hidden;
        position: absolute;
        text-indent: 2px;
      }

    </style>

  </head>


<div class="container">
  <div class="col-lg-3 col-md-3">
    <img src="http://s.cdpn.io/3/NutritionFacts.gif" class="img-responsive" />

  </div>
  <div class="col-lg-9 col-md-9">
        <div id="exampleDonut"></div>
        <div id="exampleTree"></div>
  </div>
</div>
<script src="/js/home_d3.js" type="text/javascript"></script>
<script src="/js/config_highcharts_demo.js" type="text/javascript"></script>
</apply>


