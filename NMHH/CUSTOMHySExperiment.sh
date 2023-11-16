if ! command -v python3 &> /dev/null; then
    echo "python3 not found: please install python3"
    exit 1
fi

if ! command -v pip3 &> /dev/null; then
    echo "pip3 not found: please install pip3"
    exit 1
fi

cd hhanalysis/experiment/runExperiment/customhys && python3 -m pip install . && cd -
cd hhanalysis/experiment && python3 runCUSTOMHyS.py