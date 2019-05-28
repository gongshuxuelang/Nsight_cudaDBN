#include "head.h"
/*
 * 说明,GPU分出一个文件的向量,例如32个行向量,需要分出32个线程.
 * 进入GPU中每一个线程又需要干不同的任务,一个行向量要进行DBN_N次分解和重构
 * 每一次分解要比上一次的行向量多2倍,总体上就是2的DBN_N次幂的关系.
 * 我需要的做的就是理清楚一个行向量做出2维数据,用并行算法写出代码.避免串行代码的问题,既然使用了GPU那就不要浪费GPU的计算性能.
 * */
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
//接收的数据为32*7681,32行互不相干。开32个线程来处理这个矩阵。d_data是数据row是行，line是列，DBN_N是分解层数
__global__ void GPU0(double* d_a,double* max,int row,int line,int dbn,int dbn_n)
{
	int idx = threadIdx.x;
	switch(idx)
	{
	case 0:
		int refline = 0;
		double* refdata;
		dec(d_a,max,row,line,dbn,idx,dbn_n,refdata,refline);
		__syncthreads();
		/*重构部分*/
		printf("refline = %d\n",refline);
		printf("power(2,dbn_n) * refline = %d\n",power(2,dbn_n) * refline);
		for(int i = 0; i < power(2,dbn_n) * refline;++i)
		{
			printf("refdata[%d] = %f\n",i,refdata[i]);
		}
		ref(refdata,max,refline,dbn,dbn_n);
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

__device__ void ref(double* refdata,double* max,int refline,int dbn,int dbn_n)
{
	refChooseSignal<<<1,4>>>(refdata,max,refline,dbn,dbn_n);
}

/*
 * 选择波形一共四种波形,Alpha,Beta,Delta,Theta,指定开四个线程,每个线程代表一个波形的重构,
 * 0线程代表Alpha,1线程代表Beta,2线程代表Delta,3线程代表Theta
 *
 * */
__global__ void refChooseSignal(double* refdata,double* max,int refline,int dbn,int dbn_n)
{
	int refchSigidx = threadIdx.x;

	switch(refchSigidx)
	{
	case 0:
		printf("refChooseSignal 0 = %d\n",refchSigidx);
		break;
	case 1:
		printf("refChooseSignal 1 = %d\n",refchSigidx);
		break;
	case 2:
		printf("refChooseSignal 2 = %d\n",refchSigidx);
		break;
	case 3:
		printf("refChooseSignal 3 = %d\n",refchSigidx);
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
// 这个函数用于开线程延拓线程开一组的就可以其他组的用line来区分
__global__ void decEx(double* dVectorUpSam,int line,int dbn,double* dVectorEx)
{
	int decExidx = threadIdx.x;//这个线程号最多只有一组的线程号

	for(int i = 0; i < 2 * dbn - 1; ++i)
	{
		dVectorEx[decExidx  * (line + 4 * dbn - 2) + i] 					 = dVectorUpSam[decExidx * line + 2 * dbn -2 - i];
		dVectorEx[decExidx  * (line + 4 * dbn - 2) + 2 * dbn + line - 1 + i] = dVectorUpSam[decExidx * line + line -1 - i];
	}
	for(int i = 0; i < line; ++i)
	{
		dVectorEx[decExidx  * (line + 4 * dbn - 2) + 2 * dbn - 1 + i] = dVectorUpSam[decExidx  * line + i];
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
		decEx<<<1,power(2,DBN_N)>>>(dVectorUpSam,line,dbn,dVectorEx);
	}
	return ;
}

__global__ void dataCON(double* dVectorEx,double* sdecMaxL,double* sdecMaxH,int dbn,int decCONLen,double* dVectorCON,int decCONidx,int decExLen,int DBN_N)
{
	int iidx = threadIdx.x;
	for(int i = 0; i < 2* dbn; ++i)
	{
		dVectorCON[2 * decCONidx * decCONLen + iidx] += dVectorEx[decCONidx * decExLen + iidx + i] * sdecMaxL[i];
		dVectorCON[(2 * decCONidx + 1) * decCONLen + iidx] += dVectorEx[decCONidx * decExLen + iidx + i] * sdecMaxH[i];
	}
}

__global__ void decTransfromCON(double* dVectorEx,double* sdecMaxL,double*sdecMaxH,int decCONLen,int dbn,double* dVectorCON,int decExLen,int DBN_N)
{
	int decCONidx = threadIdx.x;
	dataCON<<<1,decCONLen>>>(dVectorEx,sdecMaxL,sdecMaxH,dbn,decCONLen,dVectorCON,decCONidx,decExLen,DBN_N);
	__syncthreads();
}

__global__ void decUpSam(double* dVectorCON,double*dVectorUpSam,int decCONLen,int decUpSamLen,int DBN_N,int decUpidx)
{
	int iUpdx = threadIdx.x;
	dVectorUpSam[decUpSamLen * decUpidx + iUpdx] = dVectorCON[decCONLen * decUpidx + 2 * iUpdx + 1];
}

__global__ void decTransfromUpSam(double* dVectorCON,double*dVectorUpSam,int decCONLen,int decUpSamLen,int DBN_N)
{
	int decUpidx = threadIdx.x;
	decUpSam<<<1,decUpSamLen>>>(dVectorCON,dVectorUpSam,decCONLen,decUpSamLen,DBN_N,decUpidx);
	__syncthreads();
}

__device__ void dec(double* d_a,double* max,int row,int line,int dbn,int idx,int dbn_n,double*& refdata,int& refline)
{
	/*分解过程*/
	for(int DBN_N = 0; DBN_N < dbn_n; ++DBN_N)
	{
		int decExLen    = line + 4 * dbn - 2;//对称延拓长度
		int decCONLen   = line + 2 * dbn - 1;//分解卷积长度
		int decUpSamLen = (line + 2* dbn -1) / 2;//上采样长度

		double* dVectorEx 	  = new double[power(2,DBN_N) * decExLen]();
		double* dVectorCON    = new double[power(2,DBN_N + 1) * decCONLen]();		//  卷积和内存
		double* dVectorUpSam;													//  上采样内存

		decTransfromEx(d_a,dVectorUpSam,line,idx,dbn,decExLen,dVectorEx,DBN_N);//延拓

		printf("decExLen = %d\n",decExLen);
		for(int i = 0; i < power(2,DBN_N) * decExLen;++i)
		{
			printf("dVectorEx[%d] = %f\n",i,dVectorEx[i]);
		}
		printf("\n");

		double* sdecMaxL= new double[2 * dbn]();
		double* sdecMaxH= new double[2 * dbn]();

		for(int i = 0; i < 2 * dbn; ++i)
		{
			sdecMaxL[i] = max[0 * 2 * dbn + i];
			sdecMaxH[i] = max[1 * 2 * dbn + i];
		}
		decTransfromCON<<<1,power(2,DBN_N)>>>(dVectorEx,sdecMaxL,sdecMaxH,decCONLen,dbn,dVectorCON,decExLen,DBN_N);//卷积
		__syncthreads();
		cudaFree(dVectorEx);

		printf("decCONLen = %d\n",decCONLen);
		for(int i = 0; i < power(2,DBN_N + 1) * decCONLen;++i)
		{
			printf("dVectorCON[%d] = %f\n",i,dVectorCON[i]);
		}
		dVectorUpSam = new double[power(2,DBN_N + 1) * decUpSamLen]();
		decTransfromUpSam<<<1,power(2,DBN_N + 1)>>>(dVectorCON,dVectorUpSam,decCONLen,decUpSamLen,DBN_N);
		__syncthreads();
		cudaFree(dVectorCON);
		cudaFree(sdecMaxL);
		cudaFree(sdecMaxH);
		printf("decUpSamLen = %d\n",decUpSamLen);
		for(int i = 0; i < power(2,DBN_N + 1) * decUpSamLen;++i)
		{
			printf("dVectorUpSam[%d] = %f\n",i,dVectorUpSam[i]);
		}
		//更新系数,进行下一层分解
		line = decUpSamLen;
		if(DBN_N == dbn_n - 1)//重构信号长度
		{
			refline = line;
			refdata = new double[power(2,dbn_n)*refline];
			refdata = dVectorUpSam;
			cudaFree(dVectorUpSam);
		}
	}
}


