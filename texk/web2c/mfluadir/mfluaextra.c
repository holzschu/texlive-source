/* mfluaextra.c: Hand-coded routines for MFLua.

   This file is public domain.  */

#define	EXTERN /* Instantiate data from mfluad.h here.  */

#ifdef __IPHONE__
#define DLLPROC mfluamain
#endif

/* This file defines MFLua.  */
#include <mfluad.h>

/* Hand-coded routines for TeX or Metafont in C.  */
#include <lib/texmfmp.c>
