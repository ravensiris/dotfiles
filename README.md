# Quick guide

1. Run NixOS installer.
2. Set the hostname

```sh
sudo hostname gate
```
3. Check which drive you want to format

```sh
lsblk
```

4. Format or mount drive

Just use `-m mount` instead if only mounting.
The passed `"/dev/sda"` would be your primary disk.

```sh
nix --experimental-features 'nix-command flakes' run github:nix-community/disko -- -m zap_create_mount --arg 'disks = ["/dev/sda"]'
```
