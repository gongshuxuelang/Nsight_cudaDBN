#include "head.h"

void threadHostToDevice0(std::vector<double>& Hvec, std::vector<double>& maxVector,int row, int line, int dbn,int dbn_n)//传引用
{
    std::cout << "CPU线程操作" << std::endl;
    int decDataLen = line;
    for(int i = 0; i < dbn_n; ++i)
    {
		int decUpSamLen = (decDataLen + 2* dbn -1) / 2;//上采样长度
		decDataLen = decUpSamLen;
    }
	cudaSetDevice(0);																//启动GPU0
    double* DeviceDecDataFinsh;														//分解结果的数据
    double* HostDecDataFinsh = new double[decDataLen * H_power(2,dbn_n) * row]();   //分解结果的数据
	double* d_a;																	//申明显存地址
	double* max_data;																//申请矩阵地址
	double* maxBuffer = new double[8 * dbn]();
	double* buffer = new double[row * line](); 								//申请数组内存

	if(!Hvec.empty())									//把vector的数组转换到普通数组
	{
		memcpy(buffer,&Hvec[0],Hvec.size() * sizeof(double));
	}else
	{
		std::cout << "数据初始化失败"<< std::endl;
		exit(-1);
	}
	std::ofstream WD("../测试数据/1.txt");
    for(int i = 0; i < row; ++i)
    {
        for(int j = 0; j < line; ++j)
        {
            WD << std::setprecision(16) << buffer[i * line + j]<< " ";
        }
        WD << std::endl;
    }

	if(!maxVector.empty())									//把vector的数组转换到普通数组
	{
		memcpy(maxBuffer,&maxVector[0],maxVector.size() * sizeof(double));
	}else
	{
		std::cout << "矩阵初始化失败"<< std::endl;
		exit(-1);
	}

    cudaMalloc((void**)&DeviceDecDataFinsh,sizeof(double) * decDataLen * H_power(2,dbn_n) * row); //分解结果数据
    cudaMalloc((void**)&max_data,sizeof(double) * 8 * dbn); //申请矩阵内存
	cudaMalloc((void**)&d_a,sizeof(double) * row * line);	//申请显存大小
	cudaMemcpy(d_a,buffer,sizeof(double) * row * line,cudaMemcpyHostToDevice);//内存数据导入到显存
	cudaMemcpy(max_data,maxBuffer,sizeof(double) * 8 * dbn,cudaMemcpyHostToDevice);

	GPU0<<<1,row>>>(DeviceDecDataFinsh,d_a,max_data,row,line,dbn,dbn_n,decDataLen);					//启动核函数

	cudaMemcpy(HostDecDataFinsh,DeviceDecDataFinsh,sizeof(double) * decDataLen * H_power(2,dbn_n) * row,cudaMemcpyDeviceToHost);

//	for(int i = 0; i < decDataLen * H_power(2,dbn_n); ++i)
//	{
//		printf("HostDecDataFinsh[%d] = %f\n",i,HostDecDataFinsh[i]);
//	}
	mkdir_file(1,1);
	for(int k = 0; k < row; ++k)
	{
	    std::ofstream WD(mkdir_txt(1,1,k + 1));
	    for(uint i = 0; i < H_power(2,dbn_n); ++i)
	    {
	        for(uint j = 0; j < decDataLen; ++j)
	        {
	            WD << std::setprecision(16) << HostDecDataFinsh[k * H_power(2,dbn_n) * decDataLen + decDataLen * i + j] << " ";
	        }
	        WD << std::endl;
	    }
	}

	cudaFree(d_a);									//释放内存
	delete[] buffer;
	delete[] maxBuffer;
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
