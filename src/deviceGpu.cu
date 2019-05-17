#include "head.h"


//接收的数据为32*7681,32行互不相干。开32个线程来处理这个矩阵。d_data是数据row是行，line是列，DBN_N是分解层数
__global__ void GPU0(double* d_data, int row, int line,int dbn_n)
{
	printf("%d",BOOST_VERSION);


}

__global__ void GPU1(double* d_data, int row, int line,int dbn_n)
{

}

__global__ void TransfromEx()
{



}

