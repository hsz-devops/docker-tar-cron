FROM ez123/cron:alpine

ENV \
    TAR_CRONTAB="0 0 * * *" \
    TAR_OPTIONS="" \
    TAR_UID="0" \
    TAR_GID="0" \
    USE_DATE_IN_DEST="1" \
    TAR_EXCLUDE="" \
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
        /tar_dir/0.src \
        /tar_dir/9.dst \
    && chmod a+rwx \
        /tar_dir \
        /tar_dir/9.dst \
    && chmod a=rx \
        /tar_dir/0.src \
    && echo done...

VOLUME ["/tar_dir/0.src", "/tar_dir/9.dst"]
