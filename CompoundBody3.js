//Declaring variables
var myCanvas = document.getElementById('world');
var context = myCanvas.getContext('2d');
var engine = Matter.Engine.create();
var world = engine.world;
var compoundBodyA;
var Composites = Matter.Composites;
var stack;
var MolSlider = 0;
var volumeslider = 0;
var heatslider = 0;
var totalKE = 0;
var mvelx;
var mvely;
var mtotalvel;
var mmass;
var ke;
var systemtemp;
var totalmolecules = 20;
var MolSliderGraphX = [];
var MolSliderGraphY = [];
var roof2obj = [];
var floorobj = [];
var positionx = [];
var positiony =[];
var bodynumber = [];
var bodynumberforforces = [];
var constraint1 = [];
var options1 = [];
var constraint2 = [];
var options2 = [];
var timervalue;
var seconds;
var newtimervalue;
var mConstraint;
var startinit = 0;
var stack1flag = 0;
var arrayvalue = -1;
var toggle = true;
var xVal = 0 ;
var yVal = 20 ;
var total ;
var Moleculenumber = 20 ;
var chartind = 0;
var position2x = [];
var bTemp = 100;
var fTemp = 0;
var tempmin = -20;
var K = 1.38;
var mole = 6.022;
var MoltypeId;
    cols = 2;
for ( var i = 0; i < cols; i++ ) {
    position2x[i] = []; 
}
var position2y = [],
    cols = 2;
for ( var i = 0; i < cols; i++ ) {
    position2y[i] = []; 
}
var bodynumber2 = [],
    cols = 2;
for ( var i = 0; i < cols; i++ ) {
    bodynumber2[i] = []; 
}
var resetflag = 0;

//randomnumbergenerator
function getrand(x) {
	var q = Math.random();
	if (q < 0) q = -q;
	return q % x;
 }
 
 var randomnumber = getrand(5);
 console.log(randomnumber);

var getsim = document.getElementById('title').innerHTML;
console.log(getsim);
//Identify Simulation
if(getsim == " Making Scientific Observations with a Model ")
{
	MoltypeId = 1;
}
if(getsim == " Classifying Matter ")
{
	MoltypeId = 1;
}

var gravityX = engine.world.gravity.x;
var gravityY = engine.world.gravity.y;

//setting gravity according to state of gas

function setgravity(){
if (systemtemp >= bTemp) { // Gas case
						gravityX = 0;
						gravityY = 0;
                         } 
else if (systemtemp <= fTemp) { // Solid case
						gravityY = (bTemp - systemtemp) / (bTemp - fTemp);
						gravityX = gravityY * 2;
					      } 
else                    { // Liquid case
						gravityY = (bTemp - systemtemp) / (bTemp - fTemp);
						gravityX = gravityY * 0.6;
					     }
						 
console.log("gravity",gravityX,gravityY);
}
//openChemdbDatabase();

//pause button
function myFunction() {
if(constraint1.length != 0){
for(var delm=0;delm<19;delm++){		
Matter.World.remove(world,constraint1[delm]);	
}
//constraint1 = [];
}
if(constraint2.length != 0){
for(var deln=0;deln<16;deln++){		
Matter.World.remove(world,constraint2[deln]);
}	
//constraint2 = [];
}
//Matter.Render.stop(render);
for (var i = 0; i < 20 ; i++){
bodynumber[i].isSleeping = true;
}

if(Newmolecules2.length != 0){
for (var j = 0 ; j < Newmolecules2.length ;j ++)
{
for (var i = 0; i < total ; i++){
bodynumber2[j][i].isSleeping = true;
}
}}
}

//creating renderer
var render = Matter.Render.create({
  canvas: myCanvas,
  engine: engine,
  options: {
  width: 600,
  height: 600 ,
  background: '#303030',
  wireframes: false,
  showAngleIndicator: false
  }
});

//Add molecules
var Newmolecules2 =[];
function myFunctionN(MoltypeId){
	newtimervalue = timervalue;
	stack1flag += 1;
	arrayvalue += 1;
	Newmolecules2[arrayvalue] = new WaterMolecules(MolSlider,1,MoltypeId);
	Matter.World.add(world,[Newmolecules2[arrayvalue]]);
	chartind++;
	DrawChart(MolSlider);
	}
	
	
//creating initial stack of molecules
var Newmolecules1 = new WaterMolecules(4,5,MoltypeId);
//setting initial veocity
//applyinitvelocity();

/* //creating constraints
var options = { 
bodyA : Newmolecules1.stack.bodies[0],
bodyB : Newmolecules1.stack.bodies[1],
length : 50,
stiffness : 0.1
}

var constraint1 = Matter.constraint.create(options);
Matter.World.add(world,constraint1);  */
 
 //checking the current velocity/and kinetic energy for each molecule.
function CalculateTemp(totalmolecules){
for ( var molcount = 0;molcount < totalmolecules ; molcount++)
{
mvelx = bodynumber[molcount].velocity.x;
mvely = bodynumber[molcount].velocity.y;
mtotalvel = Math.sqrt(mvelx*mvelx + mvely*mvely);
mmass = (bodynumber[molcount].mass) * (1.6*(Math.pow(10,-24)));
ke = 0.5*mmass*mtotalvel*mtotalvel;
totalKE += ke;
var averageKE = totalKE/totalmolecules;
//console.log(mvelx,mvely,mtotalvel,mmass,ke,totalKE,totalmolecules);
}
systemtemp = ((averageKE*2*100)/(1.5*K*6.022)) + tempmin;
console.log(systemtemp,mtotalvel,mmass);
document.getElementById('temperature').innerHTML = systemtemp;
return systemtemp;
}
//detecting collision between any two molecules
/* function Moleculecollision (event){
	var pairs = event.pairs;
	//console.log(event);
	for(var i = 0; i < pairs.length; i++){
		var mollabelA = pairs[i].bodyA.label;
		var mollabelB = pairs[i].bodyB.label;
		console.log(bodyA.label,bodyB.label);
		//if(mollabelA == 'Circle Body' && mollabelB == 'Circle Body'){
		
		 //create invisible boundary
		 //Matter.World.add(world,wall);
		 //}
         
	}
	
	//groundconstraints();
}
Matter.Events.on(engine,'collisionStart',Moleculecollision); */


//basic floor 
var floor = Matter.Bodies.rectangle(300,600, 600, 50, {
  isStatic: true,
  restitution: 1.2,
  friction : 0,
  render: {
  visible: true,
  fillStyle: rgb(242,242,242)
  }
});

floor.label = "basicFloor";

//walls
function floorvalue(x,y,z) {
	this.x = x;
	this.y = y;
	this.z = z;
	
var floor = Matter.Bodies.rectangle(300,577.5, 550, 10, {
  isStatic: true,
  restitution: 1.2,
  friction : 0,
  render: {
  visible: true,
  fillStyle: rgb(x,y,z)
  }
});
return floor;
}

function rgb(r, g, b){
  return "rgb("+r+","+g+","+b+")";
}


var leftwall = Matter.Bodies.rectangle(0,300, 10, 600, {
  isStatic: true,
  restitution: 1.0,
  friction : 0,
  render: {
  visible: true
  }
});

var rightwall = Matter.Bodies.rectangle(600,300, 10, 600, {
  isStatic: true,
  restitution: 1.2,
  friction : 0,
  render: {
  visible: true
  }
});

//roof
var roof = Matter.Bodies.rectangle(300,0, 600, 10, {
  isStatic: true,
  restitution: 1.2,
  friction : 0,
  render: {
    visible: true
  }
 });
 
 //imaginary wall
 var wall = Matter.Bodies.rectangle(300,200, 600, 10, {
  isStatic: true,
  restitution: 1.0,
  friction : 0,
  render: {
    visible: false
  }
 });
  
 //roof2
function piston(volumeslider){
var roof2 = Matter.Bodies.trapezoid(300,volumeslider, 600, 25,0.10, {
  restitution: 1.2,
  isStatic : true,
   friction : 0,
     render: {
    visible: true
  }
});
return roof2;
}

//new roof
Matter.World.add(world,[leftwall,rightwall,roof,floor]);
//Matter.World.add(world, [Newmolecules1]);

//Renderer
Matter.Engine.run(engine);
Matter.Render.run(render);
Matter.World.add(world, [Newmolecules1]);

var runner = Matter.Runner.create();
Matter.Runner.run(runner, engine);

//console.log(Matter.Runner);

function callback(){
	attractiveforces();
for (i = 0; i != totalmolecules ; i++)
{
dx = 1.10;
dy = -1.500;
bodynumber[i].positionImpulse.x += dx;
bodynumber[i].positionImpulse.y += dy;
console.log("velocities",bodynumber[i].velocity.x,bodynumber[i]);
var nowsystemtemp = CalculateTemp(totalmolecules);
console.log(nowsystemtemp);
//setgravity();

}
}
Matter.Events.on(runner, "afterTick", callback);

//collision start event
function collision (event){
	var pairs = event.pairs;
	//console.log(event);
	for(var i = 0; i < pairs.length; i++){
		var labelA = pairs[i].bodyA.label;
		var labelB = pairs[i].bodyB.label;
		//console.log(bodyA.label,bodyB.label);
		if(labelA == 'Circle Body' && labelB == 'basicFloor'){
			//setgravity();
		if(constraint1.length != 0){
         for(var delm=0;delm<19;delm++){		
         Matter.World.remove(world,constraint1[delm]);	
        }	
		}
	    
		if(constraint2.length != 0){
         for(var deln=0;deln<16;deln++){		
         Matter.World.remove(world,constraint2[deln]);
         }	
         }
		 //create invisible boundary
		 //Matter.World.add(world,wall);
		 }
		 //detecting molecule collision
		 if(labelA == 'Circle Body' && labelB == 'Circle Body'){
			  
			 var collisionpositive ="yes";
			 //attractiveforces();
		 	//var nowsystemtemp = CalculateTemp(totalmolecules);
				 console.log(collisionpositive);
		 //create invisible boundary
		 //Matter.World.add(world,wall);
		 }
         
	}
}
Matter.Events.on(engine,'collisionStart',collision);

/* function attractiveforces(){
		for (i=0;i < totalmolecules ; i++){
			//var newbodynumerarray = bodynumber.splice(0);
			 var newbodyarray= [];
			 m = bodynumberforforces[i];
			 for ( j = 0; j<i;j++)
			 {
				 newbodyarray[j] = bodynumberforforces[j];
			 }
			 for (j = i+1; j < totalmolecules ;j++)
			 {
				 newbodyarray[j-1] = bodynumberforforces[j];
			 }
		 
			 //newbodyarray.splice(i,1); 
			 for (count =0 ; count < newbodyarray.length; count++){
				 var distx = newbodyarray[count].position.x - m.position.x;
				 var disty = newbodyarray[count].position.y - m.position.y;
				 totaldist = Math.sqrt(distx*distx + disty*disty);
				 
					var sx = distx ;
					var sy = disty;
					var sxynorm = Math.sqrt(sx*sx + sy*sy);
					var sxn = distx/sxynorm;
					var syn = disty/sxynorm;
				Matter.Body.applyForce(m,{x : newbodyarray[count].position.x, y : newbodyarray[count].position.y },{ x: -0.1,y:-0.1}); 	
					
				
			 }
		 }
			 //console.log("moleculenumber",m,newbodyarray,bodynumber);
			 //var mremaining = [];
			 //var mremaining = bodynumber.filter(function(e) { return e.Name != "Kristian"; }); 
			 
} */

function attractiveforces(){
	
	for (i = 0 ;i< bodynumber.length ; i++)
	{
		for ( j !=i ; j < bodynumber.length ; j++)
		{
			var magnitudex = bodynumber[i].position.x - bodynumber[j].position.x;
			var magnitudey = bodynumber[i].position.y - bodynumber[j].position.y;
			var normalizedmag = Math.sqrt(magnitudex*magnitudex + magnitudey*magnitudey);
			var nmagx = 0;
			nmagx = nmagx + (magnitudex/normalizedmag);
			var nmagy = 0;
			nmagy = nmagy +(magnitudey/normalizedmag);
			
		console.log("vectors",nmagx,nmagy);
		Matter.Body.applyForce(bodynumber[i],{x : bodynumber[j].position.x, y : bodynumber[j].position.y },{ x:nmagx,y:nmagy});
		}
	}
}




/* function applyinitforce(){
	for (i =0 ; i < 18; i+=2){
Matter.Body.applyForce(bodynumber[i],{x : positionx[i] + Math.random()*0.01, y : positiony[i] +  Math.random()*0.01},{ x:Math.random()*0.001,y:Math.random()*0.001});   
}
 for (i =1 ; i < 17; i+=2){
Matter.Body.applyForce(bodynumber[i],{x : positionx[i] + Math.random()*0.01, y : positiony[i] +  Math.random()*0.01},{ x:-1*Math.random()*0.001,y:-1*Math.random()*0.001});   
}
} */

/* function applyinitforce1(){
	for (i =0 ; i < 20; i+=1){
Matter.Body.applyForce(bodynumber[i],{x : positionx[i] + Math.random()*0.01, y : positiony[i] +  Math.random()*0.01},{ x:0,y:-1*Math.random()*0.005});   
} */
/* for (i =1 ; i < 20; i+=2){
Matter.Body.applyForce(bodynumber[i],{x : positionx[i] + Math.random()*0.01, y : positiony[i] +  Math.random()*0.01},{ x:0,y:1*Math.random()*0.005});   
} */
//} */


function applyinitforce(){
	for (i =0 ; i < 18; i+=2){
     bodynumber[i].force.x = Math.random()*0.001;
	 bodynumber[i].force.y = Math.random()*0.001;
        }
	for (i =1 ; i < 17; i+=2){
     bodynumber[i].force.x = -1*Math.random()*0.001;
	 bodynumber[i].force.y = -1*Math.random()*0.001;
        } 
     }

function applyinitvelocity(){
	for (i =0 ; i != 20; i++){
    Matter.Body.setVelocity(bodynumber[i],{x:randomnumcheckx ,y:-randomnumchecky});
	 
	         }
			 //Matter.Body.setAngularVelocity(bodynumber[0],{x: Math.PI/120 ,y: Math.PI/120});
	/* for (i =1 ; i < 17; i+=2){
     bodynumber[i].force.x = -1*Math.random()*0.0001;
	 //bodynumber[i].force.y = 1*Math.random()*0.0001;
        } */
}

function applyinitvelocity1(){
	//for (i =0 ; i < 20; i++){
     //Matter.Body.setVelocity(bodynumber[0],{x: 0 , y: -0.1*Math.random()});
	 //Matter.Body.setAngularVelocity(bodynumber[0],{x: -1*Math.PI/120 ,y: -1*Math.PI/120});
	         //}
	/* for (i =1 ; i < 17; i+=2){
     bodynumber[i].force.x = -1*Math.random()*0.0001;
	 //bodynumber[i].force.y = 1*Math.random()*0.0001;
        } */
}



/* function applyinitforce1(){
	for (i =0 ; i < 20; i++){
     bodynumber[i].force.x = 0.0001;
	 bodynumber[i].force.y = 0.0001;
        }
	for (i =1 ; i < 17; i+=2){
     bodynumber[i].force.x = -1*Math.random()*0.0001;
	 //bodynumber[i].force.y = 1*Math.random()*0.0001;
        } 
} */

//Start function
function myFunctionS(){
	//setgravityonstart();
  if(startinit == 0){
   applyinitforce();
   startinit++;
} 
engine.world.gravity.y = 0;

for (var i = 0; i < 20 ; i++){
bodynumber[i].isSleeping = false;
}
if(Newmolecules2.length !=0){
for (j = 0 ; j < Newmolecules2.length ; j++){
if (bodynumber2[j].length != 0){
for (var i = 0; i < total ; i++){
bodynumber2[j][i].isSleeping = false;
}}} }
}

//range of slider
function showValue(newValue)
{
document.getElementById("range").innerHTML = newValue;
MolSlider = newValue;
return MolSlider;
}

//volume slider
function showValue2(newValue2)
{
document.getElementById("range2").innerHTML = newValue2;
if (roof2obj.length != 0){
Matter.World.remove(world,roof2obj[0]);
}
volumeslider = Math.round(newValue2);
roof2obj[0] = new piston(volumeslider);
Matter.World.add(world,roof2obj[0]);
//Matter.Engine.run(engine);
Matter.Render.run(render);
}

//heat slider
function showValue3(newValue3)
{
	if (heatslider == 3){
		engine.world.gravity.y = 0.0;
		if (floorobj.length != 0){
			for(i=0;i<floorobj.length;i++){
		floorobj[i].restitution = 1.2;
			}
		}
	  }
document.getElementById("heatsliderval").innerHTML = newValue3;
heatslider = Math.round(newValue3);
if (floorobj.length != 0){
Matter.World.remove(world,floorobj[0]);
}
if (heatslider == 0)
{ x = 242 ; y =242 ; z = 242; }
else 
if (heatslider == 1)
{ x = 255 ; y =133 ; z = 133; }
else 
if (heatslider == 2)
{ x = 255 ; y =107 ; z = 107; }
else 
if (heatslider == 3)
{ x = 255 ; y =82 ; z = 82; }
else 
if (heatslider == 4)
{ x = 255 ; y =56 ; z = 56; }
else 
if (heatslider == 5)
{ x = 255 ; y =31 ; z = 31; }
else 
if (heatslider == -1)
{ x = 133 ; y =133 ; z = 255; }
else 
if (heatslider == -2)
{ x = 107 ; y =107 ; z = 255; }
else 
if (heatslider == -3)
{ x = 82 ; y =82 ; z = 255; }
else 
if (heatslider == -4)
{ x = 56 ; y =56 ; z = 255; }
else 
if (heatslider == -5)
{ x = 31 ; y =31 ; z = 255; }
floorobj[0] = new floorvalue(x,y,z);
Matter.World.add(world,floorobj[0]);
Matter.Render.run(render);



}


//reset function
function myFunctionR(MoltypeId){
engine.world.gravity.y = 0;
startinit = 0;
Matter.World.clear(engine.world);
Matter.Engine.clear(engine);
Matter.World.add(world, [floor,leftwall,rightwall,roof]);
var Newmolecules1 = new WaterMolecules(4,5,MoltypeId);
Matter.World.add(world,[Newmolecules1]);
}

if(chartind == 0){
DrawChart(0);
}
else {
DrawChart(MolSlider);
}
	
function DrawChart(MolSlider){

	
var yValLatest = MolSlider;

var dps = []; // dataPoints
var chart = new CanvasJS.Chart("chartContainer", {
	title :{
		text: "Output : Compounds"
	},
	axisY: {
		title : "Molecules",
		includeZero: true,
		minimum : 0,
		maximum : 65,
		//viewportMinimum : 0,
		//viewportMaximum : timervalue
	}, 
axisX: {
		title : "Time(s)",
		includeZero: false,
		valueFormatString : ""
		//interval : 1,
		//intervalType : "minute"
	}, 	
	data: [{
		type: "line",
		color: "red",
		dataPoints: dps
	}]
});


var updateInterval = 10000;
var dataLength = 60; // number of dataPoints visible at any point

var updateChart = function (count) {

	//count = count || 1;
	
	//for (var newvar = xVal; newvar < (xVal + 60); newvar++){	
    yVal = yVal + Math.round(yValLatest);
	//for keeping a count of molecules 
	totalmolecules = yVal;
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

/* //function piston(volumeslider){
volumeslider = Math.round(volumeslider);
var roof2 = Matter.Bodies.rectangle(300,0, 600, 10, {
  isStatic: true,
  restitution: 1.0,
  friction : 0,
  render: {
    visible: true
  }
});

Matter.World.add(world, [roof2]);
//Matter.Engine.run(engine);
//Matter.Render.run(render); */



/* var mouseConstraint = Matter.MouseConstraint.create(engine, { //Create Constraint
  element: myCanvas,
  constraint: {
    render: {
      visible: true
	      },
    stiffness:1.0
  }
});

//Matter.MouseConstraint.body = roof2;
Matter.World.add(world, mouseConstraint);var mouseConstraint = Matter.MouseConstraint.create(engine, { //Create Constraint
  element: myCanvas,
  constraint: {
    render: {
      visible: true
	      },
    stiffness:1.0
  }
});

//Matter.MouseConstraint.body = roof2;
Matter.World.add(world, mouseConstraint); */
