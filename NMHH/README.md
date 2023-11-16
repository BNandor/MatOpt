
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


### Optimize benchmark functions with:

```shell
./startexp.sh
```
- the experiment results will be placed in the [logs](hhanalysis/logs/SA-NMHH/newExperiment/) 

## Benchmarks:

The method was compared with [CUSTOMHyS](https://github.com/jcrvz/customhys) and six metaheuristics from [mealpy](https://mealpy.readthedocs.io/en/latest/) on six benchmark problems: 


- Qing $f(x)=\sum \limits_{i=1}^{d}(x^2-1)^2$
- Rastrigin $f(x)=10d+\sum \limits_{i=1}^{d}[x_i^2-10cos(2\pi x_i)]$
- Rosenbrock $f(x)=\sum \limits_{i=1}^{d-1}[100(x_{i+1}-x_i^2)^2+(x_i-1)^2]$
- Schwefel 2.23 $f(x)=\sum \limits_{i=1}^{d}x_i^{10}$
- Styblinski Tang $f(x)=\frac{1}{2}\sum \limits_{i=1}^{d}x_{i}^4 -16x_{i}^2+5x_{i}$
- Trid $f(x)=\sum \limits_{i=1}^{d}(x_{i}-1)^2+\sum \limits_{i=2}^{d}(x_i x_{i-1})$



#### Results:

 - [NMHH results](hhanalysis/logs/SA-NMHH/GA_DE_GD_LBFGS/) 
 - [CUSTOMHyS results](hhanalysis/logs/CustomHYSPerf/)
 - [mealpy results](hhanalysis/logs/mealpyPerf)

#### Summary:
The Median + IQR values of the performance samples are compared. The best results are highlighted in bold.
 | Problem         | Dim.  | NMHH                   | CUSTOMHyS              | SMA                   | AEO                   | BRO                   | ArchOA        | PSO           | CRO           |
|-----------------|-------|------------------------|------------------------|-----------------------|-----------------------|-----------------------|---------------|---------------|---------------|
| Qing            | 5.0   | 8.461564e-21           | **7.415293e-29**  | 8.343894e-02          | 4.719472e-01          | 1.299651e+01          | 1.878762e+01  | 1.009920e+02  | 1.785472e+04  |
| Qing            | 50.0  | **1.525220e-08**  | 1.723341e+06           | 1.390247e+04          | 2.076895e+04          | 2.594540e+04          | 3.872205e+04  | 3.945304e+11  | 1.171615e+11  |
| Qing            | 100.0 | **5.474707e-03**  | 3.802512e+10           | 1.752953e+05          | 1.881607e+05          | 2.077286e+05          | 2.954685e+05  | 9.063830e+11  | 4.454416e+11  |
| Qing            | 500.0 | **1.619487e+00**  | 2.792538e+08           | 3.277669e+07          | 2.571555e+07          | 2.550800e+07          | 3.236222e+07  | 5.113791e+12  | 4.213666e+12  |
| Rastrigin       | 5.0   | 6.431230e+00           | 2.989753e+00           | **0.000000e+00** | **0.000000e+00** | **0.000000e+00** | 5.728703e+00  | 2.914550e+01  | 1.288921e+01  |
| Rastrigin       | 50.0  | 1.241965e+02           | 9.586061e+01           | **0.000000e+00** | **0.000000e+00** | **0.000000e+00** | 2.382687e+02  | 7.467277e+02  | 3.992331e+02  |
| Rastrigin       | 100.0 | 5.127551e+02           | 3.918027e+02           | **0.000000e+00** | **0.000000e+00** | **0.000000e+00** | 8.725493e+00  | 1.614028e+03  | 1.056488e+03  |
| Rastrigin       | 500.0 | 7.857777e+02           | 4.844327e+03           | **0.000000e+00** | **0.000000e+00** | **0.000000e+00** | 1.113296e+00  | 8.662154e+03  | 7.418877e+03  |
| Rosenbrock      | 5.0   | 1.583110e+00           | **2.784722e-03**  | 3.305692e+00          | 3.923380e+00          | 4.004184e+00          | 4.209418e+00  | 1.668537e+03  | 6.532422e+02  |
| Rosenbrock      | 50.0  | **4.619361e+01**  | 1.213549e+05           | 4.896510e+01          | 4.895126e+01          | 4.864777e+01          | 4.944928e+01  | 5.162790e+08  | 1.564138e+08  |
| Rosenbrock      | 100.0 | **9.620821e+01**  | 6.950294e+04           | 9.896225e+01          | 9.894958e+01          | 9.827628e+01          | 9.953195e+01  | 1.181308e+09  | 5.747291e+08  |
| Rosenbrock      | 500.0 | **4.928036e+02**  | 6.643892e+07           | 4.989654e+02          | 4.989620e+02          | 4.953576e+02          | 4.996204e+02  | 6.636891e+09  | 5.484970e+09  |
| Schwefel 2.23   | 5.0   | 7.952927e-17           | 5.676200e-196          | **0.000000e+00** | **0.000000e+00** | **0.000000e+00** | 2.508681e-26  | 5.551924e-11  | 1.984042e-04  |
| Schwefel 2.23   | 50.0  | 6.541749e-05           | 8.446286e-01           | **0.000000e+00** | **0.000000e+00** | **0.000000e+00** | 4.994360e-18  | 2.063147e+10  | 1.319229e+09  |
| Schwefel 2.23   | 100.0 | 5.597636e-05           | 1.439840e+04           | **0.000000e+00** | **0.000000e+00** | **0.000000e+00** | 4.229144e-18  | 5.203712e+10  | 8.848782e+09  |
| Schwefel 2.23   | 500.0 | 4.186489e-04           | 9.416200e+08           | **0.000000e+00** | **0.000000e+00** | **0.000000e+00** | 3.971603e-18  | 2.856865e+11  | 2.030229e+11  |
| Styblinski Tang | 5.0   | **-1.958308e+02** | -1.933838e+02          | -1.956690e+02         | -1.704458e+02         | -1.667757e+02         | -1.739331e+02 | -1.463484e+02 | -1.815406e+02 |
| Styblinski Tang | 50.0  | **-1.887625e+03** | -1.489194e+03          | -1.375409e+03         | -1.100679e+03         | -1.508295e+03         | -1.012750e+03 | -6.238084e+02 | -1.216271e+03 |
| Styblinski Tang | 100.0 | **-3.584575e+03** | -3.070922e+03          | -2.293661e+03         | -1.995295e+03         | -3.012112e+03         | -1.880137e+03 | -1.004418e+03 | -2.062010e+03 |
| Styblinski Tang | 500.0 | **-1.655782e+04** | -1.118049e+04          | -7.941753e+03         | -9.058273e+03         | -1.485966e+04         | -8.747708e+03 | -4.109127e+03 | -6.335769e+03 |
| Trid            | 5.0   | **-3.000000e+01** | **-3.000000e+01** | -2.989293e+01         | -2.990215e+01         | -2.381171e+01         | -2.832074e+01 | -2.990560e+01 | -2.339229e+01 |
| Trid            | 50.0  | **-2.204692e+04** | 5.627452e+05           | 2.687326e+01          | 4.422637e+01          | -6.815536e+01         | 8.656032e+01  | 3.878657e+07  | 2.734110e+07  |
| Trid            | 100.0 | **-1.633696e+05** | 1.342037e+06           | 7.968146e+01          | 9.604118e+01          | -1.095212e+02         | 6.007713e+02  | 2.320677e+09  | 1.448077e+09  |
| Trid            | 500.0 | **-6.258479e+06** | 6.282067e+11           | 4.829375e+02          | 4.968886e+02          | -8.654279e+02         | 6.588898e+05  | 9.049399e+12  | 7.431550e+12  |
