# Accelerated Database Hardware Deployment

## Introduction
The use of a OpenPower cluster to enable an Accelerated Database(database making use of any accelerators).  This repository will facilitate Kinetica's GPUdb. 

## Supported Hardware Configurations
- **Minimum configuration - Four Minsky Cluster**
    - Four IBM POWER S822LC with Tesla p100 GPUs.
    - See BOM for details

- **Maximim configuration - Sixteen Minsky Cluster**
    - Sixteen IBM POWER S822LC with Tesla p100 GPUs
    - See BOM for details

## Configure Network Bridge
Create a network bridge named "br0" with port connected to management network (192.168.3.0/24).

Below is an example interface defined in the local "/etc/network/interfaces" file. Note that "enP1p3s0f0" is the name of the interface connected to the management network.

auto br0
iface br0 inet static
      address 192.168.3.3
      netmask 255.255.255.0
      bridge_ports enP1p3s0f0


## Installation Instructions
1. git clone https://github.ibm.com/open-power-solution-genesis/accelerated-db.git
2. Run `install.sh`
3. Build/edit the config.yml file using one of the templates provided.
4. Run `deploy.sh <desired config file>` to initiate deployment.
