import { getTasks } from '../common/tasks.js';

export default async function (context, req) {
  const headers = { 'Content-Type': 'application/json' };
  const { userId } = req.params;

  if (!userId) {
    return { headers, status: 401, body: 'Unauthorized' };
  }

  const tasks = getTasks(userId);
  context.log(`Retrieved ${tasks.length} tasks for user ${userId}`);

  return { headers, body: tasks };
}
