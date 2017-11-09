function Particle(x,y,r){
	
	var x2 = x + 60/sqrt(2);
	var y2 = y + 60/sqrt(2);
	var x3 = x - 60/sqrt(2);
	var y3 = y + 60/sqrt(2);
	
	var options = {
	friction : 0,
	restitution : 1.5,
	inertia : 0,
	mass : 0,
	frictionAir : 0.01
	}
	Body1 = Bodies.circle(x,y,40,options);
	World.add(world,Body1);
	
	Body2 = Bodies.circle(x2,y2,20,options);
	World.add(world,Body2);

    Body3 = Bodies.circle(x3,y3,20,options);
	World.add(world,Body3);	
	
	this.show = function(){
		var pos1 = Body1.position;
		var angle1 = Body1.angle;
		var pos2 = Body2.position;
		var angle2 = Body2.angle;
		var pos3 = Body3.position;
		var angle3 = Body3.angle;
		
		push();
		translate(pos1.x,pos1.y);
		rotate(angle1);
		strokeWeight(1);
		stroke(255);
		fill(255,204,200);
		ellipse(0,0,40*2);
		
		pop();
		
		push();
		translate(pos2.x,pos2.y);
		rotate(angle2);
		strokeWeight(1);
		stroke(255);
		fill(255,204,200);
		ellipse(0,0,20*2);
		
		pop();
		
		push();
		translate(pos3.x,pos3.y);
		rotate(angle3);
		strokeWeight(1);
		stroke(255);
		fill(255,204,200);
		ellipse(0,0,20*2);
		
		pop();
	}
	//constraint 1
	var options = {
		bodyA: Body1.body,
		bodyB: Body2.body,
		length:60,
		stiffness:0.4
	}
	
	var constraint1 = Constraint.create(options);
	World.add(world,constraint1);
	
}