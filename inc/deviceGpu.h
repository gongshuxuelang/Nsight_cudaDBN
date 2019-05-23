#ifndef __DEVICEGPU_H__
#define __DEVICEGPU_H__

__device__ void printData(double* buffer,int row,int line);
__device__ void printMax(double* max,int dbn);
__global__ void GPU0(double* d_a,double* max,int row,int line,int dbn,int dbn_n);
__global__ void GPU1(double* d_a,int row,int line,int dbn,int dbn_n);
__device__ void decTransfromEx(double* d_data,int line,int idx,int dbn,int decExLen,double* dVectorEx);
__global__ void dataCON(double* dVectorEx,double* sdecMaxL,double* sdecMaxH,int dbn,int decCONLen,double* dVectorCONL,double* dVectorCONH,int idx,int decExLen);
__device__ void decTransfromCON(double* dVectorEx,double* max,int line,int idx,int decCONLen,int dbn,double* dVectorCONL,double* dVectorCONH,int decExLen);
__global__ void decUpSam(double* dVectorCONL,double* dVectorCONH,double*dVectorUpSamH,double*dVectorUpSamL);
__device__ void dec(double* d_a,double* max,int row,int line,int dbn,int idx);
#endif
