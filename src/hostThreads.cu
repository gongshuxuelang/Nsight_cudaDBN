#include "head.h"


void threadHostToDevice0(const std::vector<double>& Hvec,const int& row,const int& line,const int& dbn_n)//传引用
{
	cudaSetDevice(0);								//启动GPU0
	double *d_a;									//申明显存地址
	double *buffer = new double[row*line];			//申请数组内存
	const std::vector<double> A = Hvec;
	if(!A.empty())									//把vector的数组转换到普通数组
	{
		memcpy(buffer,&A[0],A.size() * sizeof(double));
	}
	cudaMalloc((void**)&d_a,sizeof(double)*row*line);	//申请显存大小
	cudaMemcpy(d_a,buffer,sizeof(double)*row*line,cudaMemcpyHostToDevice);//内存数据导入到显存

	GPU0<<<1,1>>>(d_a,row,line,dbn_n);					//启动核函数

	cudaFree(d_a);									//释放内存

	cudaDeviceReset();								//重置GPU0


}

void threadHostToDevice1()
{

}

void threadDeviceToHost0()
{

}

void threadDeviceToHost1()
{

}
