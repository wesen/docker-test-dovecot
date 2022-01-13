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

rm -f /home/*/Maildir/cur/* /home/*/Maildir/new/*
