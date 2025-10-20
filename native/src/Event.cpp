#include "Event.hpp"

#include <algorithm>

template<typename... Args>
void Event<Args...>::hook(const std::function<void(Args...)>& func) {
    callbacks.push_back(func);
}

template<typename... Args>
void Event<Args...>::unHook(const std::function<void(Args...)>& func) {
    auto it = std::remove_if(callbacks.begin(), callbacks.end(), [&](const std::function<void(Args...)>& f) {
        return f.target_type() == func.target_type() && f.template target<void(*)(Args...)>() == func.template target<
            void(*)(Args...)>();
    });
    callbacks.erase(it, callbacks.end());
}

template<typename... Args>
void Event<Args...>::call(Args... args) {
    for (auto& func : callbacks) func(args...);
}

template<typename... Args>
Event<Args...>& Event<Args...>::operator+=(const std::function<void(Args...)>& func) {
    hook(func);
    return *this;
}

template<typename... Args>
Event<Args...>& Event<Args...>::operator-=(const std::function<void(Args...)>& func) {
    unHook(func);
    return *this;
}

template<typename... Args>
void Event<Args...>::operator()(Args... args) const {
    call(args...);
}
