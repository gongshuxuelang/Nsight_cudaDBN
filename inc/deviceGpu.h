#ifndef __DEVICEGPU_H__
#define __DEVICEGPU_H__


__global__ void GPU0(double* d_data, int row, int line,int dbn_n);
__global__ void GPU1(double* d_data, int row, int line,int dbn_n);
__global__ void TransfromEx();
#endif
