
# =========================================================
# ⚡ Environment
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
#  Prompt (clean + minimal)
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
# ⚡ Aliases (dev workflow)
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
#  JSON / DATA POWER (quan trọng nhất)
# =========================================================

# Pretty print JSON
def pj [] {
  from json | to json --indent 2
}

# Filter JSON nhanh
def jfilter [query: string] {
  from json | where $query
}

# Sort JSON
def jsort [field: string] {
  from json | sort-by $field
}

# =========================================================
#  LOG ANALYSIS (rất mạnh)
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
#  API / HTTP (data engineer mode)
# =========================================================

def get [url: string] {
  http get $url | from json
}

def post [url: string body: any] {
  http post $url $body | from json
}

# =========================================================
#  SYSTEM ANALYSIS
# =========================================================

def topcpu [] {
  ps | sort-by cpu -r | first 10
}

def topmem [] {
  ps | sort-by mem -r | first 10
}

# =========================================================
#  SMART NAVIGATION
# =========================================================

def .. [] { cd .. }
def ... [] { cd ../.. }
def .... [] { cd ../../.. }

# =========================================================
# ⚡ DEV HELPERS
# =========================================================

def ports [] {
  netstat -an | where address =~ ":"
}

def myip [] {
  http get https://api.ipify.org
}

# =========================================================
#  STARTUP MESSAGE (optional)
# =========================================================
print $"(ansi green)Nushell ready 🚀(ansi reset)"
