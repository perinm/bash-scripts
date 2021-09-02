# bash-scripts

## Contents

    In this repository I store bash scripts that I develop, useful or time-saving for me

- new_system.sh:

    1. useful and time-saving when starting new linux install

    2. updates system system, and install many useful packages for me

- install_flutter.sh

    1. install flutter, and android-studio, and configure some system things

- extra_things.sh

    1. Install nordvpn app.

## How to use

Run:

    ```bash
    chmod +x <script_name>.sh
    ./<script_name>.sh
    ```

## Extra info

When sideloading ubuntu with windows previously installed, select manually by using "Something else" option.
- swap
    - type: primary
    - beginning of space
    - use as: swap area
- / (root)
    - type: logical
    - location: beginning of space
    - use as: ext4
    - mount point: /
    - size: (10 - 20gb) (20480mb)
- /home
    - 4 first options same as / (root)
    - choose your home size accordingly (all free space in hard drive)
- device for boot loader being all drive
