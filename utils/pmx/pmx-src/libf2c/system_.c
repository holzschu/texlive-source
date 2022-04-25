/* f77 interface to system routine */

#include "f2c.h"

#ifdef KR_headers
extern char *F77_aloc();

 integer
system_(s, n) register char *s; ftnlen n;
#else
#undef abs
#undef min
#undef max
#include "stdlib.h"
#ifdef __IPHONE__
#include "ios_error.h"
#include <sys/wait.h>
#endif
#ifdef __cplusplus
extern "C" {
#endif
extern char *F77_aloc(ftnlen, char*);

 integer
system_(register char *s, ftnlen n)
#endif
{
	char buff0[256], *buff;
	register char *bp, *blast;
	integer rv;

	buff = bp = n < sizeof(buff0)
			? buff0 : F77_aloc(n+1, "system_");
	blast = bp + n;

	while(bp < blast && *s)
		*bp++ = *s++;
	*bp = 0;
#ifndef __IPHONE__
	rv = system(buff);
#else 
	int pid = ios_fork();
	int status;
	ios_system(buff);
	waitpid(pid, &status, 0);
	rv = WEXITSTATUS(status);
#endif
	if (buff != buff0)
		free(buff);
	return rv;
	}
#ifdef __cplusplus
}
#endif
