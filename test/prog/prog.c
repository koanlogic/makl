#include <stdio.h>
#include <x.h>
#include <u/libu.h>

int facility = LOG_LOCAL0;

int main (int argc, char *argv[])
{
    printf("%s %s!\n", a(), b());

    u_unused_args(argc, argv);

    return 0;
}
