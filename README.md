# Nutask: Your Shell Task Manager 🌰

Manage your tasks using the power of NuShell. Nutask is an intuitive, straight-forward task management system designed for those who love the command line.

TODO: add demo GIF
![Demo GIF or screenshot if available](path-to-demo-image.gif)

## Features 🚀
- **Simple Management**: Add, remove, list, and mark tasks as done seamlessly.
- **Integrated with NuShell**: Use the power and flexibility of NuShell to manipulate tasks.
- **Persistent**: Your tasks are stored securely in a `.tasks.nuon` file in your home directory.

## Installation 💽
1. Make sure you have [nushell](https://www.nushell.sh) installed 
2. Clone the repository: `git clone https://github.com/luccahuguet/nutask.git`
3. Add `use "path_to_repo\task.nu"` to your $nu.config-path or $nu.env-path
4. You are done! 

## Usage 🛠️

### Displaying Tasks:
- **Display the list of tasks**: `task`
- **Alias for displaying tasks**: `task ls`

### Adding and Modifying Tasks:
- **Add a task (default priority is medium)**: `task add [Your task description]`
- **Add a task with specific priority**: `task add [Your task description] --p [priority: l/m/h/u]`

### Interacting with Tasks:
- **Mark a task as done or not done**: `task tick [index of the task]`
- **Edit the description of a task**: `task edit [index of the task] [Your new task description]`
- **Change the priority of a task**: `task priority [index of the task] [priority: l/m/h/u]`
- **Remove a specific task**: `task rm [index of the task]`
- **Clear all completed tasks**: `task purge`

### Help:
- **Display the help message**: `task help`

### Task Priorities:
- **Low**: `l`
- **Medium**: `m`
- **High**: `h`
- **Urgent**: `u`

## Roadmap 🛣️
- [x] Enhanced Display: Mark done tasks as green
- [x] Task Prioritization: Tasks can now have different levels of priority.
- [ ] Due date: Add a due date option for each task
- [ ] Backup & Archive: Safeguard your tasks with backup and archiving features.

## Disclaimer
- This is not an "official" package endorsed by the Nushell project
