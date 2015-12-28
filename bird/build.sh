#

set -e

version="0.3"

acbuild --debug begin

acbuildEnd() {
    export EXIT=$?
    acbuild --debug end && exit $EXIT 
}
trap acbuildEnd EXIT

acbuild --debug dependency add ocjtech.us/centos7 --label version=0.5

acbuild --debug set-name ocjtech.us/bird
acbuild --debug label add version ${version}
acbuild --debug isolator add os/linux/capabilities-retain-set ./cap_net_admin.json

acbuild --debug run -- curl -o /etc/yum.repos.d/jcollie-bird-epel-7.repo https://copr.fedoraproject.org/coprs/jcollie/bird/repo/epel-7/jcollie-bird-epel-7.repo
acbuild --debug run -- yum -y update
acbuild --debug run -- yum -y install bird iproute traceroute paris-traceroute

acbuild --debug mount add config /etc/bird.conf

acbuild --debug set-exec -- /usr/sbin/bird -f

acbuild --debug write --overwrite bird-${version}.aci
