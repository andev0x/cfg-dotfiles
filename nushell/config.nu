# Nushell Config File
# version = "0.95.0"

# Minimalist Dark Green Forest Theme
let dark_theme = {
    # Color for nushell primitives
    separator: dark_gray
    leading_trailing_space_bg: { attr: n }
    header: green_bold
    empty: light_green
    bool: light_cyan
    int: white
    filesize: cyan
    duration: white
    date: purple
    range: white
    float: white
    string: white
    nothing: white
    binary: white
    cell-path: white
    row_index: green_bold
    record: white
    list: white
    block: white
    hints: dark_gray
    search_result: { bg: green fg: black }
    shape_and: purple_bold
    shape_binary: purple_bold
    shape_block: blue_bold
    shape_bool: light_cyan
    shape_closure: green_bold
    shape_custom: green
    shape_datetime: cyan_bold
    shape_directory: cyan
    shape_external: cyan
    shape_externalarg: green_bold
    shape_external_resolved: light_yellow_bold
    shape_filepath: cyan
    shape_flag: blue_bold
    shape_float: purple_bold
    shape_garbage: { fg: white bg: red attr: b }
    shape_glob_interpolation: cyan_bold
    shape_globpattern: cyan_bold
    shape_int: purple_bold
    shape_internalcall: cyan_bold
    shape_keyword: cyan_bold
    shape_list: cyan_bold
    shape_literal: blue
    shape_match_pattern: green
    shape_matching_brackets: { attr: u }
    shape_nothing: light_cyan
    shape_operator: yellow
    shape_or: purple_bold
    shape_pipe: purple_bold
    shape_range: yellow_bold
    shape_record: cyan_bold
    shape_redirection: purple_bold
    shape_signature: green_bold
    shape_string: green
    shape_string_interpolation: cyan_bold
    shape_table: blue_bold
    shape_variable: purple
    shape_vardecl: purple
    shape_raw_string: light_purple
}

$env.config = {
    show_banner: false

    ls: {
        use_ls_colors: true
    }

    rm: {
        always_trash: false
    }

    table: {
        mode: rounded
        index_mode: always
        show_empty: true
        padding: { left: 1, right: 1 }
        trim: {
            methodology: wrapping
            wrapping_try_keep_words: true
            truncating_suffix: "..."
        }
        header_on_separator: false
    }

    error_style: "fancy"

    datetime_format: {}

    explore: {
        status_bar_background: { fg: "#1D1F21", bg: "#C4C9C6" }
        command_bar_text: { fg: "#C4C9C6" }
        highlight: { fg: "black", bg: "green" }
        status: {
            error: { fg: "white", bg: "red" }
            warn: {}
            info: {}
        }
        selected_cell: { bg: dark_gray }
    }

    history: {
        max_size: 100_000
        sync_on_enter: true
        file_format: "plaintext"
        isolation: false
    }

    completions: {
        case_sensitive: false
        quick: true
        partial: true
        algorithm: "prefix"
        external: {
            enable: true
            max_results: 100
            completer: null
        }
        use_ls_colors: true
    }

    cursor_shape: {
        emacs: block
        vi_insert: block
        vi_normal: underscore
    }

    color_config: $dark_theme
    footer_mode: 25
    float_precision: 2
    buffer_editor: "nvim" # Enforce Neovim as default buffer editor
    use_ansi_coloring: true
    bracketed_paste: true
    edit_mode: vi # Stick to vi mode for unified workflow

    shell_integration: {
        osc2: true
        osc7: true
        osc8: true
        osc9_9: false
        osc133: true
        osc633: true
        reset_application_mode: true
    }

    render_right_prompt_on_last_line: false
    use_kitty_protocol: false
    highlight_resolved_externals: false
    recursion_limit: 50

    plugins: {}

    plugin_gc: {
        default: {
            enabled: true
            stop_after: 10sec
        }
        plugins: {}
    }

    hooks: {
        pre_prompt: [{||
            if (which direnv | is-empty) {
                return
            }
            try {
                direnv export json | from json | default {} | load-env
                if 'PATH' in $env {
                    $env.PATH = ($env.PATH | split row (char esep))
                }
            } catch {}
        }]
        pre_execution: [{ null }]
        env_change: {
            PWD: []
        }
        display_output: "if (term size).columns >= 100 { table -e } else { table }"
        command_not_found: { null }
    }

    menus: [
        {
            name: completion_menu
            only_buffer_difference: false
            marker: "| "
            type: {
                layout: columnar
                columns: 4
                col_width: 20
                col_padding: 2
            }
            style: {
                text: green
                selected_text: { attr: r }
                description_text: yellow
                match_text: { attr: u }
                selected_match_text: { attr: ur }
            }
        }
        {
            name: ide_completion_menu
            only_buffer_difference: false
            marker: "| "
            type: {
                layout: ide
                min_completion_width: 0
                max_completion_width: 50
                max_completion_height: 10
                padding: 0
                border: true
                cursor_offset: 0
                description_mode: "prefer_right"
                min_description_width: 0
                max_description_width: 50
                max_description_height: 10
                description_offset: 1
                correct_cursor_pos: false
            }
            style: {
                text: green
                selected_text: { attr: r }
                description_text: yellow
                match_text: { attr: u }
                selected_match_text: { attr: ur }
            }
        }
        {
            name: history_menu
            only_buffer_difference: true
            marker: "? "
            type: {
                layout: list
                page_size: 10
            }
            style: {
                text: green
                selected_text: green_reverse
                description_text: yellow
            }
        }
    ]

    # Cleaned up and deduplicated keybindings
    keybindings: [
        {
            name: completion_menu
            modifier: none
            keycode: tab
            mode: [vi_normal vi_insert]
            event: {
                until: [
                    { send: menu name: completion_menu }
                    { send: menunext }
                    { edit: complete }
                ]
            }
        }
        {
            name: ide_completion_menu
            modifier: control
            keycode: char_n
            mode: [vi_normal vi_insert]
            event: {
                until: [
                    { send: menu name: ide_completion_menu }
                    { send: menunext }
                    { edit: complete }
                ]
            }
        }
        {
            name: history_menu
            modifier: control
            keycode: char_r
            mode: [vi_insert vi_normal]
            event: { send: menu name: history_menu }
        }
        {
            name: cancel_command
            modifier: control
            keycode: char_c
            mode: [vi_normal vi_insert]
            event: { send: ctrlc }
        }
        {
            name: quit_shell
            modifier: control
            keycode: char_d
            mode: [vi_normal vi_insert]
            event: { send: ctrld }
        }
        {
            name: clear_screen
            modifier: control
            keycode: char_l
            mode: [vi_normal vi_insert]
            event: { send: clearscreen }
        }
        {
            name: open_command_editor
            modifier: control
            keycode: char_o
            mode: [vi_normal vi_insert]
            event: { send: openeditor }
        }
        {
            name: move_to_line_start
            modifier: control
            keycode: char_a
            mode: [vi_normal vi_insert]
            event: { edit: movetolinestart }
        }
        {
            name: move_to_line_end
            modifier: control
            keycode: char_e
            mode: [vi_normal vi_insert]
            event: {
                until: [
                    { send: historyhintcomplete }
                    { edit: movetolineend }
                ]
            }
        }
        {
            name: delete_one_word_backward
            modifier: control
            keycode: backspace
            mode: vi_insert
            event: { edit: backspaceword }
        }
        {
            name: delete_one_word_backward
            modifier: control
            keycode: char_w
            mode: vi_insert
            event: { edit: backspaceword }
        }
    ]
}

# Change directory and list contents automatically
def --env cx [path?: string] {
    let target = if ($path | is-empty) { "~" | path expand } else { $path | path expand }
    cd $target
    ls -la
}

# Focus window via Aerospace and FZF
def ff [] {
    ^aerospace list-windows --all | ^fzf --bind 'enter:execute(bash -c "aerospace focus --window-id {1}")+abort'
}

# General Aliases
alias l = ls --all
alias c = clear
alias ll = ls -l
alias lt = eza --tree --level=2 --long --icons --git
alias v = nvim
alias as = aerospace
alias asr = atuin scripts run
alias oc = opencode

# Git Aliases
alias gc = git commit -m
alias gca = git commit -a -m
alias gp = git push origin HEAD
alias gpu = git pull origin
alias gst = git status
alias glog = git log --graph --topo-order --pretty='%w(100,0,6)%C(yellow)%h%C(bold)%C(black)%d %C(cyan)%ar %C(green)%an%n%C(bold)%C(white)%s %N' --abbrev-commit
alias gdiff = git diff
alias gco = git checkout
alias gb = git branch
alias gba = git branch -a
alias gadd = git add
alias ga = git add -p
alias gcoall = git checkout -- .
alias gr = git remote
alias gre = git reset

# Kubernetes Aliases - Fixed duplicate 'kl' conflict
alias k = kubectl
alias ka = kubectl apply -f
alias kg = kubectl get
alias kd = kubectl describe
alias kdel = kubectl delete
alias klo = kubectl logs      # renamed from kl
alias klf = kubectl logs -f   # renamed from kl
alias kgpo = kubectl get pod
alias kgd = kubectl get deployments
alias kc = kubectx
alias kns = kubens
alias ke = kubectl exec -it

# Sourcing external configs safely
#source ~/.zoxide.nu
#source ~/.cache/carapace/init.nu
#source ~/.local/share/atuin/init.nu
use ~/.cache/paneship/init.nu
#use ~/.cache/mise/init.nu

$env.DIRENV_LOG_FORMAT = ""

# Load autoload directory
source ~/.config/nushell/vendor/autoload/wt.nu
