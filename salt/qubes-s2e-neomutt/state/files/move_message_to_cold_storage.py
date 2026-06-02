#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
# Copyright © 2026 seamus tuohy, <code@seamustuohy.com>
#
# This program is free software: you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by the Free
# Software Foundation, either version 3 of the License, or (at your option)
# any later version.
#
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
# FITNESS FOR A PARTICULAR PURPOSE. See the included LICENSE file for details.

import argparse
from notmuch2 import Database
from datetime import datetime
from pathlib import Path
import sys
import logging
logging.basicConfig(level=logging.ERROR)
log = logging.getLogger(__name__)
import email
from email import policy

# Path.copy_into support for pre 3.14
if sys.version_info <= (3, 14):
    import shutil

def main():
    """
    Requires piped eml input
    """
    args = parse_arguments()
    set_logging(args.verbose, args.debug)
    # Get piped message
    raw_message = get_piped_input()

    # Setup cold storage
    cold_storage = Path(args.cold_storage_path)
    cold_storage.mkdir(parents=True, exist_ok=True)

    message_id = get_message_id(raw_message)
    log.info(f"Storing message {message_id}")
    query = f'id:{message_id.strip('<').strip('>')}'
    current_request_path = datetime.now().strftime("%Y%m%d%H%M%S")
    with Database(mode=Database.MODE.READ_WRITE) as db:
        messages = db.messages(query)
        # Vars to use: https://github.com/weilbith/notmuch2-python-bindings/blob/master/notmuch2/_message.py
        for message in messages:
            # Don't try to move messages with no files
            if message.ghost is True:
                log.warning(f"Message {message.messageid} is a ghost and can't be stored.")
                continue
            datestamp = datetime.fromtimestamp(message.date)
            date_dir = cold_storage.joinpath(current_request_path,
                                             str(datestamp.year),
                                             str(datestamp.month),
                                             str(datestamp.day))
            date_dir.mkdir(parents=True, exist_ok=True)
            for f in message.filenames():
                _file = Path(f)
                try:
                    _file.copy_into(date_dir)
                except:
                    # for Py Versions < 3.14
                    shutil.copy(_file, date_dir)
                log.debug(f"Moved file '{f}' to '{date_dir.absolute()}'")
            message.tags.add('cold-storage')
            if args.dont_trash_stored is not True:
                message.tags.add('trash')
                log.debug(f"Added tags 'cold-storage' and 'trash' to {message.messageid}")
            else:
                log.debug(f"Added tags 'cold-storage' to {message.messageid}")

def get_piped_input():
    # .isatty() returns True if connected to a terminal (keyboard)
    # and False if connected to a pipe or redirected file.
    if sys.stdin.isatty():
        print("Error: This script requires an eml file to be piped into it.", file=sys.stderr)
        sys.exit(1)
    return sys.stdin.read().strip()

def get_message_id(message):
    msg = email.message_from_string(message, policy=policy.default)
    message_id = msg['Message-ID']
    # log.debug(f"Extracted Message-ID: {message_id} from raw message")
    return message_id


# Command Line Functions below this point

def set_logging(verbose=False, debug=False):
    if debug == True:
        log.setLevel("DEBUG")
    elif verbose == True:
        log.setLevel("INFO")

def parse_arguments():
    parser = argparse.ArgumentParser("package name")
    parser.add_argument("--verbose", "-v",
                        help="Turn verbosity on",
                        action='store_true')
    parser.add_argument("--debug", "-d",
                        help="Turn debugging on",
                        action='store_true')
    parser.add_argument("--dont_trash_stored", "-t",
                        help="Dont trash messages stored in cold_storage. Messages trashed by default",
                        action='store_true')
    parser.add_argument("--cold_storage_path", "-c",
                        help="Cold storage path",
                        default='/home/user/cold_storage')
    args = parser.parse_args()
    return args

if __name__ == '__main__':
    main()
