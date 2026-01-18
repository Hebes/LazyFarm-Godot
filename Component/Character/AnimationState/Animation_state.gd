class_name AnimationState

extends Node2D


@onready var character: Character = get_parent()

#func _ready() -> void:
    #character.animation_tree.animation_finished.connect(on_animation_finished)

func _physics_process(_delta):
    set_animation_tree_state()

#func has_accelerate():
    #return character.current_action_state == Character.ActionState.Default || character.current_action_state == Character.ActionState.Lift || character.current_action_state == Character.ActionState.Steed

func set_animation_tree_state():
    set_loop()
    #if character.current_action_state == Character.ActionState.OneShot:
        #return
    #else:
        #set_loop()

func set_loop():
    var action_state = character.current_action_state
    character.animation_tree.set("parameters/Movement_state/blend_position", action_state)
    ## 下面是测试
    character.animation_tree.set("parameters/Movement_state/%s/%s/blend_amount" % [action_state, character.ACTION_STATE[action_state]], character.current_movement_state)
    character.animation_tree.set("parameters/Movement_state/%s/%s/blend_amount" % [action_state, character.MOVEMENT_STATE[character.current_movement_state]], character.current_face_direction)   

    #if has_accelerate():
        #if action_state == Character.ActionState.Steed:
            ## parameters/movement_state/4/steed/blend_position
            ## parameters/movement_state/4/steed/0/horse/blend_amount
            ## parameters/movement_state/4/steed/0/idle/blend_amount
           #character.animation_tree.set("parameters/Movement_state/%s/%s/blend_position" % [action_state, character.ACTION_STATE[action_state]], character.character_resource.current_steed_type)
           #character.animation_tree.set("parameters/Movement_state/%s/%s/%s/%s/blend_amount" % [action_state, character.ACTION_STATE[action_state], character.character_resource.current_steed_type, Character.STEED_TYPE[character.character_resource.current_steed_type]], character.current_movement_state)
           #character.animation_tree.set("parameters/Movement_state/%s/%s/%s/%s/blend_amount" % [action_state, character.ACTION_STATE[action_state], character.character_resource.current_steed_type, Character.MOVEMENT_STATE[character.current_movement_state]], character.current_face_direction)
        #else:
            #character.animation_tree.set("parameters/Movement_state/%s/%s/blend_amount" % [action_state, character.ACTION_STATE[action_state]], character.current_movement_state)
            #character.animation_tree.set("parameters/Movement_state/%s/%s/blend_amount" % [action_state, character.MOVEMENT_STATE[character.current_movement_state]], character.current_face_direction)
    #else:
        #character.animation_tree.set("parameters/Movement_state/%s/%s/blend_amount" % [action_state, Character.ACTION_STATE[action_state]], character.current_face_direction)

#func start_one_shot(state: Character.OneShotState):
    #character.current_action_state = Character.ActionState.OneShot
    #character.animation_tree.set("parameters/one_shot_state/blend_position", state)
    #character.animation_tree.set("parameters/one_shot_state/%s/%s/blend_amount" % [state, Character.ONESHOT_STATE[state]], character.current_face_direction)
    #character.animation_tree.set("parameters/one_shot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
    #await character.animation_tree.animation_finished
#
#func on_animation_finished(e: String):
    #character.current_action_state = Character.ActionState.Default
