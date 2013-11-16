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
        locationId: 13765,
        // locationId: [48.8635, 2.301333333],
        // locationId: 'search?lat=40.741901&lng=-73.993191',
        clientId: 'd60340d55d864859a9d3a34f50a6d816',
        //accessToken: 'cdd0464dafc1460991a570c60e54fbd9',
        limit: 50,
        template: '<a href="/nutrition/cheeseburger"><img src="{{image}}" /></a>'
    });
    feed.run();
    console.log(feed);

//https://api.instagram.com/v1/locations/search?lat=40.741901&lng=-73.993191&access_token=cdd0464dafc1460991a570c60e54fbd9
//https://instagram.com/oauth/authorize/?client_id=d60340d55d864859a9d3a34f50a6d816&redirect_uri=http://katychuang.github.com&response_type=code
/*

https://instagram.com/oauth/authorize/?client_id=dd6df5e608be407395b09a5c66cc1f27&redirect_uri=http://localhost:8000/instagram/mcdonalds&response_type=code

https://api.instagram.com/v1/locations/search?lat=48.858844&lng=2.294351&access_token=9aaccc822b0d4da1bf31c3f0ccc3e6e1
*/
</script>
</apply>
