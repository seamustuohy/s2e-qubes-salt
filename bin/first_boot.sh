########################
#
# Framework WiFi Networking
#
########################
qvm-shutdown --wait sys-net
# The fedora templates don't come with the right drivers. But, debian does.
DEBVER=$(qubesctl pillar.get os:template:base_version:debian --out=txt | awk '{print $NF}')
qvm-prefs sys-net template "debian-${DEBVER}"
# Framework almost always doesn't like the latest Qubes Kernels.
# You can try changing the kernel assigned to sys-net in the Qubes VM Manager settings to the kernel that comes with the qube.
qvm-prefs sys-net kernel ''
qvm-start sys-net


########################
#
# Fix inability to install packages
#
# You need to update dom0 before you can use dnf to install packages
#
########################
qubes-dom0-update -y


########################
#
# Enable User Directories
#
# https://forum.qubes-os.org/t/qubes-salt-beginners-guide/20126
# https://github.com/QubesOS/qubes-mgmt-salt-base-config/blob/b3d2837/qubes/user-dirs.sls
#
########################
sudo qubesctl top.enable qubes.user-dirs
sudo qubesctl state.apply
