#ifndef __RWDATE_H__
#define __RWDATE_H__

class rwDate
{
    public:
        rwDate(){}
        virtual ~rwDate(){}
        virtual bool ReadDate() = 0;                     //读数据
        virtual bool Write_Date() = 0;                   //写数据   
        virtual void Print_rwDate() = 0;                 //打印数据 
};

#endif
