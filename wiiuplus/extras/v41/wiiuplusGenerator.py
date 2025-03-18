import logging
from pathlib import Path
from configgen.generators.Command import Command
from configgen.generators.controllersConfig import controllersConfig

eslog = logging.getLogger(__name__)
logging.basicConfig(level=logging.INFO)

class WiiUPlusGenerator:
    def generate(self, system, rom, playersControllers, gameResolution):
        rom_path = Path(rom)
        if rom_path.is_symlink():
            rom_path = rom_path.resolve()
        
        cemu_appimage = Path("/userdata/system/pro/wiiuplus/cemu/cemu.AppImage")
        if cemu_appimage.exists():
            cemu_appimage.chmod(cemu_appimage.stat().st_mode | 0o111)  # Ensure execute permissions
        
        commandArray = ["/userdata/system/pro/wiiuplus/launcher.sh", str(rom_path)]
        
        return Command(
            commandArray,
            env={"QT_QPA_PLATFORM": "xcb", "SDL_GAMECONTROLLERCONFIG": controllersConfig.generateSdlGameControllerConfig(playersControllers)}
        )
