#include <stdio.h>

/* 
 * $Id: main.c,v 1.1 2006/11/01 20:33:17 stewy Exp $ 
 *
 * Test programme which links statically to a 3rd-party package
 */
int main()
{
    printf("Return value of 3rd-party function: %s\n", party_test());
    
    return 0;
}
