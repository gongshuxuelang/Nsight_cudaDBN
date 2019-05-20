#include "head.h"


//接收的数据为32*7681,32行互不相干。开32个线程来处理这个矩阵。d_data是数据row是行，line是列，DBN_N是分解层数
__global__ void GPU0(double* d_a,int row,int line,int dbn,int dbn_n)
{
	//printf("GPU操作\n");
	double* d_data = d_a;
	int tid = threadIdx.x;
	switch(tid)
	{
	case 0:
		decTransfromEx(d_data,line,tid,dbn);


		break;
	case 1:
		decTransfromEx(d_data,line,tid,dbn);
		break;
	case 2:
		decTransfromEx(d_data,line,tid,dbn);
		break;
	case 3:
		decTransfromEx(d_data,line,tid,dbn);
		break;
	}
}

__global__ void GPU1(double* d_a,int row,int line,int dbn,int dbn_n)
{


}

__device__ void decTransfromEx(double* d_data,int line,int tid,int dbn)
{
	int decExLen = line + 4 * dbn - 2;
	double* dVectorEx = new double[decExLen];
	for(int i = 0; i < 2 * dbn - 1; ++i)
	{
		dVectorEx[i] = d_data[tid * line + 2 * dbn -2 - i];
		dVectorEx[2 * dbn + line - 1 + i] = d_data[tid * line + line -1 - i];
	}
	for(int i = 0; i < line; ++i)
	{
		dVectorEx[2 * dbn - 1 + i] = d_data[tid * line + i];
	}
	for(int i = 0; i < decExLen; ++i)
	{
		printf("%f\t",dVectorEx[i]);
	}
}

