for framework in texlua53 kpathsea makeindex luatex luahbtex pdftex bibtex kpsewhich texlua53A kpathseaA luatexA luahbtexA pdftexA
do
   	echo $framework
   swift package compute-checksum $framework.xcframework.zip
done

