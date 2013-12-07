<apply template="_application">
  <script src="/js/d3.v3.min.js"></script>
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
<bind tag="contentSecondary">
    <p>
      This is template application demonstrating real-world use of the Snap
      Framework.
    </p>
  </bind>

  <bind tag="pageHeader">
    <h1 class="page-header">Raw Pixels</h1>
  </bind>
<div class="container">

<!--
The following color types are supported: RGB; HSL; HSV; Hex; Name (from http://www.w3.org/TR/css3-color/#svg-color)
-->

<div class="row">

  <div class="col-lg-7 col-md-7">

  <img src="http://distilleryimage10.ak.instagram.com/a00debf236c611e3a1e322000a9e0853_8.jpg" class="img-responsive">

  </div>

  <div class="col-lg-5 col-md-5">
    <h4 style="text-align:left">Users' Interaction</h4>
    <ol id="flow">
      <li>Restaurant Foods</li>
      <li>Browse food items</li>
      <li>Check Nutrition Facts</li>
      <li>Config the chart</li>
    </ol>
    <a href="/instagram/shakeshack" class="btn btn-small btn-info">Ready? Let's go</a>
    <div id="exampleTree"></div>
    <form>
      <label><input type="radio" name="mode" value="size" checked> Size</label>
      <label><input type="radio" name="mode" value="count"> Count</label>
    </form>


  </div>

  </div>
</div>

<!-- <script src="/js/home_d3.js" type="text/javascript"></script> -->
</apply>
