# auto-nix

1. Boot your target laptop/VM from a standard nixos USB.
2. Once it boots to the terminal, type **ip addr**. Note the IP address.
3. Type passwd and set a password to nixos.


Install remotely from another machine on a local network:

```
nix run github:nix-community/nixos-anywhere -- \
  --flake github:not-a-teletubby/auto-nix#secure-laptop \
  root@<TARGET-IP-ADDRESS>
```


Or, from target computer run:

```
sudo nix --extra-experimental-features "nix-command flakes" \
  run github:nix-community/disko -- \
  --mode disko \
  --flake github:not-a-teletubby/auto-nix#secure-laptop
```

then run:

```
sudo nixos-install --flake github:not-a-teletubby/auto-nix#secure-laptop
```
