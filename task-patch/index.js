import { updateTask } from '../common/tasks.js';

export default async function (context, req) {
  const headers = { 'Content-Type': 'application/json' };
  const { userId, taskId } = req.params;

  if (!userId) {
    return { headers, status: 401, body: 'Unauthorized' };
  }

  const { completed } = req.body;

  if (!completed) {
    return { headers, status: 400, body: 'Missing completed' };
  }

  try {
    context.log(`Trying to update task ${taskId.id} for user ${userId}`);
    const updatedTask = updateTask(userId, taskId, completed);
    context.log(`Updated task ${taskId.id} for user ${userId}`);

    return { headers, body: updatedTask };
  } catch (error) {
    context.log('Error:', error);
    return { headers, status: 400, body: 'Task not found' };
  }
}
