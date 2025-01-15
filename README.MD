# Oracle Database Setup with Docker

This project provides an easy way to install an Oracle database using Docker and Docker Compose. It includes scripts for both Linux and Windows environments, as well as an initial example SQL script.

**Note:** This project is intended for testing and development purposes only and is not suitable for production use.

## Prerequisites

- Docker (installed and running)
- Docker Compose

## Setup Instructions

### Windows

1. Run the `RunAsAdmin.bat` script to start the setup process with administrator privileges.
2. The script will check if Docker Desktop is installed and running. If not, it will prompt you to install or start it.
3. Docker Compose will be used to start the Oracle database container.
4. The initial SQL script located in `init-scripts/base_script.sql` will be executed to set up the database schema and data.

### Linux

1. Open a terminal and navigate to the project directory.
2. Run the `setup.sh` script to start the setup process.
3. The script will check if Docker is installed and running. If not, it will prompt you to install or start it.
4. Docker Compose will be used to start the Oracle database container.
5. The initial SQL script located in `init-scripts/base_script.sql` will be executed to set up the database schema and data.

## Connection Details

Once the setup is complete, you can connect to the Oracle database using the following details:

- **Host:** localhost
- **Port:** 1521
- **SID:** XEPDB1
- **User:** sys as sysdba
- **Password:** admin_password

## Directory Structure
├── README.MD
├── RunAsAdmin.bat
├── docker-compose.yml
├── init-scripts
│   └── base_script.sql
├── setup-oracle.sh
└── setup.ps1


- `docker-compose.yml`: Docker Compose configuration file.
- `init-scripts/`: Directory containing the initial SQL script.
- `README.MD`: This readme file.
- `RunAsAdmin.bat`: Batch script for Windows setup.
- `setup.ps1`: PowerShell script for Linux setup.
- `setup.sh`: Shell script for Linux setup.

## Acknowledgements

We would like to thank Gerald Venzl for creating an Oracle image that is simpler to use than Oracle's official one.

## License

This project is licensed under the MIT License.