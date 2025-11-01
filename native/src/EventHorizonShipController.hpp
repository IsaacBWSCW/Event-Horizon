#pragma once
#include <glm/glm.hpp>
#include <godot_cpp/classes/node2d.hpp>

namespace eventHorizon {
    class EventHorizonShipController final : public godot::Node2D {
        GDCLASS(EventHorizonShipController, godot::Node2D);

    public:
        void _ready() override;

        void update(double deltaTime);
        void accelerate(glm::dvec2 accel);

        [[nodiscard]] bool get_thrust_active() const;

    protected:
        static void _bind_methods();

    private:
        bool thrustActive = false;

        glm::dvec2 truePosition{0.0};
        glm::dvec2 trueLastPosition{0.0};
        glm::dvec2 acceleration{0.0};
    };
}
