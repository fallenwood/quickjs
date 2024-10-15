#! /usr/bin/sh
# pacman -S mingw-w64-x86_64-gcc mingw-w64-x86_64-make mingw-w64-x86_64-dlfcn zip
mingw32-make LDEXPORT="-static -s" -j
gcc -shared -o libquickjs.dll -static -s -Wl,--whole-archive ./lib/quickjs/libquickjs.lto.a -lm -Wl,--no-whole-archive
# zip -9 -r quickjs-$(cat version)-win$(echo ${MSYSTEM:0-2}).zip qjs.exe run-test262.exe
mkdir -p ./bin
mv host-qjsc.exe qjs.exe qjsc.exe run-test262.exe libquickjs.dll ./bin
# mkdir -p ./lib/quickjs
# strip -g libquickjs.a
# mv libquickjs.a libquickjs.lto.a ./lib/quickjs
# mkdir -p ./include/quickjs
# cp -p quickjs.h quickjs-libc.h ./include/quickjs
# zip -9 -r quickjs-$(cat version)-win$(echo ${MSYSTEM:0-2})-all.zip ./bin ./doc ./examples ./include ./lib Changelog readme.txt TODO VERSION libquickjs.dll