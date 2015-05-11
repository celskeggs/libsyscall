set -e
OS=$(uname -s)

rm -rf built/
mkdir built/

if [ "$OS" = "Linux" ]
then
	cd linux
	make $*
	cd ../built
	tar -xzf ../libsyscall.tar.gz
	echo Finished compiling.
	echo Result is in `pwd`
else
	echo Kernel not supported: $OS
	exit 1
fi
