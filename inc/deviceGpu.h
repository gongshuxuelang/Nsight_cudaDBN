#ifndef __DEVICEGPU_H__
#define __DEVICEGPU_H__

__global__ void gpu(float *devPtr,int height,int width,int pitch);
__global__ void GPGPU(double* d_data,int height,int width,size_t pitc);

#endif
