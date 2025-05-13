import { proxyActivities } from '@temporalio/workflow';
import type * as activities from '../activities/example-activities';

// Define the interface for workflow parameters
export interface GreetingWorkflowParams {
  name: string;
}

// Define the activities
const { greet } = proxyActivities<typeof activities>({
  startToCloseTimeout: '1 minute',
});

/** A workflow that simply calls an activity */
export async function exampleWorkflow(params: GreetingWorkflowParams): Promise<string> {
  return await greet(params.name);
} 