#

set -e

version=0.2

tmp1=`mktemp -d`
tmp2=`mktemp -d`

tarEnd() {
    export EXIT=$?
    rm -rf $tmp1 $tmp2 && exit $EXIT
}
trap tarEnd EXIT

if [ ! -f Fedora-Docker-Base-23-20151030.x86_64.tar.xz ]
then
    curl -L -o Fedora-Docker-Base-23-20151030.x86_64.tar.xz https://download.fedoraproject.org/pub/fedora/linux/releases/23/Docker/x86_64/Fedora-Docker-Base-23-20151030.x86_64.tar.xz
fi

tar --extract --file Fedora-Docker-Base-23-20151030.x86_64.tar.xz --directory $tmp1
tar --verbose --extract --file $tmp1/*/layer.tar --directory $tmp2

acbuild --debug begin $tmp2

acbuildEnd() {
    export EXIT=$?
    rm -rf $tmp1 $tmp2
    acbuild --debug end && exit $EXIT
}
trap acbuildEnd EXIT

acbuild --debug set-name ocjtech.us/fedora23
acbuild --debug label add version ${version}

acbuild --debug run -- dnf -y update --refresh
acbuild --debug write --overwrite fedora23-${version}.aci
