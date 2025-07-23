extends Node2D

@onready var game := $".."

func generate_sun() -> RigidBody2D:
	randomize()
	
	var sun := RigidBody2D.new()
	sun.freeze = true
	sun.position = Vector2.ZERO
	
	var sun_radius := randf_range(1000, 1200)
	var sun_density := 100
	
	sun.mass = sun_density * PI * sun_radius * sun_radius
	
	var mesh_instance := MeshInstance2D.new()
	var mesh := SphereMesh.new()
	mesh.radius = sun_radius
	mesh.height = sun_radius*2
	mesh_instance.mesh = mesh
	
	var collision_shape := CollisionShape2D.new()
	var circle_shape := CircleShape2D.new()
	circle_shape.radius = sun_radius
	collision_shape.shape = circle_shape
	
	sun.add_child(mesh_instance)
	sun.add_child(collision_shape)
	
	return sun

func generate_planet() -> RigidBody2D:
	randomize()
	
	var planet := RigidBody2D.new()
	planet.freeze = true
	
	var planet_radius := randf_range(200, 400)
	var planet_surface_gravity = 9.8
	
	planet.mass = planet_surface_gravity * pow(planet_radius, 2) / game.G
	
	var mesh_instance := MeshInstance2D.new()
	var mesh := SphereMesh.new()
	mesh.radius = planet_radius
	mesh.height = planet_radius*2
	mesh_instance.mesh = mesh
	
	var collision_shape := CollisionShape2D.new()
	var circle_shape := CircleShape2D.new()
	circle_shape.radius = planet_radius
	collision_shape.shape = circle_shape
	
	planet.add_child(mesh_instance)
	planet.add_child(collision_shape)
	
	return planet

func generate_system(planet_count: int):
	var sun = generate_sun()
	sun.name = "Sun"
	add_child(sun)
	
	var planets := Node2D.new()
	planets.name = "Planets"
	add_child(planets)
	
	var radius_max: float = 40000
	var radius_min: float = 3000
	
	for i in range(planet_count):
		var planet = generate_planet()
		planet.name = "Planet" + str(i)
		var orbit_angle := randf_range(0, TAU)
		var orbit_radius := randf_range(radius_min, radius_max)
		planet.position = Vector2.from_angle(orbit_angle) * orbit_radius
		planets.add_child(planet)
