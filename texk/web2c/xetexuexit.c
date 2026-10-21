/* uexit.c: define uexit to do an exit with the right status.  We can't
   just call `exit' from the web files, since the webs use `exit' as a
   loop label.  Public domain. */

// uexit called from tangle, weave. uexitandclear called from XeTeX

#include <w2c/config.h>
#ifdef __IPHONE__
#include "ios_error.h"
#define EXTERN extern
#include "xetexd.h"
#ifndef xfree
#  define xfree(p)            do { if (p != NULL) free(p); p = NULL; } while (0)
#endif

extern void* fixmem; 
extern void* eqtb; 

// length of allocated mappedtext
extern UInt32 outLength;
// length of allocated xdvbuffer
extern int xdvBufSize;
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
  // Deallocate kpse->db (list of files):
  kpathsea_finish(kpse_def);
  // from xetexini.c
  xfree(nativetext);
  //
  xfree(yhash);
  xfree(zeqtb); 
  xfree(yzmem); 
  xfree(strstart); 
  xfree(strpool); 
  xfree(fontinfo); 
  // from xetexini.c
  xfree(fontmapping);
  xfree(fontlayoutengine);
  xfree(fontflags);
  xfree(fontletterspace);
  //
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
  // 
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
  xfree(fontused);
  xfree(nameoffile);
  // allocated in Xetex_ext.c:
  xfree(mappedtext);
  outLength = 0;
  xfree(xdvbuffer);
  xdvBufSize = 0;
  //
  nameoffile = xmalloc(2);
  namelength = 0;
  nameoffile[0] = 0;
  nameoffile[1] = 0;
  dump_name = NULL; // dump_name needs to be reset, but not freed
  dumpname = NULL; // XeTeX uses dumpname, not dump_name
  // it's a pointer to an area that has already been freed. 
#endif /* __IPHONE__ */
  //	fprintf(stderr, "Leaving uexitandclear\n");
  exit (final_code);
}
/*
   Variables that are not yet freed, but allocated in xetexini.c:
   (same in euptexuexit.c, wich will be a first try)
  formatengine = xmallocarray ( char , x ) ;
  Nothing else is allocated in xetexini.c. 
  Xetex_ext.c and Xetex_Mac.c do allocate stuff.
  It's very likely connected to the style files loaded --> where?

TODO: See what can be done for glyph_info (allocated in Xetex_mac.c, but not stored)
*/ 
