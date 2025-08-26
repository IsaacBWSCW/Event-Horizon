class_name Orbit
extends RefCounted

var gravitational_parameter: float = 0     # Standard gravitational parameter (μ)
var specific_angular_momentum: float = 0   # Specific angular momentum (h)
var eccentricity: float = 0                # Orbital eccentricity (e)
var semi_latus_rectum: float = 0           # Semi-latus rectum (p)
var argument_of_periapsis: float = 0       # Argument of periapsis (ω)
var true_anomaly: float = 0                # True anomaly (ν)

func from_state(position: Vector2, velocity: Vector2, gravitational_parameter: float) -> void:
	self.gravitational_parameter = gravitational_parameter
	specific_angular_momentum = position.cross(velocity)
	var eccentricity_vector: Vector2 = ((velocity.length_squared() - gravitational_parameter / position.length()) * position - position.dot(velocity) * velocity) / gravitational_parameter
	eccentricity = eccentricity_vector.length()
	semi_latus_rectum = pow(specific_angular_momentum, 2) / gravitational_parameter
	argument_of_periapsis = eccentricity_vector.angle()
	true_anomaly = position.angle() - argument_of_periapsis

func state_at(time: float) -> Dictionary:
	if abs(eccentricity - 1.0) < 0.0001:
		return _process_parabolic_orbit(time)
	elif eccentricity < 1.0:
		return _process_elliptical_orbit(time)
	else:
		return _process_hyperbolic_orbit(time)

func _process_elliptical_orbit(time: float) -> Dictionary:
	var semi_major_axis = semi_latus_rectum / (1 - pow(eccentricity, 2))
	var mean_motion = sqrt(gravitational_parameter / pow(semi_major_axis, 3))
	var eccentric_anomaly_initial = 2 * atan(sqrt((1 - eccentricity) / (1 + eccentricity)) * tan(true_anomaly / 2))
	var mean_anomaly_initial = eccentric_anomaly_initial - eccentricity * sin(eccentric_anomaly_initial)
	var mean_anomaly = mean_anomaly_initial + sign(specific_angular_momentum) * mean_motion * time
	var eccentric_anomaly = _solve_kepler(mean_anomaly, eccentricity)
	var true_anomaly_updated = 2 * atan(sqrt((1 + eccentricity) / (1 - eccentricity)) * tan(eccentric_anomaly / 2))
	var orbital_radius = semi_latus_rectum / (1 + eccentricity * cos(true_anomaly_updated))
	var position_x_orbital = orbital_radius * cos(true_anomaly_updated)
	var position_y_orbital = orbital_radius * sin(true_anomaly_updated)
	var radial_velocity = sqrt(gravitational_parameter / semi_latus_rectum) * eccentricity * sin(true_anomaly_updated)
	var transverse_velocity = sqrt(gravitational_parameter / semi_latus_rectum) * (1 + eccentricity * cos(true_anomaly_updated))
	var velocity_x_orbital = radial_velocity * cos(true_anomaly_updated) - transverse_velocity * sin(true_anomaly_updated)
	var velocity_y_orbital = radial_velocity * sin(true_anomaly_updated) + transverse_velocity * cos(true_anomaly_updated)
	var sin_arg_periapsis = sin(argument_of_periapsis)
	var cos_arg_periapsis = cos(argument_of_periapsis)
	return {
		"position": Vector2(
			position_x_orbital * cos_arg_periapsis - position_y_orbital * sin_arg_periapsis,
			position_x_orbital * sin_arg_periapsis + position_y_orbital * cos_arg_periapsis
		),
		"velocity": Vector2(
			velocity_x_orbital * cos_arg_periapsis - velocity_y_orbital * sin_arg_periapsis,
			velocity_x_orbital * sin_arg_periapsis + velocity_y_orbital * cos_arg_periapsis
		)
	}

func _process_parabolic_orbit(time: float) -> Dictionary:
	var time_scale = 0.5 * sqrt(pow(semi_latus_rectum, 3) / gravitational_parameter)
	var scaled_time = sign(specific_angular_momentum) * time / time_scale
	var parabolic_anomaly = scaled_time
	for i in range(10):
		var f = parabolic_anomaly + (1.0 / 3.0) * pow(parabolic_anomaly, 3) - scaled_time
		var f_derivative = 1 + parabolic_anomaly * parabolic_anomaly
		parabolic_anomaly -= f / f_derivative
	var true_anomaly = 2 * atan(parabolic_anomaly)
	var orbital_radius = semi_latus_rectum / (1 + cos(true_anomaly))
	var position_x_orbital = orbital_radius * cos(true_anomaly)
	var position_y_orbital = orbital_radius * sin(true_anomaly)
	var radial_velocity = gravitational_parameter / specific_angular_momentum * sin(true_anomaly)
	var transverse_velocity = gravitational_parameter / specific_angular_momentum * (1 + cos(true_anomaly))
	var velocity_x_orbital = radial_velocity * cos(true_anomaly) - transverse_velocity * sin(true_anomaly)
	var velocity_y_orbital = radial_velocity * sin(true_anomaly) + transverse_velocity * cos(true_anomaly)
	var sin_arg_periapsis = sin(argument_of_periapsis)
	var cos_arg_periapsis = cos(argument_of_periapsis)
	return {
		"position": Vector2(
			position_x_orbital * cos_arg_periapsis - position_y_orbital * sin_arg_periapsis,
			position_x_orbital * sin_arg_periapsis + position_y_orbital * cos_arg_periapsis
		),
		"velocity": Vector2(
			velocity_x_orbital * cos_arg_periapsis - velocity_y_orbital * sin_arg_periapsis,
			velocity_x_orbital * sin_arg_periapsis + velocity_y_orbital * cos_arg_periapsis
		)
	}

func _process_hyperbolic_orbit(time: float) -> Dictionary:
	var semi_major_axis = -semi_latus_rectum / (pow(eccentricity, 2) - 1)
	var mean_motion = sqrt(gravitational_parameter / pow(abs(semi_major_axis), 3))
	var initial_hyperbolic_arg = sqrt((eccentricity - 1) / (eccentricity + 1)) * tan(true_anomaly / 2)
	initial_hyperbolic_arg = clamp(initial_hyperbolic_arg, -0.999999, 0.999999)
	var initial_hyperbolic_anomaly = 2 * atanh(initial_hyperbolic_arg)
	var initial_mean_anomaly = eccentricity * sinh(initial_hyperbolic_anomaly) - initial_hyperbolic_anomaly
	var mean_anomaly = initial_mean_anomaly + sign(specific_angular_momentum) * mean_motion * time
	var hyperbolic_anomaly = _solve_hyperbolic_kepler(mean_anomaly, eccentricity)
	var true_anomaly_updated = 2 * atan(sqrt((eccentricity + 1) / (eccentricity - 1)) * tanh(hyperbolic_anomaly / 2))
	var orbital_radius = semi_latus_rectum / (1 + eccentricity * cos(true_anomaly_updated))
	var position_x_orbital = orbital_radius * cos(true_anomaly_updated)
	var position_y_orbital = orbital_radius * sin(true_anomaly_updated)
	var radial_velocity = sqrt(gravitational_parameter / semi_latus_rectum) * eccentricity * sin(true_anomaly_updated)
	var transverse_velocity = sqrt(gravitational_parameter / semi_latus_rectum) * (1 + eccentricity * cos(true_anomaly_updated))
	var velocity_x_orbital = radial_velocity * cos(true_anomaly_updated) - transverse_velocity * sin(true_anomaly_updated)
	var velocity_y_orbital = radial_velocity * sin(true_anomaly_updated) + transverse_velocity * cos(true_anomaly_updated)
	var cos_arg_periapsis = cos(argument_of_periapsis)
	var sin_arg_periapsis = sin(argument_of_periapsis)
	return {
		"position": Vector2(
			position_x_orbital * cos_arg_periapsis - position_y_orbital * sin_arg_periapsis,
			position_x_orbital * sin_arg_periapsis + position_y_orbital * cos_arg_periapsis
		),
		"velocity": Vector2(
			velocity_x_orbital * cos_arg_periapsis - velocity_y_orbital * sin_arg_periapsis,
			velocity_x_orbital * sin_arg_periapsis + velocity_y_orbital * cos_arg_periapsis
		)
	}

func _solve_kepler(M: float, e: float) -> float:
	var E = M
	for i in range(10):
		var f = E - e * sin(E) - M
		var f_prime = 1 - e * cos(E)
		E -= f / f_prime
	return E

func _solve_hyperbolic_kepler(M: float, e: float) -> float:
	var F = log(2 * abs(M) / e + 1.8) * sign(M)
	for i in range(10):
		var f = e * sinh(F) - F - M
		var f_prime = e * cosh(F) - 1
		F -= f / f_prime
	return F

func get_radius(angle: float) -> float:
	return semi_latus_rectum / (1 + eccentricity * cos(angle - argument_of_periapsis))

func get_angle_max() -> float:
	return acos(-1 / eccentricity) if eccentricity > 1 else TAU
