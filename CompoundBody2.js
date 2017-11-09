//Declaring variables
var myCanvas = document.getElementById('world');
var context = myCanvas.getContext('2d');
var engine = Matter.Engine.create();
var world = engine.world;
var Constraint = Matter.Constraint
var MouseConstraint = Matter.MouseConstraint;
var compoundBodyA;
var Composites = Matter.Composites;
var Mouse = Matter.Mouse;
var stack;
var MolSlider;
var positionx = [];
var positiony =[];
var bodynumber = [];
var mConstraint;
var startinit = 0;
var stack1flag = 0;
var position2x = [][];
var position2y =[][];
var bodynumber2 = [][];
var resetflag = 0;

engine.world.gravity.y = 0;

//pause button
function myFunction() {
Matter.Render.stop(render);
for (var i = 0; i < 20 ; i++){
bodynumber[i].isSleeping = true;
}
if (bodynumber2.length != 0){

for (var i = 0; i < total ; i++){
bodynumber2[i].isSleeping = true;
}
}}

//creating renderer
var render = Matter.Render.create({
  canvas: myCanvas,
  engine: engine,
  options: {
    width: 600,
    height: 700,
    background: '#303030',
    wireframes: false,
    showAngleIndicator: false
  }
});

//Add molecules
var Newmolecules2 = [];
function myFunctionN(){
	stack1flag += 1;
	Newmolecules2[0] = new WaterMolecules(MolSlider,1);
	Matter.World.add(world, [Newmolecules2[0]]);
}

//creating initial stack of molecules
var Newmolecules1 = new WaterMolecules(4,5);

//walls
var floor = Matter.Bodies.rectangle(300,700, 600, 100, {
  isStatic: true,
  restitution: 1.0,
  friction : 0,
  render: {
  visible: true
  }
});

var leftwall = Matter.Bodies.rectangle(0,400, 50, 700, {
  isStatic: true,
  restitution: 1.0,
  friction : 0,
  render: {
  visible: true
  }
});

var rightwall = Matter.Bodies.rectangle(600,400, 50, 700, {
  isStatic: true,
  restitution: 1.0,
  friction : 0,
  render: {
  visible: true
  }
});

//roof
var roof = Matter.Bodies.rectangle(300,0, 700, 50, {
  isStatic: true,
  restitution: 1.0,
  friction : 0,
  render: {
    visible: true
  }
});

//Adding objects to the world
Matter.World.add(world, [floor,leftwall,rightwall,roof]);
Matter.World.add(world, [Newmolecules1]);

//Renderer
Matter.Engine.run(engine);
Matter.Render.run(render);

function applyinitforce(){
	for (i =0 ; i < 20; i+=2){
Matter.Body.applyForce(bodynumber[i],{x : positionx[i] + Math.random()*0.01, y : positiony[i] +  Math.random()*0.01},{ x:Math.random()*0.001,y:Math.random()*0.001});   
}
for (i =1 ; i < 20; i+=2){
Matter.Body.applyForce(bodynumber[i],{x : positionx[i] + Math.random()*0.01, y : positiony[i] +  Math.random()*0.01},{ x:-1*Math.random()*0.001,y:Math.random()*0.001});   
}}

//Start function
function myFunctionS(){
  if(startinit == 0){
   applyinitforce();
   startinit++;
}

engine.world.gravity.y = 0.0004;

for (var i = 0; i < 20 ; i++){
bodynumber[i].isSleeping = false;
}
if (bodynumber2.length != 0){
for (var i = 0; i < total ; i++){
bodynumber2[i].isSleeping = false;
}} 
}

//range of slider
function showValue(newValue)
{
document.getElementById("range").innerHTML = newValue;
MolSlider = newValue;

}

//reset function
function myFunctionR(){
engine.world.gravity.y = 0;
startinit = 0;
Matter.World.clear(engine.world);
Matter.Engine.clear(engine);
Matter.World.add(world, [floor,leftwall,rightwall,roof]);
var Newmolecules1 = new WaterMolecules(4,5);
Matter.World.add(world, [Newmolecules1]);
}

