function WaterMolecules(m,n,Identifier){
//engine.world.gravity.x = 0;
//engine.world.gravity.y = 0;

if (Identifier == 1){
var molname = 'Water.png';
}
else if ( Identifier == 2)
{
var molname = 'HydrogenPeroxide.png';
}
else if ( Identifier == 3)
{
var molname = 'Pentane.png';
}
else if ( Identifier == 4)
{
var molname = 'Mercury.png';
}
else if ( Identifier == 5)
{
var molname = 'Bromine.png';
}
else if ( Identifier == 6)
{
var molname = 'Silver.png';
}
else if ( Identifier == 7)
{
var molname = 'SiliconDioxide.png';
}

total = m*n;
//random function generator
function getrand(x) {
	var q = Math.random();
	if (q < 0) q = -q;
	return q % x;
 }
var randomnumcheckx = getrand(10);
var randomnumchecky = Math.sqrt(1- (randomnumcheckx*randomnumcheckx));
console.log(randomnumcheckx,randomnumchecky);
if (randomnumcheckx > 4){
		randomnumchecky = -randomnumchecky;
}
var stack = Composites.stack(100, 30, m, n, 2, 0, function(x, y) {
var molcircle = Matter.Bodies.circle(x, y, 25, {
      //density: 0.0001,
	  //inertia : 0,
	  //angularinertia :0,
	  mass : 18,
	  frictionAir: 0.0,
      restitution: 1.0,
      friction: 0,
      render: {
      sprite: {
      texture: molname,
	  xScale: 1.0,
      yScale: 1.0
        }
      }
    }); 

return molcircle;
})
Matter.World.add(world, [stack]);
//Matter.Engine.run(engine);
Matter.Render.run(render);

//creating horizontal constraints
if(stack1flag == 0){
for( var k=0;k <19;k++){
l = k + 1;
options1[k] = {
bodyA : stack.bodies[k],
bodyB : stack.bodies[l],
stiffness : 0.001,
render : { 
visible : false 
}
}
constraint1[k] = Matter.Constraint.create(options1[k]);
Matter.World.add(world,constraint1[k]);

}
}

//creating vertical constraints
if(stack1flag == 0){
for( var m=0;m <16;m++){
j = m + 4;
options2[m] = {
bodyA : stack.bodies[m],
bodyB : stack.bodies[j],
stiffness : 0.001,
render : { 
visible : false 
}
}
constraint2[m] = Matter.Constraint.create(options2[m]);
Matter.World.add(world,constraint2[m]);
} 
}

//checking for first set of molecules
 if(stack1flag == 0){
for (var i = 0; i < 20; i++){
positionx[i] = stack.bodies[i].position.x;
positiony[i] = stack.bodies[i].position.y;
bodynumber[i] = stack.bodies[i];
bodynumberforforces[i] = stack.bodies[i];
}
}
else 
{
//if(Newmolecules2.length != 0){
for (var newmol = arrayvalue ; newmol < arrayvalue + 1; newmol++)
{
for (var newmoli = 0; newmoli < total; newmoli++){
position2x[newmol][newmoli] = stack.bodies[newmoli].position.x;
position2y[newmol][newmoli] = stack.bodies[newmoli].position.y;
bodynumber2[newmol][newmoli] = stack.bodies[newmoli];
//}	
}
}
}
}
