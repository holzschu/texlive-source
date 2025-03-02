#! /bin/sh
echo "Copying xc frameworks:"

for framework in texlua53 kpathsea makeindex luatex luahbtex pdftex xetex bibtex kpsewhich xdvipdfmx texlua53A kpathseaA luatexA luahbtexA pdftexA xetexA xdvipdfmxA ptexenc ptexencA euptex euptexA
do
	echo $framework
	rm -rf ../a-Shell/xcfs/.build/artifacts/xcfs/$framework.xcframework
	mkdir -p ../a-Shell/xcfs/.build/artifacts/xcfs/$framework
	cp -r $framework.xcframework  ../a-Shell/xcfs/.build/artifacts/xcfs/$framework/
done


