#!/bin/bash -e
# This file is part of docker-test-dovecot (https://github.com/spezifisch/docker-test-dovecot)
# Copyright (C) 2021-2022 spezifisch (https://github.com/spezifisch)

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published by
# the Free Software Foundation.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.

# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

# check for cert in "ssl" volume
if [ ! -e /etc/dovecot/ssl/key.pem ]; then
    echo "* creating self-signed SSL cert"
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
        -subj "/C=DE/CN=testcot" -addext "subjectAltName = DNS:testcot" \
        -keyout /etc/dovecot/ssl/key.pem -out /etc/dovecot/ssl/cert.pem
fi

# create symlinks in dovecot's default cert locations
[ -e /etc/dovecot/key.pem ] || ln -s /etc/dovecot/ssl/key.pem /etc/dovecot/key.pem
[ -e /etc/dovecot/cert.pem ] || ln -s /etc/dovecot/ssl/cert.pem /etc/dovecot/cert.pem

# create test users
function create_user() {
    U="$1"
    if [ -e /home/"$U" ]; then
        echo "* creating user $U"
        _UID=$(stat -c "%u" /home/$U)
        _GID=$(stat -c "%g" /home/$U)
        groupadd --gid="$_GID" "$U"
        useradd --uid="$_UID" --gid="$_GID" "$U"
    else
        echo "* creating user $U for the first time"
        useradd -m "$U"
    fi
    echo -e "pass\npass\n" | passwd "$U"
}

create_user a
create_user b
create_user c
create_user foo
create_user bar

# periodically generate test mails
cheapcron.sh &

# start dovecot
exec "$@"