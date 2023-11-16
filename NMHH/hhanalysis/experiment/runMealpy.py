import numpy as np
import json
import subprocess
import itertools
import os
import copy
from timeit import default_timer as timer
from analysis.common import *
import runExperiment.mealpy.run

import pandas as pd


backslash="\\"
dquote='"'
ROOT="../../"
LOGS_PATH_FROM_ROOT="hhanalysis/logs"

def runMealpySuite():
    EXPERIMENT_RECORDS_PATH=f"{ROOT}/{LOGS_PATH_FROM_ROOT}/mealpyPerf/newExperiment/"
    dimensions=[5,50,100,500]
    optimizers=[ 'AEO','CRO','BRO','ArchOA','SMA','PSO']
    problems=[
              ("PROBLEM_ROSENBROCK",f"hhanalysis/logs/rosenbrock.json"),
              ("PROBLEM_RASTRIGIN",f"hhanalysis/logs/rastrigin.json"),
              ("PROBLEM_STYBLINSKITANG",f"/styblinskitang.json"),
              ("PROBLEM_TRID",f"hhanalysis/logs/trid.json"),
              ("PROBLEM_SCHWEFEL223",f"hhanalysis/logs/schwefel223.json"),
              ("PROBLEM_QING",f"hhanalysis/logs/qing.json"),
            ]
    populationSize=[30]
    config={'name':'/',
            'problems':problems,
            'dimensions':dimensions,
            'populationSize':populationSize,
            'optimizers':optimizers,
            }
    runExperiment.mealpy.run.runExtraBenchMarks(EXPERIMENT_RECORDS_PATH,config)

runMealpySuite()

