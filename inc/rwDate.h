#ifndef __RWDATE_H__
#define __RWDATE_H__

#include "MAT.h"

class rwDate
{
    public:
        rwDate(){}
        virtual ~rwDate(){}
        virtual bool ReadDate() = 0;                     //读数据
        virtual bool Write_Date() = 0;                   //写数据   
        virtual void Print_rwDate() = 0;                 //打印数据 
        virtual pRWD getRaw_Data() = 0;                  //获得原始指针  


};


#endif