#pragma once

#include <godot_cpp/classes/node2d.hpp>

#include "EventHorizonShipController.hpp"

namespace eventHorizon {
    class EventHorizonGame final : public godot::Node2D {
        GDCLASS(EventHorizonGame, godot::Node2D);

    protected:
        static void _bind_methods();

    public:
        void _ready() override;
        void _process(double p_delta) override;

    private:
        EventHorizonShipController* shipController = nullptr;
    };
}
