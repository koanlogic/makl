#include <stdio.h>
#include <limits.h>
#include "conf.h"
#include "myc.h"

int main (void)
{
    printf("Project version: %s\n", v());
    printf("All the stuff goes into: %s\n", destdir());

    /* 
     * example of conditional test driven by conf.h 
     */
#ifdef HAVE_LONG_LONG
    printf("maximum long long value is %lld\n", LLONG_MAX);
    printf("minimum long long value is %lld\n", LLONG_MIN);
#else
    printf("long long is not defined on host %s\n", HOST_OS);
#endif

    return 0;
}
