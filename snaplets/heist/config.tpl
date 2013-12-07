<apply template="_application">


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
    <!-- Loop through jawbone feed -->
    <div id="config"></div>

  </div>

</div><!-- .row -->
</div><!-- .container -->

</apply>
