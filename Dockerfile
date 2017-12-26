FROM ghost:1.19.0-alpine

ENV GHOST_INSTALL /var/lib/ghost

WORKDIR $GHOST_INSTALL

COPY ./config.js ${GHOST_INSTALL}/config.production.json

COPY ./spectre-theme/ ${GHOST_INSTALL}/content/themes/spectre/

## override ghost entrypoint so we can add a wait for the database to initialize
# COPY ./entrypoint.sh /entrypoint.sh
# RUN chmod +x /entrypoint.sh
# ENTRYPOINT ["/entrypoint.sh"]

RUN apk add --no-cache sqlite

# Credit to https://www.ghostforbeginners.com/change-ghost-theme-from-command-line/
# apk add --no-cache sqlite
# sqlite3 ${GHOST_INSTALL}/content/data/ghost.db
# select * from settings where key = 'active_theme';
# 5a41d68e3398de000180efd8|active_theme|casper|theme|2017-12-26 04:56:46|1|2017-12-26 04:56:46|1
# 5a41d68e3398de000180efd8|active_theme|spectre|theme|2017-12-26 04:56:46|1|2017-12-26 04:59:06|1
# "update settings set value='spectre' where key = 'active_theme';"
# echo "select * from settings where key = 'active_theme';" | sqlite3 ghost.db
# echo "update settings set value='spectre' where key = 'active_theme';" | sqlite3 ghost.db
# 5a41d24fc309bd0001aa827e|active_theme|casper|theme|2017-12-26 04:38:39|1|2017-12-26 04:39:24|1


COPY entrypoint.sh /usr/local/bin
RUN chmod +x /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

EXPOSE 2368

CMD ["node", "current/index.js"]
