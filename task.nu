# module task.nu: a to do app for your favorite shell

# Main function to display the list of tasks.
export def main [] = {help}  # No parameters

# Alias for the show function.
export def ls [] = {show}  # No parameters

# Returns the path to the task file.
def task_path [] = {"~/.tasks.nuon"}  # No parameters

# Adds a new task with the given words as its description.
export def add [
    ...words: string # words: An array of strings that make up the task description
] {
    let task = $words | str join " "
    let date_now = date now
    list_tasks | append { "task": $task, "done": false, "age": $date_now} | save (task_path) -f
    show
}

# Displays the list of tasks.
export def show [] {
    let tasks = list_tasks | each {|in|
        if $in.done {
            ($in | upsert task $"(ansi green) ($in.task) (ansi reset)")
        } else {
            ($in | upsert task $"(ansi white) ($in.task) (ansi reset)")
        }
    }
    echo $tasks
}

# Clears all completed tasks.
export def clear [] {
    list_tasks | where not done | save (task_path) -f
    show
}

# Removes a task based on its index.
export def rm [
    index: int # The position of the task to be removed
] {
    list_tasks | drop nth $index | save (task_path) -f
    show
}

# Switches the status of a task based on its index (marks it as done or not done).
export def done [
    index: int # The position of the task to switch its status
] {
    let old_status = list_tasks | get $index | get done
    let updated_task = list_tasks | get $index | upsert done (not $old_status)
    list_tasks | upsert $index $updated_task | sort-by-done $in | save (task_path) -f
    show
}


export def edit [
    index: int # The position of the task to switch its status
    ...words: string # words: An array of strings that make up the task description
] {
    let new_task = $words | str join " "
    update_task $index task $new_task
    show
}

# Bumps a task to the top of the list.
export def bump [
    index: int # The index of the task to bump up
] {
    let bumped_task = list_tasks | get $index;
    let $first_undone_index = list_tasks | enumerate | where not $it.item.done | first | get index;
    list_tasks | drop nth $index | insert $first_undone_index $bumped_task | save (task_path) -f
    show
}

export def help [] {
print "Nutask: a to do app for your favorite shell\n
Available subcommands:
  task main  - Display the list of tasks.
  task ls    - Alias for the show function to display tasks.
  task add   - Add a new task.
  task show  - Display the list of tasks.
  task clear - Clear all completed tasks.
  task rm    - Remove a task based on its index.
  task done  - Switch the status of a task based on its index.
  task edit  - Edit a task description based on its index.
  task bump  - Move a task to the top of the list based on its index.
  task help  - Display this help message."
}

def update_task [
    index: int # The index of the task to update
    property: string # The property to update
    value: string # The new value of the property
] {
    let updated_task = list_tasks | get $index | upsert $property $value
    list_tasks | upsert $index $updated_task | save (task_path) -f
    show
}

# Sorts tasks by their status (done or not done).
def sort-by-done [
tasks: table # A table of tasks to be sorted
] {
    let true_tasks = $tasks | where done == true
    let false_tasks = $tasks | where done == false
    $true_tasks | append $false_tasks
}

# Returns the list of tasks. If the task file doesn't exist, creates a new one.
def list_tasks [] {
    if not ( task_path | path exists) {
        "[]" | save (task_path)
    }
    open (task_path)
}
