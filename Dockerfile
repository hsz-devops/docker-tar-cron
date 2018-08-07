FROM ez123/cron:alpine

ENV \
    DUMP_CRONTAB="0 0 * * *" \
    DUMP_UID="0" \
    DUMP_GID="0" \
    USE_DATE_IN_DEST="1" \
    TAR_OPTIONS="" \
    TAR_EXCLUDE="" \
    DUMP_USER_IF_NEW=tarcron \
    BAK_NAME="untitled"

COPY tar-entrypoint.sh /entrypoint.d/tar.sh
COPY run-tar.sh    /run-tar.sh

RUN set -x; \
    apk add --no-cache --update \
        sudo \
        bash \
        coreutils \
    && rm -rf /tmp/* \
    && rm -rf /var/cache/apk/* \
    \
    && chmod +x \
        /entrypoint.d/tar.sh \
        /run-tar.sh \
    && mkdir -p \
        /mnt_dir/0.src \
        /mnt_dir/9.dst \
    && chmod a+rwx \
        /mnt_dir \
        /mnt_dir/9.dst \
    && chmod a=rx \
        /mnt_dir/0.src \
    && echo done...

VOLUME ["/mnt_dir/0.src", "/mnt_dir/9.dst"]
