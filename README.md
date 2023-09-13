# Nutask: Your Shell Task Manager 🌰

Manage your tasks using the power of NuShell. Nutask is an intuitive, straight-forward task management system designed for those who love the command line.

TODO: add demo GIF
![Demo GIF or screenshot if available](path-to-demo-image.gif)

## Features 🚀
- **Simple Management**: Add, remove, list, and mark tasks as done seamlessly.
- **Integrated with NuShell**: Use the power and flexibility of NuShell to manipulate tasks.
- **Persistent**: Your tasks are stored securely in a `.tasks.nuon` file in your home directory.

## Installation 💽
1. Clone the repository: `git clone https://github.com/luccahuguet/nutask.git`
2. Add `use "path_to_repo\task.nu"` to your $nu.config-path or $nu.env-path
3. You are done!

## Usage 🛠️
- **Add a task, with high priority (default is medium)**: `task add [Your task description] -p h`
- **List tasks**:`task ls`
- **Mark your task as done**: `task done [index of the task]`
- **Remove your task**: `task rm [index of the task]`
- **Edit your task**: `task edit [index of the task] [Your task description]`
- **Delete all done tasks**: `task clear`

## Roadmap 🛣️
- [x] Enhanced Display: Mark done tasks as green
- [x] Task Prioritization: Tasks can now have different levels of priority.
- [ ] Due date: Add a due date option for each task
- [ ] Backup & Archive: Safeguard your tasks with backup and archiving features.

## Disclaimer
- This is not an "official" package endorsed by the Nushell project
