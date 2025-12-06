# shellcheck shell=ksh
# shellcheck disable=SC2034,SC2154

distro_init() {
    local ver_short="${Version%.*}"
    local tar_name="alpine-minirootfs-${Version}-aarch64.tar.gz"
    local sum_name="${tar_name}.sha256"

    TAR_FILE="$tar_name"
    SUM_FILE="$sum_name"
    TAR_URL="https://dl-cdn.alpinelinux.org/alpine/v${ver_short}/releases/aarch64/${tar_name}"
    SUM_URL="https://dl-cdn.alpinelinux.org/alpine/v${ver_short}/releases/aarch64/${sum_name}"
    SUM_CMD="sha256sum"
}
