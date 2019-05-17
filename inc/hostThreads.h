#ifndef __HOSTTHREADS_H__
#define __HOSTTHREADS_H__

void threadHostToDevice0(const std::vector<double>& Hvec,const int& row,const int& line,const int& dbn_n);
void threadHostToDevice1();
void threadDeviceToHost0();
void threadDeviceToHost1();




#endif
