#include "head.h"


//接收的数据为32*7681,32行互不相干。开32个线程来处理这个矩阵。d_data是数据row是行，line是列，DBN_N是分解层数
__global__ void GPU0(double* d_a,double* max,int row,int line,int dbn,int dbn_n)
{
	int idx = threadIdx.x;
	switch(idx)
	{
	case 0:
		dec(d_a,max,row,line,dbn,idx,dbn_n);
		__syncthreads();
		break;
	case 1:

		__syncthreads();
		break;
	case 2:

		__syncthreads();
		break;
	case 3:

		__syncthreads();
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
__device__ void decTransfromEx(double* d_data,double* dVectorUpSam,int line,int idx,int dbn,int decExLen,double* dVectorEx,int DBN_N)
{
	if(DBN_N == 0)
	{
		for(int i = 0; i < 2 * dbn - 1; ++i)
		{
			dVectorEx[i] 					  = d_data[idx * line + 2 * dbn -2 - i];
			dVectorEx[2 * dbn + line - 1 + i] = d_data[idx * line + line -1 - i];
		}
		for(int i = 0; i < line; ++i)
		{
			dVectorEx[2 * dbn - 1 + i] = d_data[idx * line + i];
		}
	}else{
		for(int i = 0; i < 2 * dbn - 1; ++i)
		{
			dVectorEx[i] 					  = dVectorUpSam[idx * line + 2 * dbn -2 - i];
			dVectorEx[2 * dbn + line - 1 + i] = dVectorUpSam[idx * line + line -1 - i];
		}
		for(int i = 0; i < line; ++i)
		{
			dVectorEx[2 * dbn - 1 + i] = dVectorUpSam[idx * line + i];
		}
	}

	//打印延拓结果
	for(int i = 0; i < decExLen; ++i)
	{
		printf("dVectorEx = %f ",dVectorEx[i]);
	}
	printf("\n");
	return ;
}
__global__ void dataCON(double* dVectorEx,double* sdecMaxL,double* sdecMaxH,int dbn,int decCONLen,double* dVectorCON,int idx,int decExLen,int DBN_N)
{
	double tempL = 0;
	double tempH = 0;
	int iidx = threadIdx.x;
	for(int i = 0; i < 2* dbn; ++i)
	{
		tempL += dVectorEx[iidx + i] * sdecMaxL[i];
		tempH += dVectorEx[iidx + i] * sdecMaxH[i];
	}
	dVectorCON[iidx] = tempL;
	dVectorCON[iidx + decCONLen] = tempH;
}
__device__ void decTransfromCON(double* dVectorEx,double* max,int line,int idx,int decCONLen,int dbn,double* dVectorCON,int decExLen,int DBN_N)
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
	dataCON<<<1,decCONLen>>>(dVectorEx,sdecMaxL,sdecMaxH,dbn,decCONLen,dVectorCON,idx,decExLen,DBN_N);
	__syncthreads();
	cudaFree(sdecMaxL);
	cudaFree(sdecMaxH);
}
__global__ void decUpSam(double* dVectorCON,double*dVectorUpSam,int decCONLen,int decUpSamLen,int DBN_N)
{
	int iUdx = threadIdx.x;
	dVectorUpSam[iUdx] 				 = dVectorCON[2 * iUdx + 1];
	dVectorUpSam[decUpSamLen + iUdx] = dVectorCON[decCONLen + 2 * iUdx + 1];
}
__device__ void dec(double* d_a,double* max,int row,int line,int dbn,int idx,int dbn_n)
{
	for(int DBN_N = 0; DBN_N < dbn_n; ++DBN_N)
	{
		int decExLen    = line + 4 * dbn - 2;//对称延拓长度
		int decCONLen   = line + 2 * dbn - 1;//分解卷积长度
		int decUpSamLen = (line + 2* dbn -1) / 2;//上采样长度

		double* dVectorEx 	  = new double[power(2,DBN_N) * decExLen];
		double* dVectorCON    = new double[power(2,DBN_N + 1) * decCONLen];		//  卷积和内存
		double* dVectorUpSam;													//  上采样内存
//		if(DBN_N == dbn_n - 1)
//		{
//			d_line = decUpSamLen;
//
//		}
		decTransfromEx(d_a,dVectorUpSam,line,idx,dbn,decExLen,dVectorEx,DBN_N);//延拓

		for(int i = 0; i < decExLen;++i)
		{
			printf("case:dVectorEx = %f\t",dVectorEx[i]);
		}
		printf("\n");
		decTransfromCON(dVectorEx,max,line,idx,decCONLen,dbn,dVectorCON,decExLen,DBN_N);//卷积
		__syncthreads();
		cudaFree(dVectorEx);
		printf("CON=\n");
		printf("decCONLen = %d\n",decCONLen);
		for(int i = 0; i < decCONLen;++i)
		{
			printf("dVectorCONL[%d] = %f\n  ",i,dVectorCON[i]);
			printf("dVectorCONH[%d] = %f\n  ",i,dVectorCON[i + decCONLen]);
		}
		dVectorUpSam = new double[power(2,DBN_N + 1) * decUpSamLen];
		decUpSam<<<1,decUpSamLen>>>(dVectorCON,dVectorUpSam,decCONLen,decUpSamLen,DBN_N);
		cudaFree(dVectorCON);
		printf("UpSam=\n");
		printf("decUpSamLen = %d\n",decUpSamLen);
		for(int i = 0; i < decUpSamLen;++i)
		{
			printf("dVectorUpSamL[%d] = %f\n  ",i,dVectorUpSam[i]);
			printf("dVectorUpSamH[%d] = %f\n  ",i,dVectorUpSam[i + decUpSamLen]);
		}
		for(int i = 0; i < 2 * decUpSamLen;++i)
		{
			printf("dVectorUpSam[%d] = %f\n  ",i,dVectorUpSam[i]);
		}
		//cudaFree(dVectorUpSam);
		//更新系数,进行下一层分解
		line = decUpSamLen;
	}
}
__device__ int power(int base, int exponent)
{
	int result = 1;
	if(exponent == 0)
	{
		return result;
	}
	for (int i = 0; i < exponent; ++i)
	{
		result *= base;
	}

	return result;
}
