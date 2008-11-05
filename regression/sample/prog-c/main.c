#include <stdio.h>
#include "myc.h"

int main (void)
{
    printf("Project version: %s\n", v());
    printf("All the stuff goes into: %s\n", destdir());

    return 0;
}
