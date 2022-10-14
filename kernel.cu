#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include <cuda.h>
#include <stdio.h>
#include <iostream>

__global__ void kernelVerificador(int n, int* array_rand, int* array_result) {
    int i = threadIdx.x;
    while (i < n) {
        array_result[i] = array_rand[i] % 2;
        i += blockDim.x;
    }
}

int main(){
    int* arrRand, * arrResult;
    int* d_arrRand, * d_arrResult; 
    
    int n = 10;
    
    int tamanho = n * sizeof(int); 

    arrRand = (int*)malloc(tamanho);
    arrResult = (int*)malloc(tamanho);

    cudaMalloc((void**)&d_arrRand, tamanho);
    cudaMalloc((void**)&d_arrResult, tamanho);

    int maior = 9;
    int menor = 1;

    for (int i = 0; i < n; i++) {
        arrRand[i] = rand() % maior + menor;
    }

    cudaMemcpy(d_arrRand, arrRand, tamanho, cudaMemcpyHostToDevice);

    kernelVerificador << <1, 10 >> > (n, d_arrRand, d_arrResult);

    cudaMemcpy(arrResult, d_arrResult, tamanho, cudaMemcpyDeviceToHost);

    printf("Resultado da verificacao: \n");
    for (int i = 0; i < n; i++) {
        printf("%d | %d \n", arrRand[i], arrResult[i]);
    }

    cudaFree(d_arrRand); 
    cudaFree(d_arrResult);
    
    return 0;
}