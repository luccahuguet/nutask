# module task.nu: a to do app for your favorite shell

# Main function to display the list of tasks.
export def main [] = {show}  # No parameters

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
    let old_desc = list_tasks | get $index | get task
    let updated_task = list_tasks | get $index | upsert task ($words | str join " ") 
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
