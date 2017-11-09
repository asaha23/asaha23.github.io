var myCanvas = document.getElementById('world');
var engine = Matter.Engine.create();
var world = engine.world;
var compoundBodyA;

var render = Matter.Render.create({
  canvas: myCanvas,
  engine: engine,
  options: {
    width: 600,
    height: 800,
    background: '#303030',
    wireframes: false,
    showAngleIndicator: false
  }
});

function Molecule(x,y){
	
	var x2 = x + 60/Math.sqrt(2);
	var y2 = y + 60/Math.sqrt(2);
	var x3 = x - 60/Math.sqrt(2);
	var y3 = y + 60/Math.sqrt(2);
	
var ball1 = Matter.Bodies.circle(x, y, 40, {
  density: 0.04,
  friction: 0.01,
  frictionAir: 0.00001,
  restitution: 1.5,
  render: {
    fillStyle: '#F35e66',
    strokeStyle: 'black',
    lineWidth: 1
  }
});

var ball2 = Matter.Bodies.circle(x2, y2, 20, {
  density: 0.04,
  friction: 0.01,
  frictionAir: 0.00001,
  restitution: 1.5,
  render: {
    fillStyle: '#F35e66',
    strokeStyle: 'black',
    lineWidth: 1
  }
});

var ball3 = Matter.Bodies.circle(x3, y3, 20, {
  density: 0.04,
  friction: 0.01,
  frictionAir: 0.00001,
  restitution: 1.5,
  render: {
    fillStyle: '#F35e66',
    strokeStyle: 'black',
    lineWidth: 1
  }
});

 compoundBodyA = Matter.Body.create({
        parts: [ball1, ball2 ,ball3]
    });
} //end of molecule

var Molecule1 = new Molecule(250,300);
var Molecule2 = new Molecule(360,300);

var floor = Matter.Bodies.rectangle(300,800, 600, 100, {
  isStatic: true,
  render: {
    visible: false
  }
});
Matter.World.add(world, floor);



Matter.World.add(world, [compoundBodyA]);

Matter.Engine.run(engine);
Matter.Render.run(render);