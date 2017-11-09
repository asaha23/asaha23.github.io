// module aliases
var Engine = Matter.Engine,
    Render = Matter.Render,
    World = Matter.World,
    Bodies = Matter.Bodies;

// create an engine
var engine;
var world;
var boxes = [];
var ground;

function setup(){
	createCanvas(400,400);
	engine = Engine.create();
	world = engine.world;
			
    // run the engine
    Engine.run(engine);
	var options = {
	isStatic : true
	}
	ground = Bodies.rectangle(200,height,width,10,options);
	World.add(world,ground);
	//box1 = new Box(200,210,50,50);
	//console.log(circle);
}

function mousePressed(){
	boxes.push(new Box(mouseX,mouseY,20,20));
		}

function draw(){
background(35);	
for (var i = 0;i < boxes.length;i++){
boxes[i].show();
}
//rect(circle.position.x,circle.position.y,60,60);
}