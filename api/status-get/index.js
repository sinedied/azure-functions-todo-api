import { readFile } from 'fs/promises';
import { getStats } from '../common/tasks.js';

const pkg = JSON.parse(await readFile(new URL('../package.json', import.meta.url)));

export default async function (context, _req) {
  const stats = getStats();
  context.log(`Retrieved server stats`);

  return {
    body: `${pkg.name} v${pkg.version} - ${stats.userCount} user(s), ${stats.taskCount} task(s)`
  };
}
