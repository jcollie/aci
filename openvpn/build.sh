#

set -e

version="0.5"

acbuild --debug begin

acbuildEnd() {
    export EXIT=$?
    acbuild --debug end && exit $EXIT 
}
trap acbuildEnd EXIT

acbuild --debug dependency add ocjtech.us/centos7 --label version=0.4

acbuild --debug set-name ocjtech.us/openvpn

acbuild --debug label add version ${version}

acbuild --debug isolator add os/linux/capabilities-retain-set ./cap_net_admin.json

acbuild --debug run -- yum -y update
acbuild --debug run -- yum -y install openvpn iproute

acbuild --debug mount add config /etc/openvpn

acbuild --debug set-exec -- /usr/sbin/openvpn --cd /etc/openvpn --config openvpn.conf

acbuild --debug write --overwrite openvpn-${version}.aci
