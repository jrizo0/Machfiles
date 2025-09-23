# Tunel port

```bash
ssh -N -L 3001:localhost:3000 user@remote
```


# SSH fingerprint

## Generate if not exists

```bash
ssh-keygen -t ed25519 -C "email@ejemplo.com"
```

## Copy to server

```bash
ssh-copy-id -i ~/.ssh/id_ed25519.pub user@remote
```
