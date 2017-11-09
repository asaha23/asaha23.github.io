(function() {

    var World = Matter.World,
        Bodies = Matter.Bodies,
        Composites = Matter.Composites;

    Example.frictionlessBeachBalls = function(demo) {

        var engine = demo.engine,
            world = engine.world;

        // need random initialization
        var stack = Composites.stack(0, 100, 3, 1, 20, 0, function(x, y) {
            return Bodies.circle(x, y, 75, { restitution: 1, friction: 0, frictionAir: 0, frictionStatic: 0 });
        });
        World.add(world, stack);
    };

})();