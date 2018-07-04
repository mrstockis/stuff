
#include <stdio.h>
#define uint unsigned int

uint pf(uint x) {
	uint i, p, k=0, c=2, l=x/2;
	_Bool f[l];
	for (i=0; i<=l; i++) {
		f[i] = 0;
	}
	while (x-1 && c<=l) {
		if (! f[c-2] ) {
			while (x%c == 0) {
				x /= c;
				p = c;
			}
			if (x-1) {
				for (i=c-2; i<x/c; i+=c) {
					f[i] = 1;
				}
			} else break;	
		}
		c++;
	}
	return p;
}

void main() {
	uint input;
	printf("Largerst prime factor: ");
	scanf("%d",&input);
	//int result = pf(input);
	printf("%d\n", pf(input) );
	main();
}
