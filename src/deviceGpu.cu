#include "head.h"


//接收的数据为32*7681,32行互不相干。开32个线程来处理这个矩阵。d_data是数据row是行，line是列，DBN_N是分解层数
__global__ void GPU0(double* d_a,double* max,int row,int line,int dbn,int dbn_n)
{
	int idx = threadIdx.x;
	switch(idx)
	{
	case 0:
		dec(d_a,max,row,line,dbn,idx);

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
__device__ void decTransfromEx(double* d_data,int line,int idx,int dbn,int decExLen,double* dVectorEx)
{
	for(int i = 0; i < line; ++i)
	{
		printf("d_data  = %f ",d_data[i]);
	}
	printf("\n");
	for(int i = 0; i < 2 * dbn - 1; ++i)
	{
		dVectorEx[i] = d_data[idx * line + 2 * dbn -2 - i];
		dVectorEx[2 * dbn + line - 1 + i] = d_data[idx * line + line -1 - i];
	}
	for(int i = 0; i < line; ++i)
	{
		dVectorEx[2 * dbn - 1 + i] = d_data[idx * line + i];
	}
	for(int i = 0; i < decExLen; ++i)
	{
		printf("dVectorEx = %f ",dVectorEx[i]);
	}
	printf("\n");
	return ;
}
__global__ void dataCON(double* dVectorEx,double* sdecMaxL,double* sdecMaxH,int dbn,int decCONLen,double* dVectorCONL,double* dVectorCONH,int idx,int decExLen)
{
	double tempL = 0;
	double tempH = 0;
	int iidx = threadIdx.x;
	for(int i = 0; i < 2* dbn; ++i)
	{
		tempL += dVectorEx[iidx + i] * sdecMaxL[i];
		tempH += dVectorEx[iidx + i] * sdecMaxH[i];
	}
	dVectorCONL[iidx] = tempL;
	dVectorCONH[iidx] = tempH;
}
__device__ void decTransfromCON(double* dVectorEx,double* max,int line,int idx,int decCONLen,int dbn,double* dVectorCONL,double* dVectorCONH,int decExLen)
{
	double* sdecMaxL= new double[2 * dbn];
	double* sdecMaxH= new double[2 * dbn];

	for(int i = 0; i < 2 * dbn; ++i)
	{
		sdecMaxL[i] = max[0 * 2 * dbn + i];
		sdecMaxH[i] = max[1 * 2 * dbn + i];
		printf("sdecMaxL = %f\t",sdecMaxL[i]);
		printf("\n");
		printf("sdecMaxH = %f\t",sdecMaxH[i]);
		printf("\n");
	}
	dataCON<<<1,decCONLen>>>(dVectorEx,sdecMaxL,sdecMaxH,dbn,decCONLen,dVectorCONL,dVectorCONH,idx,decExLen);
}
__global__ void decUpSam(double* dVectorCONL,double* dVectorCONH,double*dVectorUpSamH,double*dVectorUpSamL)
{
	int iUdx = threadIdx.x;
	dVectorUpSamH[iUdx] = dVectorCONH[2 * iUdx + 1];
	dVectorUpSamL[iUdx] = dVectorCONL[2 * iUdx + 1];
}
__device__ void dec(double* d_a,double* max,int row,int line,int dbn,int idx)
{
	int decExLen    = line + 4 * dbn - 2;//对称延拓长度
	int decCONLen   = line + 2 * dbn - 1;//分解卷积长度
	int decUpSamLen = (line + 2* dbn -1) / 2;//上采样长度

	double* dVectorEx 	  = new double[decExLen];
	double* dVectorCONL   = new double[decCONLen];
	double* dVectorCONH   = new double[decCONLen];
	double* dVectorUpSamH = new double[decUpSamLen];
	double* dVectorUpSamL = new double[decUpSamLen];
	double* dVectorUpSam  = new double[2 * decUpSamLen];
	decTransfromEx(d_a,line,idx,dbn,decExLen,dVectorEx);//延拓
	for(int i = 0; i < decExLen;++i)
	{
		printf("case:dVectorEx = %f\t",dVectorEx[i]);
	}
	printf("\n");
	decTransfromCON(dVectorEx,max,line,idx,decCONLen,dbn,dVectorCONL,dVectorCONH,decExLen);//卷积

	cudaFree(dVectorEx);
	printf("CON=\n");
	printf("decCONLen = %d\n",decCONLen);
	for(int i = 0; i < decCONLen;++i)
	{
		printf("dVectorCONL[%d] = %f\n  ",i,dVectorCONL[i]);
		printf("dVectorCONH[%d] = %f\n  ",i,dVectorCONH[i]);
	}
	decUpSam<<<1,decUpSamLen>>>(dVectorCONL,dVectorCONH,dVectorUpSamH,dVectorUpSamL);

	cudaFree(dVectorCONL);
	cudaFree(dVectorCONH);
	printf("UpSam=\n");
	printf("decUpSamLen = %d\n",decUpSamLen);
	for(int i = 0; i < decUpSamLen;++i)
	{
		printf("dVectorUpSamL[%d] = %f\n  ",i,dVectorUpSamL[i]);
		printf("dVectorUpSamH[%d] = %f\n  ",i,dVectorUpSamH[i]);
		dVectorUpSam[i] 			  = dVectorUpSamL[i];
		dVectorUpSam[decUpSamLen + i] = dVectorUpSamH[i];
	}
	cudaFree(dVectorUpSamL);
	cudaFree(dVectorUpSamH);
	for(int i = 0; i < 2 * decUpSamLen;++i)
	{
		printf("dVectorUpSam[%d] = %f\n  ",i,dVectorUpSam[i]);
	}

}
