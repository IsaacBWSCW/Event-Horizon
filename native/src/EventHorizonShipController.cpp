#include "EventHorizonShipController.hpp"

using namespace eventHorizon;
using namespace godot;

void EventHorizonShipController::_bind_methods() {
    ClassDB::bind_method(D_METHOD("get_thrust_active"), &EventHorizonShipController::get_thrust_active);
    ADD_PROPERTY(
        PropertyInfo(Variant::BOOL, "thrust_active", PROPERTY_HINT_NONE, "", PROPERTY_USAGE_DEFAULT |
            PROPERTY_USAGE_READ_ONLY), "", "get_thrust_active");
}

void EventHorizonShipController::_ready() {}
bool EventHorizonShipController::get_thrust_active() const { return thrustActive; }

void EventHorizonShipController::update(const double deltaTime) {
    const glm::dvec2 velocity = truePosition - trueLastPosition;
    trueLastPosition = truePosition;
    truePosition += velocity + acceleration * deltaTime * deltaTime;
    acceleration = glm::dvec2{0};
}
void EventHorizonShipController::accelerate(const glm::dvec2 accel) { acceleration += accel; }

