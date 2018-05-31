#include <stdio.h>

int f() {
    static int si = 0;
    static const int sci = 2;
    si += sci;
    return si;
}

int main() {
    printf("%d\n", f());
    printf("%d\n", f());
    printf("%d\n", f());
    return 0;
}
