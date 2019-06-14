#include "head.h"
/*
 * 说明,GPU分出一个文件的向量,例如32个行向量,需要分出32个线程.
 * 进入GPU中每一个线程又需要干不同的任务,一个行向量要进行DBN_N次分解和重构
 * 每一次分解要比上一次的行向量多2倍,总体上就是2的DBN_N次幂的关系.
 * 我需要的做的就是理清楚一个行向量做出2维数据,用并行算法写出代码.避免串行代码的问题,既然使用了GPU那就不要浪费GPU的计算性能.
 * */


__shared__ double* sdecMaxL;
__shared__ double* sdecMaxH;

__device__ int T_power(int n)
{
	int m = 1;
	m = m << n;
	return m;
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

__device__ void dec(double* d_a,double* max,int row,int line,int dbn,int idx,int dbn_n,double* refdata)
{
	for(int DBN_N = 0; DBN_N < dbn_n; ++DBN_N)
	{
//		int decExLen    = line + 4 * dbn - 2;//对称延拓长度
//		int decCONLen   = line + 2 * dbn - 1;//分解卷积长度
//		int decUpSamLen = (line + 2* dbn -1) / 2;//上采样长度////
//		decTransfromEx(d_a,dVectorUpSam,line,idx,dbn,decExLen,dVectorEx,DBN_N);//延拓
//		__syncthreads();
//		printf("decExLen = %d\n",decExLen);

//		for(int i = 0;i < row * T_power(DBN_N) * decExLen; ++i)
//		{
//			printf("dVectorEx[%d] = %f\n",i,*(dVectorEx + i));
//		}
//		decTransfromCON<<<1,T_power(DBN_N)>>>(dVectorEx,sdecMaxL,sdecMaxH,decCONLen,dbn,dVectorCON,decExLen,DBN_N);//卷积
//		__syncthreads();

//		if(DBN_N != 0)
//		{
//			delete[] dVectorUpSam;
//		}
		//只能在这里申请内存,在开头申请内存第二次循环数据为空了.
//
//		dVectorUpSam = new double[T_power(DBN_N + 1) * decUpSamLen]();
//		dVectorUpSam = new double[10]();
//		delete[] dVectorEx;
//		delete[] dVectorCON;
//		delete[] dVectorUpSam;//
//		decTransfromUpSam<<<1,T_power(DBN_N + 1)>>>(dVectorCON,dVectorUpSam,decCONLen,decUpSamLen,DBN_N);
//		__syncthreads();
		//更新系数,进行下一层分解
//		line = decUpSamLen;
//		if(dbn_n - 1 == DBN_N)//重构信号长度
//		{
//			memcpy(refdata + line * T_power(dbn_n) * idx,dVectorUpSam,sizeof(double) * line * T_power(dbn_n));
//
//			//delete[] dVectorUpSam;
//		}

	}

}

__device__ void decSignal(double* DeviceDecDataFinsh,double* dVectorEx,double* dVectorCON,double* d_a,double* max,int row,int line,int dbn,int dbn_n,int idx)
{
	sdecMaxL = new double[2 * dbn]();
	sdecMaxH = new double[2 * dbn]();
	for(int i = 0; i < 2 * dbn; ++i)
	{
		sdecMaxL[i] = max[0 * 2 * dbn + i];
		sdecMaxH[i] = max[1 * 2 * dbn + i];
	}
	for(int DBN_N = 0; DBN_N < 1; ++DBN_N)
	{
		int decExLen    = line + 4 * dbn - 2;//对称延拓长度
		int decCONLen   = line + 2 * dbn - 1;//分解卷积长度
		int decUpSamLen = (line + 2* dbn -1) / 2;//上采样长度
		decTransfromEx(d_a,DeviceDecDataFinsh,line,idx,dbn,decExLen,dVectorEx,DBN_N);//延拓
		__syncthreads();
		for(int i = 0;i < row * T_power(DBN_N) * decExLen; ++i)
		{
			printf("dVectorEx[%d] = %f\n",i,*(dVectorEx + i));
		}

		dim3 dimBlock;
		if(0 == decCONLen / 1000)
		{
			dimBlock = (1,decCONLen);
		}else{
			int girdconIdx  = 0;
			int blockconIdx = 0;
			girdconIdx  = decCONLen / 1000 + 1;
			blockconIdx = 1000;
			dimBlock = (girdconIdx,blockconIdx);
		}
		decTransfromCON<<<T_power(DBN_N),dimBlock>>>(dVectorEx,sdecMaxL,sdecMaxH,decCONLen,dbn,dVectorCON,decExLen,DBN_N,idx);//卷积
		__syncthreads();
		printf("dVectorCON[%d] = %f\n",0,*(dVectorCON));
		printf("dVectorCON = %d\n",dVectorCON);
		for(int i = 0;i < T_power(DBN_N+1) * decCONLen; ++i)
		{
			printf("i = %d\n",i);
			printf("dVectorCON = %d\n",dVectorCON+i);
			printf("dVectorCON[%d] = %f\n",idx * T_power(DBN_N+1) * decCONLen + i,*(dVectorCON + idx * T_power(DBN_N+1) * decCONLen + i));
		}
	}
}
//接收的数据为32*7681,32行互不相干。开32个线程来处理这个矩阵。d_data是数据row是行，line是列，DBN_N是分解层数
__global__ void GPU0(double* DeviceDecDataFinsh,double* dVectorEx,double* dVectorCON,double* d_a,double* max,int row,int line,int dbn,int dbn_n,int finshline)
{
	int idx = threadIdx.x;
	decSignal(DeviceDecDataFinsh,dVectorEx,dVectorCON,d_a,max,row,line,dbn,dbn_n,idx);
}

__device__ void ref(double* refdata,double* max,int refline,int dbn,int dbn_n,int Begin,int End)
{
	double* refMaxL= new double[2 * dbn]();
	double* refMaxH= new double[2 * dbn]();
	for(int i = 0; i < 2 * dbn; ++i)
	{
		refMaxL[i] = max[2 * 2 * dbn + i];
		refMaxH[i] = max[3 * 2 * dbn + i];
		printf("refMaxL[%d] = %f\n",i,refMaxL[i]);
		printf("refMaxH[%d] = %f\n",i,refMaxH[i]);
	}
	printf("refline = %d\n",refline);
	for(int i = 0; i < 24; ++i)
	{
		printf("refdata[%d] = %f\n",i,refdata[i]);
	}
	for(int DBN_N = 0; DBN_N < 1; ++DBN_N)
	{
		printf("refline = %d\n",refline);
		for(int i = 0; i < 24; ++i)
		{
			printf("refdata[%d] = %f\n",i,refdata[i]);
		}

		int refDsamLen   = 2 * refline + 1;				//重构下采样长度
		int refExLen     = 2 * refline + 4 * dbn - 1;	//重构对称延拓长度
		int refConLen    = 2 * refline + 2 * dbn;		//重构卷积长度
		int refSingalLen = 2 * refline - 2 * dbn + 2;	//重构信号长度

		double* refTransfromDsam = new double[(End - Begin + 1) * refDsamLen]();
		double* refTransfromEx   = new double[(End - Begin + 1) * refExLen]();
		double* refTransfromCon  = new double[(End / 2 - Begin / 2 + 1) * refConLen]();
		double* refTransfromSignal;


		refSignalDSam<<<1,End - Begin + 1>>>(refdata,refTransfromDsam,refTransfromSignal,refDsamLen,Begin,DBN_N,refline);
		__syncthreads();
		printf("refDsamLen = %d\n",refDsamLen);
		for(int i = 0; i < (End - Begin + 1) * refDsamLen; ++i)
		{
			printf("refTransfromDsam[%d] = %f\n",i,refTransfromDsam[i]);
		}
		printf("refExLen = %d\n",refExLen);
		refSignalEx<<<1,End - Begin + 1>>>(refTransfromDsam,refTransfromEx,dbn,refDsamLen,refExLen);
		__syncthreads();
		for(int i = 0; i < (End - Begin + 1) * refExLen; ++i)
		{
			printf("refTransfromEx[%d] = %f\n",i,refTransfromEx[i]);
		}
		delete[] refTransfromDsam;
		//卷积区分高频低频卷积
		//测试卷积效果

		printf("Begin = %d\n",Begin);
		printf("End = %d\n",End);
		if(Begin % 2 == 0)
		{
			if(End % 2 == 0)//第一种情况 Begin和End都是偶数
			{
				printf("执行第一种情况\n");
				refSignalCon<<<1,End / 2 - Begin / 2>>>(refTransfromEx,refTransfromCon,refMaxL,refMaxH,refConLen,refExLen,dbn,Begin,End,0);
				refConEnd<<<1,refConLen>>>(refTransfromEx,refTransfromCon,refMaxL,refConLen,refExLen,dbn,Begin,End);//计算End数据
			}else{//第二种情况Begin是偶数,End是奇数
				printf("执行第二种情况\n");
				refSignalCon<<<1,End / 2 - Begin / 2 + 1>>>(refTransfromEx,refTransfromCon,refMaxL,refMaxH,refConLen,refExLen,dbn,Begin,End,0);
			}
		}else{
			if(End % 2 == 0)//第三种情况Begin是奇数,End是偶数
			{
				printf("执行第三种情况\n");
				refConBegin<<<1,refConLen>>>(refTransfromEx,refTransfromCon,refMaxH,dbn);//计算Begin数据
				refSignalCon<<<1,End / 2 - Begin / 2 - 1>>>(refTransfromEx,refTransfromCon,refMaxL,refMaxH,refConLen,refExLen,dbn,Begin,End,1);
				refConEnd<<<1,refConLen>>>(refTransfromEx,refTransfromCon,refMaxL,refConLen,refExLen,dbn,Begin,End);//计算End数据
			}else{//第四种情况,Begin和End都是奇数
				printf("执行第四种情况\n");
				refConBegin<<<1,refConLen>>>(refTransfromEx,refTransfromCon,refMaxH,dbn);//计算Begin数据
				refSignalCon<<<1,End / 2 - Begin / 2>>>(refTransfromEx,refTransfromCon,refMaxL,refMaxH,refConLen,refExLen,dbn,Begin,End,1);
			}
		}
		delete[] refTransfromEx;
		//打印卷积结果
		printf("refTransfromCon = \n");
		printf("refConLen = %d\n",refConLen);
		for(int i = 0; i < (End / 2 - Begin / 2 + 1) * refConLen; ++i)
		{
			printf("refTransfromCon[%d] = %f\n",i,refTransfromCon[i]);
		}
		//信号选取
		refTransfromSignal = new double[(End / 2 - Begin / 2 + 1) * refSingalLen]();
		refSignal<<<1,End / 2 - Begin / 2 + 1>>>(refTransfromCon,refTransfromSignal,refConLen,refSingalLen,dbn);
		delete[] refTransfromCon;

		printf("refTransfromSignal = \n");
		printf("refSingalLen = %d\n",refSingalLen);
		for(int i = 0; i < (End / 2 - Begin / 2 + 1) * refSingalLen; ++i)
		{
			printf("refTransfromSignal[%d] = %f\n",i,refTransfromSignal[i]);
		}
		Begin = (int)Begin / 2;
		End   = (int)End / 2;
		printf("Begin = %d\n",Begin);
		printf("End = %d\n",End);
	}
	delete[] refMaxL;
	delete[] refMaxH;
}

__global__ void refSignal(double* refTransfromCon,double*refTransfromSignal,int refConLen,int refSingalLen,int dbn)
{
	int refSignalIdx = threadIdx.x;
	refSig<<<1,refSingalLen>>>(refTransfromCon,refTransfromSignal,refConLen,refSingalLen,dbn,refSignalIdx);

}

__global__ void refSig(double* refTransfromCon,double*refTransfromSignal,int refConLen,int refSingalLen,int dbn,int refSignalIdx)
{
	int refSinidx = threadIdx.x;
	refTransfromSignal[refSignalIdx * refSingalLen + refSinidx] = refTransfromCon[refSignalIdx * refConLen + 2 * dbn - 2 + refSinidx];
}

//flag是为了保证Begin和之后的不会重复
__global__ void refConBegin(double* refTransfromEx,double* refTransfromCon,double* refMaxH,int dbn)
{
	int refConidx = threadIdx.x;
	for(int i = 0; i < 2* dbn; ++i)
	{
		refTransfromCon[refConidx] += refTransfromEx[refConidx + i] * refMaxH[i];
	}
}

__global__ void refConEnd(double* refTransfromEx,double* refTransfromCon,double* refMaxL,int refConLen,int refExLen,int dbn,int Begin,int End)
{
	int refConidx = threadIdx.x;
	for(int i = 0; i < 2* dbn; ++i)
	{
		refTransfromCon[(End / 2 - Begin / 2) * refConLen + refConidx] += refTransfromEx[(End - Begin) * refExLen + refConidx + i] * refMaxL[i];
	}
}

__global__ void refCon(double* refTransfromEx,double* refTransfromCon,double* refMaxL,double* refMaxH,int refConLen,int refExLen,int dbn,int refConBlockIdx,int flag)
{
	int refConidx = threadIdx.x;

	for(int i = 0; i < 2* dbn; ++i)
	{
		refTransfromCon[(refConBlockIdx + flag) * refConLen + refConidx] += refTransfromEx[2 * refConBlockIdx * refExLen + flag  * refExLen + refConidx + i] * refMaxL[i]
		                                                        + refTransfromEx[(2 * refConBlockIdx + 1) * refExLen  + flag * refExLen + refConidx + i] * refMaxH[i];
	}
}

__global__ void refSignalCon(double* refTransfromEx,double* refTransfromCon,double* refMaxL,double* refMaxH,int refConLen,int refExLen,int dbn,int Begin,int End,int flag)
{
	int refConBlockIdx = threadIdx.x;

	refCon<<<1,refConLen>>>(refTransfromEx,refTransfromCon,refMaxL,refMaxH,refConLen,refExLen,dbn,refConBlockIdx,flag);
}

__device__ void refEx(double* refTransfromDsam,double* refTransfromEx,int dbn,int refDsamLen,int refExLen,int refExidx)
{
	for(int i = 0; i < 2 * dbn - 1; ++i)
	{
		refTransfromEx[refExidx * refExLen + i] 				       = refTransfromDsam[refExidx * refDsamLen + 2 * dbn -2 - i];
		refTransfromEx[refExidx * refExLen + refDsamLen + 2 * dbn -1 + i] = refTransfromDsam[refExidx * refDsamLen + refDsamLen -1 - i];
	}
	for(int i = 0; i < refDsamLen; ++i)
	{
		refTransfromEx[refExidx * refExLen + 2 * dbn - 1 + i] = refTransfromDsam[refExidx * refDsamLen + i];
	}
}

__global__ void refSignalEx(double* refTransfromDsam,double* refTransfromEx,int dbn,int refDsamLen,int refExLen)
{
	int refExidx = threadIdx.x;
	refEx(refTransfromDsam,refTransfromEx,dbn,refDsamLen,refExLen,refExidx);
}

__global__ void refDSam(double* refdata,double* refTransfromDsam,double* refTransfromSignal,int refDsamLen,int Begin,int DBN_N,int refline,int refDsamidx)
{
	int refDidx = threadIdx.x;
	if(DBN_N == 0)
	{
		refTransfromDsam[refDsamidx * refDsamLen + 2 * refDidx + 1] = refdata[(refDsamidx + Begin) * refline + refDidx];
	}else{
		refTransfromDsam[refDsamidx * refDsamLen + 2 * refDidx + 1] = refTransfromSignal[refDsamidx * refDsamLen + refDidx];
	}
}

__global__ void refSignalDSam(double* refdata,double* refTransfromDsam,double* refTransfromSignal,int refDsamLen,int Begin,int DBN_N,int refline)
{
	int refDsamidx = threadIdx.x;
	refDSam<<<1,refline>>>(refdata,refTransfromDsam,refTransfromSignal,refDsamLen,Begin,DBN_N,refline,refDsamidx);
	__syncthreads();
}

/*
 * 选择波形一共四种波形,Alpha,Beta,Delta,Theta,指定开四个线程,每个线程代表一个波形的重构,
 * 0线程代表Alpha,1线程代表Beta,2线程代表Delta,3线程代表Theta
 *
 * */
__global__ void refChooseSignal(double* refdata,double* max,int refline,int dbn,int dbn_n)
{
	int refchSigidx = threadIdx.x;

//	switch(refchSigidx)
//	{
//	case 0:
//		/*
//		 * Alpha波的起始频率为7.81Hz终止信号为13.28Hz
//		 *
//		 * */
//		printf("选择Alpha波.\n");
////		int AlphaBegin = static_cast<int>(floor(7.81 * power(2,dbn_n) / 64));
////		int AlphaEnd   = static_cast<int>(floor(13.28 * power(2,dbn_n) / 64));
//		int AlphaBegin = 0;
//		int AlphaEnd = 1;
//		printf("AlphaBegin = %d\n",AlphaBegin);
//		printf("AlphaEnd = %d\n",AlphaEnd);
//		ref(refdata,max,refline,dbn,dbn_n,AlphaBegin,AlphaEnd);
//
//
//		break;
//	case 1:
//		/*
//		 * Beta波的起始频率为13.28Hz终止信号为30.47Hz
//		 *
//		 * */
//		printf("选择Beta波.\n");
//		int BetaBegin = static_cast<int>(floor(13.28 * power(2,dbn_n) / 64));
//		int BetaEnd   = static_cast<int>(floor(30.47 * power(2,dbn_n) / 64));
//		printf("BetaBegin = %d\n",BetaBegin);
//		printf("BetaEnd = %d\n",BetaEnd);
//		break;
//	case 2:
//		/*
//		 * Delta波的起始频率为0.78Hz终止信号为3.91Hz
//		 *
//		 * */
//		printf("选择Delta波.\n");
//		int DeltaBegin = static_cast<int>(floor(0.78 * power(2,dbn_n) / 64));
//		int DeltaEnd   = static_cast<int>(floor(3.91 * power(2,dbn_n) / 64));
//		printf("DeltaBegin = %d\n",DeltaBegin);
//		printf("DeltaEnd = %d\n",DeltaEnd);
//		break;
//	case 3:
//		/*
//		 *Theta波的起始频率为3.91Hz终止信号为7.81Hz
//		 *
//		 * */
//		printf("选择Theta波.\n");
//		int ThetaBegin = static_cast<int>(floor(3.91 * power(2,dbn_n) / 64));
//		int ThetaEnd   = static_cast<int>(floor(7.81 * power(2,dbn_n) / 64));
//		printf("ThetaBegin = %d\n",ThetaBegin);
//		printf("ThetaEnd = %d\n",ThetaEnd);
//		break;
//	}


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
__global__ void decEx(double* dVectorUpSam,int line,int dbn,double*& dVectorEx)
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

__device__ void decTransfromEx(double* d_data,double* dVectorUpSam,int line,int idx,int dbn,int decExLen,double*& dVectorEx,int DBN_N)
{
	if(DBN_N == 0)
	{
		for(int i = 0; i < 2 * dbn - 1; ++i)
		{
			dVectorEx[idx * T_power(DBN_N) * decExLen + i] = d_data[idx * line + 2 * dbn -2 - i];
			dVectorEx[idx * T_power(DBN_N) * decExLen + 2 * dbn + line - 1 + i] = d_data[idx * line + line -1 - i];
		}
		for(int i = 0; i < line; ++i)
		{
			dVectorEx[idx * T_power(DBN_N) * decExLen + 2 * dbn - 1 + i] = d_data[idx * line + i];
		}
	}else{
		decEx<<<1,T_power(DBN_N)>>>(dVectorUpSam,line,dbn,dVectorEx);
		__syncthreads();
	}
}

__global__ void decTransfromCON(double* dVectorEx,double* sdecMaxL,double*sdecMaxH,int decCONLen,int dbn,double* dVectorCON,int decExLen,int DBN_N,int idx)
{
	int decCONidx = threadIdx.y * blockDim.x + threadIdx.x;
	int decgridIdx = blockIdx.x;

	for(int i = 0; i < 2 * dbn; ++i)
	{
		dVectorCON[idx * T_power(DBN_N + 1) * decCONLen + 2 * decgridIdx * decCONLen + decCONidx]       += dVectorEx[idx * T_power(DBN_N) * decExLen + decgridIdx * decExLen + decCONidx + i] * sdecMaxL[i];
		dVectorCON[idx * T_power(DBN_N + 1) * decCONLen + (2 * decgridIdx + 1) * decCONLen + decCONidx] += dVectorEx[idx * T_power(DBN_N) * decExLen + decgridIdx * decExLen + decCONidx + i] * sdecMaxH[i];
	}
}

__global__ void decUpSam(double* dVectorCON,double* dVectorUpSam,int decCONLen,int decUpSamLen,int DBN_N,int decUpidx)
{
	int iUpdx = blockIdx.x * blockDim.x + threadIdx.x;
	dVectorUpSam[decUpSamLen * decUpidx + iUpdx] = dVectorCON[decCONLen * decUpidx + 2 * iUpdx + 1];
}

__global__ void decTransfromUpSam(double* dVectorCON,double* dVectorUpSam,int decCONLen,int decUpSamLen,int DBN_N)
{
	int decUpidx = threadIdx.x;
	int gridUpsamIdx  = 0;
	int blockUpsamIdx = 0;

	if(decUpSamLen >= 1000)
	{
		gridUpsamIdx  = decUpSamLen / 1000 + 1;
		blockUpsamIdx = 1000;
	}else{
		gridUpsamIdx  = 1;
		blockUpsamIdx = decUpSamLen;
	}
	decUpSam<<<gridUpsamIdx,blockUpsamIdx>>>(dVectorCON,dVectorUpSam,decCONLen,decUpSamLen,DBN_N,decUpidx);
	__syncthreads();
}

