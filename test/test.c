int main() {
    int *pi = malloc(sizeof(int));
    int max = readi();
    for (int i = 0; i < max; i += 2) {
        println(i);
        *pi += i;
    }
    println(*pi);
    free(pi);
    return 0;
}
