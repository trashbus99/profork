import logging
from pathlib import Path
import subprocess

eslog = logging.getLogger(__name__)
logging.basicConfig(level=logging.INFO)

def launch_game(rom):
    rom_path = Path(rom)
    if rom_path.is_symlink():
        rom_path = rom_path.resolve()
    
    launcher_script = Path("/userdata/system/pro/wiiuplus/launcher.sh")
    if not launcher_script.exists():
        eslog.error("Launcher script not found.")
        return False
    
    eslog.info(f"Launching game: {rom_path}")
    subprocess.run([str(launcher_script), str(rom_path)], check=True)
    return True
