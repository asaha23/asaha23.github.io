function MoleculeComb(x1,y1){

	var x2 = x1 + 60/sqrt(2);
	var y2 = y1 + 60/sqrt(2);
	var x3 = x1 - 60/sqrt(2);
	var y3 = y1 + 60/sqrt(2);
	
	var Particle1 = [];
	var Particle2 = [];
	var Particle = [];
	
	//Create atoms
	Particle1 = new Particle(x1,y1,40);
	Particle2 = new Particle(x2,y2,20);
	Particle3 = new Particle(x3,y3,20);
	
	//constraint 1
	var options = {
		bodyA: Particle1.body,
		bodyB: Particle2.body,
		length:60,
		stiffness:0.4
	}
	
	var constraint1 = Constraint.create(options);
	World.add(world,constraint1);
	
	//constraint 2
	var options = {
		bodyA: Particle1.body,
		bodyB: Particle3.body,
		length:60,
		stiffness:0.4
	}
	
	var constraint2 = Constraint.create(options);
	World.add(world,constraint2);
	
	//constraint 3
	var options = {
		bodyA: Particle2.body,
		bodyB: Particle3.body,
		length:60,
		stiffness:0.4
	}
	
	var constraint3 = Constraint.create(options);
	World.add(world,constraint3);
	
	this.show = function(){
		var pos = Particle1.body.position;
		var angle = Particle1.body.angle;
		push();
		translate(pos.x,pos.y);
		rotate(angle);
		pop();
	}
	
}