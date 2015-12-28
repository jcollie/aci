#

set -e

version="0.5"

if [ ! -f centos-7.2.1511-docker.tar.xz ]
then
    curl -o centos-7.2.1511-docker.tar.xz https://raw.githubusercontent.com/CentOS/sig-cloud-instance-images/CentOS-7.2.1511/docker/centos-7.2.1511-docker.tar.xz
fi

tmp=`mktemp -d`

tarEnd() {
    export EXIT=$?
    rm -rf $tmp && exit $EXIT
}
trap tarEnd EXIT

tar --extract --file centos-7.2.1511-docker.tar.xz --directory $tmp

acbuild --debug begin $tmp

acbuildEnd() {
    export EXIT=$?
    rm -rf $tmp
    acbuild --debug end && exit $EXIT 
}
trap acbuildEnd EXIT

acbuild --debug set-name ocjtech.us/centos7
acbuild --debug label add version ${version}

acbuild --debug run -- rpm --rebuilddb
acbuild --debug run -- yum -y install epel-release
acbuild --debug run -- yum -y update
acbuild --debug run -- yum -y clean all
acbuild --debug write --overwrite centos7-${version}.aci
