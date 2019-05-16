#include "head.h"


void threadHostToDevice0(const std::vector<double>& Hvec)//传引用
{
	cudaSetDevice(0);
	std::vector<double> A = Hvec;
	std::cout << "gpu" << std::endl;
    std::cout << "rdt.size() = " << A.size() << std::endl;
    for(std::vector<double>::size_type i = 0; i < 4; ++i)
    {
        for(std::vector<double>::size_type j = 0; j < 5; ++j)
        {
            std::cout << A[i * 5 + j] << " ";
        }
        std::cout<< std::endl;
    }

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
