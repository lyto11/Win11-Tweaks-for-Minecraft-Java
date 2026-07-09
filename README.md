# Minecraft Win11 Optimizer

A menu-driven **Windows 11 batch script** designed to optimize the system for **Minecraft and gaming performance**.  
It focuses on responsiveness, lower input latency, cleaner background activity, and a more streamlined Windows setup while keeping important Windows features protected.

## Features

- Safe, menu-based Windows 11 tweaks.
- Minecraft-focused performance options.
- Low-end PC mode.
- Streaming mode for OBS/Discord use.
- Cleanup tools for temp files, cache, Recycle Bin, and DNS.
- Detailed logging and backup support.
- Registry export backups before changes.
- Status checks and maintenance tools.
- Keep-list protection for essential Windows features.

## Kept Features

This optimizer is designed to **preserve** important Windows components and should not remove or break:

- Snipping Tool.
- Installer functionality.
- Wireless device pairing support.
- Windows Search.
- File Explorer core features.
- Windows Settings.
- Microsoft Store access when needed for app repair or updates.

## Included Files

- `Minecraft-Win11-Optimizer.bat` — main optimizer script.
- `Minecraft-Win11-Revert.bat` — separate revert script for undoing tweaks.

## Backup Location

The script creates its backup structure under:

- `C:\Program Files\Minecraft Win11 Backup`

If that location is not available, it falls back to:

- `%ProgramData%\Minecraft Win11 Backup`

Backups may include:

- Registry exports.
- Logs.
- Manifests.
- Older script versions.

## How to Use

1. Download both batch files into the same folder.
2. Right-click `Minecraft-Win11-Optimizer.bat`.
3. Run as administrator.
4. Choose the desired optimization mode.
5. If needed, run `Minecraft-Win11-Revert.bat` to undo supported changes.

## What It Can Do

- Enable or restore Game Mode settings.
- Adjust power plan behavior.
- Reduce transparency and visual effects.
- Change background app behavior.
- Tune system responsiveness for gaming.
- Suggest Minecraft RAM and JVM settings.
- Apply low-end or streaming-friendly tweaks.
- Clean temporary files and related clutter.

## Revert Script

A separate revert script is included:

- `Minecraft-Win11-Revert.bat`

This script is meant to undo changes made by the optimizer and restore backed-up settings where possible.  
It does **not** create or rely on a Windows restore point.

## Safety Notes

- Run both scripts as administrator.
- Read the prompts before confirming changes.
- Some tweaks are reversible, while others may depend on registry backups.
- Use the revert script if you want to return to a safer/default configuration.

## Minecraft Tips Included

The optimizer also prints helpful Minecraft guidance, such as:

- Recommended RAM ranges.
- Render distance suggestions.
- Fullscreen advice.
- VSync guidance.
- JVM argument recommendations.
- Java Edition performance tips.

## Project Goal

The goal is not to be a “one-click miracle booster,” but a practical and transparent Windows 11 tuning script for Minecraft players who want better performance with fewer unnecessary Windows distractions.

## Disclaimer

Use at your own risk. Always review system changes before applying them, especially on your main PC.
