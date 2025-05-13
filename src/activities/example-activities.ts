/**
 * Activities are functions that contain your business logic.
 * They can be executed either remotely or locally by a workflow.
 */
export async function greet(name: string): Promise<string> {
  return `Hello, ${name}!`;
} 