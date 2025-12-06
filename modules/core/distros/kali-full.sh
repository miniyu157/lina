# shellcheck shell=ksh
# shellcheck disable=SC2034,SC2154

distro_init() {
    local v_path="${Version}"
    [[ $v_path == "latest" ]] && v_path="current"

    local tar_name="kali-nethunter-rootfs-full-arm64.tar.xz"
    local sum_name="SHA256SUMS"

    TAR_FILE="$tar_name"
    SUM_FILE="kali-nethunter-full-${v_path}-${sum_name}"

    TAR_URL="https://kali.download/nethunter-images/${v_path}/rootfs/${tar_name}"
    SUM_URL="https://kali.download/nethunter-images/${v_path}/rootfs/${sum_name}"
    SUM_CMD="sha256sum"

    TAR_STRIP=1
}

distro_sum() {
    local ptn="${TAR_FILE/-rootfs/-.*rootfs}"
    grep "$ptn" "$2" | awk -v f="$1" '{print $1, f}' | "$SUM_CMD" -c > /dev/null 2>&1
}
