################################################################################
# 自动生成的文件。不要编辑！
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
CU_SRCS += \
../src/Matrix.cu \
../src/deviceGpu.cu \
../src/hostThreads.cu \
../src/main.cu \
../src/power.cu \
../src/rwDate_dec.cu 

OBJS += \
./src/Matrix.o \
./src/deviceGpu.o \
./src/hostThreads.o \
./src/main.o \
./src/power.o \
./src/rwDate_dec.o 

CU_DEPS += \
./src/Matrix.d \
./src/deviceGpu.d \
./src/hostThreads.d \
./src/main.d \
./src/power.d \
./src/rwDate_dec.d 


# Each subdirectory must supply rules for building sources it contributes
src/%.o: ../src/%.cu
	@echo '正在构建文件： $<'
	@echo '正在调用： NVCC Compiler'
	/usr/local/cuda-10.0/bin/nvcc -I"/home/lcx/code/cudaworkspace/cudaDBN/inc" -G -g -O0 -std=c++11 -gencode arch=compute_52,code=sm_52 -m64 -odir "src" -M -o "$(@:%.o=%.d)" "$<"
	/usr/local/cuda-10.0/bin/nvcc -I"/home/lcx/code/cudaworkspace/cudaDBN/inc" -G -g -O0 -std=c++11 --compile --relocatable-device-code=true -gencode arch=compute_52,code=compute_52 -gencode arch=compute_52,code=sm_52 -m64  -x cu -o  "$@" "$<"
	@echo '已结束构建： $<'
	@echo ' '


