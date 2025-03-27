def command_output(command):
    import subprocess

    return subprocess.check_output(command, shell=True).decode().strip()


def parse_args():
    import argparse

    # required arguments
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--system",
        type=str,
        help="system architecture",
        required=True,
    )

    # optional arguments with default values
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
        "--dir",
        type=str,
        help="path to dotfiles directory (default to ${pwd})",
        default=command_output("pwd"),
    )
    parser.add_argument(
        "--type",
        type=str,
        choices=["home", "darwin", "nixos"],
        help="profile type (default to home)",
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

    return parser.parse_args()


def get_command():
    args = parse_args()
    args.fullname = args.fullname or args.username
    args.email = args.email or f"{args.username}@{args.hostname}"

    config = {
        "system": args.system,
        "type": args.type,
        "directory": args.dir,
        "username": args.username,
        "hostname": args.hostname,
        "fullname": args.fullname,
        "email": args.email,
    }
    print(config)

    # config to nix
    with open("config/default.nix", "w") as f:
        config_str = "\n".join([f'\t{k} = "{v}";' for k, v in config.items()])
        f.write("{\n" + config_str + "\n}")

    if args.type == "darwin":
        cmd = "darwin-rebuild"
    elif args.type == "nixos":
        cmd = "nixos-rebuild"
    else:
        cmd = "home-manager"

    derivation = args.type == "home" and args.username or args.hostname

    return [
        "nix",
        "run",
        f"{args.dir}#{cmd}",
        "--show-trace",
        "--",
        "switch",
        "--show-trace",
        "-b",
        "backup",
        "--flake",
        f"{args.dir}#{derivation}",
    ]


def main():
    import os

    cmd = get_command()
    print(cmd)
    os.execvp(cmd[0], cmd)


if __name__ == "__main__":
    main()
    # 1. ci: nix build or nix run .#bootstrap
    # 2. local: nix run .#bootstrap --system darwin, switch
