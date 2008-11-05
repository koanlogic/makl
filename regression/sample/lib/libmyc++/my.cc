#include "myc++.h"

double my_div (double a, double b) 
{
    if (b) 
        return a / b;
    else 
        throw("Division by zero");
}

double my_log (double a) 
{
    if (a > 0) 
        return log10(a);
    else
        throw("Invalid argument");
}
