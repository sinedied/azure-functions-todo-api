import { deleteTask } from '../api/common/tasks.js';

export default async function (context, req) {
  const headers = { 'Content-Type': 'application/json' };
  const { userId, taskId } = req.params;

  if (!userId) {
    return { headers, status: 401, type: 'application/json', body: 'Unauthorized' };
  }

  try {
    context.log(`Trying to delete task ${taskId.id} for user ${userId}`);
    deleteTask(userId, taskId);
    context.log(`Deleted task ${taskId.id} for user ${userId}`);

    return { headers, status: 204 };
  } catch (error) {
    context.log('Error:', error);
    return { headers, status: 400, type: 'application/json', body: 'Task not found' };
  }
}
