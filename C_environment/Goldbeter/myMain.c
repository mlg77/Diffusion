#include <stdio.h>
#include <stdlib.h>
#include "myMain.h"
/*void myprint(double *, int , int );*/

int main(int argc, char *argv[])
{

	double dx = 0.1;
	int n_space= 1/dx +1;
	double **space =  malloc(sizeof(double *) * n_space);/*[1][n_space];*/
	int i;
	for( i = 0; i < n_space; i++)
	   {
		space[i] = malloc(sizeof(double) *n_space);
	   }
	myarray(space, 0, dx, n_space);

	printf("%6.2f\n", space[0][2]);

	/*double dt = 0.005;
	double t_end = 15;
	int n_time= t_end/dt +1;
	double time[1][n_time];
	myarray(time, 0, dt, n_time);

	double example[n_space][n_space];
	matrixmultiply(example, space, space, n_space, n_space );
	printf("%6.2f\n", space[0][1]);
	printf("%6.2f\n", space[0][2]);
	/*myprint(space, 1, n_space);
	myprint(ex, n_space, n_space);*/

	return 0;
}

void myarray(double **A, double start, double step, double n)
{
	int i;
	for ( i = 0; i < n; i++)
	   {
		A[0][ i ] = start + i*step;
	   }
}

#if 0
void matrixmultiply(double **matC, double **A, double **B, int Ra, int Cb )
{
	int i;
	int j;
	for ( i = 0; i < Ra; i++){
		for ( j = 0; j < Cb; j++) {
				matC[i][j] = A[i][j]*B[j][i];
			   }
		   }

}

void myprint(double *matC, int R, int C)
{
	int i;
	int j;
	int mysize = (R*C);

	for ( i = 0; i < R; i++){
		for ( j = 0; j < C; j++) {
				printf("%6.2f  ", *(matC+i*C+j));
			   }
		printf("\n");
		   }

}

#endif
