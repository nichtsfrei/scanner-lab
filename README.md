# eulabeia-lab

Is a lab to test openvas in a larger environment.

## Installation

On a newly created environment you need to have
- curl
- victim.yaml
- openvas.yaml

on your machine.

### Install k3s

Although k3s is just a single binary it is useful to have a systemd integration for that they prepared a script which you can download via:

```
  curl -Lo install_k3s.sh https://get.k3s.io
```

review and execute it.

The script should install:
- `/usr/local/bin/k3s`
- `/usr/local/bin/kubectl` - kubernetes client (symlinked to k3s)
- `/usr/local/bin/crictl` - CRI client (symlinked to k3s)
- `/usr/local/bin/k3s-killall.sh` - to kill k3s
- `/usr/local/bin/k3s-uninstall.sh` - to uninstall

Additionally it should create
- `/etc/systemd/system/k3s.service`
and enabling it per default.

To allow user execution create a group and open up `k3s.yaml` a bit:
```
sudo groupadd k3s
sudo usermod -a -G k3s $USER
sudo chown root:k3s /etc/rancher/k3s/k3s.yaml
```

Further resources:
- https://rancher.com/docs/k3s/latest/en/installation/installation-requirements/
- https://rancher.com/docs/k3s/latest/en/quick-start/

### Apply deployments

```
kubectl apply -f openvas.yaml
kubectl apply -f victim.yaml
```


