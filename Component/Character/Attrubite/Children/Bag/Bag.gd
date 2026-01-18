class_name Bag

extends InterfaceNode

@export var panel: PanelContainer

var bag_item_list: Array[BagItem] = []
var tween: Tween

func _enter_tree() -> void:
    for child in %ListContainer.get_children():
        if child is BagItem:
            child.bag = self
            bag_item_list.append(child)
    reset()

func switch():
    if tween:
        tween.kill()
    tween = create_tween().set_parallel(true)
    if !visible:
        visible = true
        tween.tween_property(self, "modulate:a", 1.0, 0.05)
    else:
        tween.tween_property(self, "modulate:a", 0.0, 0.05)
        tween.finished.connect(func(): visible = false)

func reset():
    if tween:
        tween.kill()
    visible = false
    modulate.a = 0.0


func _process(delta: float) -> void:
    if Input.is_action_just_pressed("BagSwitch"):
        switch()
