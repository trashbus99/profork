import logging
from pathlib import Path
from configgen.generators.Command import Command
from configgen.generators.controllersConfig import controllersConfig
from configgen.generators.batoceraFiles import batoceraFiles

eslog = logging.getLogger(__name__)
logging.basicConfig(level=logging.INFO)

class PCSX2MINUSGenerator(Generator):

    def generate(self, system, rom, playersControllers, gameResolution):
        # Ensure executable permissions for required files
        for filename in ["pcsx2-AVX2.AppImage", "pcsx2-SSE4.AppImage", "launcher.sh"]:
            file_path = Path(f"/userdata/system/pro/ps2minus/pcsx2/{filename}")
            if file_path.exists():
                file_path.chmod(file_path.stat().st_mode | 0o111)  # Ensure execute permissions

        rom_path = Path(rom)
        if rom_path.is_symlink():
            rom_path = rom_path.resolve()

        pcsx2minusConfig = Path("/userdata/system/pro/ps2minus/pcsx2/.config1")
        beforepcsx2minusConfig = Path("/userdata/system/pro/ps2minus/pcsx2/.config0")
        
        PCSX2MINUSGenerator.writePCSX2MINUSConfig(str(pcsx2minusConfig), str(beforepcsx2minusConfig), system, playersControllers)
        commandArray = ["/userdata/system/pro/ps2minus/launcher.sh", str(rom_path)]
        
        return Command(
            commandArray,
            env={"QT_QPA_PLATFORM": "xcb", "SDL_GAMECONTROLLERCONFIG": controllersConfig.generateSdlGameControllerConfig(playersControllers)}
        )
