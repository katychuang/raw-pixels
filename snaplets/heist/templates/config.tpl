<apply template="base">
    <head>
    <script src="/js/raphael-2.1.0-min.js" type="text/javascript"></script>
    <script src="/js/colorwheel.js" type="text/javascript"></script>
    <script src="/js/chroma.js" type="text/javascript"></script>
    <script src="/js/chroma.palette-gen.js" type="text/javascript"></script>


    <script src="http://code.highcharts.com/highcharts.js"></script>
    <script src="http://code.highcharts.com/modules/exporting.js"></script>
  </head>


<div class="container">

<!--
The following color types are supported: RGB; HSL; HSV; Hex; Name (from http://www.w3.org/TR/css3-color/#svg-color)
-->
<h1 class="page-header">Configure Charts</h1>

<div class="row">

  <div class="col-lg-7 col-md-7">

  <div id='demo'>
    <div id='inputter'>
      <div id="show_off"></div>
      <div id="exampleDonut"></div>
    </div>

    <!-- Chart -->

  </div><!-- /end #demo -->



</div>

<div class="col-lg-5 col-md-5">
    <pre id='code-output'></pre>

    <div id='filter-output'>
       <table>
           <tr>
               <th>Lighten</th>
               <td><div class='lighten'></div></td>
           </tr>
           <tr>
               <th>Darken</th>
               <td><div class='darken'></div></td>
           </tr>
           <tr>
               <th>Saturate</th>
               <td><div class='saturate'></div></td>
           </tr>
           <tr>
               <th>Desaturate</th>
               <td><div class='desaturate'></div></td>
           </tr>
           <tr>
               <th>Greyscale</th>
               <td><div class='greyscale'></div></td>
           </tr>
       </table>
    </div>

    <div id='combine-output'>
       <table>
           <tr>
               <th>Triad</th> <td><div class='triad'></div></td>
           </tr>
           <tr>
               <th>Tetrad</th> <td><div class='tetrad'></div></td>
           </tr>
           <tr>
               <th>Monochromatic</th> <td><div class='mono'></div></td>
           </tr>
           <tr>
               <th>Analogous</th> <td><div class='analogous'></div></td>
           </tr>
           <tr>
               <th>Split Complements</th> <td><div class='sc'></div></td>
           </tr>
       </table>
    </div>




    </div>

    </div>
</div>
<script src="/js/config.js" type="text/javascript"></script>
</apply>
