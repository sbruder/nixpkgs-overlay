#!/usr/bin/env python3
# SPDX-FileCopyrightText: 2026 Simon Bruder <simon@sbruder.de>
#
# SPDX-License-Identifier: MIT OR Apache-2.0

import argparse

import uvicorn

if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        formatter_class=argparse.ArgumentDefaultsHelpFormatter
    )
    parser.add_argument(
        "-a", "--address", type=str, default="0.0.0.0", help="The address to listen on"
    )
    parser.add_argument(
        "-p", "--port", type=int, default=3000, help="The port to bind to"
    )
    parser.add_argument(
        "-l", "--log-level", type=str, default="warning", help="The log level"
    )
    args = parser.parse_args()

    config = uvicorn.Config(
        "smtp_dane_verify.api:app",
        host=args.address,
        port=args.port,
        log_level=args.log_level,
    )
    server = uvicorn.Server(config)
    server.run()
