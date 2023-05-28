# Quick guide

1. Run NixOS installer.
2. Set the hostname

```sh
sudo hostname gate
```
3. Clone this repo

```sh
git clone https://github.com/ravensiris/dotfiles
cd dotfiles
```

4. Check which drive you want to format

```sh
lsblk
```
5. Add disk encryption password

```sh
echo -n "mypassword" > /tmp/secret.key
```

6. Format or mount drive

Just use `-m mount` instead if only mounting.
The passed `"/dev/sda"` would be your primary disk.
The `./hosts/gate/disk.nix` would be the path to your host `disko` disk configuration

```sh
nix --experimental-features 'nix-command flakes' run github:nix-community/disko -- ./hosts/gate/disk.nix -m zap_create_mount --arg "disks" '["/dev/sda"]'
```

