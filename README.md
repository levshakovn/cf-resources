## Overview

This repository contains scripts designed to simplify the creation and deletion of AWS infrastructure for various tasks. The scripts are organized into individual task directories, each containing all the necessary files to manage the infrastructure using AWS CloudFormation.

## Structure

- **Common Module**: The `common` directory contains reusable scripts based on AWS services (e.g., S3, EC2). These functions are shared across tasks and imported into the task-specific scripts.

- **Task Directories**: Each task has its own directory with the following components:
  - **`create.sh`**: Script to create all required infrastructure for the task.
  - **`delete.sh`**: Script to delete the created infrastructure.
  - **`stack.yaml`**: CloudFormation template to be deployed on AWS.
  
  Depending on the complexity of the task, additional files may also be present.

## Usage

To manage the AWS infrastructure for any task, navigate to the appropriate task directory and run the scripts:

- **Create Infrastructure**: 
  ```bash
  ./create.sh

- **Delete Infrastructure**: 
  ```bash
  ./delete.sh

- **Run a task**:
  ```bash
  ./run.sh <task-number> <create/delete>

## Prerequisites
- AWS CLI: Ensure the AWS CLI is installed and configured with appropriate credentials and permissions.
- Bash: The scripts are written in Bash, so a Unix-based environment is required (Linux, macOS, or WSL on Windows).

## Contributing
Feel free to contribute by opening issues or submitting pull requests. If you encounter any problems or have feedback, please let us know!