#include <gdextension_interface.h>
#include <godot_cpp/core/defs.hpp>
#include <godot_cpp/godot.hpp>

#include "core/class_db.hpp"

#include "Engine.hpp"

using namespace godot;

void initializeEngineModule(const ModuleInitializationLevel level) {
    if (level != MODULE_INITIALIZATION_LEVEL_SCENE) return;
    GDREGISTER_RUNTIME_CLASS(Engine);
}

void unInitializeEngineModule(const ModuleInitializationLevel level) {
    if (level != MODULE_INITIALIZATION_LEVEL_SCENE) return;
}

extern "C" GDExtensionBool GDE_EXPORT nativeExtensionEntry(const GDExtensionInterfaceGetProcAddress getProcAddress,
                                                           const GDExtensionClassLibraryPtr library,
                                                           GDExtensionInitialization* initialization) {
    const GDExtensionBinding::InitObject initObject(getProcAddress, library, initialization);
    initObject.register_initializer(initializeEngineModule);
    initObject.register_terminator(unInitializeEngineModule);
    initObject.set_minimum_library_initialization_level(MODULE_INITIALIZATION_LEVEL_SCENE);

    return initObject.init();
}
