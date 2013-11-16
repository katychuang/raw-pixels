$(function () {

/*
http://www.fiveguys.com/menu/nutritional-information.aspx
*/
//console.log(Highcharts.getOptions().colors);
//["#2f7ed8", "#0d233a", "#8bbc21", "#910000", "#1aadce", "#492970", "#f28f43", "#77a1e5", "#c42525", "#a6c96a"]



        var colors = Highcharts.getOptions().colors,
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
    });

