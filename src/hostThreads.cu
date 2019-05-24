#include "head.h"

void threadHostToDevice0(std::vector<double>& Hvec, std::vector<double>& maxVector,int row, int line, int dbn,int dbn_n)//传引用
{
    std::cout << "CPU线程操作" << std::endl;
	cudaSetDevice(0);								//启动GPU0
	double* d_a;									//申明显存地址
	double* max_data;								//申请矩阵地址
	double* maxBuffer = new double[8 * dbn];
	double* buffer = new double[row * line]; 		//申请数组内存
	thrust::host_vector<int> h_line;
	thrust::device_vector<int> d_line;

	if(!Hvec.empty())									//把vector的数组转换到普通数组
	{
		memcpy(buffer,&Hvec[0],Hvec.size() * sizeof(double));
	}else
	{
		std::cout << "数据初始化失败"<< std::endl;
		exit(-1);
	}
    for(int i = 0; i < row; ++i)
    {
        for(int j = 0; j < line; ++j)
        {
            std::cout << buffer[i * line + j] << " ";
        }
        std::cout<< std::endl;
    }

	if(!maxVector.empty())									//把vector的数组转换到普通数组
	{
//		memcpy(maxBuffer,&maxVector[0],maxVector.size() * sizeof(double));
		//测试矩阵
		for(int i = 0; i < 4;i++)
		{
			for(int j = 0; j < 2 * dbn; ++j)
			{
				maxBuffer[i * 2 * dbn + j] = i * 2 * dbn + j + 1;
			}
		}
	}else
	{
		std::cout << "矩阵初始化失败"<< std::endl;
		exit(-1);
	}
    for(int i = 0; i < 4; ++i)
    {
        for(int j = 0; j < 2 * dbn; ++j)
        {
            std::cout << maxBuffer[i * 2 * dbn + j] << " ";
        }
        std::cout<< std::endl;
    }
//    cudaMalloc(&d_line,sizeof(int));
    cudaMalloc((void**)&max_data,sizeof(double) * 8 * dbn); //申请矩阵内存
	cudaMalloc((void**)&d_a,sizeof(double) * row * line);	//申请显存大小
	cudaMemcpy(d_a,buffer,sizeof(double) * row * line,cudaMemcpyHostToDevice);//内存数据导入到显存
	cudaMemcpy(max_data,maxBuffer,sizeof(double) * 8 * dbn,cudaMemcpyHostToDevice);

	GPU0<<<1,4>>>(d_a,max_data,row,line,dbn,dbn_n);					//启动核函数

	h_line = d_line;


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
