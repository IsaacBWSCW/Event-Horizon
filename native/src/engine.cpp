#include <godot_cpp/godot.hpp>
#include <godot_cpp/classes/node.hpp>
#include <godot_cpp/core/class_db.hpp>

using namespace godot;

class Engine : public Node
{
    GDCLASS(Engine, Node);

public:
    void say_hello() const {
        UtilityFunctions::print("Hello from C++");
    }
};