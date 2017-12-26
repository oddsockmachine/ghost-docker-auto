#!/bin/bash
set -e

# allow the container to be started with `--user`
if [[ "$*" == node*current/index.js* ]] && [ "$(id -u)" = '0' ]; then
	chown -R node "$GHOST_CONTENT"
	exec su-exec node "$BASH_SOURCE" "$@"
fi

if [[ "$*" == node*current/index.js* ]]; then
	baseDir="$GHOST_INSTALL/content.orig"
	for src in "$baseDir"/*/ "$baseDir"/themes/*; do
		src="${src%/}"
		target="$GHOST_CONTENT/${src#$baseDir/}"
		mkdir -p "$(dirname "$target")"
		if [ ! -e "$target" ]; then
			tar -cC "$(dirname "$src")" "$(basename "$src")" | tar -xC "$(dirname "$target")"
		fi
	done

	knex-migrator-migrate --init --mgpath "$GHOST_INSTALL/current"
fi

# Credit to https://www.ghostforbeginners.com/change-ghost-theme-from-command-line/
# apk add --no-cache sqlite
# sqlite3 ${GHOST_INSTALL}/content/data/ghost.db
# select * from settings where key = 'active_theme';
# 5a41d68e3398de000180efd8|active_theme|casper|theme|2017-12-26 04:56:46|1|2017-12-26 04:56:46|1
# 5a41d68e3398de000180efd8|active_theme|spectre|theme|2017-12-26 04:56:46|1|2017-12-26 04:59:06|1
# "update settings set value='spectre' where key = 'active_theme';"
echo "select * from settings where key = 'active_theme';" | sqlite3 /var/lib/ghost/content/data/ghost.db
echo "update settings set value='spectre' where key = 'active_theme';" | sqlite3 /var/lib/ghost/content/data/ghost.db
# 5a41d24fc309bd0001aa827e|active_theme|casper|theme|2017-12-26 04:38:39|1|2017-12-26 04:39:24|1


exec "$@"
