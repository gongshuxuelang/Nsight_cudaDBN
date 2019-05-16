#ifndef __RWDATE_DEC_H__
#define __RWDATE_DEC_H__

class rwDate_dec:public rwDate 
{
    public:
		rwDate_dec(int dbn_n,int row,int line,int m,int n, int mo);
		~rwDate_dec();
        virtual bool ReadDate();                     //读数据
        virtual bool Write_Date();                   //写数据   
        virtual void Print_rwDate();                 //打印数据 
        std::vector<double> getRaw_Data(){return rData;}//返回数组

    private:
        int file_m;                          //读文件夹号
        int file_n;                          //读文件夹中的txt
        int mode;                            //读取的模式
        int DBN_N;                           //DBn小波系数
        int data_row;                        //信号行
        int data_line;                       //信号列
        std::vector<double> rData;			 //读数据
};



#endif
