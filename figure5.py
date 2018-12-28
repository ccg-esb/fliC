'''
Created on Jun 27, 2011

@author: rp2007
'''
import pylab as P #@UnusedImport
import numpy as N #@UnusedImport
import scipy.io #@UnusedImport

import sys
sys.path.insert(0, './src/src_temperature/')

from DataLoader import * #@UnusedWildImport
from Plotter import * #@UnusedWildImport

#===============================================================================
# SETUP
#===============================================================================

temperatures=[29, 31, 33, 35, 37]
#temperatures=[29]

dirName='data/temperature/'
outDir='figures/temperature/'

#===============================================================================
# LOAD DATA
#===============================================================================

cells=[]
for C in temperatures:
    fileName='results_%sC_all.txt'%(C)
    data = DataLoader(dirName)
    cells.append(data.loadData(fileName))

#===============================================================================
# ANALYZE DATA
#===============================================================================
minGFP, meanGFP, maxGFP=data.getStatsData(cells)

print '------------'
print 'Mean GFP:',meanGFP
print 'Min GFP : ',minGFP
print 'Max GFP: ',maxGFP
print '------------'

##===============================================================================
## PLOT DATA
##===============================================================================

plotter = Plotter()

###################Plot GFP expression for each cell
#print 'Plotting GFP expression for each cell'
#for cell_temp in cells:
#    plotter.plotAllGFP(cell_temp, outDir+'cells/')
#
##Plot deviation from mean GFP expression for each cell
#print 'Plotting deviation from mean GFP expression for each cell'
#for cell in cells:
#    plotter.plotAllNormGFP(cell, meanGFP, outDir+'cellsnorm/')


##################Plot population-level histograms
#print 'Plotting population-level histograms'
#numBins=35
#meanGFP=0.
#plotter.plotHistogram3D(cells, meanGFP, 0, 100, numBins, outDir)
#
#
###simGFPs=mat_
#simGFPs=[]
#ids=[1,2,3,4,5]
#for i in ids:
#    fileName='%s/m-histogram_DSDE_N10000_i%s.mat'%(dirName,i)
#    mat = scipy.io.loadmat(fileName) 
#    simGFPs.append(mat['GFPs'])
#    print 'Loaded simulations from ',dirName+fileName
#
#plotter.plotHistogram3Dsim(simGFPs, 0., 0., N.log10(24), numBins, outDir)


#

#################Plot heatmap
#numFrames=200
#plotter.plotHeatMap(cells, numFrames, meanGFP, outDir)
#plotter.plotAverageGFP(cells, numFrames, meanGFP, outDir)

################# Identify sub-populations
plotter.plotFractionON(cells, dirName=outDir)


P.show()

#===============================================================================

print '_______'


