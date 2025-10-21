#include "EventHorizonGame.hpp"

#include <godot_cpp/classes/resource_loader.hpp>
#include <godot_cpp/classes/sprite2d.hpp>
#include <godot_cpp/classes/texture_rect.hpp>

using namespace godot;

void EventHorizonGame::_bind_methods() {}

void EventHorizonGame::_ready() {
    gameScene = memnew(Node2D);

    Sprite2D* sprite = memnew(Sprite2D);
    const Ref<Texture2D> texture = ResourceLoader::get_singleton()->load("res://assets/ship.png");
    sprite->set_texture(texture);
    sprite->set_position(Vector2{0,0});
    gameScene->add_child(sprite);

    add_child(gameScene);
}
