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

## Installation Instructions
1. git clone https://github.ibm.com/open-power-solution-genesis/accelerated-db.git
2. Run `install.sh`
3. Build/edit the config.yml file using one of the templates provided.
4. Run `deploy.sh` to initiate deployment.
