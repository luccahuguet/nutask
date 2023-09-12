# module task.nu: a to do app for your favorite shell

# Main function to display the list of tasks.
export def main [] = {help}

# Alias for the show function.
export def ls [] = {show}

# Variables
const task_path = "~/.tasks.nuon"
const list_of_priorities = ["l" "a" "h" "u"]

# Adds a new task with the given description.
export def add [
    ...words: string # the task description
    --p: string = "a" # The priority of the task
] {
    check_priority $p

    let task = $words | str join " "
    let date_now = date now
    let $p_num = get_num_priority $p
    list_tasks | append { "task": $task, "priority": $p_num, "done": false, "age": $date_now} | save $task_path -f
    show
}

# Displays the list of tasks.
export def show [] {
    list_tasks | each {|in|
        ($in | upsert task $"(color_done $in.done) ($in.task) (ansi reset)")
    } | each {|in|
        ($in | upsert priority $"(get_pretty_priority $in.priority)")
    }
}

def sort_tasks [] { sort-by done priority -r age }

def color_done [
    done: bool
] {
    if $done { ansi green } else { ansi white }
}

# Colors the priority of a task, and returns the colored string.
def get_pretty_priority [
    priority: number
] {
    match $priority {
        1 => { ($"(ansi blue) low (ansi reset)") }
        2 => { ($"(ansi white) medium (ansi reset)") }
        3 => { ($"(ansi xterm_darkorange) high (ansi reset)") }
        4 => { ($"(ansi red) urgent (ansi reset)") }
        _ => { echo "Unknown priority!" }
    }
}

# obtains the numeric priority of a task
def get_num_priority [
    priority: string
] {
    match $priority {
        "l" => { 1 }
        "a" => { 2 }
        "h" => { 3 }
        "u" => { 4 }
        _ => {
            echo "Unknown priority!"
            return 0
        }
    }
}


def check_priority [
    priority: string
] {
    if not ($priority in $list_of_priorities) {
        print $"Invalid priority. Valid priorities are: ($list_of_priorities | str join ', ' )"
        return
    }
}

# Sets the priority of a task based on its index.
export def p [
    index: int # The index of the task to bump up
    p: string # The priority to set
] {
    check_priority $p
    let $p_num = get_num_priority $p
    update_task $index priority $p_num
    show
}

# Clears all completed tasks.
export def clear [] {
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
export def done [
    index: int # The position of the task to switch its status
] {
    let old_status = list_tasks | get $index | get done
    update_task $index done (not $old_status)
    show
}

# Edits a task description based on its index.
export def edit [
    index: int # The position of the task to switch its status
    ...words: string # words: An array of strings that make up the task description
] {
    let new_task = $words | str join ' '
    update_task $index task $new_task
    show
}

# Bumps a task to the top of the list.
export def bump [
    index: int # The index of the task to bump up
] {
    let bumped_task = list_tasks | get $index;
    let $first_undone_index = list_tasks | enumerate | where not $it.item.done | first | get index;
    list_tasks | drop nth $index | insert $first_undone_index $bumped_task | save $task_path -f
    show
}

# Displays the help message.
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
    value # The new value of the property
] {
    let updated_task = list_tasks | get $index | upsert $property $value
    list_tasks | upsert $index $updated_task | sort_tasks | save $task_path -f
    show
}

# Returns the list of tasks. If the task file doesn't exist, creates a new one.
def list_tasks [] {
    if not ($task_path| path exists) {
        "[]" | save $task_path
    }
    open $task_path
}

