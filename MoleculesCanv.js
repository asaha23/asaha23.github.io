// module aliases
var Engine = Matter.Engine,
    World = Matter.World,
    Bodies = Matter.Bodies;
	Constraint = Matter.Constraint;
	Body = Matter.Body;
	
//global vaiables	
var engine;	
var world;
var cnv;
var Particle1;
var Particle2;

function setup(){
	//set canvas position
	cnv = createCanvas(600,800);
	var x = (windowWidth - width) / 2;
    var y = (windowHeight - height) / 2;
	cnv.position(x, y);
	engine = Engine.create();
	world = engine.world;
	Engine.run(engine);
	engine.world.gravity.y = 0.05;
	engine.world.gravity.x = 0;
	
	//set canvas boundaries 
	World.add(world, [
        Bodies.rectangle(300, height, width, 50, { isStatic: true }),
        Bodies.rectangle(width, 400, 50, height, { isStatic: true }),
        Bodies.rectangle(300, 0, width, 50, { isStatic: true }),
        Bodies.rectangle(0, 400, 50, height, { isStatic: true })
    ]);
	
	var partC = Bodies.circle(x, y, 30),
	
	
		
}

function draw(){
	
	background(170);
	
	
	
}