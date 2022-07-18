import { addTask } from '../common/tasks.js';

export default async function (context, req) {
  const headers = { 'Content-Type': 'application/json' };
  const { userId } = req.params;

  if (!userId) {
    return { headers, status: 401, body: 'Unauthorized' };
  }

  const { description } = req.body;

  if (!description) {
    return { headers, status: 400, body: 'Missing description' };
  }

  const newTask = addTask(userId, description);
  context.log(`Added task ${newTask.id} for user ${userId}`);

  return { headers, status: 201, body: newTask };
}
