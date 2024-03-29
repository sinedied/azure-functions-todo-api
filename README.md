# ✅ Todo API for Azure Functions

[![Deploy on Azure](https://github.com/sinedied/azure-functions-todo-api/actions/workflows/deploy.yml/badge.svg)](https://github.com/sinedied/azure-functions-todo-api/actions/workflows/deploy.yml)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

> Simple todo list API built with Azure Functions and Node.js.

All entries are stored in-memory and are not persisted, so when the server is stopped all data is lost.

## API details

Route                                        | Description
---------------------------------------------|------------------------------------
`GET    /api/`                               | Get server info
`GET    /api/users/:userId/tasks`            | Get tasks for specified user, creating a new account if needed.
`POST   /api/users/:userId/tasks`            | Add a new task for specified user, creating a new account if needed. Payload: `{ "description": "<task_description>" }`
`PATCH  /api/users/:userId/tasks/:taskId`    | Update specified task. Payload: `{ "completed": <boolean> }`
`DELETE /api/users/:userId/tasks/:taskId`    | Delete specified task

## Running the server locally

Make sure you have [Node.js](https://nodejs.org) and [Azure Functions Core Tools](https://aka.ms/functions-core-tools) installed.

1. Run `cd api && npm install`.
2. Run `npm start`. The API will be available at `http://localhost:7071/api/`.

## Deploying on Azure

You need an [Azure account](https://azure.microsoft.com/free/?WT.mc_id=javascript-0000-yolasors), [Azure CLI](https://aka.ms/tools/azure-cli) and [GitHub CLI](https://cli.github.com) installed.
If you're using Windows, you'll also either need to use [WSL](https://docs.microsoft.com/windows/wsl/install?WT.mc_id=javascript-0000-yolasors) or [Git Bash](https://git-scm.com/downloads) to run the scripts.

1. Run `.azure/setup.sh`, and follow the instructions. At the end of the process, the first deployment will be triggered.

Now every time you make a commit to the repository, the project will be automatically redeployed to Azure using [GitHub Actions](https://github.com/features/actions).

If you want to clean up everything and delete the deployed resources, run `.azure/setup.sh --terminate`.

