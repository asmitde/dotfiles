# dotfiles
My dotfiles for WSL

Warning: This is a work in progress. Not all config files may work. Setup has not been tested across multile configurations.

## Project vision
I am hoping to build this repository as a one-stop shop for a setting up a productive developer environment for Windows Subsystem for Linux. WSL is an ongoing project at Microsoft, and recently they announced the second version (WSL2) of this awesome Windows-Linux integration. My current scripts and configs are based on WSL1 and I will be continuing to support WSL1 even after WSL2 is released. However, once WSL2 is available to Windows Insiders, I am planning to port my configs and start testing on WSL2 (This will mostly involve removing some of the hacks that were present to make things work on WSL1; as WSL2 is more feature-rich due to the inclusion of the linux kernel).

## Planned features
Following are the inital set of features that I'm currently working on (or planned):
1. Fish Shell support
2. Tmux config and default attached session on load
3. GPG key signing (including git commits)
4. Visual Studio Code Remote support
5. Auto-install scripts for the entire setup
