<apply template="_application">
<script src="http://code.highcharts.com/highcharts.js"></script>

<div class="container">

<!--
The following color types are supported: RGB; HSL; HSV; Hex; Name (from http://www.w3.org/TR/css3-color/#svg-color)
-->

<div class="row">

  <div class="col-lg-2 col-md-2 col-sm-12 col-xs-12">
    <bind tag="contentSecondary">
      <apply template="config/_sidebar"/>
    </bind>
  </div>

  <div class="col-lg-10 col-md-10 col-sm-12 col-xs-12">
    <div id="jawbonebackground"></div>
      <h1 class="page-header">My Jawbone Up Lifeline</h1>
    <!-- Loop through jawbone feed -->
    <!--
      Example of D3 chart of jawbone data
      https://gist.github.com/robu3/6141560
      -->
    <div class="col-lg-12 col-md-12">
      <p>My (in)activity over the past 30 days. Each day is a point on the spiral, with the points closest to the center being the most recent. Color indicates activity and size indicates the number of hours slept on that day.</p>

      <div id="canvas"></div>
      <div id="exampleLifeline"></div>
    </div>

  </div>

</div><!-- .row -->
</div><!-- .container -->
<script type='text/javascript' src='/static/js/up.js'></script>
<script>
$(function(){
  var url = window.location.href;
  var urlAux = url.split('=');
  var token = urlAux[1]

// $.ajax({
//       url: "https://jawbone-up-client.herokuapp.com/up/users/@me/meals",
//       dataType: 'json',
//       data: {token: token},
//       success: function(data, status) {
//         var html = "<table class='table table-striped'><tr><td>Date</td><td>Meal</td><td>Calories</td></tr>"
//         for (i=0; i<data.data.items.length; i++){
//           html = html + "<tr><td>"+ data.data.items[i].date +
//             "</td><td><a href='salad.html' class='black'>" + data.data.items[i].title  + "</a></td><td>" + data.data.items[i].details.calories + "</td></tr>";
//         }
//         $("#exampleLifeline").append(html + "</table>");
//       },
//       error: function(data, status){
//         console.log("error");
//       }
//   });
});
</script>
</apply>
