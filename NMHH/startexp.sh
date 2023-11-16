if ! command -v nvcc &> /dev/null; then
    echo "nvcc not found: please install CUDA Toolkit"
    exit 1
fi
    echo "Found: CUDA Toolkit"
if ! command -v python3 &> /dev/null; then
    echo "python3 not found: please install python3"
    exit 1
fi
export LD_LIBRARY_PATH=`pwd`/libs && \
 export CPATH=`pwd`/libs/include/nomad:`pwd`/libs/include/eigen3:`pwd`/libs/include/cmaes && \
  cd hhanalysis/experiment && python3 run.py
