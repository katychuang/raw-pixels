/*global d3*/

// global app variable
var up = {
  width: 960,
    height: 700
};

// ## loadData(rows)
// Loads the data into the chart
function loadData(rows) {
    rows = rows.reverse();
    console.log(rows);
    var maxSteps,
        maxSleep,
        goalSteps = 10000, // 一日万歩
        goalSleep = 28800,
        minRadius = 2,
        radius = 25,
        svg = d3.select("svg"),
        colorScale;


    // find upper bounds of steps and sleep
    maxSteps = d3.max(rows, function (r) {
        return parseInt(r.m_steps);
    });

    maxSleep = d3.max(rows, function (r) {
        return parseInt(r.s_duration);
    });

    var s = goalSteps / 5;
    colorScale = d3.scale.linear()
        .domain([s, s * 2, s * 3, s * 4, goalSteps])
        .range(["#3333FF", "#9933FF", "#FF33FF", "#FF3399", "#FF3333"]);

    // draw reference circles / points
    svg.selectAll("circle.reference-point")
        .attr("r", radius);

    // color and size data points
    var rSleep = (radius - minRadius) / goalSleep;
    svg.selectAll("circle.datapoint")
        .data(rows)
        .attr("class", "point")
        .attr("r", function (d) { return minRadius + d.s_duration * rSleep; })
        .attr("style", function (d) {
            return "fill: " + colorScale(d.m_steps);
        });
}

// ## generateSpiral
// Archimedean spiral
// in polar coords: r = a + b * (theta)
function generateSpiral(width, points, step) {
    var a = 0,
        i,
        x,
        y,
        r,
        theta,
        buffer = [];

    // initialize
    points = points || 10;
    step = step || Math.PI * 0.25;

    for (i = 0; i < points; i++) {
        theta = step * i;
        r = a + width * theta;
        x = r * Math.cos(theta);
        y = r * Math.sin(theta);
        buffer.push({ x: x, y: y });
    }

    return buffer;
}

// ## drawSpiral()
// Draws the spiral and data points that make up the graph
function drawSpiral() {
    var step = Math.PI * .05,
        points = generateSpiral(22, 100, step),
        i,
        x = up.width / 2,
        y = up.height / 2,
        svg = d3.select("#canvas")
            .append("svg")
            .attr("width", up.width)
            .attr("height", up.height),
        line = d3.svg.line()
            .x(function (d) { return x + d.x; })
            .y(function (d) { return y + d.y; })
            .interpolate("cardinal"),
        // connect dots
        spiral = svg.append("path")
            .datum(points)
            .attr("class", "line")
            .attr("d", line),
        // simple tooltip
        tooltip = svg
            .append("g")
            .attr("class", "tooltip");


        // add rectangle
        tooltip.append("rect")
            .attr("width", 125)
            .attr("height", 70)
            .attr("rx", 5)
            .attr("ry", 5);

        // add text elements for tooltip
        var tooltipTextTop = tooltip
                .append("text")
                .attr("x", 5)
                .attr("y", 40)
                .attr("class", "tooltip-text"),
            tooltipTextBottom = tooltip
                .append("text")
                .attr("x", 5)
                .attr("y", 60)
                .attr("class", "tooltip-text"),
            tooltipTextTitle = tooltip
                .append("text")
                .attr("x", 5)
                .attr("y", 20)
                .attr("class", "tooltip-text tooltip-title");

    // draw points
    for (i = 0; i < points.length; i++) {
        // skip points because they are bunched together at the beginning of the spiral
        // the first entire revolution is skipped
        if (i * step < Math.PI * 2) {
            continue;
        }

        // use every other spiral vertex as a data point position
        if (i % 2 > 0) {
            continue;
        }

        // add data point circle
        svg.insert("circle", ".tooltip")
            .attr("class", "datapoint")
            .attr("r", 0)
            .attr("cx", x + points[i].x)
            .attr("cy", y + points[i].y)
            .on("mouseover", function (d) {
                var me = d3.select(this),
                    x = parseFloat(me.attr("cx")) + parseFloat(me.attr("r")) + 10,
                    y = parseFloat(me.attr("cy")) - parseFloat(tooltip.select("rect").attr("height")) / 2;

                // set tooltip text
                tooltipTextTitle
                    .text(d.date.substring(4, 6) + "/" + d.date.substring(6, 8) + "/" + d.date.substring(0, 4))
                    .style("fill", me.style("fill"));
                tooltipTextTop.text("Steps: " + parseInt(d.m_steps).toLocaleString());
                tooltipTextBottom.text("Sleep: " + parseFloat(d.s_duration / 3600).toFixed(2) + " hours");

                return tooltip
                    .style("visibility", "visible")
                    .attr("transform", "translate(" + x + "," + y + ")")
                    .select("rect")
                    .style("stroke", me.style("fill"));
            })
            .on("mouseout", function (d) {
                return tooltip.style("visibility", "hidden");
            });
    }
}

function bootstrap() {
    // draw the spiral
    drawSpiral();
    d3.csv("../up-data.csv", function (rows) {
        loadData(rows);
    });
}

bootstrap();
