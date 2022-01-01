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

function send_random_mail() {
    USER="$1"
    cat <<EOF | /usr/lib/dovecot/deliver -d "$USER" -e
From: noreply.$USER@mailgen.example.com
To: $USER@testcot
Subject: test mail $(date +%s) to $USER
Date: $(date -R)

this is content
EOF
}

for USER_HOME in /home/*; do
    USER=$(basename "$USER_HOME")

    # check how many mails the user has
    NEW_MAILS=0
    if [ -d "$USER_HOME/Maildir/new" ]; then
        NEW_MAILS=$(ls -1 "$USER_HOME/Maildir/new" | wc -l)
    fi

    # send a mail if the user has no new mails
    if [ "$NEW_MAILS" -eq 0 ]; then
        echo "$(date) generating new mail for $USER"
        send_random_mail "$USER"
    fi
done
