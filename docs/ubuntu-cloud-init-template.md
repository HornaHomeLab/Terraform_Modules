# How to prepare Cloud init Proxmox ubuntu template

## Download Cloud image

```shell
wget -P /var/lib/vz/template/iso/ https://cloud-images.ubuntu.com/daily/server/releases/24.04/release/ubuntu-24.04-server-cloudimg-amd64.img
```

iso file should be saved in `/var/lib/vz/template/iso/`

## Add qemu tools to image

```shell
apt install libguestfs-tools -y
cd /var/lib/vz/template/iso/
virt-customize -a ubuntu-24.04-server-cloudimg-amd64.img --install qemu-guest-agent
```

## Create new VM

```shell
qm create 9000 \
--name "ubuntu-cloud-init-template" \
--memory 2048 \
--cores 4 \
--net0 virtio,bridge=vmbr0
```

## Import downloaded image to Proxmox storage

```shell
qm importdisk 9000 \
/var/lib/vz/template/iso/ubuntu-24.04-server-cloudimg-amd64.img \
local-lvm
```

## Configure primary disk and boot settings

```shell
qm set 9000 --scsihw virtio-scsi-pci --scsi0 local-lvm:vm-9000-disk-0
qm set 9000 --boot c --bootdisk scsi0

```

## Add Cloud-init disk

```shell
qm set 9000 --ide2 local-lvm:cloudinit
```

## Configure Cloud-init

```shell
qm set 9000 --ostype l26
qm set 9000 --tags "ubuntu-24.04, template"
qm set 9000 --ipconfig0 ip=dhcp
```
## Save template

```shell
qm template 9000
```