# module task.nu: a to do app for your favorite shell

# Main function to display the list of tasks.
export def main [] = {help}

# Variables
const task_path = "~/.tasks.nuon"
const list_of_priorities = ["l" "m" "h" "u"]

# Aliases.
export def ls [] = {show}
export def p [index priority] = {priority $index $priority}
def sort_tasks [] { sort-by done priority -r age }
def sort_save [] { sort_tasks | save $task_path -f }


# Adds a new task with the given description.
export def add [
    ...words: string # the task description
    -p: string = "m" # The priority of the task
    -d: string = "none" # When the task is due
] {
    if not (is_priority_valid $p) {return}

    let desc = $words | str join " "
    let priority_num = get_num_priority $p
    let done = false
    let due = $d 
    let age = date now
    list_tasks | append {
     "description": $desc,
     "priority": $priority_num,
     "done": $done,
     "age": $age,
     "due": $due,
    } | sort_save
    show
}

# Displays the list of tasks.
export def show [] {
    list_tasks | each { |task| 
        let done_color = get_done_color $task.done
        let pri = get_priority $task.priority
        let color = if $task.done {$done_color} else {$pri.color}
        $task | reject done
                | update priority ($"($color)($pri.name)(ansi reset)")
                | update description ($"($color)($task.description)(ansi reset)")         
    }
}
def get_done_color [done: bool] { if $done { (ansi green) } else { (ansi white) } }

def get_priority [priority: number] {
    match $priority {
        1 => { {name: "low", color: (ansi blue)} }
        2 => { {name: "medium", color: (ansi white)} }
        3 => { {name: "high", color: (ansi xterm_darkorange)} }
        4 => { {name: "urgent", color: (ansi red)} }
        _ => { echo "Unknown priority!" }
    }
}

# obtains the numeric priority of a task
def get_num_priority [
    priority: string
] {
    match $priority {
        "l" => { 1 }
        "m" => { 2 }
        "h" => { 3 }
        "u" => { 4 }
        _ => {
            echo "Unknown priority!"
            return 0
        }
    }
}


def is_priority_valid [
    priority: string
] {
    if not ($priority in $list_of_priorities) {
        print $"Invalid priority. Valid priorities are: ($list_of_priorities | str join ', ' )"
        false
    } else {
        true
    }
}

# Sets the priority of a task based on its index.
export def priority [
    index: int # The index of the task to change priority
    p: string # The priority to set
] {
    if not (is_priority_valid $p) {return}
    let $p_num = get_num_priority $p
    update_task $index priority $p_num
    show
}

# Clears all completed tasks.
export def purge [] {
    list_tasks | where not done | save $task_path -f
    show
}

# Removes a task based on its index.
export def rm [
    index: int # The position of the task to be removed
] {
    list_tasks | drop nth $index | save $task_path -f
    show
}

# Switches the status of a task based on its index (marks it as done or not done).
export def tick [
    index: int # The position of the task to switch its status
] {
    let old_status = list_tasks | get $index | get done
    update_task $index done (not $old_status)
    show
}

# Edits a task description based on its index.
export def desc [
    index: int # The position of the task to switch its status
    ...words: string # An array of strings that make up the task description
] {
    let new_description = $words | str join ' '
    update_task $index description $new_description
    show
}

export def due [
    index: int # The position of the task to switch its status
    ...words: string # An array of strings that make up the task description
] {
    let new_due_date = $words | str join ' '
    update_task $index due $new_due_date
    show
}

export def help [] {
    print $"(ansi cyan)Nutask: a to do app for your favorite shell(ansi reset)\n"
    print $"(ansi yellow)Available subcommands:(ansi reset)"
    print $"    (ansi green)task help(ansi reset)          - Display this help message."
    print $"    (ansi green)task(ansi reset)               - Alias to \"task help\""
    print $"    (ansi green)task ls(ansi reset)            - Alias for the show function to display tasks."
    print $"    (ansi green)task purge(ansi reset)         - Deletes all completed tasks."
    print $"    (ansi green)task rm <index>(ansi reset)    - Remove a task based on its index."
    print $"    (ansi green)task tick <index>(ansi reset)  - Switch the status of a task based on its index."
    print $"    (ansi green)task desc <index> <description>(ansi reset)  - Edit a task description based on its index."
    print $"    (ansi green)task \(p\)riority <index> <priority>(ansi reset)  - Change the priority of a task based on its index."
    print $"    (ansi green)task add <description> [-p <priority>](ansi reset)   
    ╰-> Add a new task with a description and an optional priority \(default: medium\)."
    print $"\n(ansi yellow)Priorities:(ansi reset)"
    print $"    (ansi blue)l - Low(ansi reset)"
    print $"    (ansi white)m - Medium(ansi reset)"
    print $"    (ansi xterm_darkorange)h - High(ansi reset)"
    print $"    (ansi red)u - Urgent(ansi reset)"
}

def update_task [
    index: int # The index of the task to update
    property: string # The property to update
    value # The new value of the property
] {
    let updated_task = list_tasks | get $index | upsert $property $value
    list_tasks | upsert $index $updated_task | sort_save
    show
}

# Returns the list of tasks. If the task file doesn't exist, creates a new one.
def list_tasks [] {
    if not ($task_path| path exists) {
        "[]" | save $task_path
    }
    open $task_path
}

