# Please add right gencode for older CUDA/GPU: -gencode arch=compute_35,code=sm_35 -gencode arch=compute_52,code=sm_52 -gencode arch=compute_60,code=sm_60

bitcracker_cuda:
	nvcc -U_ISOC23_SOURCE -U_ISOC2Y_SOURCE -U_GNU_SOURCE -gencode arch=compute_89,code=sm_89 -gencode arch=compute_120,code=sm_120 -Xptxas -v -o bitcracker_cuda main.cu cuda_attack.cu utils.cu w_blocks.cu

clean:
	rm -rf *.o
	rm -rf bitcracker_cuda
	rm -rf ../build/bitcracker_cuda
