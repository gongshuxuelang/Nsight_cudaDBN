#include "head.h"
//字母说明，dec为分解，signal为信号，Len为长度，filter为滤波器，
//EX为延拓，CON为卷积，DSam为下采样，D为下，sam为采样。L为低频信号，H为高频信号
//ref为重构，
void funic(std::vector<double>& q)
{
	std::vector<double> a = q;
}
int main()
{
	//初始化小波分解所需要的系数，第一个参数为DBn小波，第二个系数是信号的行数，第三个系数是信号的列数
    DWT dwt(4, 3, 4, 5, 0, 1, 1, 32); //参数说明，，第一参数是dbn小波，第二个参数是分解n层，第三个参数是有
    std::vector<double> sp;
    std::cout << "测试点" << std::endl;
    Matrix max(dwt.getDWT_DBN());
    max.matrix();					//创建系数矩阵
    std::cout << "打印系数矩阵" << std::endl;
//    max.Print_matrix();
    sp = max.getMatrix();

    std::cout << "系数矩阵返回值" << std::endl;
    for(int i = 0; i < 4; ++i)
    {
    	for(int j = 0; j < 2 * dwt.getDWT_DBN();++j)
    	{
    		std::cout << "sp["<< i << "][" << j << "] = " << sp[i * 2 * dwt.getDWT_DBN()  + j] <<"  ";
    	}
    	std::cout << std::endl;
    }

    //测试读文件
    std::vector<double> rdt;
    rwDate_dec rdc(dwt.getDWT_DBN(),dwt.getDWT_data_row(),dwt.getDWT_data_line(),dwt.getDWT_file_m(),dwt.getDWT_file_n(),dwt.getDWT_mode());
    rdc.ReadDate();
//    rdc.Print_rwDate();
    //测试返回值
    rdt = rdc.getRaw_Data();
    std::cout << "rdt.size() = " << rdt.size() << std::endl;
    for(std::vector<double>::size_type i = 0; i < dwt.getDWT_data_row(); ++i)
    {
        for(std::vector<double>::size_type j = 0; j < dwt.getDWT_data_line(); ++j)
        {
            std::cout << rdt[i * dwt.getDWT_data_line() + j] << " ";
        }
        std::cout<< std::endl;
    }

    funic(rdt);

    boost::thread t_HtoD0(threadHostToDevice0,boost::cref(rdt));
    t_HtoD0.join();


	return 0;
}
