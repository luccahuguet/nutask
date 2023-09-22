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
    -d: string = "-" # When the task is due
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

def shorten [input] {
    let $input = $input | date humanize
    match $input {
        "now"            =>  { "now" }
        "a minute ago"   =>  { "1m" }
        "an hour ago"    =>  { "1h" }
        "a day ago"      =>  { "1d" }
        "a week ago"     =>  { "1w" }
        "a month ago"    =>  { "1mo" }
        "a year ago"     =>  { "1y" }
        "eternity"   =>  { "∞" }
        _            =>  { 
            # For other strings with numbers
            let num = $input | split column " " | $in.column1 | to text
            let text = $input | split column " " | $in.column2 | to text
            match  $text {
                "minutes" => { $num + "m"  }
                "hours" =>   { $num + "h"  }
                "days"  =>   { $num + "d"  }
                "weeks" =>   { $num + "w"  }
                "months" =>  { $num + "mo" }
                "years" =>   { $num + "y"  }
                _       =>   { $num        }
            }
        }
    }
}

# Displays the list of tasks.
export def show [] {
    list_tasks | each { |task| 
        let done_color = get_done_color $task.done
        let pri = get_priority $task.priority
        let color = if $task.done {$done_color} else {$pri.color}
        $task 
            | reject done
            | update priority (apply_color $color $pri.name)
            | update description (apply_color $color $task.description)
            | update age (apply_color "purple" (shorten $task.age))
    }
}

def get_done_color [done: bool] { if $done { "green" } else { "white" } }

def apply_color [color: string, str: string] { $"(ansi $color)($str)(ansi reset)" }

def get_priority [priority: number] {
    match $priority {
        1 => { {name: "low", color: "blue"} }
        2 => { {name: "medium", color: "white"} }
        3 => { {name: "high", color: "xterm_darkorange"} }
        4 => { {name: "urgent", color: "red"} }
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

# Bumps a task to the top of the list, within the same priority.
export def bump [
    index: int # The position of the task to switch its status
] {
    let bumped = list_tasks | get $index; 
    let undone = list_tasks | enumerate | where not $it.item.done
    let pri_start_idx = $undone | where $it.item.priority == $bumped.priority | first | get index
    list_tasks | drop nth $index | insert $pri_start_idx $bumped | save $task_path -f
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
    print ("\n" + (apply_color "cyan" "Nutask: a to-do app for your favorite shell\n"))

    print (apply_color "yellow" "Available subcommands:")

    let task_mgmt_cmds = [
        ["task add <description> [-p <priority>]", 
        "◯\n    ◯──> Add a new task with a description and optional priority. Ex: task add 'Buy milk' -p h"],
        ["task rm <index>", "> Remove a task based on its index. Ex: task rm 2"],
        ["task tick <index>", "> Switch the status of a task based on its index. Ex: task tick 2"],
        ["task bump <index>", "> Move a task to the top within the same priority. Ex: task bump 2"]
    ]

    let editing_cmds = [
        ["task desc <index> <description>", 
        "◯\n    ◯──> Edit a task's description based on its index. Ex: task desc 2 'Buy almond milk'"],
        ["task priority <index> <priority>", "> Change the priority of a task. Ex: task priority 2 l"],
        ["task due <index> <due_date>", "> Edit a task's due date. Ex: task due 2 '2023-10-10'"]
    ]

    let view_cmds = [
        ["task ls", "> Display tasks"],
        ["task purge", "> Deletes all completed tasks"]
        ["task help", "> Displays this help message"]
        ["task", "> Alias to task help"]
    ]

    print ("\n" + (apply_color "magenta" "Task Management"))
    display_commands $task_mgmt_cmds

    print ("\n" + (apply_color "magenta" "Task Editing"))
    display_commands $editing_cmds

    print ("\n" + (apply_color "magenta" "View & Cleanup"))
    display_commands $view_cmds

    print ("\n" + (apply_color "yellow" "Priorities:"))
    display_priorities

    print ("\n" + (apply_color "blue" "For more help, visit: https://docs.nutask.com"))

}

def display_commands [commands] {
    $commands | each { |inn|
        let command_part = apply_color "green" ($inn | get 0)
        let desc_part = apply_color "white" ($inn | get 1)
        print ("   " + $command_part + " ──" + $desc_part)
    }
}

def display_priorities [] {
    let priorities = [
        {"color": "blue", "desc": "l - Low"},
        {"color": "white", "desc": "m - Medium"},
        {"color": "xterm_darkorange", "desc": "h - High"},
        {"color": "red", "desc": "u - Urgent"}
    ]

    $priorities | each { |in|
        print (apply_color $in.color ("   " + $in.desc))
    } 
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

