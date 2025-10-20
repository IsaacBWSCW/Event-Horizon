#pragma once

#include "Event.hpp"

class Object {
public:
    virtual ~Object() = default;

    void update();
    void draw();

protected:
    double posX = 0, posY = 0;
    double lastPosX = 0, lastPosY = 0;
    double accelX = 0, accelY = 0;

    Event<> onUpdate;
    Event<> onDraw;
};
