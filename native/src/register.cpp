#include <gdextension_interface.h>
#include <godot_cpp/godot.hpp>
#include <godot_cpp/core/defs.hpp>

#include "EventHorizonGame.hpp"
#include "EventHorizonShipController.hpp"

using namespace godot;

void initializeModule(const ModuleInitializationLevel level) {
    if (level != MODULE_INITIALIZATION_LEVEL_SCENE) return;
    GDREGISTER_RUNTIME_CLASS(eventHorizon::EventHorizonGame);
    GDREGISTER_RUNTIME_CLASS(eventHorizon::EventHorizonShipController);
}

void unInitializeModule(const ModuleInitializationLevel level) {}

extern "C" GDExtensionBool GDE_EXPORT nativeExtensionEntry(
    const GDExtensionInterfaceGetProcAddress gdExtensionInterfaceGetProcAddress,
    const GDExtensionClassLibraryPtr gdExtensionClassLibraryPtr, GDExtensionInitialization* gdExtensionInitialization) {
    const GDExtensionBinding::InitObject initObject(gdExtensionInterfaceGetProcAddress, gdExtensionClassLibraryPtr,
                                                    gdExtensionInitialization);
    initObject.register_initializer(initializeModule);
    initObject.register_terminator(unInitializeModule);
    initObject.set_minimum_library_initialization_level(MODULE_INITIALIZATION_LEVEL_SCENE);

    return initObject.init();
}
