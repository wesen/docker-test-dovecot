#!/bin/bash
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

DELAY=60

echo "cheapcron: waiting for dovecot to start"
while ! pidof dovecot > /dev/null; do
    sleep 1
done

echo "cheapcron: starting every $DELAY s"
while true; do
    mailgen.sh
    RET=$?
    if [ $RET -ne 0 ]; then
        echo "$(date) mailgen failed with code $RET"
    fi
    sleep $DELAY
done
