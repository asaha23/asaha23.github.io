function DrawChart(){

var yValLatest = MolSlider;

var dps = []; // dataPoints
var chart = new CanvasJS.Chart("chartContainer", {
	title :{
		text: "Output : Compounds1"
	},
	axisY: {
		title : "Molecules",
		includeZero: true,
		minimum : 0,
		maximum : 65,
		zoomEnabled : true,
		viewportMinimum : 0,
		viewportMaximum : 65,
		lineColor : "red"
		}, 
axisX: {
		title : "Time(s)1",
		includeZero: true,
		interval : 1,
		//intervalType : "second",
		lineColor : "red"
		}, 	
	data: [{
		type: "line",
		dataPoints: dps
	}]
});

var xVal = 00 ;
var yVal = 20 + Math.round(yValLatest);
var updateInterval = 10000;
var dataLength = 10000; // number of dataPoints visible at any point

var updateChart = function (count) {

	count = count || 1;

	for (var j = 0; j < count; j++) {
		yVal = yVal;
		dps.push({
			x: xVal,
			y: yVal
		});
		xVal++;
	}

	if (dps.length > dataLength) {
		dps.shift();
	}

	chart.render();
};

updateChart(dataLength);
setInterval(function(){updateChart()}, updateInterval);

}