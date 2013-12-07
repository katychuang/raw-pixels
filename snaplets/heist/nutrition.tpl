<apply template="_application">
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

  <div class="row">

    <div class="col-lg-2 col-md-2 col-sm-12 col-xs-12">
      <bind tag="contentSecondary">
        <apply template="nutrition/_sidebar"/>
      </bind>
    </div>

    <div class="col-lg-10 col-md-10 col-sm-12 col-xs-12">
      <!-- Loop through jawbone feed -->
      <div id="nutrition"></div>
      <div class="col-lg-3 col-md-3">
        <img src="http://s.cdpn.io/3/NutritionFacts.gif" class="img-responsive" />
      </div>
      <div class="col-lg-9 col-md-9">
            <div id="exampleDonut"></div>
            <div id="exampleTree"></div>
      </div>
    </div>

  </div><!-- .row -->

</div>
<script src="/static/js/home_d3.js" type="text/javascript"></script>
<script src="/static/js/config_highcharts_demo.js" type="text/javascript"></script>
</apply>


