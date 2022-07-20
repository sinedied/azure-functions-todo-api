import { readFile } from 'fs/promises';
import { getStats } from '../common/tasks.js';

const pkg = JSON.parse(await readFile(new URL('../package.json', import.meta.url)));

export default async function (context, _req) {
  const stats = getStats();
  context.log(`Retrieved server stats`);

  let version = 'dev';  
  try {
    version = await readFile(new URL('../.version', import.meta.url), 'utf-8');
    version = version.trim();
  } catch {}
  
  return {
    body: `${pkg.name} [${version}] - ${stats.userCount} user(s), ${stats.taskCount} task(s)`
  };
}
