# =========================================================
# Nushell Configuration
# =========================================================
# Version: 0.111.0
# Author: andev0x
# Purpose: Full-featured developer config with Starship, zoxide,
#          dev aliases, JSON helpers, and safe history.

# =========================================================
# ⚡ Environment Settings
# =========================================================
$env.config = {
  show_banner: false
  edit_mode: vi
  history: {
    max_size: 100000
    sync_on_enter: true
  }
  completions: {
    case_sensitive: false
    quick: true
    partial: true
  }
}

# =========================================================
# ⚡ Prompt (minimal, clean)
# =========================================================
def create_left_prompt [] {
  let dir = (pwd | str replace $nu.home-path "~")
  $"(ansi green)($dir)(ansi reset) "
}

def create_right_prompt [] {
  let time = (date now | format date "%H:%M")
  $"(ansi yellow)($time)(ansi reset)"
}

$env.PROMPT_COMMAND = { create_left_prompt }
$env.PROMPT_COMMAND_RIGHT = { create_right_prompt }

# =========================================================
# ⚡ Aliases for development workflow
# =========================================================
alias ll = ls -la
alias cl = clear

# Go
alias grun = go run main.go
alias gbuild = go build .

# Docker
alias dlog = docker logs -f
alias dcup = docker compose up -d

# =========================================================
# ⚡ JSON & Data Helpers
# =========================================================
# Pretty-print JSON
def pj [] {
  from json | to json --indent 2
}

# Filter JSON by query
def jfilter [query: string] {
  from json | where $query
}

# Sort JSON by field
def jsort [field: string] {
  from json | sort-by $field
}

# =========================================================
# ⚡ Log Analysis Helpers
# =========================================================
def logs-error [] {
  from json | where level == "error"
}

def logs-warn [] {
  from json | where level == "warn"
}

def logs-top [field: string] {
  from json | group-by $field | sort-by count -r
}

# =========================================================
# ⚡ API / HTTP Helpers
# =========================================================
def get [url: string] {
  http get $url | from json
}

def post [url: string body: any] {
  http post $url $body | from json
}

# =========================================================
# ⚡ System Monitoring
# =========================================================
def topcpu [] {
  ps | sort-by cpu -r | first 10
}

def topmem [] {
  ps | sort-by mem -r | first 10
}

# =========================================================
# ⚡ Smart Navigation
# =========================================================
def .. [] { cd .. }
def ... [] { cd ../.. }
def .... [] { cd ../../.. }

# =========================================================
# ⚡ Dev Helpers
# =========================================================
def ports [] {
  netstat -an | where address =~ ":"
}

def myip [] {
  http get https://api.ipify.org
}

# =========================================================
# ⚡ Starship Prompt Integration
# =========================================================
# Starship requires a literal path for source-env
# Generate starship config at ~/.cache/starship.nu
mkdir ($nu.data-dir | path join "vendor/autoload")

# Only source Starship if file exists
if ("~/.cache/starship.nu" | path exists) {
    source-env "~/.cache/starship.nu"
} else {
    # Initialize Starship for Nushell
    starship init nu | save-env "~/.cache/starship.nu"
    source-env "~/.cache/starship.nu"
}

# =========================================================
# ⚡ Zoxide Integration
# =========================================================
# Only source zoxide if file exists
if ("~/.cache/zoxide.nu" | path exists) {
    source-env "~/.cache/zoxide.nu"
} else {
    # Initialize zoxide for Nushell
    zoxide init nushell | save-env "~/.cache/zoxide.nu"
    source-env "~/.cache/zoxide.nu"
}

# =========================================================
# ⚡ Startup Message
# =========================================================
print $"(ansi green)Nushell ready 🚀(ansi reset)"

