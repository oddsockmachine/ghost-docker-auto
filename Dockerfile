FROM ghost:1.19.0-alpine

ENV GHOST_INSTALL /var/lib/ghost

WORKDIR $GHOST_INSTALL

COPY ./config.js ${GHOST_INSTALL}/config.production.json

COPY ./spectre-theme/ ${GHOST_INSTALL}/content/themes/spectre/

## override ghost entrypoint so we can add a wait for the database to initialize
# COPY ./entrypoint.sh /entrypoint.sh
# RUN chmod +x /entrypoint.sh
# ENTRYPOINT ["/entrypoint.sh"]




COPY entrypoint.sh /usr/local/bin

ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 2368

CMD ["node", "current/index.js"]
