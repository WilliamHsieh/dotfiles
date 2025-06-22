#!/usr/bin/env python3

import argparse
import os
import re
import subprocess


def command_output(command):
    env = os.environ.copy()
    env["NIX_CONFIG"] = "experimental-features = flakes nix-command"
    return subprocess.check_output(command, shell=True, env=env).decode().strip()


def get_value_by_key(nix_content, key):
    pattern = f'  {re.escape(key)} = "([^"]+)";'
    match = re.search(pattern, nix_content)
    assert match is not None, f"Key '{key}' not found in the provided Nix content."
    return match.group(1)


def parse_args():
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--build",
        action="store_true",
        help="build profile without switch (default to switch)",
        default=False,
    )
    parser.add_argument(
        "--dry",
        action="store_true",
        help="dry run (do not execute the command)",
        default=False,
    )

    # bootstrap related arguments
    parser.add_argument(
        "--bootstrap",
        action="store_true",
        help="generate bootstrap configuration (config/default.nix)",
        default=False,
    )

    # following arguments will be ignored when --bootstrap is not set
    parser.add_argument(
        "--profile",
        type=str,
        choices=["home", "darwin", "nixos"],
        help="profile type",
    )
    parser.add_argument(
        "--username",
        type=str,
        help="unix user name (default to $USER)",
    )
    parser.add_argument(
        "--hostname",
        type=str,
        help="unix host name (default to $(hostname))",
    )
    parser.add_argument(
        "--fullname",
        type=str,
        help="display name (for git config, default to USERNAME)",
    )
    parser.add_argument(
        "--email",
        type=str,
        help="email address (for git config, default to USERNAME@HOSTNAME)",
    )
    parser.add_argument("remainder", nargs="*")

    args = parser.parse_args()
    args.dir = command_output("dirname " + __file__)

    if args.bootstrap:
        args.profile = args.profile or "home"
        args.username = args.username or command_output("printenv USER")
        args.hostname = args.hostname or command_output("hostname")
        return args

    if args.profile or args.username or args.hostname or args.fullname or args.email:
        print(
            "Warning: The following arguments require --bootstrap to be enabled to be effective:\n"
            "  * --profile\n"
            "  * --username\n"
            "  * --hostname\n"
            "  * --fullname\n"
            "  * --email\n"
        )

    config = open(args.dir + "/config/default.nix").read()
    args.profile = get_value_by_key(config, "profile")
    args.username = get_value_by_key(config, "username")
    args.hostname = get_value_by_key(config, "hostname")

    return args


def write_config(args):
    if args.profile == "nixos":
        hardware_config = command_output(
            "nixos-generate-config --show-hardware-config || true"
        )
        if hardware_config != "":
            with open(args.dir + "/system/nixos/hardware.nix", "w") as f:
                f.write(hardware_config)

    config = {
        "system": command_output(
            "nix eval --impure --expr 'builtins.currentSystem'"
        ).strip('"'),
        "profile": args.profile,
        "directory": args.dir,
        "username": args.username,
        "hostname": args.hostname,
        "fullname": args.fullname or args.username,
        "email": args.email or f"{args.username}@{args.hostname}",
    }

    with open(args.dir + "/config/default.nix", "w") as f:
        config_str = "\n".join([f'  {k} = "{v}";' for k, v in config.items()])
        f.write("{\n" + config_str + "\n}\n")


def get_command():
    args = parse_args()
    if args.bootstrap and not args.dry:
        write_config(args)

    def get_derivation():
        if args.profile == "home":
            return f"#{args.username}"
        else:
            return f"#{args.hostname}"

    cmd = [
        "nix",
        "run",
        f"{args.dir}",
        "--show-trace",
        "--",
        "build" if args.build else "switch",
        "--show-trace",
        "--flake",
        args.dir + get_derivation(),
        *args.remainder,
    ]

    if not args.build:
        if args.profile == "home":
            cmd += ["-b", "backup"]
        else:
            cmd = ["sudo"] + cmd

    if args.dry:
        cmd = ["echo"] + cmd
    else:
        print(cmd)

    return cmd


def main():
    cmd = get_command()
    os.execvp(cmd[0], cmd)


if __name__ == "__main__":
    main()
