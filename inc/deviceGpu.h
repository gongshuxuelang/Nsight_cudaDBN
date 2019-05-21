#ifndef __DEVICEGPU_H__
#define __DEVICEGPU_H__

__device__ void printData(double* buffer,int row,int line);
__device__ double* dataCON(double* dVectorEx,double* max);
__device__ void printMax(double* max,int dbn);
__global__ void GPU0(double* d_a,double* max,int row,int line,int dbn,int dbn_n);
__global__ void GPU1(double* d_a,int row,int line,int dbn,int dbn_n);
__device__ double* decTransfromEx(double* d_data,int line,int tid,int dbn,int decExLen);
__global__ void dataCON(double* dVectorEx,double* sdecMaxL,double* sdecMaxH,int dbn,int decCONLen,double* dVectorCON);
__device__ double* decTransfromCON(double* dVectorEx,double* max,int line,int tid,int decCONLen,int dbn);

#endif
