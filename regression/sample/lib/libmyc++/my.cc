#include"myc++.h"

double div (double a, double b) 
{
    if (b) 
        return a / b;
    else 
        throw("Division by zero");
}

double log (double a) 
{
    if (a > 0) 
        return log10(a);
    else
        throw("Invalid argument");
}
