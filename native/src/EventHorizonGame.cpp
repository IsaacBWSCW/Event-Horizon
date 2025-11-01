#include "EventHorizonGame.hpp"

#include <godot_cpp/classes/resource_loader.hpp>
#include <godot_cpp/classes/sprite2d.hpp>
#include <godot_cpp/classes/texture_rect.hpp>

using namespace eventHorizon;

void EventHorizonGame::_bind_methods() {}

void EventHorizonGame::_ready() {
    shipController = memnew(EventHorizonShipController);
    add_child(shipController);
}

void EventHorizonGame::_process(const double p_delta) {
    shipController->accelerate(glm::dvec2{0.0, -1.0});
    shipController->update(p_delta);
}
