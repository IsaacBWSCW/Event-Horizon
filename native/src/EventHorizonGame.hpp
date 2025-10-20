#pragma once

#include <godot_cpp/classes/node.hpp>

namespace godot {
    class EventHorizonGame final : public Node {
        GDCLASS(EventHorizonGame, godot::Node);

    protected:
        static void _bind_methods();

    public:
        EventHorizonGame();
    };
}
