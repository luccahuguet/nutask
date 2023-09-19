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
    --p: string = "m" # The priority of the task
] {
    if not (is_priority_valid $p) {return}

    let description = $words | str join " "
    let date_now = date now
    let $p_num = get_num_priority $p
    list_tasks | append {
     "description": $description, "priority": $p_num, "done": false, "age": $date_now
    } | sort_save
    show
}

# Displays the list of tasks.
export def show [] {
    list_tasks | each { |task| 
        let desc_color = color_done $task.done
        let pri_name = get_pri_name $task.priority
        let new_task = $task | reject done
        if $task.done {
            $new_task 
                | update priority ($"($desc_color)($pri_name)(ansi reset)")
                | update description ($"($desc_color)($task.description)(ansi reset)")         
        } else {
            $new_task 
                | update priority ($"(get_pri_color $task.priority)($pri_name)(ansi reset)")
                | update description ($"(get_pri_color $task.priority)($task.description)(ansi reset)")         
        }
    }
}
def color_done [done: bool] { if $done { (ansi green) } else { (ansi white) } }

# Colors the priority of a task, and returns the colored string.
def get_pri_name [priority: number] {
    match $priority {
        1 => { "low" }
        2 => { "medium" }
        3 => { "high" }
        4 => { "urgent" }
        _ => { echo "Unknown priority!" }
    }
}

# Colors the priority of a task, and returns the colored string.
def get_pri_color [priority: number] { 
    match $priority {
        1 => { (ansi blue) }
        2 => { (ansi white) }
        3 => { (ansi xterm_darkorange) }
        4 => { (ansi red) }
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
export def edit [
    index: int # The position of the task to switch its status
    ...words: string # An array of strings that make up the task description
] {
    let new_description = $words | str join ' '
    update_task $index description $new_description
    show
}

export def help [] {
    print $"(ansi cyan)Nutask: a to do app for your favorite shell(ansi reset)\n"
    print $"(ansi yellow)Available subcommands:(ansi reset)"
    print $"    (ansi green)task(ansi reset)               - Display the list of tasks."
    print $"    (ansi green)task help(ansi reset)          - Display this help message."
    print $"    (ansi green)task ls(ansi reset)            - Alias for the show function to display tasks."
    print $"    (ansi green)task purge(ansi reset)         - Deletes all completed tasks."
    print $"    (ansi green)task rm <index>(ansi reset)    - Remove a task based on its index."
    print $"    (ansi green)task tick <index>(ansi reset)  - Switch the status of a task based on its index."
    print $"    (ansi green)task edit <index> <description>(ansi reset)  - Edit a task description based on its index."
    print $"    (ansi green)task \(p\)riority <index> <priority>(ansi reset)  - Change the priority of a task based on its index."
    print $"    (ansi green)task add <description> [--p <priority>](ansi reset)   
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

