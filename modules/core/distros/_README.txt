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
#     -> $TAR_STRIP: (Optional) Strip N leading components on extraction.
#                    Set to "1" if tarball has a parent dir. Default: 0.
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
