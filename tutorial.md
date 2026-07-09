# 🎮 Minecraft Win11 Optimizer v3.1.2 Tutorial

Welcome to the **Ultimate Minecraft Windows 11 Optimization Suite**. This guide will walk you through how to use the scripts to achieve the lowest input latency, highest FPS, and best stability for both Java and Bedrock editions.

---

## 🚀 Quick Start Guide

1.  **Preparation**: Ensure both `Minecraft-Win11-Optimizer.bat` and `Minecraft-Win11-Revert.bat` are in the same folder.
2.  **Launch**: Right-click `Minecraft-Win11-Optimizer.bat` and select **"Run as Administrator"**. 
    *   *Note: The script has auto-elevation, so double-clicking may also work.*
3.  **The "God Tier" Setup**: Press **`0`** on your keyboard and hit Enter.
    *   This will automatically backup your registry, create a System Restore Point, and apply every safe system optimization at once.
4.  **Restart**: Once the script finishes, **Restart your PC**. This is required to activate kernel-level timer and power plan changes.

---

## 🛠️ Key Optimization Tiers

### 1. System Engine (Recommended)
These tweaks target the Windows kernel and CPU scheduling:
*   **Core Unparking**: Stops Windows from "sleeping" CPU cores, eliminating micro-stutter.
*   **MMCSS Priority**: Gives Minecraft "High Priority" scheduling for CPU and GPU resources.
*   **BCD Timer Tuning**: Disables "Dynamic Ticks" to force a consistent hardware timer, lowering input lag.

### 2. Gaming & Visuals
*   **Mouse 1:1**: Disables "Enhance Pointer Precision" to ensure your aim is consistent.
*   **Global FSO Disable**: Prevents Windows from interfering with Minecraft's fullscreen mode.
*   **Game DVR Disable**: Shuts down background recording services that eat up FPS.

### 3. Low-End / Aggressive Mode
*   **Background Apps**: Globally stops Windows 11 apps from running in the background.
*   **Win32 Priority Separation**: Gives the foreground game more "time slices" of the CPU.

---

## ☕ Deep Java & JVM Optimization

The script includes a **JVM Flag Generator** (Option 3 -> 1). 

### Why JVM Flags?
Java's "Garbage Collection" (GC) is the #1 cause of lag spikes in Minecraft. By using **Aikar's Flags**, you force Java to clean up memory more efficiently.

**How to apply them:**
1.  Run the generator in the script to create `JVM_Flags.txt`.
2.  Open your Minecraft Launcher (Official, Prism, Lunar, etc.).
3.  Find **JVM Arguments** in your profile settings.
4.  Delete the old ones and paste the generated flags.
5.  **RAM Advice**: 
    *   Vanilla: 4GB (`-Xmx4G`)
    *   Modpacks: 6-8GB (`-Xmx8G`)
    *   *Never go above 12GB unless you have 32GB+ of total System RAM.*

---

## 📂 Launcher-Specific Optimization

Use **Option 4** in the menu for tailored advice:

*   **Prism Launcher / XMCL**: 
    *   Set Min and Max RAM to the same value to prevent memory resizing lag.
    *   Enable "Close launcher on game start" to free up RAM.
*   **Lunar Client / Badlion**:
    *   Turn OFF "Cosmetic Rendering" and "Emotes."
    *   Enable "Hide Ground Items" in Lunar's performance settings.
*   **Official Launcher**:
    *   Always use a custom Java Runtime (like **Temurin 17**) instead of the bundled one for a 5-10% FPS boost.

---

## 🛡️ Safety & The Revert Script

### Where are my backups?
The script creates a professional root folder at:
`C:\Program Files\Minecraft Win11 Backup` 
*(Fallback: %ProgramData% if permissions are restricted)*

Inside, you will find:
*   `Backups`: Your original Registry keys.
*   `Logs`: A timestamped history of every change made.
*   `OldVersions`: Previous copies of the script itself.

### How to Revert
If you experience any system instability:
1.  Run `Minecraft-Win11-Revert.bat` as Administrator.
2.  Select **"Y"** to confirm.
3.  The script will automatically find the latest backup and restore your Windows defaults (Balanced Power Plan, default timers, etc.).
4.  **Restart your PC.**

---

## 🔍 "Keep List" Guarantee
This script is designed for **power users who still use their PC for work**. It will **NOT** break:
*   ✅ Snipping Tool (`Win+Shift+S`)
*   ✅ Windows Search
*   ✅ Bluetooth & Wireless Pairing
*   ✅ Microsoft Store & App Installers
*   ✅ Windows Update

---

**Enjoy the extra frames!** If you have bugs, check the `Logs` folder and view the `MC_Optimizer_Log.txt`.
