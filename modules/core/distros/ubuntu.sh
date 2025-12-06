# shellcheck shell=ksh
# shellcheck disable=SC2034,SC2154

distro_init() {
    local tar_name="ubuntu-base-${Version}-base-arm64.tar.gz"
    local sum_name="SHA256SUMS"

    TAR_FILE="$tar_name"
    SUM_FILE="ubuntu-${Version}-${sum_name}"
    TAR_URL="https://cdimage.ubuntu.com/ubuntu-base/releases/${Version}/release/${tar_name}"
    SUM_URL="https://cdimage.ubuntu.com/ubuntu-base/releases/${Version}/release/${sum_name}"
    SUM_CMD="sha256sum"
}

distro_sum() {
    local sumfile="$2"
    grep "$TAR_FILE" "$sumfile" | "$SUM_CMD" -c > /dev/null 2>&1
}
