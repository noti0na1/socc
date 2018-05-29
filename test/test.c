int factorial(int n) {
    if (n < 0) return 0;
    int c = 1;
    for (int i = 1; i <= n; i += 1) {
        println(i);
        c *= i;
    }
    return c;
}

int main() {
    int i = factorial(10);
    println(i);
    return 0;
}
