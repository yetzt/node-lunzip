#!/bin/sh

LZIP_VERSION="1.23"

# change to script dir
cd "$( dirname $0 )";
ROOT=$( pwd -P );

# fetch source
if [ ! -d $ROOT/lzip-src ]; then
	echo "fetch lzip source";
	curl -s -L https://download.savannah.gnu.org/releases/lzip/lzip-$LZIP_VERSION.tar.gz | tar xz - --directory $ROOT;
	mv lzip-$LZIP_VERSION lzip-src;
fi;

echo "build";
cd $ROOT/lzip-src;
rm config.status;
./configure CXX="em++" CXXFLAGS="-Wall -W -O2 -g2 --pre-js ../fragments/pre.js --post-js ../fragments/post.js -sWASM=1 -sALLOW_MEMORY_GROWTH";
make clean;
DECODER_ONLY=1 emmake make -j 4;
cd $ROOT;

echo "install";
rm -rf $ROOT/lib/*;
mv $ROOT/lzip-src/lzip $ROOT/lib/lzip.js;
if [ -f $ROOT/lzip-src/lzip.wasm ]; then 
	mv $ROOT/lzip-src/lzip.wasm $ROOT/lib/.;
fi;
if [ -f $ROOT/lzip-src/lzip.mem ]; then 
	mv $ROOT/lzip-src/lzip.mem $ROOT/lib/.;
fi;

echo "done";