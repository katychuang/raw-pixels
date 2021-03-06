
function show_source(target){
  target.slideDown();
}

function set_source(f, target){
  f();
  target.text(f.toString())
}

function input_example(){
  var cw = Raphael.colorwheel($("#input_example .colorwheel")[0],150);
  cw.input($("#input_example input")[0]);
}

function callback_example(){
  var cw = Raphael.colorwheel($("#callback_example .colorwheel")[0],150),
      onchange_el = $("#callback_example .onchange"),
      ondrag_el = $("#callback_example .ondrag");
      cw.color("#F00");

  function start(){ondrag_el.show()}
  function stop(){ondrag_el.hide()}

  cw.ondrag(start, stop);
  cw.onchange(function(color)
    {
      var colors = [parseInt(color.r), parseInt(color.g), parseInt(color.b)]
      onchange_el.css("background", color.hex).text("RGB:"+colors.join(", "))
    })

}

function cycle_example(){
  var position = 0,
      letters = [],
      colorwheel;


  function setup_the_letters(){
    var cycle = $(".cycle"),
        l = cycle.text().split("");

    cycle.html("");

    for (var i=0; i < l.length; i++) {
      var letter = $("<span>"+l[i]+"</span>");
      cycle.append(letter);
      letters.push(letter);
    };
  }

  function update(color){
    position++;
    if(position > letters.length-1){ position = 0; }
    letters[position].css("color", color.hex);
  }

  colorwheel = Raphael.colorwheel($("#cycle_example .colorwheel")[0],150);
  setup_the_letters();
  colorwheel.onchange(update).color("#864343");
}

function colorChange(color) {
    var tiny = tinycolor(color);

    var output = [
            "hex:\t" + tiny.toHexString(),
            "hex8:\t" + tiny.toHex8String(),
            "rgb:\t" + tiny.toRgbString(),
            "hsl:\t" + tiny.toHslString(),
            "hsv:\t" + tiny.toHsvString(),
    ].join("\n");

    $("#code-output").text(output).css("border-color", tiny.toHexString());

    var filters = $("#filter-output").toggleClass("invisible", !tiny.ok);

    filters.find(".lighten").css("background-color",
        tinycolor.lighten(tiny, 20).toHexString()
    );
    filters.find(".darken").css("background-color",
        tinycolor.darken(tiny, 20).toHexString()
    );
    filters.find(".saturate").css("background-color",
         tinycolor.saturate(tiny, 20).toHexString()
     );
    filters.find(".desaturate").css("background-color",
         tinycolor.desaturate(tiny, 20).toHexString()
     );
    filters.find(".greyscale").css("background-color",
         tinycolor.greyscale(tiny).toHexString()
     );

    var allColors = [];
    for (var i in tinycolor.names) {
            allColors.push(i);
    }

     var combines = $("#combine-output").toggleClass("invisible", !tiny.ok);

     var triad = tinycolor.triad(tiny);
     combines.find(".triad").html($.map(triad, function(e) {
         return '<span style="background:'+e.toHexString()+'"></span>'
     }).join(''));

     var tetrad = tinycolor.tetrad(tiny);
     combines.find(".tetrad").html($.map(tetrad, function(e) {
         return '<span style="background:'+e.toHexString()+'"></span>'
     }).join(''));

     var mono = tinycolor.monochromatic(tiny);
     combines.find(".mono").html($.map(mono, function(e) {
         return '<span style="background:'+e.toHexString()+'"></span>'
     }).join(''));

     var analogous = tinycolor.analogous(tiny);
     combines.find(".analogous").html($.map(analogous, function(e) {
         return '<span style="background:'+e.toHexString()+'"></span>'
     }).join(''));

     var sc = tinycolor.splitcomplement(tiny);
     combines.find(".sc").html($.map(sc, function(e) {
         return '<span style="background:'+e.toHexString()+'"></span>'
     }).join(''));
}

function redraw_Pie(generatedColors){

    var colors = generatedColors,
      categories = ['Calories', 'Fat', 'Cholesterol', 'Sodium', 'Carbohydrates', 'Protein', 'Vitamins'],
      name = 'Nutritional Content',
      data = [{
              y: 55.11,
              color: colors[0],
              drilldown: {
                  name: 'Calories',
                  categories: ['Total Calories', 'Calories from Fat'],
                  data: [840, 500],
                  color: colors[0]
              }
          }, {
              y: 21.63,
              color: colors[1],
              drilldown: {
                  name: 'Fat',
                  categories: ['Total', 'Saturated Fat', 'TransFat'],
                  data: [50, 22.5, 0],
                  color: colors[1]
              }
          }, {
              y: 11.94,
              color: colors[2],
              drilldown: {
                  name: 'Cholesterol',
                  categories: ['Cholesterol'],
                  data: [140],
                  color: colors[2]
              }
          }, {
              y: 7.15,
              color: colors[3],
              drilldown: {
                  name: 'Sodium',
                  categories: ['Sodium'],
                  data: [430],
                  color: colors[3]
              }
          }, {
              y: 2.14,
              color: colors[4],
              drilldown: {
                  name: 'Others',
                  categories: ['Carbs', 'Fiber', 'Sugars', 'Protein'],
                  data: [40, 2, 9, 47],
                  color: colors[4]
              }
          }];


      // Build the data arrays
      var browserData = [];
      var versionsData = [];
      for (var i = 0; i < data.length; i++) {

          // add browser data
          browserData.push({
              name: categories[i],
              y: data[i].y,
              color: data[i].color
          });

          // add version data
          for (var j = 0; j < data[i].drilldown.data.length; j++) {
              var brightness = 0.2 - (j / data[i].drilldown.data.length) / 5 ;
              versionsData.push({
                  name: data[i].drilldown.categories[j],
                  y: data[i].drilldown.data[j],
                  color: Highcharts.Color(data[i].color).brighten(brightness).get()
              });
          }
      }

    // Create the chart
    $('#exampleDonut').highcharts({
        chart: {
            type: 'pie'
        },
        title: {
            text: 'Nutritional Value, cheeseburger'
        },
        yAxis: {
            title: {
                text: 'Total percent nutritional value'
            }
        },
        plotOptions: {
            pie: {
                shadow: false,
                center: ['50%', '50%']
            }
        },
        tooltip: {
            valueSuffix: '%'
        },
        series: [{
            name: 'Nutritional value',
            data: browserData,
            size: '60%',
            dataLabels: {
                formatter: function() {
                    return this.y > 5 ? this.point.name : null;
                },
                color: 'white',
                distance: -30
            }
        }, {
            name: 'Versions',
            data: versionsData,
            size: '80%',
            innerSize: '60%',
            dataLabels: {
                formatter: function() {
                    // display only if larger than 1
                    return this.y > 1 ? '<b>'+ this.point.name +':</b> '+ this.y +'%'  : null;
                }
            }
        }]
    });
}

function genColors(startingPoint, n) {
    var n = 10;
    var tiny = tinycolor(startingPoint);
    var analogous = tinycolor.analogous(tiny);
    var colors = [];
    for (i=0; i<analogous.length; i++){
      colors.push(analogous[i].toHexString());
    }
    console.log("colors \t " + colors);
    return colors; //Returns a list of hext strings
}

$(document).ready(function(){
  //Set color
  colorChange({r: 255, g: 102, b: 0});

  Raphael.colorwheel(
    $("#show_off")[0],300).color("#FF6600").onchange(
        function(c){
          colorChange(c.hex);
          redraw_Pie(genColors(c.hex));
    });

});

