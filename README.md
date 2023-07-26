# Quick guide

## Run NixOS installer.

Available here: https://nixos.org/download.html#nixos-iso

## Set the hostname

```sh
sudo hostname gate
```

## Clone this repo

```sh
git clone https://github.com/ravensiris/dotfiles
cd dotfiles
```

## Check which drive you want to format

```sh
lsblk
```

## Add disk encryption password

```sh
echo -n "mypassword" > /tmp/secret.key
```

## Format or mount drive

Just use `-m mount` instead if only mounting.

The passed `"/dev/sda"` would be your primary disk.

The `./hosts/gate/disk.nix` would be the path to your host `disko` disk configuration

```sh
sudo nix --experimental-features 'nix-command flakes' run github:nix-community/disko -- ./hosts/gate/disk.nix -m zap_create_mount --arg "disks" '["/dev/sda"]'
```

