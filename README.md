# Nutask: Your Shell Task Manager 🌰

Manage your tasks using the power of NuShell. Nutask is an intuitive, no-frills task management system designed for those who love the command line.

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
- **Add a task**:
  
```nu
task add [Your task description]
```

- **List tasks**:
```nu
task ls
```
 
or just 

```nu
task
```

- **Mark your task as done**:
```nu
task done [index of the task]
```

- **Remove your task**:
```nu
task rm [index of the task]
```

- **Edit your task**:
```nu
task edit [index of the task] [Your task description]
```

- **Delete all done tasks**:
```nu
task clear
```

## Roadmap 🛣️
- [x] Enhanced Display: Mark done tasks as green
- Due data: Add a due date option for each task
- Task Prioritization: Introducing priority levels for tasks.
- Backup & Archive: Safeguard your tasks with backup and archiving features.
