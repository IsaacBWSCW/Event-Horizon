#pragma once
#include <functional>

template<typename... Args>
class Event {
public:
    void hook(const std::function<void(Args...)>& func);
    void unHook(const std::function<void(Args...)>& func);
    void call(Args... args);

    Event& operator+=(const std::function<void(Args...)>& func);
    Event& operator-=(const std::function<void(Args...)>& func);
    void operator()(Args... args) const;

private:
    std::vector<std::function<void(Args...)>> callbacks;
};
