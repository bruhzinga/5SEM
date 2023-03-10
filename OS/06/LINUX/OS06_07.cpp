// Разработайте консольное приложение OS06_07,  которое динамически выделяет 256 МБ памяти.
//  В выделенной памяти разместите int-массив максимальной размерности. Проинициализируйте массив последовательными значениями с шагом 1.
//  Выведите на консоль адрес выделенной памяти.


#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <errno.h>

int main() {
	int *p = (int*)malloc(256 * 1024 * 1024);
	for(int i = 0; i < 256 * 1024 * 1024 / 4; i++) {
		p[i] = i;
	}
	printf("pid %d, p = %p\n", getpid(), p);

	sleep(60*60);
	free(p);
	exit(0);
}
