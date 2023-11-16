import numpy as np
import json
import subprocess
import itertools
import os
import copy
from timeit import default_timer as timer
from analysis.common import *
import runExperiment.customhys.customhys.batchexperiments 

import pandas as pd


backslash="\\"
dquote='"'
ROOT="../../"
LOGS_PATH_FROM_ROOT="hhanalysis/logs"

def runCUSTOMHySSuite():
    EXPERIMENT_RECORDS_PATH=f"{ROOT}/{LOGS_PATH_FROM_ROOT}/CustomHYSPerf/newExperiment/"
    dimensions=[5,50,100,500]
 
    problems=[
              ("Rosenbrock",f"hhanalysis/logs/rosenbrock.json"),
              ("Rastrigin",f"hhanalysis/logs/rastrigin.json"),
              ("StyblinskiTang",f"/styblinskitang.json"),
              ("Trid",f"hhanalysis/logs/trid.json"),
              ("Schwefel223",f"hhanalysis/logs/schwefel223.json"),
              ("Qing",f"hhanalysis/logs/qing.json"),
            ]
    populationSize=[30]
    config={'name':'/',
            'problems':problems,
            'dimensions':dimensions,
            'populationSize':populationSize,
            }
    runExperiment.customhys.customhys.batchexperiments.runExperiments(EXPERIMENT_RECORDS_PATH,config)

runCUSTOMHySSuite()

