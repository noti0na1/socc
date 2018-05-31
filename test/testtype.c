#include <stdio.h>

int main() {
    int a<:1:>;
    printf("%d\n", sizeof(_Bool));
    printf("%d\n", sizeof(char));
    printf("%d\n", sizeof(short int));
    printf("%d\n", sizeof(int));
    printf("%d\n", sizeof(long int));
    printf("%d\n", sizeof(long long int));
    printf("%d\n", sizeof(unsigned int));
    printf("%d\n", sizeof(float));
    printf("%d\n", sizeof(double));
    printf("%d\n", sizeof(long double));
    printf("%d\n", sizeof(int *));
    printf("%d\n", sizeof(double *));
    // printf("%d\n", sizeof(int[]));
    printf("%d\n", sizeof(int[3]));
}
