#include "Object.hpp"

void Object::update() {
    onUpdate.call();
}

void Object::draw() {
    onDraw.call();
}