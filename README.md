# Accelerated Database Hardware Deployment

## Introduction
This repository is a comprehensive set of instructions, rules, and automation tools for building an OpenPOWER-based cluster tuned for Accelerated Databases(database making use of any accelerators).  Examples of such accelerated databases include Kinetica's GPUdb.  This repository currently facilitates Kinetica's GPUdb, but support for other Accelerated Databases to be added in the future. 

## Supported Hardware Configurations
- **Minimum configuration - Four Minsky Cluster**
    - Four IBM POWER S822LC with Tesla p100 GPUs.
    - See BOM (in https://github.com/open-power-ref-design/accelerated-db/blob/master/docs/Accelerated%20Database%20Deployment%20BOM.pdf ) for details.

- **Maximim configuration - Sixteen Minsky Cluster**
    - Sixteen IBM POWER S822LC with Tesla p100 GPUs
    - See BOM (in https://github.com/open-power-ref-design/accelerated-db/blob/master/docs/Accelerated%20Database%20Deployment%20BOM.pdf ) for details.

## Configure Network Bridge
Create a network bridge named "br0" with port connected to management network (192.168.3.0/24).

Below is an example interface defined in the local "/etc/network/interfaces" file. Note that "enP1p3s0f0" is the name of the interface connected to the management network.

- auto br0
- iface br0 inet static
     - address 192.168.3.3
     - netmask 255.255.255.0
     - bridge_ports enP1p3s0f0


## Installation Instructions
1. Run `git clone https://github.com/open-power-ref-design/accelerated-db.git`
2. Run `install.sh`
3. Build/edit the config.yml file using one of the templates provided to fit desired configuration.
4. Run `deploy.sh accel-db.4compute.config.yml` to initiate deployment on example within documentation or substitute config.yml built/edited on step 3. 
