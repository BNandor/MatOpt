
<!-- <script type="text/javascript" async
  src="https://cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.7/MathJax.js?config=TeX-MML-AM_CHTML">
</script> -->


![logo](img/Logo.png)
<br>

##  NMHH: Nested Markov Chain Hyper Heuristic

A hyperheuristic framework for the continuous domain.

###  Requirements:


Install required packages via

```
pip3 install -r requirements.txt 
```
- Python >= 3.8 is required

- A CUDA enabled GPU supporting at least ```sm_arch=60``` and the CUDA compiler (`nvcc >= 11.4`) from the [cuda toolkit](https://docs.nvidia.com/cuda/cuda-installation-guide-linux/index.html) is required.

- A CPU supporting the x86 instruction set is required

## Benchmarks:

The method was compared with [CUSTOMHyS](https://github.com/jcrvz/customhys) and six metaheuristics from [mealpy](https://mealpy.readthedocs.io/en/latest/) on six benchmark problems: 


- Qing $f(x)=\sum \limits_{i=1}^{d}(x^2-1)^2$
- Rastrigin $f(x)=10d+\sum \limits_{i=1}^{d}[x_i^2-10cos(2\pi x_i)]$
- Rosenbrock $f(x)=\sum \limits_{i=1}^{d-1}[100(x_{i+1}-x_i^2)^2+(x_i-1)^2]$
- Schwefel 2.23 $f(x)=\sum \limits_{i=1}^{d}x_i^{10}$
- Styblinski Tang $f(x)=\frac{1}{2}\sum \limits_{i=1}^{d}x_{i}^4 -16x_{i}^2+5x_{i}$
- Trid $f(x)=\sum \limits_{i=1}^{d}(x_{i}-1)^2+\sum \limits_{i=2}^{d}(x_i x_{i-1})$




### Optimize benchmark functions with:

Start NMHH benchmarks

```shell
./NMHHExperiment.sh
```
- the NMHH experiment results will be placed in the [NMHH logs](hhanalysis/logs/SA-NMHH/newExperiment/) 

#### Results:

 - [NMHH results](hhanalysis/logs/SA-NMHH/GA_DE_GD_LBFGS/) 
 - [CUSTOMHyS results](hhanalysis/logs/CustomHYSPerf/)
 - [mealpy results](hhanalysis/logs/mealpyPerf)

#### Summary:
The Median + IQR values of the performance samples are compared. The best results are highlighted in bold.
| problem | dimension | NMHH                 | CUSTOMHyS            | SMA                 | AEO                 | BRO                 | ArchOA      | PSO         | CRO         |
|---------|-----------|----------------------|----------------------|---------------------|---------------------|---------------------|-------------|-------------|-------------|
 | Qing           | 5   | **1.3805e-30**    | 6.9269e-27           | 7.7565e-02          | 6.6547e-01          | 1.2591e+01          | 1.9785e+01  | 1.0583e+03  | 1.0405e+05  |
| Qing           | 50  | **3.8581e-03**  | 3.5255e+05           | 1.4020e+04          | 2.0684e+04          | 2.5249e+04          | 3.8629e+04  | 2.8970e+10  | 1.2337e+11  |
| Qing           | 100 | **2.1094e-05**  | 1.0445e+08           | 1.6719e+05          | 1.8468e+05          | 2.0831e+05          | 3.0352e+05  | 7.2997e+10  | 4.4440e+11  |
| Qing           | 500 | **5.5487e-01**  | 2.7925e+08           | 3.2776e+07          | 2.5715e+07          | 2.5508e+07          | 3.2362e+07  | 5.1137e+12  | 4.2136e+12  |
| Rastrigin      | 5   | 6.8168e-03           | 2.0791e+00           | **0.0000e+00** | **0.0000e+00** | **0.0000e+00** | 5.3705e+00  | 2.2249e+01  | 1.1563e+01  |
| Rastrigin      | 50  | 8.1054e+01           | 1.2439e+02           | **0.0000e+00** | **0.0000e+00** | **0.0000e+00** | 2.1727e+02  | 6.1434e+02  | 4.1291e+02  |
| Rastrigin      | 100 | 2.5358e+02           | 3.3217e+02           | **0.0000e+00** | **0.0000e+00** | **0.0000e+00** | 2.7143e+00  | 1.2222e+03  | 1.0735e+03  |
| Rastrigin      | 500 | 2.1600e+03           | 5.4562e+03           | **0.0000e+00** | **0.0000e+00** | **0.0000e+00** | 1.1132e+00  | 8.6621e+03  | 7.4188e+03  |
| Rosenbrock     | 5   | **1.8418e+00**  | 3.9387e+00           | 3.3818e+00          | 3.8733e+00          | 4.0155e+00          | 4.1998e+00  | 2.9554e+02  | 1.0212e+03  |
| Rosenbrock     | 50  | **4.5794e+01**  | 4.9130e+03           | 4.8965e+01          | 4.8951e+01          | 4.8649e+01          | 4.9374e+01  | 4.1971e+07  | 1.4990e+08  |
| Rosenbrock     | 100 | **9.5543e+01**  | 1.5961e+05           | 9.8964e+01          | 9.8954e+01          | 9.8281e+01          | 9.9508e+01  | 9.5397e+07  | 5.6190e+08  |
| Rosenbrock     | 500 | **4.9184e+02**  | 1.4714e+07           | 4.9896e+02          | 4.9896e+02          | 4.9535e+02          | 4.9962e+02  | 6.6368e+09  | 5.4849e+09  |
| Schwefel223    | 5   | 9.5097e-17           | 4.5248e-92           | **0.0000e+00** | **0.0000e+00** | **0.0000e+00** | 3.0466e-26  | 5.7078e-09  | 4.3097e-04  |
| Schwefel223    | 50  | 8.0301e-05           | 4.5912e-04           | **0.0000e+00** | **0.0000e+00** | **0.0000e+00** | 1.8737e-18  | 1.6220e+09  | 1.2841e+09  |
| Schwefel223    | 100 | 7.7415e-05           | 1.6397e+02           | **0.0000e+00** | **0.0000e+00** | **0.0000e+00** | 5.6318e-18  | 4.4789e+09  | 8.9519e+09  |
| Schwefel223    | 500 | 3.4822e-04           | 9.4162e+08           | **0.0000e+00** | **0.0000e+00** | **0.0000e+00** | 3.9716e-18  | 2.8568e+11  | 2.0302e+11  |
| Styblinskitang | 5   | **-1.9583e+02** | **-1.9583e+02** | -1.9569e+02         | -1.8076e+02         | -1.6963e+02         | -1.7348e+02 | -1.7592e+02 | -1.8158e+02 |
| Styblinskitang | 50  | **-1.9018e+03** | -1.6965e+03          | -1.3724e+03         | -1.0942e+03         | -1.5435e+03         | -1.0184e+03 | -8.9307e+02 | -1.2202e+03 |
| Styblinskitang | 100 | **-3.4077e+03** | -2.8352e+03          | -2.3018e+03         | -2.0178e+03         | -3.0103e+03         | -1.8841e+03 | -1.5568e+03 | -2.0718e+03 |
| Styblinskitang | 500 | **-1.6526e+04** | -8.4084e+03          | -7.9417e+03         | -9.0582e+03         | -1.4859e+04         | -8.7477e+03 | -4.1091e+03 | -6.3357e+03 |
| Trid           | 5   | **-3.0000e+01** | **-3.0000e+01** | -2.9890e+01         | -2.9916e+01         | -2.4194e+01         | -2.8117e+01 | -2.9704e+01 | -2.1214e+01 |
| Trid           | 50  | **-8.1106e+03** | 2.5636e+05           | 2.6391e+01          | 4.4701e+01          | -1.0558e+02         | 8.5830e+01  | 1.6161e+07  | 2.8479e+07  |
| Trid           | 100 | **-4.1094e+04** | 2.9695e+07           | 7.9457e+01          | 9.5869e+01          | -1.6720e+02         | 7.4611e+02  | 5.6313e+08  | 1.3875e+09  |
| Trid           | 500 | **-2.1395e+05** | 6.2820e+11           | 4.8293e+02          | 4.9688e+02          | -8.6542e+02         | 6.5888e+05  | 9.0493e+12  | 7.4315e+12  |
