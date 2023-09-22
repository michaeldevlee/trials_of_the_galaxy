extends Boss
class_name TestBoss

onready var ray_cast = get_node("RayCast2D")
onready var mega_beam_cast = get_node("MegaBeamRayCast")
onready var beam_anim_player = get_node("BeamAnimPlayer")
onready var beam = get_node("MegaBeam")
onready var beam_area = get_node("MegaBeam/Area2D")



