int factorial(int n) {
    if (n < 0) return 0;
    int c = 1;
    for (int i = 1; i <= n; i += 1) {
        c *= i;
    }
    return c;
}

int main() {
    return factorial(5);
}
