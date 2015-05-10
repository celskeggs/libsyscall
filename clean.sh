set -e
OS=$(uname -s)

echo "rm -rf built/"
rm -rf built/

if [ "$OS" = "Linux" ]
then
	cd linux
	make clean
else
	echo Kernel not supported: $OS
	exit 1
fi
