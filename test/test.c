int main() {
    int a = 2;
    if (a >= 2) {
        int b = 3;
        int c = b + 1;
        a = c * 2;
    } else {
        a = a ? 7 : 9;
    }
    int c = a;
    a = 0;
    return c;
}
