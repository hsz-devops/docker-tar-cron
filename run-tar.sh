#!/usr/bin/env bash
set -ex

echo $UID $GID $(whoami)

[ -z "$1" ] && echo "RSYNC UID parameter not specified" && exit -1
[ -z "$2" ] && echo "RSYNC GID parameter not specified" && exit -2

### extract year, month, day to create sub-directories and format date to append to backup name.
T_STAMP=$(date -u  "+%Y%m%d_%H%M%SZ")
echo "current timestamp is: ${T_STAMP}"

BACKUP_ROOT="/mnt_dir"
BACKUP_ROOT_SRC="${BACKUP_ROOT}/0.src"
BACKUP_ROOT_DST="${BACKUP_ROOT}/9.dst"

ls -la "${BACKUP_ROOT}"     ||true
ls -la "${BACKUP_ROOT_SRC}" ||true
ls -la "${BACKUP_ROOT_DST}" ||true

[ -d "${BACKUP_ROOT_SRC}" ] || exit -3
[ -d "${BACKUP_ROOT_DST}" ] || exit -4

if [ "${USE_DATE_IN_DEST}" == "1" ]; then
    CURRENT_YEAR="${T_STAMP:0:4}"
    CURRENT_MONTH="${T_STAMP:4:2}"
    CURRENT_DAY="${T_STAMP:6:2}"
    BACKUP_DIR_DST="${BACKUP_ROOT_DST}/${CURRENT_YEAR}/${CURRENT_MONTH}/${CURRENT_DAY}"

    ### create backups directory if not present
    mkdir -p "${BACKUP_DIR_DST}"
else
    BACKUP_DIR_DST="${BACKUP_ROOT_DST}"
fi

ls -la "${BACKUP_DIR_DST}" ||true
[ -d "${BACKUP_DIR_DST}" ] || exit -5

## make sure folder is writeable by the user
## but not recursivelly (there may already be some files from previous backups in same day)
chown "$1":"$2" "${BACKUP_DIR_DST}"

echo "backup directory: ${BACKUP_DIR_DST}"

TAR_ARCHIVE_NAME="${BACKUP_DIR_DST}/${BAK_NAME}.${T_STAMP}.tar.gz"

ls -la "${BACKUP_ROOT_SRC}" ||true
pushd "${BACKUP_ROOT_SRC}"

# doing this weird repetition because I could not find out how to add a simple set of single quotes around the ${TAR_EXCLUDE}
# watch out if you use wildcards
if [ -z "${TAR_EXCLUDE}" ]; then
    sudo -u "$1" -g "$2" tar c -z -f ${TAR_ARCHIVE_NAME} .
else
    sudo -u "$1" -g "$2" tar c -z -f ${TAR_ARCHIVE_NAME} --exclude "${TAR_EXCLUDE}" .
fi
