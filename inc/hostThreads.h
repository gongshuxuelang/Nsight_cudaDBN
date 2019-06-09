#ifndef __HOSTTHREADS_H__
#define __HOSTTHREADS_H__


void threadHostToDevice0(std::vector<double>& Hvec, std::vector<double>& maxVector,int row, int line, int dbn,int dbn_n);
void threadHostToDevice1();
void threadDeviceToHost0();
void threadDeviceToHost1();




#endif
