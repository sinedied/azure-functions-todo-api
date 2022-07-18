const db = {};

function generateId() {
  return Math.random().toString(36).substring(2);
}

export function getStats() {
  return {
    userCount: Object.keys(db).length,
    taskCount: Object.values(db).reduce((acc, tasks) => acc + tasks.length, 0)
  }
}

export function getTasks(userId) {
  let tasks = db[userId];
  if (!tasks) {
    tasks = [
      { id: generateId(), description: 'Learn JavaScript', completed: false },
      { id: generateId(), description: 'Learn HTML', completed: false },
      { id: generateId(), description: 'Learn CSS', completed: false },
    ];
    db[userId] = tasks;
  }
  return tasks;
}

export function addTask(userId, description) {
  const tasks = getTasks(userId);
  const newTask = { id: generateId(), description, completed: false };
  tasks.push(newTask);
  return newTask;
}

export function updateTask(userId, taskId, completed) {
  const tasks = getTasks(userId);
  const task = tasks.find(t => t.id === taskId);
  if (!task) {
    throw new Error('Task not found');
  }
  task.completed = completed;
  return task;
}

export function deleteTask(userId, taskId) {
  const tasks = getTasks(userId);
  const taskIndex = tasks.findIndex(t => t.id === taskId);
  if (taskIndex === -1) {
    throw new Error('Task not found');
  }
  tasks.splice(taskIndex, 1);
}
