#!/bin/sh
# -D __IPHONE__ for specific changes in the code
# -D NDEBUG to deactivate assert

# 2023 TODO list:
# - make it work, release (build 338, May 1st)
# - activate euptex: on it.
# - activate xetex, dvipdfmx: done
# - clean up memory in dvipdfmx?
#
# 1) download the xcframework:

IOS_SYSTEM_VER="v3.0.1"
HHROOT="https://github.com/holzschu"
BUILD_SIMULATOR=0

# echo "Downloading ios_system Framework:"
# rm -rf ios_system.xcframework
# curl -OL $HHROOT/ios_system/releases/download/$IOS_SYSTEM_VER/ios_system.xcframework.zip
# unzip ios_system.xcframework.zip
# rm ios_system.xcframework.zip
# curl -OL $HHROOT/ios_system/releases/download/$IOS_SYSTEM_VER/ios_error.h

# 2) build for iOS:
echo "Building for iOS:"

export SYSROOT=$(xcrun --sdk iphoneos --show-sdk-path) 
export STRIP="strip -x"
./Build --host=arm-apple-darwin --build=x86_64-apple-darwin \
--disable-native-texlive-build \
--enable-shared \
--disable-static \
--disable-cxx-runtime-hack \
--without-x \
--disable-cjkutils \
--disable-texdoctk \
--disable-tpic2pdftex \
--disable-tex         \
--disable-ptex        \
--disable-eptex       \
--disable-uptex       \
--enable-euptex      \
--disable-hitex       \
--disable-luajittex   \
--enable-xetex       \
--disable-web-progs   \
--disable-synctex     \
--disable-tex4htk     \
--disable-mktexmf-default \
--disable-mktexpk-default \
--disable-mktextfm-default \
--disable-mktexfmt-default \
--disable-aleph \
--disable-mp \
--disable-pmp \
--disable-upmp \
--disable-xdvipdfmx \
--disable-xindy \
--disable-xpdfopen \
--disable-dvi2tty \
--disable-dvidvi \
--disable-dviljk \
--enable-dvipdfm-x \
--disable-dvipng \
--disable-dvipos \
--disable-dvipsk \
--disable-dvisvgm \
--disable-xdvik \
--with-system-zlib \
--disable-mfluajit \
--disable-multiplatform \
CC=clang \
CXX=clang++ \
OBJCXX=clang++ \
CFLAGS="-arch\ arm64\ -miphoneos-version-min=14.0\ -isysroot\ ${SYSROOT}\ -D\ __IPHONE__\ -DPNG_ARM_NEON_OPT=0\ -I${PWD}\ -I${PWD}/texk/ptexenc" \
CPPFLAGS="-arch\ arm64\ -miphoneos-version-min=14.0\ -isysroot\ ${SYSROOT}\ -D\ __IPHONE__\ -I${PWD}" \
LDFLAGS="-arch\ arm64\ -miphoneos-version-min=14.0\ -isysroot\ ${SYSROOT}\ -F${PWD}/ios_system.xcframework/ios-arm64\ -framework\ ios_system\ " \
CXXFLAGS="-arch\ arm64\ -miphoneos-version-min=14.0\ -isysroot\ ${SYSROOT}\ -std=c++11\ -D\ __IPHONE__\ -stdlib=libc++ " \
OBJCXXFLAGS="-arch\ arm64\ -miphoneos-version-min=14.0\ -isysroot\ ${SYSROOT}\ \ -std=c++11\ -D\ __IPHONE__\ -stdlib=libc++ " \
>& build_cross.log

# exit 0 # When debugging

echo "Compilation done, generating frameworks"
mkdir -p Frameworks

rm -rf Frameworks/texlua53.framework
mkdir Frameworks/texlua53.framework 
cp Work/libs/lua53/.libs/libtexlua53.5.dylib Frameworks/texlua53.framework/texlua53
cp basic_Info.plist Frameworks/texlua53.framework/Info.plist
plutil -replace CFBundleExecutable -string texlua53 Frameworks/texlua53.framework/Info.plist
plutil -replace CFBundleName -string texlua53 Frameworks/texlua53.framework/Info.plist
plutil -replace CFBundleIdentifier -string Nicolas-Holzschuch.texlua53 Frameworks/texlua53.framework/Info.plist
install_name_tool -id @rpath/texlua53.framework/texlua53   Frameworks/texlua53.framework/texlua53

rm -rf Frameworks/kpathsea.framework
mkdir Frameworks/kpathsea.framework 
cp Work/texk/kpathsea/.libs/libkpathsea.dylib Frameworks/kpathsea.framework/kpathsea
cp basic_Info.plist Frameworks/kpathsea.framework/Info.plist
plutil -replace CFBundleExecutable -string kpathsea Frameworks/kpathsea.framework/Info.plist
plutil -replace CFBundleName -string kpathsea Frameworks/kpathsea.framework/Info.plist
plutil -replace CFBundleIdentifier -string Nicolas-Holzschuch.kpathsea Frameworks/kpathsea.framework/Info.plist
install_name_tool -id  @rpath/kpathsea.framework/kpathsea   Frameworks/kpathsea.framework/kpathsea

rm -rf Frameworks/makeindex.framework
mkdir Frameworks/makeindex.framework 
cp Work/texk/makeindexk/.libs/makeindex.dylib Frameworks/makeindex.framework/makeindex
cp basic_Info.plist Frameworks/makeindex.framework/Info.plist
plutil -replace CFBundleExecutable -string makeindex Frameworks/makeindex.framework/Info.plist
plutil -replace CFBundleName -string makeindex Frameworks/makeindex.framework/Info.plist
plutil -replace CFBundleIdentifier -string Nicolas-Holzschuch.makeindex Frameworks/makeindex.framework/Info.plist
install_name_tool -id  @rpath/makeindex.framework/makeindex   Frameworks/makeindex.framework/makeindex
install_name_tool -change @rpath/libkpathsea.6.dylib  @rpath/kpathsea.framework/kpathsea Frameworks/makeindex.framework/makeindex

rm -rf Frameworks/luatex.framework
mkdir Frameworks/luatex.framework 
cp Work/texk/web2c/.libs/luatex.dylib Frameworks/luatex.framework/luatex
cp basic_Info.plist Frameworks/luatex.framework/Info.plist
plutil -replace CFBundleExecutable -string luatex Frameworks/luatex.framework/Info.plist
plutil -replace CFBundleName -string luatex Frameworks/luatex.framework/Info.plist
plutil -replace CFBundleIdentifier -string Nicolas-Holzschuch.luatex Frameworks/luatex.framework/Info.plist
install_name_tool -id @rpath/luatex.framework/luatex   Frameworks/luatex.framework/luatex
install_name_tool -change $PWD/inst/lib/libtexlua53.5.dylib @rpath/texlua53.framework/texlua53  Frameworks/luatex.framework/luatex
install_name_tool -change @rpath/libkpathsea.6.dylib  @rpath/kpathsea.framework/kpathsea Frameworks/luatex.framework/luatex

rm -rf Frameworks/luahbtex.framework
mkdir Frameworks/luahbtex.framework 
cp Work/texk/web2c/.libs/luahbtex.dylib Frameworks/luahbtex.framework/luahbtex
cp basic_Info.plist Frameworks/luahbtex.framework/Info.plist
plutil -replace CFBundleExecutable -string luahbtex Frameworks/luahbtex.framework/Info.plist
plutil -replace CFBundleName -string luahbtex Frameworks/luahbtex.framework/Info.plist
plutil -replace CFBundleIdentifier -string Nicolas-Holzschuch.luahbtex Frameworks/luahbtex.framework/Info.plist
install_name_tool -id @rpath/luahbtex.framework/luahbtex   Frameworks/luahbtex.framework/luahbtex
install_name_tool -change $PWD/inst/lib/libtexlua53.5.dylib @rpath/texlua53.framework/texlua53  Frameworks/luahbtex.framework/luahbtex
install_name_tool -change @rpath/libkpathsea.6.dylib  @rpath/kpathsea.framework/kpathsea Frameworks/luahbtex.framework/luahbtex

rm -rf Frameworks/pdftex.framework
mkdir Frameworks/pdftex.framework
cp Work/texk/web2c/.libs/pdftex.dylib Frameworks/pdftex.framework/pdftex
cp basic_Info.plist Frameworks/pdftex.framework/Info.plist
plutil -replace CFBundleExecutable -string pdftex Frameworks/pdftex.framework/Info.plist
plutil -replace CFBundleName -string pdftex Frameworks/pdftex.framework/Info.plist
plutil -replace CFBundleIdentifier -string Nicolas-Holzschuch.pdftex Frameworks/pdftex.framework/Info.plist
install_name_tool -id @rpath/pdftex.framework/pdftex   Frameworks/pdftex.framework/pdftex
install_name_tool -change @rpath/libkpathsea.6.dylib @rpath/kpathsea.framework/kpathsea Frameworks/pdftex.framework/pdftex

rm -rf Frameworks/xetex.framework
mkdir Frameworks/xetex.framework
cp Work/texk/web2c/.libs/xetex.dylib Frameworks/xetex.framework/xetex
cp basic_Info.plist Frameworks/xetex.framework/Info.plist
plutil -replace CFBundleExecutable -string xetex Frameworks/xetex.framework/Info.plist
plutil -replace CFBundleName -string xetex Frameworks/xetex.framework/Info.plist
plutil -replace CFBundleIdentifier -string Nicolas-Holzschuch.xetex Frameworks/xetex.framework/Info.plist
install_name_tool -id @rpath/xetex.framework/xetex   Frameworks/xetex.framework/xetex
install_name_tool -change @rpath/libkpathsea.6.dylib @rpath/kpathsea.framework/kpathsea Frameworks/xetex.framework/xetex

rm -rf Frameworks/ptexenc.framework
mkdir Frameworks/ptexenc.framework 
cp Work/texk/ptexenc/.libs/libptexenc.dylib Frameworks/ptexenc.framework/ptexenc
cp basic_Info.plist Frameworks/ptexenc.framework/Info.plist
plutil -replace CFBundleExecutable -string ptexenc Frameworks/ptexenc.framework/Info.plist
plutil -replace CFBundleName -string ptexenc Frameworks/ptexenc.framework/Info.plist
plutil -replace CFBundleIdentifier -string Nicolas-Holzschuch.ptexenc Frameworks/ptexenc.framework/Info.plist
install_name_tool -id  @rpath/ptexenc.framework/ptexenc   Frameworks/ptexenc.framework/ptexenc
install_name_tool -change @rpath/libkpathsea.6.dylib @rpath/kpathsea.framework/kpathsea Frameworks/ptexenc.framework/ptexenc

rm -rf Frameworks/euptex.framework
mkdir Frameworks/euptex.framework
cp Work/texk/web2c/.libs/euptex.dylib Frameworks/euptex.framework/euptex
cp basic_Info.plist Frameworks/euptex.framework/Info.plist
plutil -replace CFBundleExecutable -string euptex Frameworks/euptex.framework/Info.plist
plutil -replace CFBundleName -string euptex Frameworks/euptex.framework/Info.plist
plutil -replace CFBundleIdentifier -string Nicolas-Holzschuch.euptex Frameworks/euptex.framework/Info.plist
install_name_tool -id @rpath/euptex.framework/euptex   Frameworks/euptex.framework/euptex
install_name_tool -change @rpath/libkpathsea.6.dylib @rpath/kpathsea.framework/kpathsea Frameworks/euptex.framework/euptex
install_name_tool -change $PWD/inst/lib/libptexenc.1.dylib @rpath/ptexenc.framework/ptexenc Frameworks/euptex.framework/euptex

rm -rf Frameworks/bibtex.framework
mkdir Frameworks/bibtex.framework
cp Work/texk/bibtex-x/.libs/bibtex8.dylib Frameworks/bibtex.framework/bibtex
cp basic_Info.plist Frameworks/bibtex.framework/Info.plist
plutil -replace CFBundleExecutable -string bibtex Frameworks/bibtex.framework/Info.plist
plutil -replace CFBundleName -string bibtex Frameworks/bibtex.framework/Info.plist
plutil -replace CFBundleIdentifier -string Nicolas-Holzschuch.bibtex Frameworks/bibtex.framework/Info.plist
install_name_tool -id @rpath/bibtex.framework/bibtex   Frameworks/bibtex.framework/bibtex
install_name_tool -change @rpath/libkpathsea.6.dylib @rpath/kpathsea.framework/kpathsea Frameworks/bibtex.framework/bibtex

rm -rf Frameworks/kpsewhich.framework
mkdir Frameworks/kpsewhich.framework
cp Work/texk/kpathsea/.libs/kpsewhich Frameworks/kpsewhich.framework/kpsewhich
cp basic_Info.plist Frameworks/kpsewhich.framework/Info.plist
plutil -replace CFBundleExecutable -string kpsewhich Frameworks/kpsewhich.framework/Info.plist
plutil -replace CFBundleName -string kpsewhich Frameworks/kpsewhich.framework/Info.plist
plutil -replace CFBundleIdentifier -string Nicolas-Holzschuch.kpsewhich Frameworks/kpsewhich.framework/Info.plist
install_name_tool -id @rpath/kpsewhich.framework/kpsewhich   Frameworks/kpsewhich.framework/kpsewhich
install_name_tool -change @rpath/libkpathsea.6.dylib @rpath/kpathsea.framework/kpathsea Frameworks/kpsewhich.framework/kpsewhich

rm -rf Frameworks/xdvipdfmx.framework
mkdir Frameworks/xdvipdfmx.framework
cp Work/texk/dvipdfm-x/.libs/xdvipdfmx.dylib Frameworks/xdvipdfmx.framework/xdvipdfmx
cp basic_Info.plist Frameworks/xdvipdfmx.framework/Info.plist
plutil -replace CFBundleExecutable -string xdvipdfmx Frameworks/xdvipdfmx.framework/Info.plist
plutil -replace CFBundleName -string xdvipdfmx Frameworks/xdvipdfmx.framework/Info.plist
plutil -replace CFBundleIdentifier -string Nicolas-Holzschuch.xdvipdfmx Frameworks/xdvipdfmx.framework/Info.plist
install_name_tool -id @rpath/xdvipdfmx.framework/xdvipdfmx   Frameworks/xdvipdfmx.framework/xdvipdfmx
install_name_tool -change @rpath/libkpathsea.6.dylib @rpath/kpathsea.framework/kpathsea Frameworks/xdvipdfmx.framework/xdvipdfmx

# New frameworks with ...A:
rm -rf Frameworks/texlua53A.framework
mkdir Frameworks/texlua53A.framework 
cp Work/libs/lua53/.libs/libtexlua53.5.dylib Frameworks/texlua53A.framework/texlua53A
cp basic_Info.plist Frameworks/texlua53A.framework/Info.plist
plutil -replace CFBundleExecutable -string texlua53A Frameworks/texlua53A.framework/Info.plist
plutil -replace CFBundleName -string texlua53A Frameworks/texlua53A.framework/Info.plist
plutil -replace CFBundleIdentifier -string Nicolas-Holzschuch.texlua53A Frameworks/texlua53A.framework/Info.plist
install_name_tool -id @rpath/texlua53A.framework/texlua53A   Frameworks/texlua53A.framework/texlua53A

rm -rf Frameworks/kpathseaA.framework
mkdir Frameworks/kpathseaA.framework 
cp Work/texk/kpathsea/.libs/libkpathsea.dylib Frameworks/kpathseaA.framework/kpathseaA
cp basic_Info.plist Frameworks/kpathseaA.framework/Info.plist
plutil -replace CFBundleExecutable -string kpathseaA Frameworks/kpathseaA.framework/Info.plist
plutil -replace CFBundleName -string kpathseaA Frameworks/kpathseaA.framework/Info.plist
plutil -replace CFBundleIdentifier -string Nicolas-Holzschuch.kpathseaA Frameworks/kpathseaA.framework/Info.plist
install_name_tool -id  @rpath/kpathseaA.framework/kpathseaA   Frameworks/kpathseaA.framework/kpathseaA

rm -rf Frameworks/luatexA.framework
mkdir Frameworks/luatexA.framework 
cp Work/texk/web2c/.libs/luatex.dylib Frameworks/luatexA.framework/luatexA
cp basic_Info.plist Frameworks/luatexA.framework/Info.plist
plutil -replace CFBundleExecutable -string luatexA Frameworks/luatexA.framework/Info.plist
plutil -replace CFBundleName -string luatexA Frameworks/luatexA.framework/Info.plist
plutil -replace CFBundleIdentifier -string Nicolas-Holzschuch.luatexA Frameworks/luatexA.framework/Info.plist
install_name_tool -id @rpath/luatexA.framework/luatexA   Frameworks/luatexA.framework/luatexA
install_name_tool -change $PWD/inst/lib/libtexlua53.5.dylib @rpath/texlua53A.framework/texlua53A  Frameworks/luatexA.framework/luatexA
install_name_tool -change @rpath/libkpathsea.6.dylib  @rpath/kpathseaA.framework/kpathseaA Frameworks/luatexA.framework/luatexA

rm -rf Frameworks/luahbtexA.framework
mkdir Frameworks/luahbtexA.framework 
cp Work/texk/web2c/.libs/luahbtex.dylib Frameworks/luahbtexA.framework/luahbtexA
cp basic_Info.plist Frameworks/luahbtexA.framework/Info.plist
plutil -replace CFBundleExecutable -string luahbtexA Frameworks/luahbtexA.framework/Info.plist
plutil -replace CFBundleName -string luahbtexA Frameworks/luahbtexA.framework/Info.plist
plutil -replace CFBundleIdentifier -string Nicolas-Holzschuch.luahbtexA Frameworks/luahbtexA.framework/Info.plist
install_name_tool -id @rpath/luahbtexA.framework/luahbtexA   Frameworks/luahbtexA.framework/luahbtexA
install_name_tool -change $PWD/inst/lib/libtexlua53.5.dylib @rpath/texlua53A.framework/texlua53A Frameworks/luahbtexA.framework/luahbtexA
install_name_tool -change @rpath/libkpathsea.6.dylib  @rpath/kpathseaA.framework/kpathseaA Frameworks/luahbtexA.framework/luahbtexA

rm -rf Frameworks/pdftexA.framework
mkdir Frameworks/pdftexA.framework
cp Work/texk/web2c/.libs/pdftex.dylib Frameworks/pdftexA.framework/pdftexA
cp basic_Info.plist Frameworks/pdftexA.framework/Info.plist
plutil -replace CFBundleExecutable -string pdftexA Frameworks/pdftexA.framework/Info.plist
plutil -replace CFBundleName -string pdftexA Frameworks/pdftexA.framework/Info.plist
plutil -replace CFBundleIdentifier -string Nicolas-Holzschuch.pdftexA Frameworks/pdftexA.framework/Info.plist
install_name_tool -id @rpath/pdftexA.framework/pdftexA   Frameworks/pdftexA.framework/pdftexA
install_name_tool -change @rpath/libkpathsea.6.dylib @rpath/kpathseaA.framework/kpathseaA Frameworks/pdftexA.framework/pdftexA

rm -rf Frameworks/xetexA.framework
mkdir Frameworks/xetexA.framework
cp Work/texk/web2c/.libs/xetex.dylib Frameworks/xetexA.framework/xetexA
cp basic_Info.plist Frameworks/xetexA.framework/Info.plist
plutil -replace CFBundleExecutable -string xetexA Frameworks/xetexA.framework/Info.plist
plutil -replace CFBundleName -string xetexA Frameworks/xetexA.framework/Info.plist
plutil -replace CFBundleIdentifier -string Nicolas-Holzschuch.xetexA Frameworks/xetexA.framework/Info.plist
install_name_tool -id @rpath/xetexA.framework/xetexA   Frameworks/xetexA.framework/xetexA
install_name_tool -change @rpath/libkpathsea.6.dylib @rpath/kpathseaA.framework/kpathseaA Frameworks/xetexA.framework/xetexA

rm -rf Frameworks/ptexencA.framework
mkdir Frameworks/ptexencA.framework 
cp Work/texk/ptexenc/.libs/libptexenc.dylib Frameworks/ptexencA.framework/ptexencA
cp basic_Info.plist Frameworks/ptexencA.framework/Info.plist
plutil -replace CFBundleExecutable -string ptexencA Frameworks/ptexencA.framework/Info.plist
plutil -replace CFBundleName -string ptexencA Frameworks/ptexencA.framework/Info.plist
plutil -replace CFBundleIdentifier -string Nicolas-Holzschuch.ptexencA Frameworks/ptexencA.framework/Info.plist
install_name_tool -id  @rpath/ptexencA.framework/ptexencA   Frameworks/ptexencA.framework/ptexencA
install_name_tool -change @rpath/libkpathsea.6.dylib @rpath/kpathsea.framework/kpathsea Frameworks/ptexencA.framework/ptexencA

rm -rf Frameworks/euptexA.framework
mkdir Frameworks/euptexA.framework
cp Work/texk/web2c/.libs/euptex.dylib Frameworks/euptexA.framework/euptexA
cp basic_Info.plist Frameworks/euptexA.framework/Info.plist
plutil -replace CFBundleExecutable -string euptexA Frameworks/euptexA.framework/Info.plist
plutil -replace CFBundleName -string euptexA Frameworks/euptexA.framework/Info.plist
plutil -replace CFBundleIdentifier -string Nicolas-Holzschuch.euptexA Frameworks/euptexA.framework/Info.plist
install_name_tool -id @rpath/euptexA.framework/euptexA   Frameworks/euptexA.framework/euptexA
install_name_tool -change @rpath/libkpathsea.6.dylib @rpath/kpathseaA.framework/kpathseaA Frameworks/euptexA.framework/euptexA
install_name_tool -change $PWD/inst/lib/libptexenc.1.dylib @rpath/ptexencA.framework/ptexencA Frameworks/euptexA.framework/euptexA

rm -rf Frameworks/xdvipdfmxA.framework
mkdir Frameworks/xdvipdfmxA.framework
cp Work/texk/dvipdfm-x/.libs/xdvipdfmx.dylib Frameworks/xdvipdfmxA.framework/xdvipdfmxA
cp basic_Info.plist Frameworks/xdvipdfmxA.framework/Info.plist
plutil -replace CFBundleExecutable -string xdvipdfmxA Frameworks/xdvipdfmxA.framework/Info.plist
plutil -replace CFBundleName -string xdvipdfmxA Frameworks/xdvipdfmxA.framework/Info.plist
plutil -replace CFBundleIdentifier -string Nicolas-Holzschuch.xdvipdfmxA Frameworks/xdvipdfmxA.framework/Info.plist
install_name_tool -id @rpath/xdvipdfmxA.framework/xdvipdfmxA   Frameworks/xdvipdfmxA.framework/xdvipdfmxA
install_name_tool -change @rpath/libkpathsea.6.dylib @rpath/kpathsea.framework/kpathsea Frameworks/xdvipdfmxA.framework/xdvipdfmxA

if [ $BUILD_SIMULATOR == 1 ];
then 
#3 Now compile for the simulator: 
echo "Building for Simulator:"

export SYSROOT=$(xcrun --sdk iphonesimulator --show-sdk-path) 
./Build --host=x86-apple-darwin --build=x86_64-apple-darwin \
--disable-native-texlive-build \
--enable-shared \
--disable-static \
--disable-cxx-runtime-hack \
--without-x \
--disable-cjkutils \
--disable-texdoctk \
--disable-tpic2pdftex \
--disable-tex         \
--disable-ptex        \
--disable-eptex       \
--disable-uptex       \
--enable-euptex      \
--disable-hitex       \
--disable-luajittex   \
--enable-xetex       \
--disable-web-progs   \
--disable-synctex     \
--disable-tex4htk     \
--disable-mktexmf-default \
--disable-mktexpk-default \
--disable-mktextfm-default \
--disable-mktexfmt-default \
--disable-aleph \
--disable-mp \
--disable-pmp \
--disable-upmp \
--disable-xdvipdfmx \
--disable-xindy \
--disable-xpdfopen \
--disable-dvi2tty \
--disable-dvidvi \
--disable-dviljk \
--enable-dvipdfm-x \
--disable-dvipng \
--disable-dvipos \
--disable-dvipsk \
--disable-dvisvgm \
--disable-xdvik \
--with-system-zlib \
--disable-mfluajit \
--disable-multiplatform \
CC=clang \
CXX=clang++ \
OBJCXX=clang++ \
CFLAGS="-miphonesimulator-version-min=14.0\ -isysroot\ ${SYSROOT}\ -D\ __IPHONE__\ -I${PWD}\ -I${PWD}/texk/ptexenc" \
CPPFLAGS="-miphonesimulator-version-min=14.0\ -isysroot\ ${SYSROOT}\ -D\ __IPHONE__\ -I${PWD}" \
LDFLAGS="-miphonesimulator-version-min=14.0\ -isysroot\ ${SYSROOT}\ -F${PWD}/ios_system.xcframework/ios-arm64_x86_64-simulator\ -framework\ ios_system\ " \
CXXFLAGS="-miphonesimulator-version-min=14.0\ -isysroot\ ${SYSROOT}\ -std=c++11\ -D\ __IPHONE__\ -stdlib=libc++ " \
OBJCXXFLAGS="-miphonesimulator-version-min=14.0\ -isysroot\ ${SYSROOT}\ \ -std=c++11\ -D\ __IPHONE__\ -stdlib=libc++ " \
>& build_simulator.log

echo "Compilation done, generating frameworks"
mkdir -p Frameworks_Simulator

rm -rf Frameworks_Simulator/texlua53.framework
mkdir Frameworks_Simulator/texlua53.framework 
cp Work/libs/lua53/.libs/libtexlua53.5.dylib Frameworks_Simulator/texlua53.framework/texlua53
cp basic_Info_Simulator.plist Frameworks_Simulator/texlua53.framework/Info.plist
plutil -replace CFBundleExecutable -string texlua53 Frameworks_Simulator/texlua53.framework/Info.plist
plutil -replace CFBundleName -string texlua53 Frameworks_Simulator/texlua53.framework/Info.plist
plutil -replace CFBundleIdentifier -string Nicolas-Holzschuch.texlua53 Frameworks_Simulator/texlua53.framework/Info.plist
install_name_tool -id @rpath/texlua53.framework/texlua53   Frameworks_Simulator/texlua53.framework/texlua53

rm -rf Frameworks_Simulator/kpathsea.framework
mkdir Frameworks_Simulator/kpathsea.framework 
cp Work/texk/kpathsea/.libs/libkpathsea.dylib Frameworks_Simulator/kpathsea.framework/kpathsea
cp basic_Info_Simulator.plist Frameworks_Simulator/kpathsea.framework/Info.plist
plutil -replace CFBundleExecutable -string kpathsea Frameworks_Simulator/kpathsea.framework/Info.plist
plutil -replace CFBundleName -string kpathsea Frameworks_Simulator/kpathsea.framework/Info.plist
plutil -replace CFBundleIdentifier -string Nicolas-Holzschuch.kpathsea Frameworks_Simulator/kpathsea.framework/Info.plist
install_name_tool -id  @rpath/kpathsea.framework/kpathsea   Frameworks_Simulator/kpathsea.framework/kpathsea

rm -rf Frameworks_Simulator/makeindex.framework
mkdir Frameworks_Simulator/makeindex.framework 
cp Work/texk/makeindexk/.libs/makeindex.dylib Frameworks_Simulator/makeindex.framework/makeindex
cp basic_Info.plist Frameworks_Simulator/makeindex.framework/Info.plist
plutil -replace CFBundleExecutable -string makeindex Frameworks_Simulator/makeindex.framework/Info.plist
plutil -replace CFBundleName -string makeindex Frameworks_Simulator/makeindex.framework/Info.plist
plutil -replace CFBundleIdentifier -string Nicolas-Holzschuch.makeindex Frameworks_Simulator/makeindex.framework/Info.plist
install_name_tool -id  @rpath/makeindex.framework/makeindex   Frameworks_Simulator/makeindex.framework/makeindex
install_name_tool -change @rpath/libkpathsea.6.dylib  @rpath/kpathsea.framework/kpathsea Frameworks_Simulator/makeindex.framework/makeindex

rm -rf Frameworks_Simulator/luatex.framework
mkdir Frameworks_Simulator/luatex.framework 
cp Work/texk/web2c/.libs/luatex.dylib Frameworks_Simulator/luatex.framework/luatex
cp basic_Info_Simulator.plist Frameworks_Simulator/luatex.framework/Info.plist
plutil -replace CFBundleExecutable -string luatex Frameworks_Simulator/luatex.framework/Info.plist
plutil -replace CFBundleName -string luatex Frameworks_Simulator/luatex.framework/Info.plist
plutil -replace CFBundleIdentifier -string Nicolas-Holzschuch.luatex Frameworks_Simulator/luatex.framework/Info.plist
install_name_tool -id @rpath/luatex.framework/luatex   Frameworks_Simulator/luatex.framework/luatex
install_name_tool -change $PWD/inst/lib/libtexlua53.5.dylib @rpath/texlua53.framework/texlua53  Frameworks_Simulator/luatex.framework/luatex
install_name_tool -change @rpath/libkpathsea.6.dylib  @rpath/kpathsea.framework/kpathsea Frameworks_Simulator/luatex.framework/luatex

rm -rf Frameworks_Simulator/luahbtex.framework
mkdir Frameworks_Simulator/luahbtex.framework 
cp Work/texk/web2c/.libs/luahbtex.dylib Frameworks_Simulator/luahbtex.framework/luahbtex
cp basic_Info.plist Frameworks_Simulator/luahbtex.framework/Info.plist
plutil -replace CFBundleExecutable -string luahbtex Frameworks_Simulator/luahbtex.framework/Info.plist
plutil -replace CFBundleName -string luahbtex Frameworks_Simulator/luahbtex.framework/Info.plist
plutil -replace CFBundleIdentifier -string Nicolas-Holzschuch.luahbtex Frameworks_Simulator/luahbtex.framework/Info.plist
install_name_tool -id @rpath/luahbtex.framework/luahbtex   Frameworks_Simulator/luahbtex.framework/luahbtex
install_name_tool -change $PWD/inst/lib/libtexlua53.5.dylib @rpath/texlua53.framework/texlua53  Frameworks_Simulator/luahbtex.framework/luahbtex
install_name_tool -change @rpath/libkpathsea.6.dylib  @rpath/kpathsea.framework/kpathsea Frameworks_Simulator/luahbtex.framework/luahbtex


rm -rf Frameworks_Simulator/pdftex.framework
mkdir Frameworks_Simulator/pdftex.framework
cp Work/texk/web2c/.libs/pdftex.dylib Frameworks_Simulator/pdftex.framework/pdftex
cp basic_Info_Simulator.plist Frameworks_Simulator/pdftex.framework/Info.plist
plutil -replace CFBundleExecutable -string pdftex Frameworks_Simulator/pdftex.framework/Info.plist
plutil -replace CFBundleName -string pdftex Frameworks_Simulator/pdftex.framework/Info.plist
plutil -replace CFBundleIdentifier -string Nicolas-Holzschuch.pdftex Frameworks_Simulator/pdftex.framework/Info.plist
install_name_tool -id @rpath/pdftex.framework/pdftex   Frameworks_Simulator/pdftex.framework/pdftex
install_name_tool -change @rpath/libkpathsea.6.dylib @rpath/kpathsea.framework/kpathsea Frameworks_Simulator/pdftex.framework/pdftex

rm -rf Frameworks_Simulator/xetex.framework
mkdir Frameworks_Simulator/xetex.framework
cp Work/texk/web2c/.libs/xetex.dylib Frameworks_Simulator/xetex.framework/xetex
cp basic_Info_Simulator.plist Frameworks_Simulator/xetex.framework/Info.plist
plutil -replace CFBundleExecutable -string xetex Frameworks_Simulator/xetex.framework/Info.plist
plutil -replace CFBundleName -string xetex Frameworks_Simulator/xetex.framework/Info.plist
plutil -replace CFBundleIdentifier -string Nicolas-Holzschuch.xetex Frameworks_Simulator/xetex.framework/Info.plist
install_name_tool -id @rpath/xetex.framework/xetex   Frameworks_Simulator/xetex.framework/xetex
install_name_tool -change @rpath/libkpathsea.6.dylib @rpath/kpathsea.framework/kpathsea Frameworks_Simulator/xetex.framework/xetex

rm -rf Frameworks_Simulator/ptexenc.framework
mkdir Frameworks_Simulator/ptexenc.framework 
cp Work/texk/ptexenc/.libs/libptexenc.dylib Frameworks_Simulator/ptexenc.framework/ptexenc
cp basic_Info.plist Frameworks_Simulator/ptexenc.framework/Info.plist
plutil -replace CFBundleExecutable -string ptexenc Frameworks_Simulator/ptexenc.framework/Info.plist
plutil -replace CFBundleName -string ptexenc Frameworks_Simulator/ptexenc.framework/Info.plist
plutil -replace CFBundleIdentifier -string Nicolas-Holzschuch.ptexenc Frameworks_Simulator/ptexenc.framework/Info.plist
install_name_tool -id  @rpath/ptexenc.framework/ptexenc   Frameworks_Simulator/ptexenc.framework/ptexenc
install_name_tool -change @rpath/libkpathsea.6.dylib @rpath/kpathsea.framework/kpathsea Frameworks_Simulator/ptexenc.framework/ptexenc

rm -rf Frameworks_Simulator/euptex.framework
mkdir Frameworks_Simulator/euptex.framework
cp Work/texk/web2c/.libs/euptex.dylib Frameworks_Simulator/euptex.framework/euptex
cp basic_Info.plist Frameworks_Simulator/euptex.framework/Info.plist
plutil -replace CFBundleExecutable -string euptex Frameworks_Simulator/euptex.framework/Info.plist
plutil -replace CFBundleName -string euptex Frameworks_Simulator/euptex.framework/Info.plist
plutil -replace CFBundleIdentifier -string Nicolas-Holzschuch.euptex Frameworks_Simulator/euptex.framework/Info.plist
install_name_tool -id @rpath/euptex.framework/euptex   Frameworks_Simulator/euptex.framework/euptex
install_name_tool -change @rpath/libkpathsea.6.dylib @rpath/kpathsea.framework/kpathsea Frameworks_Simulator/euptex.framework/euptex
install_name_tool -change $PWD/inst/lib/libptexenc.1.dylib @rpath/ptexenc.framework/ptexenc Frameworks_Simulator/euptex.framework/euptex

rm -rf Frameworks_Simulator/bibtex.framework
mkdir Frameworks_Simulator/bibtex.framework
cp Work/texk/bibtex-x/.libs/bibtex8.dylib Frameworks_Simulator/bibtex.framework/bibtex
cp basic_Info_Simulator.plist Frameworks_Simulator/bibtex.framework/Info.plist
plutil -replace CFBundleExecutable -string bibtex Frameworks_Simulator/bibtex.framework/Info.plist
plutil -replace CFBundleName -string bibtex Frameworks_Simulator/bibtex.framework/Info.plist
plutil -replace CFBundleIdentifier -string Nicolas-Holzschuch.bibtex Frameworks_Simulator/bibtex.framework/Info.plist
install_name_tool -id @rpath/bibtex.framework/bibtex   Frameworks_Simulator/bibtex.framework/bibtex
install_name_tool -change @rpath/libkpathsea.6.dylib @rpath/kpathsea.framework/kpathsea Frameworks_Simulator/bibtex.framework/bibtex

rm -rf Frameworks_Simulator/kpsewhich.framework
mkdir Frameworks_Simulator/kpsewhich.framework
cp Work/texk/kpathsea/.libs/kpsewhich Frameworks_Simulator/kpsewhich.framework/kpsewhich
cp basic_Info.plist Frameworks_Simulator/kpsewhich.framework/Info.plist
plutil -replace CFBundleExecutable -string kpsewhich Frameworks_Simulator/kpsewhich.framework/Info.plist
plutil -replace CFBundleName -string kpsewhich Frameworks_Simulator/kpsewhich.framework/Info.plist
plutil -replace CFBundleIdentifier -string Nicolas-Holzschuch.kpsewhich Frameworks_Simulator/kpsewhich.framework/Info.plist
install_name_tool -id @rpath/kpsewhich.framework/kpsewhich   Frameworks_Simulator/kpsewhich.framework/kpsewhich
install_name_tool -change @rpath/libkpathsea.6.dylib @rpath/kpathsea.framework/kpathsea Frameworks_Simulator/kpsewhich.framework/kpsewhich

rm -rf Frameworks_Simulator/xdvipdfmx.framework
mkdir Frameworks_Simulator/xdvipdfmx.framework
cp Work/texk/dvipdfm-x/.libs/xdvipdfmx.dylib Frameworks_Simulator/xdvipdfmx.framework/xdvipdfmx
cp basic_Info.plist Frameworks_Simulator/xdvipdfmx.framework/Info.plist
plutil -replace CFBundleExecutable -string xdvipdfmx Frameworks_Simulator/xdvipdfmx.framework/Info.plist
plutil -replace CFBundleName -string xdvipdfmx Frameworks_Simulator/xdvipdfmx.framework/Info.plist
plutil -replace CFBundleIdentifier -string Nicolas-Holzschuch.xdvipdfmx Frameworks_Simulator/xdvipdfmx.framework/Info.plist
install_name_tool -id @rpath/xdvipdfmx.framework/xdvipdfmx   Frameworks_Simulator/xdvipdfmx.framework/xdvipdfmx
install_name_tool -change @rpath/libkpathsea.6.dylib @rpath/kpathsea.framework/kpathsea Frameworks_Simulator/xdvipdfmx.framework/xdvipdfmx

# New frameworks with ...A:
rm -rf Frameworks_Simulator/texlua53A.framework
mkdir Frameworks_Simulator/texlua53A.framework 
cp Work/libs/lua53/.libs/libtexlua53.5.dylib Frameworks_Simulator/texlua53A.framework/texlua53A
cp basic_Info.plist Frameworks_Simulator/texlua53A.framework/Info.plist
plutil -replace CFBundleExecutable -string texlua53A Frameworks_Simulator/texlua53A.framework/Info.plist
plutil -replace CFBundleName -string texlua53A Frameworks_Simulator/texlua53A.framework/Info.plist
plutil -replace CFBundleIdentifier -string Nicolas-Holzschuch.texlua53A Frameworks_Simulator/texlua53A.framework/Info.plist
install_name_tool -id @rpath/texlua53A.framework/texlua53A   Frameworks_Simulator/texlua53A.framework/texlua53A

rm -rf Frameworks_Simulator/kpathseaA.framework
mkdir Frameworks_Simulator/kpathseaA.framework 
cp Work/texk/kpathsea/.libs/libkpathsea.dylib Frameworks_Simulator/kpathseaA.framework/kpathseaA
cp basic_Info.plist Frameworks_Simulator/kpathseaA.framework/Info.plist
plutil -replace CFBundleExecutable -string kpathseaA Frameworks_Simulator/kpathseaA.framework/Info.plist
plutil -replace CFBundleName -string kpathseaA Frameworks_Simulator/kpathseaA.framework/Info.plist
plutil -replace CFBundleIdentifier -string Nicolas-Holzschuch.kpathseaA Frameworks_Simulator/kpathseaA.framework/Info.plist
install_name_tool -id  @rpath/kpathseaA.framework/kpathseaA   Frameworks_Simulator/kpathseaA.framework/kpathseaA

rm -rf Frameworks_Simulator/luatexA.framework
mkdir Frameworks_Simulator/luatexA.framework 
cp Work/texk/web2c/.libs/luatex.dylib Frameworks_Simulator/luatexA.framework/luatexA
cp basic_Info.plist Frameworks_Simulator/luatexA.framework/Info.plist
plutil -replace CFBundleExecutable -string luatexA Frameworks_Simulator/luatexA.framework/Info.plist
plutil -replace CFBundleName -string luatexA Frameworks_Simulator/luatexA.framework/Info.plist
plutil -replace CFBundleIdentifier -string Nicolas-Holzschuch.luatexA Frameworks_Simulator/luatexA.framework/Info.plist
install_name_tool -id @rpath/luatexA.framework/luatexA   Frameworks_Simulator/luatexA.framework/luatexA
install_name_tool -change $PWD/inst/lib/libtexlua53.5.dylib @rpath/texlua53A.framework/texlua53A  Frameworks_Simulator/luatexA.framework/luatexA
install_name_tool -change @rpath/libkpathsea.6.dylib  @rpath/kpathseaA.framework/kpathseaA Frameworks_Simulator/luatexA.framework/luatexA

rm -rf Frameworks_Simulator/luahbtexA.framework
mkdir Frameworks_Simulator/luahbtexA.framework 
cp Work/texk/web2c/.libs/luahbtex.dylib Frameworks_Simulator/luahbtexA.framework/luahbtexA
cp basic_Info.plist Frameworks_Simulator/luahbtexA.framework/Info.plist
plutil -replace CFBundleExecutable -string luahbtexA Frameworks_Simulator/luahbtexA.framework/Info.plist
plutil -replace CFBundleName -string luahbtexA Frameworks_Simulator/luahbtexA.framework/Info.plist
plutil -replace CFBundleIdentifier -string Nicolas-Holzschuch.luahbtexA Frameworks_Simulator/luahbtexA.framework/Info.plist
install_name_tool -id @rpath/luahbtexA.framework/luahbtexA   Frameworks_Simulator/luahbtexA.framework/luahbtexA
install_name_tool -change $PWD/inst/lib/libtexlua53.5.dylib @rpath/texlua53A.framework/texlua53A  Frameworks_Simulator/luahbtexA.framework/luahbtexA
install_name_tool -change @rpath/libkpathsea.6.dylib  @rpath/kpathseaA.framework/kpathseaA Frameworks_Simulator/luahbtexA.framework/luahbtexA

rm -rf Frameworks_Simulator/pdftexA.framework
mkdir Frameworks_Simulator/pdftexA.framework
cp Work/texk/web2c/.libs/pdftex.dylib Frameworks_Simulator/pdftexA.framework/pdftexA
cp basic_Info.plist Frameworks_Simulator/pdftexA.framework/Info.plist
plutil -replace CFBundleExecutable -string pdftexA Frameworks_Simulator/pdftexA.framework/Info.plist
plutil -replace CFBundleName -string pdftexA Frameworks_Simulator/pdftexA.framework/Info.plist
plutil -replace CFBundleIdentifier -string Nicolas-Holzschuch.pdftexA Frameworks_Simulator/pdftexA.framework/Info.plist
install_name_tool -id @rpath/pdftexA.framework/pdftexA   Frameworks_Simulator/pdftexA.framework/pdftexA
install_name_tool -change @rpath/libkpathsea.6.dylib @rpath/kpathseaA.framework/kpathseaA Frameworks_Simulator/pdftexA.framework/pdftexA

rm -rf Frameworks_Simulator/xetexA.framework
mkdir Frameworks_Simulator/xetexA.framework
cp Work/texk/web2c/.libs/xetex.dylib Frameworks_Simulator/xetexA.framework/xetexA
cp basic_Info.plist Frameworks_Simulator/xetexA.framework/Info.plist
plutil -replace CFBundleExecutable -string xetexA Frameworks_Simulator/xetexA.framework/Info.plist
plutil -replace CFBundleName -string xetexA Frameworks_Simulator/xetexA.framework/Info.plist
plutil -replace CFBundleIdentifier -string Nicolas-Holzschuch.xetexA Frameworks_Simulator/xetexA.framework/Info.plist
install_name_tool -id @rpath/xetexA.framework/xetexA   Frameworks_Simulator/xetexA.framework/xetexA
install_name_tool -change @rpath/libkpathsea.6.dylib @rpath/kpathseaA.framework/kpathseaA Frameworks_Simulator/xetexA.framework/xetexA

rm -rf Frameworks_Simulator/ptexencA.framework
mkdir Frameworks_Simulator/ptexencA.framework 
cp Work/texk/ptexenc/.libs/libptexenc.dylib Frameworks_Simulator/ptexencA.framework/ptexencA
cp basic_Info.plist Frameworks_Simulator/ptexencA.framework/Info.plist
plutil -replace CFBundleExecutable -string ptexencA Frameworks_Simulator/ptexencA.framework/Info.plist
plutil -replace CFBundleName -string ptexencA Frameworks_Simulator/ptexencA.framework/Info.plist
plutil -replace CFBundleIdentifier -string Nicolas-Holzschuch.ptexencA Frameworks_Simulator/ptexencA.framework/Info.plist
install_name_tool -id  @rpath/ptexencA.framework/ptexencA   Frameworks_Simulator/ptexencA.framework/ptexencA
install_name_tool -change @rpath/libkpathsea.6.dylib @rpath/kpathsea.framework/kpathsea Frameworks_Simulator/ptexencA.framework/ptexencA

rm -rf Frameworks_Simulator/euptexA.framework
mkdir Frameworks_Simulator/euptexA.framework
cp Work/texk/web2c/.libs/euptex.dylib Frameworks_Simulator/euptexA.framework/euptexA
cp basic_Info.plist Frameworks_Simulator/euptexA.framework/Info.plist
plutil -replace CFBundleExecutable -string euptexA Frameworks_Simulator/euptexA.framework/Info.plist
plutil -replace CFBundleName -string euptexA Frameworks_Simulator/euptexA.framework/Info.plist
plutil -replace CFBundleIdentifier -string Nicolas-Holzschuch.euptexA Frameworks_Simulator/euptexA.framework/Info.plist
install_name_tool -id @rpath/euptexA.framework/euptexA   Frameworks_Simulator/euptexA.framework/euptexA
install_name_tool -change @rpath/libkpathsea.6.dylib @rpath/kpathseaA.framework/kpathseaA Frameworks_Simulator/euptexA.framework/euptexA
install_name_tool -change $PWD/inst/lib/libptexenc.1.dylib @rpath/ptexencA.framework/ptexencA Frameworks_Simulator/euptexA.framework/euptexA

rm -rf Frameworks_Simulator/xdvipdfmxA.framework
mkdir Frameworks_Simulator/xdvipdfmxA.framework
cp Work/texk/dvipdfm-x/.libs/xdvipdfmx.dylib Frameworks_Simulator/xdvipdfmxA.framework/xdvipdfmxA
cp basic_Info.plist Frameworks_Simulator/xdvipdfmxA.framework/Info.plist
plutil -replace CFBundleExecutable -string xdvipdfmxA Frameworks_Simulator/xdvipdfmxA.framework/Info.plist
plutil -replace CFBundleName -string xdvipdfmxA Frameworks_Simulator/xdvipdfmxA.framework/Info.plist
plutil -replace CFBundleIdentifier -string Nicolas-Holzschuch.xdvipdfmxA Frameworks_Simulator/xdvipdfmxA.framework/Info.plist
install_name_tool -id @rpath/xdvipdfmxA.framework/xdvipdfmxA   Frameworks_Simulator/xdvipdfmxA.framework/xdvipdfmxA
install_name_tool -change @rpath/libkpathsea.6.dylib @rpath/kpathseaA.framework/kpathseaA Frameworks_Simulator/xdvipdfmxA.framework/xdvipdfmxA

# 4) build xc frameworks:
echo "Building xc frameworks:"

for framework in texlua53 kpathsea makeindex luatex luahbtex pdftex xetex bibtex kpsewhich xdvipdfmx texlua53A kpathseaA luatexA luahbtexA pdftexA xetexA xdvipdfmxA ptexenc ptexencA euptex euptexA
do
   rm -rf $framework.xcframework
   xcodebuild -create-xcframework -framework Frameworks/$framework.framework -framework Frameworks_Simulator/$framework.framework -output $framework.xcframework
   # while we're at it, let's compute the checksum:
   rm -f $framework.xcframework.zip
   zip -r $framework.xcframework.zip $framework.xcframework
   swift package compute-checksum $framework.xcframework.zip
done
else
# 4) Just build xc frameworks:
echo "Building xc frameworks:"

for framework in texlua53 kpathsea makeindex luatex luahbtex pdftex xetex bibtex kpsewhich xdvipdfmx texlua53A kpathseaA luatexA luahbtexA pdftexA xetexA xdvipdfmxA ptexenc ptexencA euptex euptexA
do
   rm -rf $framework.xcframework
   xcodebuild -create-xcframework -framework Frameworks/$framework.framework -output $framework.xcframework
done




fi
