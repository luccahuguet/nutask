# Variables
export const task_path = "/home/lucca/.tasks.nuon"
# export def task_path [] { $env.HOME ++ "/.tasks.nuon" }
export const list_of_priorities = ["l" "m" "h" "u"]

export def sort_tasks [] { sort-by done priority -r age }
export def sort_save [] { sort_tasks | collect | save $task_path -f }

export def shorten_unit [input]: string -> string {
    match $input {
        "second" => { "s" }
        "minute" => { "m" }
        "hour"  => { "h" }
        "day"    => { "d" }
        "week"   => { "w" }
        "month"  => { "mo" }
        "year"   => { "y" }
        _           => { null }
    }
}

export def parse_date [input] {
    let parsed = $input | parse "{fst} {snd} {third}"
    let fst = $parsed.fst | str join " "
    let snd = $parsed.snd | str join " "
    let third = $parsed.third | str join " "
    if ($snd == "" and $third == "") { return $input }
    mut date = if (($fst) == "in") {
        {number: $snd, unit: $third, future: true}
    } else { 
        {number: $fst, unit: $snd, future: false}
    }
    shorten_any_date $date.number $date.unit $date.future
}

export def shorten_any_date [number, unit, future] {
    let res = if ($number in ["a", "an"]) {
        "1" + (shorten_unit $unit)
    } else {
        let $new_unit = $unit | str substring 0..(($unit | str length) - 2)
        let shorten_unit = shorten_unit $new_unit
        $number + $shorten_unit
    }
    if $future {"in " + $res} else { $res }
}

export def try_date [date_string: string] {
        try {
            let date_h = $date_string | into datetime | date humanize
            parse_date $date_h
        } catch {
            $date_string
        }
}

export def colorize [task, field: string] {
    let color = if $task.done { "green" } else { get_color $task $field }
    apply_color $color (get_field_value $task $field)
}

export def get_color [task, field: string] {
    match $field {
        "description" => { get_priority $task.priority | get color }
        "priority" => { get_priority $task.priority | get color }
        "age" => { "purple" }
        "proj" => { "yellow" }
        "due" => { "purple" }
        _ => { "white" }
    }
}

export def get_field_value [task, field: string] {
    match $field {
        "description" => { $task.description }
        "priority" => { get_priority $task.priority | get name }
        "age" => { parse_date ($task.age | date humanize) }
        "proj" => { $task.proj }
        "due" => { try_date $task.due }
        _ => { "" }
    }
}

export def apply_color [color: string, str: string] { $"(ansi $color)($str)(ansi reset)" }

export def get_priority [priority: number] {
    match $priority {
        1 => { {name: "low", color: "blue"} }
        2 => { {name: "medium", color: "white"} }
        3 => { {name: "high", color: "xterm_darkorange"} }
        4 => { {name: "urgent", color: "red"} }
        _ => { echo "Unknown priority!" }
    }
}

export def get_num_priority [
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

export def is_priority_valid [
    priority: string
] {
    if not ($priority in $list_of_priorities) {
        print $"Invalid priority. Valid priorities are: ($list_of_priorities | str join ', ' )"
        false
    } else {
        true
    }
}

export def update_task [
    index: int # The index of the task to update
    property: string # The property to update
    value # The new value of the property
] {
    let updated_task = list_tasks | get $index | upsert $property $value
    list_tasks | upsert $index $updated_task | sort_save
}

export def list_tasks [] {
    if not ($task_path| path exists) {
        "[]" | save $task_path
    }
    open $task_path
}
export def display_commands [commands] {
    $commands | each { |inn|
        let command_part = apply_color "green" ($inn | get 0)
        let desc_part = apply_color "white" ($inn | get 1)
        print ("   " + $command_part + " ──" + $desc_part)
    }
}

export def display_priorities [] {
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

