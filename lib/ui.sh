# shellcheck disable=SC2059

init_ui() {
    if [[ ! -t 1 ]] && [[ -z $FORCE_COLOR ]]; then
        unset BOLD COFF DGRAY LGRAY RED GREEN YELLOW BLUE PINK CYAN
        return
    fi

    BOLD=$'\e[1m'
    COFF=$'\e[0m'
    GRAY=$'\e[38;5;243m'
    DGRAY=$'\e[38;2;88;91;112m'
    LGRAY=$'\e[38;2;166;173;200m'
    RED=$'\e[38;2;243;139;168m'
    GREEN=$'\e[38;2;166;227;161m'
    YELLOW=$'\e[38;2;249;226;175m'
    BLUE=$'\e[38;2;137;180;250m'
    PINK=$'\e[38;2;245;194;231m'
    CYAN=$'\e[38;2;148;226;213m'
    readonly BOLD COFF GRAY DGRAY LGRAY RED GREEN YELLOW BLUE PINK CYAN
}

init_ui

m1red()     { local m=$1; shift; printf "${RED}==>${COFF}${BOLD} ${m}${COFF}\n" "$@"; }
m1green()   { local m=$1; shift; printf "${GREEN}==>${COFF}${BOLD} ${m}${COFF}\n" "$@"; }
m1yellow()  { local m=$1; shift; printf "${YELLOW}==>${COFF}${BOLD} ${m}${COFF}\n" "$@"; }
m1blue()    { local m=$1; shift; printf "${BLUE}==>${COFF}${BOLD} ${m}${COFF}\n" "$@"; }
m1pink()    { local m=$1; shift; printf "${PINK}==>${COFF}${BOLD} ${m}${COFF}\n" "$@"; }
m1cyan()    { local m=$1; shift; printf "${CYAN}==>${COFF}${BOLD} ${m}${COFF}\n" "$@"; }

m2red()     { local m=$1; shift; printf "${RED}  ->${COFF}${BOLD} ${m}${COFF}\n" "$@"; }
m2green()   { local m=$1; shift; printf "${GREEN}  ->${COFF}${BOLD} ${m}${COFF}\n" "$@"; }
m2yellow()  { local m=$1; shift; printf "${YELLOW}  ->${COFF}${BOLD} ${m}${COFF}\n" "$@"; }
m2blue()    { local m=$1; shift; printf "${BLUE}  ->${COFF}${BOLD} ${m}${COFF}\n" "$@"; }
m2pink()    { local m=$1; shift; printf "${PINK}  ->${COFF}${BOLD} ${m}${COFF}\n" "$@"; }
m2cyan()    { local m=$1; shift; printf "${CYAN}  ->${COFF}${BOLD} ${m}${COFF}\n" "$@"; }

m1()        { local m=$1; shift; printf "${GREEN}==>${COFF}${BOLD} ${m}${COFF}\n" "$@"; }
m1warn()    { local m=$1; shift; printf "${YELLOW}==> 警告:${COFF}${BOLD} ${m}${COFF}\n" "$@" >&2; }
m1err()     { local m=$1; shift; printf "${RED}==> 错误: ${COFF}${BOLD} ${m}${COFF}\n" "$@" >&2; }

m2()        { local m=$1; shift; printf "${BLUE}  ->${COFF}${BOLD} ${m}${COFF}\n" "$@"; }
m2err()     { local m=$1; shift; printf "${RED}  ->${COFF}${BOLD} ${m}${COFF}\n" "$@" >&2; }

plain()     { local m=$1; shift; printf "${BOLD}    ${m}${COFF}\n" "$@"; }
ask()       { local m=$1; shift; printf "${BLUE}::${COFF}${BOLD} ${m}${COFF}" "$@"; }
