function piston(volumeslider){

var roof2 = Matter.Bodies.rectangle(300,volumeslider, 600, 50, {
  isStatic: true,
  restitution: 1.0,
  friction : 0,
  render: {
    visible: true
  }
});

Matter.World.add(world, [roof2]);
Matter.Engine.run(engine);
Matter.Render.run(render);
}