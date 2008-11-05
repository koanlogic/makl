#include <iostream>
#include "myc.h"
#include "myc++.h"

using namespace std;
 
int main (void)
{
    cout << "Project version: " << v() << endl;
    cout << "All the stuff goes into: " << destdir() << endl;
    cout << "log(1) = " << my_log(1) << endl;

    return 0;
}
