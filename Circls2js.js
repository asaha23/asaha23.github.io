function DrawCircle(x,y,r){
	var options = {
	friction : 0,
	restitution : 1,
	inertia : 0,
	mass : 0,
	frictionAir : 0
	}
	this.body = Bodies.circle(x,y,r,options);
	this.r = r;
	World.add(world,this.body);
	
	this.show = function(){
		var pos = this.body.position;
		var angle = this.body.angle;
		
		push();
		translate(pos.x,pos.y);
		rotate(angle);
		ellipse(0,0,this.r,this.r);
		pop();
	}
}