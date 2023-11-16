if ! command -v python3 &> /dev/null; then
    echo "python3 not found: please install python3"
    exit 1
fi

if ! command -v pip3 &> /dev/null; then
    echo "pip3 not found: please install pip3"
    exit 1
fi

if python3 -c "import mealpy" &> /dev/null; then
    echo "mealpy is installed."
else
    echo "mealpy is not installed."
    cd hhanalysis/experiment/runExperiment/mealpy && pip3 install . && cd -
fi

cd hhanalysis/experiment && python3 runMealpy.py
