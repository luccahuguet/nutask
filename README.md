# Nutask: Your Shell Task Manager 🌰

Manage your tasks using the power of NuShell. Nutask is an intuitive, straight-forward task management system designed for those who love the command line.

TODO: add demo GIF
![Demo GIF or screenshot if available](path-to-demo-image.gif)

## Features 🚀
- **Simple Management**: Add, remove, list, and tick tasks as done seamlessly.
- **Integrated with NuShell**: Use the power and flexibility of NuShell to manipulate tasks.
- **Persistent**: Your tasks are stored securely in a `.tasks.nuon` file in your home directory.
\\
## Installation 💽
1. Make sure you have [nushell](https://www.nushell.sh) installed 
2. Clone the repository: `git clone https://github.com/luccahuguet/nutask.git`
3. Add `use "path_to_repo\task.nu"` to your $nu.config-path or $nu.env-path
4. You are done!
   \\
## Usage 🛠️

### Task Management:
**Add a task (with the default values)**: 
```bash
task add [Your task description]
```
**Add a task, using all the options/flags**: 
```bash
task add [Your task description] --pri [l/m/h/u] --proj [<string>] --due <string or date>
```
**Mark a task as done or not done**: 
```bash
task tick [index of the task]
```
**Remove a specific task**: 
```bash
task rm [index of the task]
```
\\  
\\  
### Task Editing:
**Change the description of a task**: 
```bash
task desc [index of the task] [Your new task description]
```
**Change the priority of a task**: 
```bash
task pri [index of the task] [l/m/h/u]
```
**Change the due date of a task**: 
```bash
task due [index of the task] [<string or date>]
```
**Change the proj date of a task**: 
```bash
task proj [index of the task] [<string>]
```

\\
\\  
### View & Cleanup:
**Display the list of tasks**: 
```bash
task ls
```
**Shows every task from a project**: 
```bash
task lsproj <project>
```
**Clear all completed tasks**: 
```bash
task purge
```
**Display the help message**: 
```bash
task help
```
**Alias for displaying the help message**: 
```bash
task 
```
\\
\\  
### Task Priorities:
- **Low**: `l`
- **Medium**: `m`
- **High**: `h`
- **Urgent**: `u`
\\
## Roadmap 🛣️
- [x] Task Prioritization: Tasks can now have different levels of priority.
- [x] Enhanced Display: Mark done tasks as green, and color tasks by priority
- [x] Due date: Add a due date option for each task
- [x] Support for Projects: Separate your tasks into different projects
- [ ] Backup & Archive: Safeguard your tasks with backup and archiving features.

\\
## Disclaimer
- This is not an "official" package endorsed by the Nushell project (for now...)
