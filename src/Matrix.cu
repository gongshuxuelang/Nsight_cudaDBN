#include "head.h"

bool Matrix::matrix()
{
	if (0 > DBN || DBN > 10)
	{
		std::cout << "你输入的维度有误！" << std::endl;	
		exit(-1);
	}

    switch (DBN)
	{
        case 1:
            for (int i = 0; i < DBN_N; ++i)
            {
            	dBmaxtrix.push_back(db1_Lo_D[DBN_N - 1 - i]);
            }
            for (int i = 0; i < DBN_N; ++i)
            {
            	dBmaxtrix.push_back(db1_Hi_D[DBN_N - 1 - i]);
            }
            for (int i = 0; i < DBN_N; ++i)
            {
            	dBmaxtrix.push_back(db1_Lo_R[DBN_N - 1 - i]);
            }
            for (int i = 0; i < DBN_N; ++i)
            {
            	dBmaxtrix.push_back(db1_Hi_R[DBN_N - 1 - i]);
            }
            break;
        case 2:
            for (int i = 0; i < DBN_N; ++i)
            {
            	dBmaxtrix.push_back(db2_Lo_D[DBN_N - 1 - i]);
            }
            for (int i = 0; i < DBN_N; ++i)
            {
            	dBmaxtrix.push_back(db2_Hi_D[DBN_N - 1 - i]);
            }
            for (int i = 0; i < DBN_N; ++i)
            {
            	dBmaxtrix.push_back(db2_Lo_R[DBN_N - 1 - i]);
            }
            for (int i = 0; i < DBN_N; ++i)
            {
            	dBmaxtrix.push_back(db2_Hi_R[DBN_N - 1 - i]);
            }
            break;
        case 3:
            for (int i = 0; i < DBN_N; ++i)
            {
            	dBmaxtrix.push_back(db3_Lo_D[DBN_N - 1 - i]);
            }
            for (int i = 0; i < DBN_N; ++i)
            {
            	dBmaxtrix.push_back(db3_Hi_D[DBN_N - 1 - i]);
            }
            for (int i = 0; i < DBN_N; ++i)
            {
            	dBmaxtrix.push_back(db3_Lo_R[DBN_N - 1 - i]);
            }
            for (int i = 0; i < DBN_N; ++i)
            {
            	dBmaxtrix.push_back(db3_Hi_R[DBN_N - 1 - i]);
            }
            break;
        case 4:
            for (int i = 0; i < DBN_N; ++i)
            {
            	dBmaxtrix.push_back(db4_Lo_D[DBN_N - 1 - i]);
            }
            for (int i = 0; i < DBN_N; ++i)
            {
            	dBmaxtrix.push_back(db4_Hi_D[DBN_N - 1 - i]);
            }
            for (int i = 0; i < DBN_N; ++i)
            {
            	dBmaxtrix.push_back(db4_Lo_R[DBN_N - 1 - i]);
            }
            for (int i = 0; i < DBN_N; ++i)
            {
            	dBmaxtrix.push_back(db4_Hi_R[DBN_N - 1 - i]);
            }
            break;
        case 5:
            for (int i = 0; i < DBN_N; ++i)
            {
            	dBmaxtrix.push_back(db5_Lo_D[DBN_N - 1 - i]);
            }
            for (int i = 0; i < DBN_N; ++i)
            {
            	dBmaxtrix.push_back(db5_Hi_D[DBN_N - 1 - i]);
            }
            for (int i = 0; i < DBN_N; ++i)
            {
            	dBmaxtrix.push_back(db5_Lo_R[DBN_N - 1 - i]);
            }
            for (int i = 0; i < DBN_N; ++i)
            {
            	dBmaxtrix.push_back(db5_Hi_R[DBN_N - 1 - i]);
            }
            break;
        case 6:
            for (int i = 0; i < DBN_N; ++i)
            {
            	dBmaxtrix.push_back(db6_Lo_D[DBN_N - 1 - i]);
            }
            for (int i = 0; i < DBN_N; ++i)
            {
            	dBmaxtrix.push_back(db6_Hi_D[DBN_N - 1 - i]);
            }
            for (int i = 0; i < DBN_N; ++i)
            {
            	dBmaxtrix.push_back(db6_Lo_R[DBN_N - 1 - i]);
            }
            for (int i = 0; i < DBN_N; ++i)
            {
            	dBmaxtrix.push_back(db6_Hi_R[DBN_N - 1 - i]);
            }
            break;
        case 7:
            for (int i = 0; i < DBN_N; ++i)
            {
            	dBmaxtrix.push_back(db7_Lo_D[DBN_N - 1 - i]);
            }
            for (int i = 0; i < DBN_N; ++i)
            {
            	dBmaxtrix.push_back(db7_Hi_D[DBN_N - 1 - i]);
            }
            for (int i = 0; i < DBN_N; ++i)
            {
            	dBmaxtrix.push_back(db7_Lo_R[DBN_N - 1 - i]);
            }
            for (int i = 0; i < DBN_N; ++i)
            {
            	dBmaxtrix.push_back(db7_Hi_R[DBN_N - 1 - i]);
            }
            break;
        case 8:
            for (int i = 0; i < DBN_N; ++i)
            {
            	dBmaxtrix.push_back(db8_Lo_D[DBN_N - 1 - i]);
            }
            for (int i = 0; i < DBN_N; ++i)
            {
            	dBmaxtrix.push_back(db8_Hi_D[DBN_N - 1 - i]);
            }
            for (int i = 0; i < DBN_N; ++i)
            {
            	dBmaxtrix.push_back(db8_Lo_R[DBN_N - 1 - i]);
            }
            for (int i = 0; i < DBN_N; ++i)
            {
            	dBmaxtrix.push_back(db8_Hi_R[DBN_N - 1 - i]);
            }
            break;
        case 9:
            for (int i = 0; i < DBN_N; ++i)
            {
            	dBmaxtrix.push_back(db9_Lo_D[DBN_N - 1 - i]);
            }
            for (int i = 0; i < DBN_N; ++i)
            {
            	dBmaxtrix.push_back(db9_Hi_D[DBN_N - 1 - i]);
            }
            for (int i = 0; i < DBN_N; ++i)
            {
            	dBmaxtrix.push_back(db9_Lo_R[DBN_N - 1 - i]);
            }
            for (int i = 0; i < DBN_N; ++i)
            {
            	dBmaxtrix.push_back(db9_Hi_R[DBN_N - 1 - i]);
            }
            break;
        case 10:
            for (int i = 0; i < DBN_N; ++i)
            {
            	dBmaxtrix.push_back(db10_Lo_D[DBN_N - 1 - i]);
            }
            for (int i = 0; i < DBN_N; ++i)
            {
            	dBmaxtrix.push_back(db10_Hi_D[DBN_N - 1 - i]);
            }
            for (int i = 0; i < DBN_N; ++i)
            {
            	dBmaxtrix.push_back(db10_Lo_R[DBN_N - 1 - i]);
            }
            for (int i = 0; i < DBN_N; ++i)
            {
            	dBmaxtrix.push_back(db10_Hi_R[DBN_N - 1 - i]);
            }
		    break;
	}
    return true;
}

 void Matrix::Print_matrix()
 {
     for(int i = 0; i < 4; ++i)
     {
         for(int j = 0; j < DBN_N; ++j)
         {
             std::cout << dBmaxtrix[i * DBN_N + j] << "    ";
         }
         std::cout << std::endl;
     }
 }
