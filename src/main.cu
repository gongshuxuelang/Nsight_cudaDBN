#include "head.h"

//字母说明，dec为分解，signal为信号，Len为长度，filter为滤波器，
 //EX为延拓，CON为卷积，DSam为下采样，D为下，sam为采样。L为低频信号，H为高频信号
 //ref为重构，
__global__ void gpu()
{
    printf("hello gpu\n");
}

int main()
{
      
    //初始化小波分解所需要的系数，第一个参数为DBn小波，第二个系数是信号的行数，第三个系数是信号的列数
    DWT dwt(4,9,32,7681,0,32,40,32);//参数说明，，第一参数是dbn小波，第二个参数是分解n层，第三个参数是有
    Matrix max(4);
    max.Matrix_Init();
    max.creatMatrix();
    max.Print_matrix();
    cudaSetDevice(0);
    gpu<<<1,20>>>();
    cudaDeviceReset();
     std::cout << "读文件： " << std::endl;
    rwDate_dec rwdDec(dwt.getDWT_DBN(),dwt.getDWT_data_row(),dwt.getDWT_data_line(),1,1,dwt.getDWT_mode());
    //测试点
    std::cout << "打印数据" << std::endl;
    rwdDec.ReadDate();
    rwdDec.Print_rwDate();

    return 0;
}
