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

## Appendix A: Project Details

### Main Project Files:
- **src/ folder** - Contains all your source code
  - **worker.ts** - Runs in the background and processes your workflows
  - **client.ts** - Starts workflows and waits for their results
  - **workflows/** - Contains workflow definitions (the sequences of tasks)
  - **activities/** - Contains individual tasks that workflows can call

### Docker Configuration Files:
- **Dockerfile.worker** - Instructions to build the worker container
- **Dockerfile.client** - Instructions to build the client container
- **Dockerfile.dev** - Instructions for development environment
- **docker-compose.yml** - Coordinates all the containers together

### Project Management:
- **package.json** - Lists dependencies and commands
- **tsconfig.json** - Configures TypeScript settings
- **.gitignore** - Tells Git which files to ignore
- **README.md** - Documentation for the project

### Helper Scripts:
- **Start-Project.ps1** - PowerShell script to start everything
- **Stop-Project.ps1** - PowerShell script to shut everything down
- **temporal-docker/ folder** - Contains the Temporal server setup

## How to Use Temporal in Your Projects

### Basic Concepts:
- **Workflows**: Think of these as recipes or instruction manuals. They define the steps of a process that should happen in a specific order.
- **Activities**: These are individual tasks that a workflow calls - like sending an email, processing a payment, or updating a record.
- **Worker**: This is a service that runs in the background and executes your workflows and activities.
- **Client**: This is how your application starts workflows and gets results.

### Implementation Steps:
1. **Install Temporal Server**:
   - Use Docker to run the Temporal server (like we did with temporal-docker)
   - Or use Temporal Cloud (a hosted version)
2. **Create Your Workflow**:
   - Define the steps in your business process
   - Example: onboarding a new customer might involve creating a record, sending a welcome email, and scheduling a follow-up
3. **Implement Activities**:
   - Write the code for each individual task
   - Make them reliable with automatic retries
4. **Set Up Worker**:
   - Create a worker service that will execute your workflows and activities
   - Start this worker alongside your application
5. **Use the Client**:
   - From your main application, use the client to start workflows
   - Optionally wait for results, or just let them run

### Benefits of Using Temporal:
- **Durability**: If your system crashes, workflows will resume where they left off
- **Visibility**: You can see all running workflows in the web UI
- **Reliability**: Automatic retries mean fewer failures
- **Scalability**: Run many workflows in parallel

### Practical Example:
Instead of implementing a payment process like:

```javascript
try {
  processPayment();
  updateInventory();
  sendConfirmationEmail();
} catch (error) {
  // What do we do if this fails halfway?
}
```

With Temporal, you can create a workflow that handles failures automatically and resumes from where it left off, even if your server crashes.

To use this project as a template, copy the files, update the workflows and activities with your business logic, and follow the README instructions to run it.

### Integrating Temporal With Existing Projects

When adapting this Temporal setup to work with your own projects:

1. **Files you'll need to modify:**
   - `src/workflows/` - Replace with your project-specific workflow definitions
   - `src/activities/` - Implement activities relevant to your business logic
   - `src/worker.ts` - Update to register your specific workflows and activities
   - `src/client.ts` - Modify to execute your custom workflows
   - `package.json` - Add any additional dependencies your project requires

2. **Components that typically remain unchanged:**
   - `temporal-docker/` - The Temporal server infrastructure 
   - Docker configuration files (unless you need specific environment settings)
   - `tsconfig.json` - TypeScript configuration (unless you have special needs)
   - Helper scripts (`Start-Project.ps1`, `Stop-Project.ps1`)

3. **Integration process:**
   - First, identify the business processes you want to manage with Temporal
   - Break these processes into workflows (sequences) and activities (individual tasks)
   - Implement each component following the patterns in the example code
   - Update the worker to register your new components
   - Test using the client to start your workflows

### Integrating With External Databases and Services

When your Temporal workflows need to interact with external databases or services:

1. **Connecting to External Databases:**
   - Add database client libraries to `package.json` (e.g., MongoDB, MySQL, PostgreSQL)
   - Create database connection logic in your activities
   - Consider implementing connection pooling for efficiency
   - Use environment variables in `docker-compose.yml` for database credentials
   - Example: `DB_HOST=your-external-db-host`

2. **Network Configuration:**
   - For local development with external services:
     - Update `docker-compose.yml` to include external networks
     - Or use host networking for direct access to localhost services
   - For production deployments:
     - Define proper network configurations to allow container communication
     - Consider using service discovery mechanisms 

3. **Best Practices:**
   - Keep database operations inside activities, not workflows
   - Use idempotent operations when possible
   - Implement proper error handling and retries for database connections
   - Consider using the Temporal SDK's built-in retry policies for activities
   - Use dependency injection to make testing easier

### Understanding Database Components in Temporal

It's important to distinguish between different database components in this project:

1. **Temporal's Required Persistence Databases:**
   - Temporal Server **requires** a persistence database to function
   - This database stores workflow history, task queues, and execution state
   - By default, Temporal supports PostgreSQL, MySQL, or Cassandra
   - The configuration in `temporal-docker` sets this up automatically
   - **You should not remove these** as they are essential for Temporal's operation

2. **Monitoring and Observability Databases:**
   - Components like Prometheus, Grafana, and Loki in `temporal-docker/deployment/`
   - These store metrics, logs, and visualization data
   - They are optional but recommended for production deployments
   - Can be modified or removed if you have alternative monitoring solutions

3. **Your Application Databases:**
   - These are external databases your workflows/activities connect to
   - Completely separate from Temporal's internal storage
   - You configure and manage these connections in your activity code
   - Examples: product databases, user databases, transaction systems, etc.

When integrating Temporal with an existing project, you keep Temporal's internal databases as-is while connecting your workflows/activities to your application's existing databases.