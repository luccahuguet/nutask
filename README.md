# Nutask: Your Shell Task Manager 🌰

Manage your tasks directly from your favorite shell using the power of NuShell. Nutask is an intuitive, no-frills task management system designed for those who love the command line.

TODO: add demo GIF
![Demo GIF or screenshot if available](path-to-demo-image.gif)

## Features 🚀
- **Simple Management**: Add, remove, list, and mark tasks as done seamlessly.
- **Integrated with NuShell**: Use the power and flexibility of NuShell to manipulate tasks.
- **Persistent**: Your tasks are stored securely in a `.tasks.nuon` file in your home directory.
- **Easy-to-use**: Familiar command line operations for those acquainted with NuShell.

## Installation 💽
1. Clone the repository: `git clone https://github.com/luccahuguet/nutask`
2. Add `use "path_to_repo\task.nu"` to your $nu.config-path or $nu.env-path
3. You are done!

## Usage 🛠️
- **Add a task**:
  
```nu
task add [Your task description here]
```

- **List tasks**:
```nu
task add [Your task description here]
```

- **Mark your task as done**:
```nu
task done [index of the task]
```

- **Remove your task**:
```nu
task done [index of the task]
```

- **Clear (delete) completed tasks**:
```nu
task clear
```

## Roadmap 🛣️
- Task Prioritization: Introducing priority levels for tasks.
- Enhanced Display: Mark done tasks as green
- Backup & Archive: Safeguard your tasks with backup and archiving features.
