# module task.nu: a to do app for your favorite shell
use task_helper.nu *

# Main function to display the list of tasks.
export def main [] = {help}

# Aliases.
export def ls [] = {show}
export def pri [index priority] = {priority $index $priority}

# Adds a new task with the given description.
export def add [
    ...words: string # the task description
    --pri: string = "m" # The priority of the task
    --due: string = "" # When the task is due
    --proj: string = ""  # The project of the task
    ] {
    if not (is_priority_valid $pri) {return}

    let desc = $words | str join " "
    let priority_num = get_num_priority $pri
    let done = false
    let due = $due
    let age = date now
    list_tasks | append {
        "description": $desc,
        "priority": $priority_num,
        "proj": $proj,
        "done": $done,
        "age": $age,
        "due": $due,
    } | sort_save
    show
}

# Displays the list of tasks.
export def show [] {
    list_tasks | each { |task|
        $task
            | reject done
            | reject priority
            | update description (colorize $task "description")
            | update age (colorize $task "age")
            | update proj (colorize $task "proj")
            | update due (colorize $task "due")
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

# Sets the project of a task based on its index.
export def proj [
    index: int # The index of the task to change project
    j: string # The project to set
] {
    update_task $index proj $j
    show
}

export def help [] {
    print ("\n" + (apply_color "cyan" "Nutask: a to-do app for your favorite shell\n"))

    print (apply_color "yellow" "Available subcommands:")

    let task_mgmt_cmds = [
        ["task add <description> [--pri <priority>]",
        "⭘ \n    ⭘──▶ Add a new task with a description and optional priority. Ex: task add 'Buy milk' -p h"],
        ["task rm <index>", "▶ Remove a task based on its index. Ex: task rm 2"],
        ["task tick <index>", "▶ Switch the status of a task based on its index. Ex: task tick 2"],
        ["task bump <index>", "▶ Move a task to the top within the same priority. Ex: task bump 2"]
    ]

    let editing_cmds = [
        ["task desc <index> <description>",
        "⭘ \n    ⭘──▶ Edit a task's description based on its index. Ex: task desc 2 'Buy almond milk'"],
        ["task pri <index> <priority>", "▶ Change the priority of a task. Ex: task priority 2 l"],
        ["task due <index> <due_date>", "▶ Edit a task's due date. Ex: task due 2 tomorrow"],
        ["task proj <index> <project>", "▶ Change the project of a task. Ex: task proj 2 work"],
    ]

    let view_cmds = [
        ["task ls", "▶ Display tasks"],
        ["task purge", "▶ Deletes all completed tasks"]
        ["task help", "▶ Displays this help message"]
        ["task", "▶ Alias to task help"]
    ]

    print ("\n" + (apply_color "magenta" "Task Management"))
    display_commands $task_mgmt_cmds

    print ("\n" + (apply_color "magenta" "Task Editing"))
    display_commands $editing_cmds

    print ("\n" + (apply_color "magenta" "View & Cleanup"))
    display_commands $view_cmds

    print ("\n" + (apply_color "yellow" "Priorities:"))
    display_priorities

    print ("\n" + (apply_color "blue" "For more info, visit: https://github.com/luccahuguet/nutask"))

}

