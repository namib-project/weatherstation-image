[![Build Status](https://github.com/namib-project/weatherstation-image/actions/workflows/create-image.yml/badge.svg)](https://github.com/namib-project/weatherstation-image/actions/workflows/create-image.yml)

# NAMIB Web of Things Weather Station

This repository contains the needed files to create a Raspberry Pi OS image for creating a weather station with Web of Things (WoT) and Manufacturer Usage Description (MUD, RFC 8520) support.
To create the image, run `build_image.sh` with root privileges and flash it onto an SD card using, for instance, the Raspberry Pi Imager.

## Functionality

The weather station acts as a WoT consumer, discovers sensor nodes with Thing Descriptions (TDs) in the local network using CoAP multicast, and interacts with them based on their TD to read sensor values.
It also emits a MUD URL via DHCP that can be used by a MUD Manager (e. g. the [NAMIB MUD controller](https://github.com/namib-project/namib_mud_controller)) to retrieve a MUD file that describes the required connections of the weather station and to configure the local network accordingly. 

As the logic of the weather station is realized with Node-RED it can be easily adjusted to other use cases.

## Login into the Node-RED editor

The Node-RED editor is accessible from the browser via `weatherstation.local:1880` or `<IP address>:1880`.
It is password protected.
The default credentials are:

- Username: `admin` 
- Password: `namib`

Username and password can be changed using the `changeCredentials.sh` in the directory `/home/pi` (which can be accessed using SSH).
The username is case sensitive.
