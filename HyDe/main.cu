#include <iostream>
#include <iomanip>
#include "core/common/Constants.cuh"
#include "core/optimizer/LBFGS.cuh"
#include "core/optimizer/GradientDescent.cuh"
#include "core/optimizer/DifferentialEvolution.cuh"
#include <curand.h>
#include <curand_kernel.h>
#include <random>
#include <fstream>

void generateInitialPopulation(double *x, unsigned xSize) {
    std::uniform_real_distribution<double> unif(-10000, 10000);
    std::default_random_engine re(time(NULL));
    for (int i = 0; i < xSize; i++) {
        x[i] = unif(re);
    }
}
void readPopulation(double *x, unsigned xSize, std::string filename) {
    std::fstream input;
    input.open(filename.c_str());
    if (input.is_open()) {
        unsigned cData = 0;
        while (input >> x[cData]) {
            cData++;
        }
        std::cout << "read: " << cData << " expected: " << xSize
                  << std::endl;
        assert(cData == xSize);
    } else {
        std::cerr << "err: could not open " << filename << std::endl;
        exit(1);
    }
}

#if defined(PROBLEM_SNLP) || defined(PROBLEM_SNLP3D)

void readSNLPProblem(double *data, std::string filename) {
    std::fstream input;
    input.open(filename.c_str());
    if (input.is_open()) {
        unsigned cData = 0;
        while (input >> data[cData]) {
            cData++;
        }
        std::cout << "read: " << cData << " expected: " << RESIDUAL_CONSTANTS_COUNT_1 * RESIDUAL_CONSTANTS_DIM_1
                  << std::endl;
        assert(cData == RESIDUAL_CONSTANTS_COUNT_1 * RESIDUAL_CONSTANTS_DIM_1);
    } else {
        std::cerr << "err: could not open " << filename << std::endl;
        exit(1);
    }
}

void readSNLPAnchors(double *data, std::string filename) {
    std::fstream input;
    input.open(filename.c_str());
    if (input.is_open()) {
        unsigned cData = 0;
        while (input >> data[cData]) {
            cData++;
        }
        std::cout << "read: " << cData << " expected: " << RESIDUAL_CONSTANTS_COUNT_2 * RESIDUAL_CONSTANTS_DIM_2
                  << std::endl;
        assert(cData == RESIDUAL_CONSTANTS_COUNT_2 * RESIDUAL_CONSTANTS_DIM_2);
    } else {
        std::cerr << "err: could not open " << filename << std::endl;
        exit(1);
    }
}

#endif
void persistBestSNLPModel(double *x, int modelSize, std::string filename) {
    std::ofstream output;
    output.open(filename.c_str());
    if (output.is_open()) {
        for (int i=0;i<modelSize;i++){
            output<<std::setprecision(17)<<x[i]<<std::endl;
        }
        output.close();
    } else {
        std::cout << "err: could not open " << filename << std::endl;
        exit(1);
    }
}

void testH_DE_SNLP() {

    curandState *dev_curandState;
    cudaEvent_t start, stop, startCopy, stopCopy;
    cudaEventCreate(&start);
    cudaEventCreate(&stop);
    cudaEventCreate(&startCopy);
    cudaEventCreate(&stopCopy);


    const unsigned xSize = X_DIM * POPULATION_SIZE;

#if defined(PROBLEM_SNLP) || defined(PROBLEM_SNLP3D)
    const unsigned dataSize = RESIDUAL_CONSTANTS_DIM_1 * RESIDUAL_CONSTANTS_COUNT_1 +
                              RESIDUAL_CONSTANTS_DIM_2 * RESIDUAL_CONSTANTS_COUNT_2;
#else
    const unsigned dataSize = RESIDUAL_CONSTANTS_DIM_1 * RESIDUAL_CONSTANTS_COUNT_1;
#endif
    OPTIMIZER::GlobalData *dev_globalContext;
    cudaMalloc(&dev_globalContext, sizeof(OPTIMIZER::GlobalData)*POPULATION_SIZE);
    printf("Allocating %lu global memory\n",sizeof(OPTIMIZER::GlobalData)*POPULATION_SIZE);

    double *dev_x;
    double *dev_xDE;
    double *dev_x1;
    double *dev_x2;
    double *dev_data;
    double *dev_F;
    double *dev_FDE;
    double *dev_F1;
    double *dev_F2;

    // ALLOCATE DEVICE MEMORY
    cudaMalloc((void **) &dev_x, xSize * sizeof(double));
    cudaMalloc((void **) &dev_xDE, xSize * sizeof(double));
    cudaMalloc((void **) &dev_data, dataSize * sizeof(double));
    cudaMalloc((void **) &dev_F, POPULATION_SIZE * sizeof(double));
    cudaMalloc((void **) &dev_FDE, POPULATION_SIZE * sizeof(double));
    cudaMalloc(&dev_curandState, THREADS_PER_GRID * sizeof(curandState));

    // GENERATE PROBLEM
    double x[xSize] = {};
    double solution[xSize] = {};
    double finalFs[POPULATION_SIZE] = {};
    double data[dataSize] = {};


#if defined(PROBLEM_SNLP) || defined(PROBLEM_SNLP3D)
    readSNLPProblem(data, PROBLEM_PATH);

    readSNLPAnchors(data + RESIDUAL_CONSTANTS_DIM_1 * RESIDUAL_CONSTANTS_COUNT_1,
                    PROBLEM_ANCHOR_PATH);
//    generateInitialPopulation(x, xSize);
    readPopulation(x, xSize,PROBLEM_INPUT_POPULATION_PATH);
#endif
    // COPY TO DEVICE
    cudaEventRecord(startCopy);
    cudaMemcpy(dev_x, &x, xSize * sizeof(double), cudaMemcpyHostToDevice);
    cudaMemcpy(dev_data, &data, dataSize * sizeof(double), cudaMemcpyHostToDevice);
    cudaEventRecord(stopCopy);
    cudaEventRecord(start);

    // EXECUTE KERNEL
    // initialize curand
    setupCurand<<<POPULATION_SIZE, THREADS_PER_BLOCK>>>(dev_curandState);
    dev_x1 = dev_x;
    dev_x2 = dev_xDE;
    dev_F1 = dev_F;
    dev_F2 = dev_FDE;

#if  defined(OPTIMIZER_MIN_INIT_DE) || defined(OPTIMIZER_MIN_DE)
    OPTIMIZER::optimize<<<POPULATION_SIZE, THREADS_PER_BLOCK>>>(dev_x1, dev_data,dev_F1, dev_globalContext);
#endif

#ifdef OPTIMIZER_SIMPLE_DE
    OPTIMIZER::evaluateF<<<POPULATION_SIZE, THREADS_PER_BLOCK>>>(dev_x1, dev_data, dev_F1, dev_globalContext);
#endif

    for (unsigned i = 0; i < DE_ITERATION_COUNT; i++) {
        differentialEvolutionStep<<<POPULATION_SIZE, THREADS_PER_BLOCK>>>(dev_x1, dev_x2, dev_curandState);
        //dev_x2 is the differential model
#if  defined(OPTIMIZER_MIN_INIT_DE) || defined(OPTIMIZER_SIMPLE_DE)
        OPTIMIZER::evaluateF<<<POPULATION_SIZE, THREADS_PER_BLOCK>>>(dev_x2, dev_data, dev_F2, dev_globalContext);
#elif defined(OPTIMIZER_MIN_DE)
        OPTIMIZER::optimize<<<POPULATION_SIZE, THREADS_PER_BLOCK>>>(dev_x2, dev_data, dev_F2, dev_globalContext);
#else
        std::cerr<<"Incorrect optimizer configuration"<<std::endl;
        exit(1);
#endif
        //evaluated differential model into F2
        selectBestModels<<<POPULATION_SIZE, THREADS_PER_BLOCK>>>(dev_x1, dev_x2, dev_F1, dev_F2, i);
        //select the best models from current and differential models
        std::swap(dev_x1, dev_x2);
        std::swap(dev_F1, dev_F2);
        // dev_x1 contains the next models, dev_F1 contains the associated costs
    }
#if defined(OPTIMIZER_SIMPLE_DE) || defined(OPTIMIZER_MIN_INIT_DE) || defined(OPTIMIZER_MIN_DE)
        printf("\nthreads:%d\n", THREADS_PER_BLOCK);
        printf("\niterations:%d\n", DE_ITERATION_COUNT);
        printf("\nfevaluations: %d\n", DE_ITERATION_COUNT);
#endif

    printBestF<<<1,1>>>(dev_F1,POPULATION_SIZE);

    cudaMemcpy(&finalFs, dev_F1, POPULATION_SIZE * sizeof(double), cudaMemcpyDeviceToHost);
    int min=0;
    for(int ff=1;ff<POPULATION_SIZE;ff++){
        if(finalFs[min]>finalFs[ff]){
            min=ff;
        }
    }
    cudaMemcpy(&solution, dev_x1, xSize * sizeof(double), cudaMemcpyDeviceToHost);
    printf("\nsolf: %f and solution: ",finalFs[min]);
    for(int ff=X_DIM*min;ff<X_DIM*(min+1)-1;ff++) {
        printf("%f,",solution[ff]);
    }
    printf("%f\n",solution[X_DIM*(min+1)-1]);
    persistBestSNLPModel(&solution[X_DIM*min],X_DIM, std::string("finalModel")+std::string(OPTIMIZER::name)+std::string(".csv"));

    cudaEventRecord(stop);
    cudaEventSynchronize(stop);

    float memcpyMilli = 0;
    cudaEventElapsedTime(&memcpyMilli, startCopy, stopCopy);
    float kernelMilli = 0;
    cudaEventElapsedTime(&kernelMilli, start, stop);
//    printf("Memcpy,kernel elapsed time (ms): %f,%f\n", memcpyMilli, kernelMilli);
    printf("\ntime ms : %f\n", kernelMilli);


    cudaFree(dev_x);
    cudaFree(dev_xDE);
    cudaFree(dev_data);
    cudaFree(dev_F);
    cudaFree(dev_FDE);

#ifdef GLOBAL_SHARED_MEM
    cudaFree(dev_globalContext);
#endif
}

int main() {
    testH_DE_SNLP();
    return 0;
}