# shellcheck shell=ksh
# shellcheck disable=SC2034,SC2154

# -----------------------------------------------------------------------------
# Lina Distribution Definition
# -----------------------------------------------------------------------------
# [Protocol]
# Context (Provided by main script):
#   $Version   : User input version string (e.g., "22.04", "latest")
#   $BasePath  : Chroot base directory (e.g., "/data/local/chroot")
#
# Mandatory Hook:
#   distro_init()
#     Must export the following global variables:
#     -> $TAR_FILE : Absolute path for local tarball
#     -> $SUM_FILE : Absolute path for local checksum file
#     -> $TAR_URL  : Download URL for the tarball
#     -> $SUM_URL  : Download URL for the checksum file
#     -> $SUM_CMD  : Checksum command (e.g., "md5sum", "sha256sum")
#
# Optional Hooks (Override if necessary):
#   distro_sum <tarball_path> <checksum_file_path>
#     $1: Absolute path to the tarball
#     $2: Absolute path to the checksum file
#     Returns: 0 for success, non-zero for failure.
#     Default: "$SUM_CMD" -c "$2"
#
#   distro_hook <rootfs_path>
#     $1: Absolute path to the mounted rootfs
#     Perform distro-specific post-install configuration here.
#     Default: no-op
# -----------------------------------------------------------------------------

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
