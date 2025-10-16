#pragma once
#include "godot_cpp/classes/node.hpp"

class Engine final : public godot::Node {
    GDCLASS(Engine, godot::Node);

protected:
    static void _bind_methods();
};
