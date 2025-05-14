# Integrating Temporal with Other Projects

This guide explains how to integrate this Temporal setup with your existing Docker-based projects.

## Network Setup

The Temporal services run on a network called `temporal-learning-network`. To connect your application to Temporal:

1. Add the network to your project's docker-compose.yml:

```yaml
networks:
  your-project-network:
    # Your existing network definitions
  temporal-learning-network:
    external: true
```

2. Add the network to your services that need to connect to Temporal:

```yaml
services:
  your-service:
    # Your service configuration
    networks:
      - your-project-network
      - temporal-learning-network
```

## Connecting to Temporal Server

To connect to the Temporal server from your services, use these settings:

- **Temporal Address**: `temporal:7233` 
- **Web UI**: Available at http://localhost:8080

Example service configuration:

```yaml
services:
  your-app:
    image: your-app-image
    environment:
      - TEMPORAL_ADDRESS=temporal:7233
    networks:
      - your-project-network
      - temporal-learning-network
```

## Starting Everything

1. First start the Temporal infrastructure:
   ```
   cd /path/to/temporal_learning
   ./Start-Project.ps1
   ```

2. Then start your project's services:
   ```
   cd /path/to/your-project
   docker-compose up -d
   ```

## Sample Code for Connecting

```typescript
// Connect to Temporal from your application
import { Client } from '@temporalio/client';

async function connectToTemporal() {
  const client = new Client({
    address: 'temporal:7233' // Uses Docker network DNS resolution
  });
  
  // Now you can interact with Temporal workflows
  const handle = await client.workflow.start(/* your workflow */);
  // ...
}
```

## Troubleshooting

If your services can't connect to Temporal:

1. Verify both projects are on the `temporal-learning-network`
2. Check if Temporal services are running: `docker ps | findstr temporal`
3. Try pinging the Temporal server from your container: 
   ```
   docker exec -it your-container-name ping temporal
   ```
4. Ensure your application is using the correct address: `temporal:7233` 