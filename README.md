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

## Extra info ([source](https://askubuntu.com/questions/343268/how-to-use-manual-partitioning-during-installation/343352#343352))

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
  - size: (10 - 20gb) (20480mb) [if installing cuda in a nvidia machine make it 35gb or 35840mb]
- /home
  - 4 first options same as / (root)
  - choose your home size accordingly (all free space in hard drive)
- device for boot loader being main drive (if there is windows, choose the same one)

## Useful commands

- [manual config brightness keys](https://askubuntu.com/questions/798203/changing-screen-brightness-through-keyboard-functions-on-my-notebook)

```bash
ssh-keygen -t ed25519 -C "<example@email.com>"
```

- [create bootable liveimage using hdd partition instead of usb](https://askubuntu.com/questions/1156490/make-a-hdd-partition-work-like-usb-bootable-in-ubuntu)
