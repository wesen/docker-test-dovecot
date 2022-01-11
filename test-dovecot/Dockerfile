# This file is part of docker-test-dovecot (https://github.com/spezifisch/docker-test-dovecot)
# Original source: https://github.com/gw0/docker-dovecot-getmail/tree/6ab6e11e922899d00fbc970c7767333faf5d4177
# Copyright (C) 2021-2022 spezifisch (https://github.com/spezifisch)
# Copyright (C) 2021      gw0 (http://gw.tnode.com/) <gw.2021@ena.one>

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published by
# the Free Software Foundation.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.

# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

FROM debian:bullseye-slim

LABEL org.opencontainers.image.authors="spezifisch"
LABEL org.opencontainers.image.url="https://github.com/spezifisch/docker-test-dovecot"
LABEL org.opencontainers.image.source="https://github.com/spezifisch/docker-test-dovecot"
LABEL org.opencontainers.image.licenses="AGPL-3.0-or-later"

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update -qq \
    && apt-get install --no-install-recommends -y \
    dovecot-imapd \
    dovecot-lmtpd \
    dovecot-managesieved \
    dovecot-pop3d \
    openssl \
    procps \
    psmisc \
    net-tools \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN sed -i 's/#log_path = syslog/log_path = \/dev\/stderr/' /etc/dovecot/conf.d/10-logging.conf \
    # authentication
    && sed -i 's/#auth_verbose =.*/auth_verbose = yes/' /etc/dovecot/conf.d/10-logging.conf \
    # mailboxes
    && sed -i 's/^mail_location =.*/mail_location = maildir:~\/Maildir:LAYOUT=fs/' /etc/dovecot/conf.d/10-mail.conf \
    && sed -i 's/#separator = $/separator = \//' /etc/dovecot/conf.d/10-mail.conf \
    # lda
    && sed -i 's/#lda_mailbox_autocreate =.*/lda_mailbox_autocreate = yes/' /etc/dovecot/conf.d/15-lda.conf \
    && sed -i 's/#lda_mailbox_autosubscribe =.*/lda_mailbox_autosubscribe = yes/' /etc/dovecot/conf.d/15-lda.conf \
    # lmtp listener (unix (already there) + tcp socket)
    && sed -i 's/#inet_listener lmtp.*/inet_listener lmtp {\naddress = 0.0.0.0\nport = 24\n}/' /etc/dovecot/conf.d/10-master.conf \
    && echo 'protocols = $protocols lmtp' >> /etc/dovecot/conf.d/15-lda.conf

# setup entrypoint
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

COPY mailgen.sh nukemails.sh cheapcron.sh /usr/bin/
RUN chmod +x /usr/bin/*.sh

VOLUME /etc/dovecot/ssl

# lmtp
EXPOSE 24
# pop3
EXPOSE 110
EXPOSE 995
# imap
EXPOSE 143
EXPOSE 993
# sieve
EXPOSE 4190

ENTRYPOINT ["/entrypoint.sh"]
CMD ["dovecot", "-F"]
