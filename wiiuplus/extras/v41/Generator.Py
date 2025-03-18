import logging
from pathlib import Path
from configgen.generators.Command import Command
from configgen.generators.controllersConfig import controllersConfig
from configgen.generators.batoceraFiles import batoceraFiles

eslog = logging.getLogger(__name__)
logging.basicConfig(level=logging.INFO)

class Generator:
    def generate(self, system, rom, playersControllers, gameResolution):
        raise NotImplementedError("This method should be implemented by subclasses.")

    @staticmethod
    def setButton(key, padGuid, padInputs, controllerNumber):
        if key in padInputs:
            input = padInputs[key]
            if input.type == "button":
                return f"engine:sdl,button:{input.id},guid:{padGuid},port:{controllerNumber}"
            elif input.type == "hat":
                return f"engine:sdl,hat:{input.id},direction:{Generator.hatdirectionvalue(input.value)},guid:{padGuid},port:{controllerNumber}"
            elif input.type == "axis":
                return f"engine:sdl,threshold:0.5,axis:{input.id},guid:{padGuid},port:{controllerNumber},invert:+"
        return ""

    @staticmethod
    def hatdirectionvalue(value):
        return {1: "up", 4: "down", 2: "right", 8: "left"}.get(int(value), "unknown")
