#ifndef __MATRIX_H__
#define __MATRIX_H__

class Matrix
{
    public:
        Matrix(int dbn):DBN(dbn){DBN_N = 2 * DBN;}
        ~Matrix(){}

        bool matrix();                     		//创建系数矩阵
        void Print_matrix();                    //打印矩阵

        std::vector<double> getMatrix()	//获得系数矩阵
        {
        	return dBmaxtrix;
        }
    private:
        int DBN;
        int DBN_N;                              //DBN小波
        std::vector<double> dBmaxtrix;			//系数矩阵
};

#endif
