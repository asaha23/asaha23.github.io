// module aliases
var Engine = Matter.Engine,
    World = Matter.World,
    Bodies = Matter.Bodies;

//global vaiables	
var engine;	
var world;
var mycircles = [];
var ground;

function setup(){
	
	createCanvas(600,800);
	engine = Engine.create();
	engine.world.gravity.y = 0.05;
	engine.world.gravity.x = 0;
	world = engine.world;
	}
	World.add(world, [
        Bodies.rectangle(300, height, width, 50, { isStatic: true }),
        Bodies.rectangle(width, 400, 50, height, { isStatic: true }),
        Bodies.rectangle(300, 0, width, 50, { isStatic: true }),
	Engine.run(engine);
	var options =  {
	isStatic : true
        Bodies.rectangle(0, 400, 50, height, { isStatic: true })
    ]);

}

function mousePressed(){
	mycircles.push(new DrawCircle(mouseX,mouseY,20));
}

function draw(){
	background(35);
	for(var i = 0; i < mycircles.length ; i++){
	mycircles[i].show();
	}
	rect(0,height,width,50);
	rect(0,0,50,height);
	rect(0,0,width,50);
	rect(width,0,50,height);
	
	
}