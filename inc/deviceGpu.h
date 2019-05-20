#ifndef __DEVICEGPU_H__
#define __DEVICEGPU_H__


__global__ void GPU0(double* d_a,int row,int line,int dbn,int dbn_n);
__global__ void GPU1(double* d_a,int row,int line,int dbn,int dbn_n);
__device__ void decTransfromEx(double* d_data,int line,int tid,int dbn);

#endif
