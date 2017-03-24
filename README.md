# Broadcom Bluetooth for Ubuntu

## About

Broadcom Bluetooth chips firmware installer for Ubuntu.
Based on original answer by [Adnan](http://stackoverflow.com/a/22311205).

## How to Use

Just run from current directory with root privileges:

```bash
./install.sh
```

After that you need power of your laptop or PC.

In some cases need to run after power on:

```bash
modprobe -r btusb && modprobe btusb
```

## Hardware

* Working on ``HP 250 G4 Notebook PC``

## License

The MIT License (MIT)

Copyright (c) 2017 Aleksandr Karpov <keyfour13@gmail.com>

Except of content of next file(s):

* 68560_Bluetooth_Broadcom_Win81_64_VER12009840.zip
