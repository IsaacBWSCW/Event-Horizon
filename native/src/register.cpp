#include <gdextension_interface.h>
#include <godot_cpp/godot.hpp>
#include <godot_cpp/core/defs.hpp>

#include "EventHorizonGame.hpp"

using namespace godot;

void initializeEngineModule(const ModuleInitializationLevel level) {
    if (level != MODULE_INITIALIZATION_LEVEL_SCENE) return;
    GDREGISTER_RUNTIME_CLASS(EventHorizonGame);
}

void unInitializeEngineModule(const ModuleInitializationLevel level) {}

extern "C" GDExtensionBool GDE_EXPORT nativeExtensionEntry(
    const GDExtensionInterfaceGetProcAddress gdExtensionInterfaceGetProcAddress,
    const GDExtensionClassLibraryPtr gdExtensionClassLibraryPtr, GDExtensionInitialization* gdExtensionInitialization) {
    const GDExtensionBinding::InitObject initObject(gdExtensionInterfaceGetProcAddress, gdExtensionClassLibraryPtr,
                                                    gdExtensionInitialization);
    initObject.register_initializer(initializeEngineModule);
    initObject.register_terminator(unInitializeEngineModule);
    initObject.set_minimum_library_initialization_level(MODULE_INITIALIZATION_LEVEL_SCENE);

    return initObject.init();
}
