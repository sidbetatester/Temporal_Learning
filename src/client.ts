import { Connection, Client } from '@temporalio/client';
import { exampleWorkflow } from './workflows/example-workflow';
import type { GreetingWorkflowParams } from './workflows/example-workflow';

// Function to wait for a specific amount of time
const sleep = (ms: number) => new Promise((resolve) => setTimeout(resolve, ms));

async function run() {
  try {
    console.log('Attempting to connect to Temporal server...');
    
    // Get Temporal server address from environment or use default
    const address = process.env.TEMPORAL_ADDRESS || 'localhost:7233';
    console.log(`Using Temporal address: ${address}`);
    
    // Connect to the Temporal Server
    const connection = await Connection.connect({
      address,
    });
    
    console.log('Successfully connected to Temporal server');
    
    const client = new Client({
      connection,
      namespace: 'default',
    });

    // Run a workflow
    const handle = await client.workflow.start(exampleWorkflow, {
      args: [{ name: 'Temporal' }],
      taskQueue: 'example-task-queue',
      workflowId: 'example-workflow-' + Date.now(),
    });

    console.log(`Started workflow ${handle.workflowId}`);

    // Wait for the workflow to complete
    const result = await handle.result();
    console.log(`Workflow result: ${result}`);
  } catch (error) {
    console.error('Error connecting to Temporal:', error);
  }
}

// Add retry logic for Docker environment
async function runWithRetry(maxRetries = 5, retryInterval = 3000) {
  let attempts = 0;
  
  while (attempts < maxRetries) {
    try {
      await run();
      return;
    } catch (error) {
      attempts++;
      console.log(`Attempt ${attempts}/${maxRetries} failed. Retrying in ${retryInterval/1000} seconds...`);
      await sleep(retryInterval);
    }
  }
  
  console.error(`Failed after ${maxRetries} attempts`);
}

runWithRetry().catch((err) => {
  console.error(err);
  process.exit(1);
}); 