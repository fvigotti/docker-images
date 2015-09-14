FROM fvigotti/env-fatubuntu

RUN curl -SL https://github.com/odise/go-cron/releases/download/v0.0.7/go-cron-linux.gz \
    | zcat > /usr/local/bin/go-cron \
  && chmod u+x /usr/local/bin/go-cron

COPY files/go-cron-run.sh /usr/local/bin/

RUN chmod +x /usr/local/bin/go-cron-run.sh

EXPOSE 18080
CMD ["go-cron-run.sh"]