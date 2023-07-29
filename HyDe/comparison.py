from oct2py import octave
from dvhopConverter import convertCSVtoSNLP
import os
import numpy as np
import runConfig

PWD=os.getcwd()
DVHOPPATH=f"{PWD}/SNLP2D/problems/dvhopbench"
DVHOPWSNLOCALPATH=f"{DVHOPPATH}/WSN-localization"
DVHOPLOCALERRPATH=f"{DVHOPWSNLOCALPATH}/Localization Error"
octave.eval('pkg load statistics')
octave.eval('pkg load symbolic')

def setupProblem(config):
    octave.eval(f"cd {DVHOPWSNLOCALPATH}")
    octave.eval(f"delete 'Localization Error/result.mat'")
    octave.push('boxsize',config["boxsize"])
    octave.push('total_nodes_n',config["total_nodes_n"])
    octave.push('anchors_n',config["anchors_n"])
    octave.push('gpsErr',config["gpsErr"])
    octave.eval("generateSNLPProblem()")
    octave.push('comm_r',config["comm_r"])
    octave.eval("Neighbor()")

def solveWith(solver):
    octave.eval(solver)

def currentError(config,ofMethod):
    octave.eval(f"cd {DVHOPWSNLOCALPATH}")
    octave.eval("cd 'Localization Error'")
    err=octave.feval("localization_error_of.m",config['comm_r'],ofMethod)
    octave.eval("cd ..")
    return err

def copyProblemToCSVs():
    octave.eval(f"cd {DVHOPWSNLOCALPATH}")
    octave.eval(f"load './Deploy Nodes/coordinates.mat'")
    octave.eval(f"load './Topology Of WSN/neighbor.mat'")
    return (octave.pull('neighbor_matrix'),octave.pull('neighbor_dist'),octave.pull('all_nodes'))

def saveToSNLPCSV(neighbors,distances,all_nodes):
    np.savetxt(f"{DVHOPPATH}/exportedanchorflags.csv", all_nodes['anc_flag'].astype(int), fmt='%i', delimiter=",")
    np.savetxt(f"{DVHOPPATH}/exportedanchors.csv", all_nodes['estimated'], fmt='%.20f',delimiter=",")
    np.savetxt(f"{DVHOPPATH}/exporteddistances.csv", distances,  fmt='%.20f',delimiter=",")
    np.savetxt(f"{DVHOPPATH}/exportedneighbors.csv", neighbors.astype(int), fmt='%i', delimiter=",")

def exportToSNLP():
    (neighbors,distances,all_nodes)=copyProblemToCSVs()
    saveToSNLPCSV(neighbors,distances,all_nodes)
    anchorCsv=f'{DVHOPPATH}/exportedanchors.csv'
    anchorFlagsCsv=f'{DVHOPPATH}/exportedanchorflags.csv'
    neighborsCsv=f'{DVHOPPATH}/exportedneighbors.csv'
    distancesCsv=f'{DVHOPPATH}/exporteddistances.csv'
    convertCSVtoSNLP(anchorCsv,anchorFlagsCsv,neighborsCsv,distancesCsv, DVHOPPATH)

def evaluateLocalizationError(bestModelCsvPath, verbose=False):
    octave.eval(f"cd '{DVHOPLOCALERRPATH}'")
    octave.eval(f"load 'result.mat'")
    all_nodes=octave.pull('all_nodes')
    if verbose:
        print(all_nodes['estimated'])

    bestModel=np.loadtxt(bestModelCsvPath)
    bestModel=bestModel.reshape((bestModel.shape[0]//all_nodes['estimated'].shape[1], all_nodes['estimated'].shape[1]))
    if verbose:
        print(f"hybrid model: {bestModel}")
    anchorsEncountered=0
    for i in range(all_nodes['anc_flag'].shape[0]):
        if all_nodes['anc_flag'][i] != 1:
            all_nodes['estimated'][i]=bestModel[i-anchorsEncountered]
        else:
            anchorsEncountered+=1
    if verbose:
        print(all_nodes['estimated'])
    octave.push('all_nodes',all_nodes)
    octave.eval(f"save 'result.mat' all_nodes comm_r")


def runHybirdDESolver(problemConfig,hyDeConfig):
    popsize=hyDeConfig["popsize"]
    DEGen=hyDeConfig["generations"]
    totalIterations=hyDeConfig["totalevaluations"]
    iterations=totalIterations//(DEGen+1)
    nodecount=problemConfig["total_nodes_n"]-problemConfig["anchors_n"]
    maxDist=400
    box=problemConfig["boxsize"]
    solver=hyDeConfig['solver']
    problemPath=DVHOPPATH
    problemName="exportedDVHop.snlp"                  
    anchorName="exportedDVHop.snlpa"
    runConfig.hybridDE(popsize,DEGen,totalIterations,iterations,nodecount,maxDist,box,problemPath,problemName,anchorName,solver)

problemConfig={
    "boxsize":100,
    "comm_r":100,
    "total_nodes_n":50,
    "anchors_n":3,
    "gpsErr":0.3
}

hyDeConfig={
    "popsize":100,
    "generations":10,
    "totalevaluations":20000,
    'solver':'OPTIMIZER_MIN_DE'#OPTIMIZER_SIMPLE_DE,OPTIMIZER_MIN_INIT_DE
}

setupProblem(problemConfig) # -> coordinates.mat, neighbor.mat
# solveWith("cd 'DV-hop';DV_hop; cd ..") # -> result.mat
# dvHopErr=currentError(problemConfig,'DVHop')# result.mat -> error
# solveWith("cd APIT;APIT(0.1*comm_r); cd ..") # -> result.mat
# apiterr=currentError(problemConfig,'APIT')# result.mat -> error
# solveWith("cd Amorphous;Amorphous; cd ..") # -> result.mat
# amorphous=currentError(problemConfig,'Amorphous')# result.mat -> error
solveWith("dist_available=true;cd 'MDS-MAP';MDS_MAP(dist_available);cd ..") # -> result.mat
mdsMAP=currentError(problemConfig,'MDS-MAP')# result.mat -> error

# solveWith("cd 'Grid Scan';Grid_Scan(0.1*comm_r); cd ..") # -> result.mat
# gridScan=currentError(problemConfig,'Grid Scan')# result.mat -> error

# solveWith("cd 'Bounding Box';Bounding_Box; cd ..") # -> result.mat
# boundingBox=currentError(problemConfig,'Bounding box')# result.mat -> error
# RSSI has information about power also
solveWith("cd RSSI;RSSI; cd ..") # -> result.mat
rssiError=currentError(problemConfig,'RSSI')# result.mat -> error

exportToSNLP() # coordinates.mat, neighbor.mat, result.mat -> exportedDVHop.snlp,exportedDVHop.snlpa
runHybirdDESolver(problemConfig,hyDeConfig) # exportedDVHop.snlp,exportedDVHop.snlpa -> finalModelLBFGS.csv, finalModelGD.csv
# print(f'DVHop error: {dvHopErr}')
# print(f'Apit error: {apiterr}')
# print(f'Amorphous error: {amorphous}')
print(f'MDS-MAP error: {mdsMAP}')
# print(f'GridScan error: {gridScan}')
# print(f'BoundingBox error: {boundingBox}')
print(f'rssiError error: {rssiError}')

evaluateLocalizationError("finalModelGD.csv")# finalModelGD.csv -> result.mat
print(f'HybridDE GD error: {currentError(problemConfig,"H-DE-GD")}')# result.mat -> error
evaluateLocalizationError("finalModelLBFGS.csv")# finalModelLBFGS.csv -> result.mat
print(f'HybridDE LBFGS error: {currentError(problemConfig,"H-DE-LBFGS")}')# result.mat -> error
input("Press enter to exit...")