# ✅ Todo API for Azure Functions

> Simple todo list API built with Azure Functions and Node.js.

All entries are stored in-memory and are not persisted, so when the server is stopped all data is lost.

## Running the server locally

Make sure you have [Node.js](https://nodejs.org) and [Azure Functions Core Tools](https://aka.ms/functions-core-tools) installed.

1. Run `npm install`.
2. Run `npm start`. The API will be available at `http://localhost:7071/api/`.

## API details

Route                                        | Description
---------------------------------------------|------------------------------------
GET    /api/                                 | Get server info
GET    /api/user/:userId/tasks               | Get tasks for specified user, creating a new account if needed.
POST   /api/user/:userId/tasks               | Add a new task for specified user, creating a new account if needed. Payload: `{ "description": "<task_description>" }`
PATCH  /api/user/:userId/tasks/:taskId       | Update specified task. Payload: `{ "completed": <boolean> }`
DELETE /api/user/:userId/tasks/:taskId       | Delete specified task
