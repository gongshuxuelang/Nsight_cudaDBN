#ifndef __DEVICEGPU_H__
#define __DEVICEGPU_H__

__device__ int  power(int base, int exponent);
__device__ void printData(double* buffer,int row,int line);
__device__ void printMax(double* max,int dbn);
__global__ void GPU0(double* d_a,double* max,int row,int line,int dbn,int dbn_n);
__global__ void GPU1(double* d_a,int row,int line,int dbn,int dbn_n);
__device__ void decTransfromEx(double* d_data,double* dVectorUpSam,int line,int idx,int dbn,int decExLen,double* dVectorEx,int DBN_N);
__global__ void dataCON(double* dVectorEx,double* sdecMaxL,double* sdecMaxH,int dbn,int decCONLen,double* dVectorCON,int idx,int decExLen,int DBN_N);
__device__ void decTransfromCON(double* dVectorEx,double* max,int line,int idx,int decCONLen,int dbn,double* dVectorCON,int decExLen,int DBN_N);
__global__ void decUpSam(double* dVectorCON,double*dVectorUpSam,int decCONLen,int decUpSamLen,int DBN_N);
__device__ void dec(double* d_a,double* max,int row,int line,int dbn,int idx,int dbn_n);
#endif
