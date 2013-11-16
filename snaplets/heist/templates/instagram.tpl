<apply template="base">


<div class="container">

<!--
The following color types are supported: RGB; HSL; HSV; Hex; Name (from http://www.w3.org/TR/css3-color/#svg-color)
-->

<div class="row">

  <div class="col-lg-2 col-md-2 col-sm-12 col-xs-12">
    <bind tag="contentSecondary">
      <apply template="instagram/_nav_side"/>
    </bind>
  </div>

  <div class="col-lg-10 col-md-10 col-sm-12 col-xs-12">
    <!-- Loop through instagram feed -->
    <div id="instafeed"></div>

  </div>

</div><!-- .row -->
</div><!-- .container -->
<script type="text/javascript" src="/js/instafeed.min.js"></script>
<script>
    var feed = new Instafeed({
        get: 'location',
        locationId: 13765, //ShakeShack
        clientId: 'd60340d55d864859a9d3a34f50a6d816',
        limit: 50,
        tagsBurger: true,
        filter: function (image) {
          console.log(image.tags);

          if (image.tags != 'burger') {
            return false;
          }
          // otherwise keep them
          return true;
        }
        // get: 'tagged',
        // tagName: 'whatiate',
        // clientId: 'd60340d55d864859a9d3a34f50a6d816'
    });

    feed.run();

</script>
</apply>
