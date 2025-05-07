#!/usr/bin/env python3

import os


def command_output(command):
    import subprocess

    return subprocess.check_output(command, shell=True).decode().strip()


def parse_args():
    import argparse

    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--build",
        action="store_true",
        help="build profile without switch (default to switch)",
        default=False,
    )

    # bootstrap related arguments
    parser.add_argument(
        "--bootstrap",
        action="store_true",
        help="generate bootstrap configuration (config/default.nix)",
        default=False,
    )
    parser.add_argument(
        "--system",
        type=str,
        help="system architecture",
    )
    parser.add_argument(
        "--dir",
        type=str,
        help="path to dotfiles directory (default to ${dirname __file__})",
        default=command_output("dirname " + __file__),
    )
    parser.add_argument(
        "--profile",
        type=str,
        choices=["home", "darwin", "nixos"],
        help="profile type (default to home)",
        default="home",
    )

    # following arguments will be ignored when --bootstrap is not set
    parser.add_argument(
        "--username",
        type=str,
        help="unix user name (default to ${whoami})",
        default=command_output("whoami"),
    )
    parser.add_argument(
        "--hostname",
        type=str,
        help="unix host name (default to ${hostname})",
        default=command_output("hostname"),
    )
    parser.add_argument(
        "--fullname",
        type=str,
        help="display name (for git config, default to ${username})",
    )
    parser.add_argument(
        "--email",
        type=str,
        help="email address (for git config, default to ${username}@${hostname})",
    )

    args = parser.parse_args()
    args.fullname = args.fullname or args.username
    args.email = args.email or f"{args.username}@{args.hostname}"

    if args.bootstrap:
        if not args.system:
            parser.error("--system is required when --bootstrap is set")
    else:
        if not args.profile:
            parser.error("--profile is required when --bootstrap is not set")

    return args


def write_config(args):
    config = {
        "system": args.system,
        "profile": args.profile,
        "directory": args.dir,
        "username": args.username,
        "hostname": args.hostname,
        "fullname": args.fullname,
        "email": args.email,
    }

    with open("config/default.nix", "w") as f:
        config_str = "\n".join([f'  {k} = "{v}";' for k, v in config.items()])
        f.write("{\n" + config_str + "\n}\n")


def bootstrap(args):
    derivation = args.profile == "home" and args.username or args.hostname

    return [
        "nix",
        "run",
        f"{args.dir}",
        "--show-trace",
        "--",
        "build" if args.build else "switch",
        "--show-trace",
        "--flake",
        f"{args.dir}#{derivation}",
    ]


def switch_profile(args):
    if args.profile == "darwin":
        cmd = "darwin-rebuild"
    elif args.profile == "nixos":
        cmd = "nixos-rebuild"
    else:
        cmd = "home-manager"

    return [
        cmd,
        "build" if args.build else "switch",
        "--show-trace",
        "--flake",
        f"{args.dir}",
    ]


def get_command():
    args = parse_args()
    if args.bootstrap:
        write_config(args)
        res = bootstrap(args)
    else:
        res = switch_profile(args)

    if not args.build and args.profile == "home":
        res += ["-b", "backup"]

    return res


def main():
    cmd = get_command()
    print(cmd)
    os.execvp(cmd[0], cmd)


if __name__ == "__main__":
    main()
