import { NativeConnection, Worker } from '@temporalio/worker';
import * as activities from './activities/example-activities';
import { exampleWorkflow } from './workflows/example-workflow';

// Function to wait for a specific amount of time
const sleep = (ms: number) => new Promise((resolve) => setTimeout(resolve, ms));

// Function to retry connecting to Temporal server
async function connectWithRetry(address: string, maxRetries = 15, retryInterval = 5000) {
  let currentRetry = 0;
  
  while (currentRetry < maxRetries) {
    try {
      console.log(`Attempting to connect to Temporal server at ${address}...`);
      const connection = await NativeConnection.connect({
        address,
      });
      console.log('Connection to Temporal server successful!');
      return connection;
    } catch (err) {
      currentRetry++;
      console.log(`Connection attempt ${currentRetry}/${maxRetries} failed:`, err);
      
      if (currentRetry >= maxRetries) {
        console.error('Max retries reached. Giving up connecting to Temporal server.');
        throw err;
      }
      
      console.log(`Waiting ${retryInterval}ms before next retry...`);
      await sleep(retryInterval);
    }
  }
  
  throw new Error('Failed to connect to Temporal server after max retries.');
}

// Register with the Temporal server and start accepting tasks
async function run() {
  try {
    // Get Temporal server address from environment or use default
    const address = process.env.TEMPORAL_ADDRESS || 'localhost:7233';
    console.log(`Using Temporal address: ${address}`);
    
    // Connect to the Temporal server with retry logic
    const connection = await connectWithRetry(address);

    const worker = await Worker.create({
      connection,
      namespace: 'default',
      workflowsPath: require.resolve('./workflows/example-workflow'),
      activities,
      taskQueue: 'example-task-queue',
    });

    console.log('Worker connected, starting...');

    // Start accepting tasks on the `example-task-queue` queue
    await worker.run();
  } catch (err) {
    console.error('Worker error:', err);
    process.exit(1);
  }
}

run().catch((err) => {
  console.error('Error starting worker:', err);
  process.exit(1);
}); 