@tool
extends Node2D

@export var spread: float = 15.0 :
	set(value):
		spread = value
		_update_spread()
	get:
		return spread

@export var temperature: float = 3000 :
	set(value):
		temperature = value
		_update_shader_param("exhaustTemperature", value)
	get:
		return temperature

@export var temperature_randomness: float = 100.0 :
	set(value):
		temperature_randomness = value
		_update_shader_param("exhaustTemperatureRandom", value)
	get:
		return temperature_randomness

@export var temperature_decay_rate: float = 2.0 :
	set(value):
		temperature_decay_rate = value
		_update_shader_param("exhaustTemperatureDecayRate", value)
	get:
		return temperature_decay_rate

@onready var particles: GPUParticles2D = $GPUParticles2D

func _ready() -> void:
	_update_spread()
	_update_all_shader_params()

func _update_spread() -> void:
	if particles and particles.process_material is ParticleProcessMaterial:
		var process_material: ParticleProcessMaterial = particles.process_material
		process_material.spread = spread

func _update_all_shader_params() -> void:
	_update_shader_param("exhaustTemperature", temperature)
	_update_shader_param("exhaustTemperatureRandom", temperature_randomness)
	_update_shader_param("exhaustTemperatureDecayRate", temperature_decay_rate)

func _update_shader_param(param_name: String, value) -> void:
	if particles and particles.material is ShaderMaterial:
		var mat: ShaderMaterial = particles.material
		mat.set_shader_parameter(param_name, value)
