#include <stdlib.h>
#include <stdio.h>

void println(int n) {
    printf("%d\n", n);
}

int readi() {
    int i = 0;
    scanf("%d", &i);
    return i;
}

void *alloc(int sz) {
    return malloc(sz);
}

void freep(void *p) {
    free(p);
}
