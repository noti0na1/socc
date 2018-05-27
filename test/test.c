
int f(int i, int j) {
    return i * j;
}

int main() {
    int a = 2 + 3;
    return f(f(1, a), f(3, 4));
}
