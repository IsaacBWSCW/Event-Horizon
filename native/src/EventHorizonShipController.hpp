#pragma once
#include <godot_cpp/classes/node2d.hpp>

namespace eventHorizon {
    class EventHorizonShipController final : public godot::Node2D {
        GDCLASS(EventHorizonShipController, godot::Node2D);

    public:
        void _ready() override;

        bool get_thrust_active() const;

    protected:
        static void _bind_methods();

    private:
    };
}
