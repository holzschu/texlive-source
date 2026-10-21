/* uexit.c: define uexit to do an exit with the right status.  We can't
   just call `exit' from the web files, since the webs use `exit' as a
   loop label.  Public domain. */

// uexit called from tangle, weave. uexitandclear called from (pdf)TeX

#include <w2c/config.h>
#ifdef __IPHONE__
#include "ios_error.h"
#define EXTERN extern
#include "etexd.h"
#ifndef xfree
#  define xfree(p)            do { if (p != NULL) free(p); p = NULL; } while (0)
#endif

#endif

// uexit_and_clear is defined in texlive/texk/web2c/tex.ch. Must be changed too.
void
uexitandclear (int unix_code)
{
  // 	fprintf(stderr, "Entering uexitandclear\n");
  int final_code;
  
  if (unix_code == 0)
    final_code = EXIT_SUCCESS;
  else if (unix_code == 1)
    final_code = EXIT_FAILURE;
  else
    final_code = unix_code;
#ifdef __IPHONE__
  // This function is called for each exit, either regular exit 
  // or exit after error.
  // We need to deallocate everything
  // Deallocate kpse->db (list of files):
  kpathsea_finish(kpse_def);
  // We need to deallocate everything. Taken from etexini.c
  xfree(yhash);
  xfree(zeqtb); 
  xfree(yzmem); 
  xfree(strstart); 
  xfree(strpool); 
  xfree(fontinfo); 
  xfree(fontcheck);
  xfree(fontsize );
  xfree(fontdsize );
  xfree(fontparams);
  xfree(fontname);
  xfree(fontarea);
  xfree(fontbc);
  xfree(fontec);
  xfree(fontglue);
  xfree(hyphenchar);
  xfree(skewchar);
  xfree(bcharlabel);
  xfree(fontbchar);
  xfree(fontfalsebchar);
  xfree(charbase);
  xfree(widthbase);
  xfree(heightbase);
  xfree(depthbase);
  xfree(italicbase);
  xfree(ligkernbase);
  xfree(kernbase);
  xfree(extenbase);
  xfree(parambase);
  xfree(trietrl);
  xfree(trietro);
  xfree(trietrc);
  // Addition, may 11
  xfree(triec);
  xfree(trieo);
  xfree(triel);
  xfree(trier);
  xfree(triehash);
  xfree(trietaken);
  //  
  xfree(buffer);
  xfree(nest);
  xfree(savestack);
  xfree(inputstack);
  xfree(inputfile);
  xfree(linestack);
  xfree(eofseen);
  xfree(grpstack);
  xfree(ifstack);
  xfree(sourcefilenamestack);
  xfree(fullsourcefilenamestack);
  xfree(paramstack);
  xfree(dvibuf);
  xfree(hyphword);
  xfree(hyphlist);
  xfree(hyphlink);
  // xfree(objtab);
  xfree(fontused);
  xfree(nameoffile);
  nameoffile = xmalloc(2);
  namelength = 0;
  nameoffile[0] = 0;
  nameoffile[1] = 0;
  dump_name = NULL; // dump_name needs to be reset, but not freed
  dumpname = NULL; // C translated code uses dumpname (?)
  // it's a pointer to an area that has already been freed. 
#endif /* __IPHONE__ */
  //	fprintf(stderr, "Leaving uexitandclear\n");
  exit (final_code);
}
/* 
  formatengine = xmallocarray ( ASCIIcode , x ) ;
      // vfefnts = xmallocarray ( integer , fontmax ) ;
      // vfifnts = xmallocarray ( internalfontnumber , fontmax ) ;
 */ 
