#include "head.h"

void mkdir_file(int file_m,int file_n)
{
	std::string DIR = "../TF_DATE/s";
    std::string FILE_NAME = boost::lexical_cast<std::string>(file_m);
    DIR = DIR + FILE_NAME;
    DIR = "mkdir -p " + DIR;
    system(DIR.c_str());//创建Sn总文件夹
    std::string  num= boost::lexical_cast<std::string>(file_n);
    DIR = DIR + "/s"+ FILE_NAME+ "_" + num;
    system(DIR.c_str());//创建Sn_n总文件夹
}
std::string mkdir_txt(int file_m,int file_n,int n)
{
	std::string DIR = "../TF_DATE/s";
    std::string FILE_NAME = boost::lexical_cast<std::string>(file_m);
    std::string  num= boost::lexical_cast<std::string>(file_n);
    std::string  NEMBER_NAME= boost::lexical_cast<std::string>(n);
    DIR = DIR + FILE_NAME;// /home/lcx/code/REF_DATE/S1
    DIR = DIR + "/s"+ FILE_NAME+ "_" + num + "/s" + FILE_NAME + "_" + num + "_" + NEMBER_NAME + ".txt"; //  /s1/s1_1/s1_1_n.txt
    return DIR;
}
int H_power(int base, int exponent)
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
