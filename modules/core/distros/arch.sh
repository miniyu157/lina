# shellcheck shell=ksh
# shellcheck disable=SC2034,SC2154

distro_init() {
    local tar_name="archlinuxarm-aarch64-latest.tar.gz"
    local sum_name="${tar_name}.md5"

    TAR_FILE="$tar_name"
    SUM_FILE="$sum_name"
    TAR_URL="http://os.archlinuxarm.org/os/$tar_name"
    SUM_URL="http://os.archlinuxarm.org/os/$sum_name"
    SUM_CMD="md5sum"
}
