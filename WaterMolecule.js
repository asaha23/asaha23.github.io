function WaterMolecules(m,n){
total = m*n;


var stack = Composites.stack(200, 30, m, n, 2, 2, function(x, y) {
  var partA = Matter.Bodies.circle(x, y, 15, {
  //density: 0.04,
  friction: 0.0,
  frictionAir: 0.0,
  render: {
    fillStyle: '#FF0000',
    strokeStyle: 'black',
    lineWidth: 1
  }
}),
   partB = Matter.Bodies.circle(x + 25/Math.sqrt(2), y + 25/Math.sqrt(2), 10, {
  //density: 0.04,
  friction: 0.0,
  frictionAir: 0.0,
  render: {
    fillStyle: '#ffffff',
    strokeStyle: 'black',
    lineWidth: 1
  }
}),
  partC = Matter.Bodies.circle(x - 25/Math.sqrt(2), y + 25/Math.sqrt(2), 10, {
  //density: 0.04,
  friction: 0.0,
  frictionAir: 0.00001,
  render: {
    fillStyle: '#ffffff',
    strokeStyle: 'black',
    lineWidth: 1
  }
});

         return Matter.Body.create({
            parts: [partA, partB,partC],
			restitution: 1.0,
			frictionAir: 0.0,
			//density: 0.02,
			angularinertia: 0.07,
			Mass : 0.01,
			inertia : 0,
			friction : 0 
        });
})
Matter.World.add(world, [stack]);
Matter.Engine.run(engine);
Matter.Render.run(render);
 
 if(stack1flag == 1){
for (var i = 0; i < 20; i++){
positionx[i] = stack.bodies[i].position.x;
positiony[i] = stack.bodies[i].position.y;
bodynumber[i] = stack.bodies[i];
}
}
else 
{
for (var i = 0; i < total; i++){
position2x[i] = stack.bodies[i].position.x;
position2y[i] = stack.bodies[i].position.y;
bodynumber2[i] = stack.bodies[i];	
}
}
}