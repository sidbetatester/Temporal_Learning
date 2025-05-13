# Temporal TypeScript Docker Example

This project demonstrates how to run a Temporal application in Docker with TypeScript.

## Project Structure

```
Temporal_Learning/
├── src/
│   ├── workflows/
│   │   └── example-workflow.ts   # Example workflow definition
│   ├── activities/
│   │   └── example-activities.ts # Example activities implementation
│   ├── worker.ts                 # Worker implementation
│   └── client.ts                 # Client for testing workflows
├── temporal-docker/              # Official Temporal Docker Compose repository
├── Dockerfile.worker             # Docker configuration for worker
├── Dockerfile.client             # Docker configuration for client
├── Dockerfile.dev                # Docker configuration for development
├── docker-compose.yml            # Docker Compose configuration
├── package.json                  # Node.js dependencies
├── tsconfig.json                 # TypeScript configuration
└── README.md                     # This file
```

## Prerequisites

- [Docker](https://www.docker.com/get-started) and Docker Compose

## Getting Started

### Running with Docker Compose

1. Start the Temporal server and UI:

```bash
cd temporal-docker
docker-compose up -d
```

2. Start the entire application stack:

```bash
cd ..
docker-compose up -d
```

3. Access the Temporal UI at [http://localhost:8080](http://localhost:8080)

4. Run the client to execute a workflow:

```bash
# Run the client inside Docker
docker-compose run client
```

### Development Workflow

The project is fully containerized for development. No local Node.js installation is needed.

1. Start the development container:

```bash
docker-compose up dev
```

This container will watch for file changes and recompile TypeScript in real-time.

2. Make changes to your workflows and activities

The source code is mounted as a volume in the container, so all changes are immediately reflected.

3. Execute workflows during development:

```bash
# Run the client container
docker-compose run client
```

4. Access a development shell:

```bash
docker-compose exec dev /bin/bash
```

From this shell, you can run npm commands, execute tests, or any other development tasks.

## Documentation

- [Temporal TypeScript SDK Documentation](https://docs.temporal.io/dev-guide/typescript)
- [Temporal Docker Documentation](https://docs.temporal.io/kb/all-docker-images) 




Appendix A:

Project Files and Their Purpose
Main Project Files:
src/ folder - Contains all your source code
worker.ts - Runs in the background and processes your workflows
client.ts - Starts workflows and waits for their results
workflows/ - Contains workflow definitions (the sequences of tasks)
activities/ - Contains individual tasks that workflows can call
Docker Configuration Files:
Dockerfile.worker - Instructions to build the worker container
Dockerfile.client - Instructions to build the client container
Dockerfile.dev - Instructions for development environment
docker-compose.yml - Coordinates all the containers together
Project Management:
package.json - Lists dependencies and commands
tsconfig.json - Configures TypeScript settings
.gitignore - Tells Git which files to ignore
README.md - Documentation for the project
Helper Scripts:
Start-Project.ps1 - PowerShell script to start everything
Stop-Project.ps1 - PowerShell script to shut everything down
temporal-docker/ folder - Contains the Temporal server setup
How to Use Temporal in Your Projects
Basic Concepts:
Workflows: Think of these as recipes or instruction manuals. They define the steps of a process that should happen in a specific order.
Activities: These are individual tasks that a workflow calls - like sending an email, processing a payment, or updating a record.
Worker: This is a service that runs in the background and executes your workflows and activities.
Client: This is how your application starts workflows and gets results.
Implementation Steps:
Install Temporal Server:
Use Docker to run the Temporal server (like we did with temporal-docker)
Or use Temporal Cloud (a hosted version)
Create Your Workflow:
Define the steps in your business process
Example: onboarding a new customer might involve creating a record, sending a welcome email, and scheduling a follow-up
Implement Activities:
Write the code for each individual task
Make them reliable with automatic retries
Set Up Worker:
Create a worker service that will execute your workflows and activities
Start this worker alongside your application
Use the Client:
From your main application, use the client to start workflows
Optionally wait for results, or just let them run
Benefits of Using Temporal:
Durability: If your system crashes, workflows will resume where they left off
Visibility: You can see all running workflows in the web UI
Reliability: Automatic retries mean fewer failures
Scalability: Run many workflows in parallel
Practical Example:
Instead of implementing a payment process like:
Apply to README.md
try {
  processPayment();
  updateInventory();
  sendConfirmationEmail();
} catch (error) {
  // What do we do if this fails halfway?
}
try {  processPayment();  updateInventory();  sendConfirmationEmail();} catch (error) {  // What do we do if this fails halfway?}
With Temporal, you can create a workflow that handles failures automatically and resumes from where it left off, even if your server crashes.
To use this project as a template, copy the files, update the workflows and activities with your business logic, and follow the README instructions to run it.