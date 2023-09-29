#include <stdio.h>


int main(){
    
    int x = 55;
    int y = 43;

    if (x > y)
    {
        printf("X Y'den buyuktur.");
    }
    else if (x == y)
    {
        printf("X Y'ye eşittir.");
    }
    else
    {
        printf("X Y'den küçüktür.");
    }

    return 0;
}