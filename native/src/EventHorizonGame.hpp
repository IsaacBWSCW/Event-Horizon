#pragma once

#include <godot_cpp/classes/node2d.hpp>
#include <godot_cpp/classes/ref.hpp>

namespace godot {
    class EventHorizonGame final : public Node2D {
        GDCLASS(EventHorizonGame, Node2D);

    protected:
        static void _bind_methods();

    public:
        void _ready() override;

    private:
        Node2D* gameScene;
    };
}
