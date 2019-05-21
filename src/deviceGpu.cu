#include "head.h"


//接收的数据为32*7681,32行互不相干。开32个线程来处理这个矩阵。d_data是数据row是行，line是列，DBN_N是分解层数
__global__ void GPU0(double* d_a,double* max,int row,int line,int dbn,int dbn_n)
{
	//初始化重要的系数系数
	printf("GPU\n");
	int tid = threadIdx.x;
	int decExLen  = line + 4 * dbn - 2;//对称延拓长度
	int decCONLen = line + 2 * dbn - 1;//f分解卷积长度
	double* d_data = d_a;
	//构造产量内存
//	__shared__ double* sdecLo;
//	__shared__ double* sdecHo;
//	__shared__ double* ssamLo;
//	__shared__ double* ssamHo;
//	for(int i = 0; i < 2 * dbn; ++i)
//	{
//		sdecLo[i] = max[0 * dbn + i];
//		sdecHo[i] = max[1 * dbn + i];
//		ssamLo[i] = max[2 * dbn + i];
//		ssamHo[i] = max[3 * dbn + i];
//	}
	switch(tid)
	{
	case 0:
		printf("EX\n");
		double* dVectorEx = new double[decExLen];
		dVectorEx = decTransfromEx(d_data,line,tid,dbn,decExLen);//延拓
		for(int i = 0; i < decExLen;++i)
		{
			printf("%d\t",dVectorEx[i]);
		}
		printf("\n");
		decTransfromCON(dVectorEx,max,line,tid,decCONLen,dbn);//卷积

		break;
	case 1:
		break;
	case 2:
		break;
	case 3:
		break;
	}
}

__global__ void GPU1(double* d_a,int row,int line,int dbn,int dbn_n)
{


}

__device__ void printMax(double* max,int dbn)
{
	printf("GPU打印\n");
    for(int i = 0; i < 4; ++i)
    {
        for(int j = 0; j < 2 * dbn; ++j)
        {
        	printf("%f\t",max[i * 2 * dbn + j]);
        }
        printf("\n");
    }
}

__device__ void printData(double* buffer,int row,int line)
{
    for(int i = 0; i < row; ++i)
    {
        for(int j = 0; j < line; ++j)
        {
        	printf("%d\t",buffer[i * line + j]);
        }
        printf("\n");
    }
}
__device__ double* decTransfromEx(double* d_data,int line,int tid,int dbn,int decExLen)
{
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
	return dVectorEx;
}
__global__ void dataCON(double* dVectorEx,double* sdecMaxL,double* sdecMaxH,int dbn,int decCONLen,double* dVectorCON)
{

	int tidx = threadIdx.x;
	int bidx = blockIdx.x;
	double temp = 0;
	int i= 0,j = 0,ll = 0;
	for(j = bidx * blockDim.x + tidx;j < decCONLen; j+=gridDim.x * blockDim.x)
	{
		temp = 0;
		for(i = 0; i < decCONLen; ++i)
		{
			ll = j + 1;
			temp += dVectorEx[ll] *  sdecMaxL[i];
		}
		dVectorCON[j] = temp;
	}
}
__device__ double* decTransfromCON(double* dVectorEx,double* max,int line,int tid,int decCONLen,int dbn)
{
	double* sdecMaxL= new double[2 * dbn];
	double* sdecMaxH= new double[2 * dbn];
	double* dVectorCON = new double[decCONLen];
	for(int i = 0; i < 2 * dbn; ++i)
	{
		sdecMaxL[i] = max[0 * 2 * dbn + i];
		sdecMaxH[i] = max[1 * 2 * dbn + i];
		printf("sdecMaxL = %f\t",sdecMaxL[i]);
		printf("\n");
		printf("sdecMaxH = %f\t",sdecMaxH[i]);
		printf("\n");
	}
	dataCON<<<1,4>>>(dVectorEx,sdecMaxL,sdecMaxH,dbn,decCONLen,dVectorCON);

	for(int i = 0; i < 4;++i)
	{
		for(int j = 0; j < decCONLen; ++j)
		{
			printf("%f\t",dVectorCON[i * decCONLen + j]);
		}
		printf("\n");
	}
	return dVectorCON;
}
