'''
Created on Jun 7, 2011

@author: rp2007
'''
#from Mother import *
import pylab as P #@UnusedImport
import numpy as N #@UnusedImport
from matplotlib.colors import LinearSegmentedColormap
import matplotlib.colors as cols
import matplotlib.gridspec as gridspec
import random as R
from mpl_toolkits.mplot3d import Axes3D
from itertools import *
from matplotlib.collections import PolyCollection
from matplotlib.colors import colorConverter
import matplotlib.pyplot as plt

class Plotter:
    
    def cmap_double_discretize(self, cmap_bottom, cmap_top, num_bins, split=.5):
     
        # sanity check
        assert split < 1 and split > 0
        # set up the data structure
        cdict = {lab: [] for lab in ('red','green','blue')}
        # do this in a fancy loop to a) save typing, b) make it easy to
        # retrofit to do arbitrary splits
        for cmap, ends in zip((cmap_bottom, cmap_top), ((0, split), (split, 1))):
    
            # run over the _whole_ range for each color map
            
            colors_i = N.concatenate((N.linspace(0, 1.,  num_bins), (0.,0.,0.,0.)))
            # map the color
            colors_rgba = cmap(colors_i)
            # get the values 
            indices = N.linspace(ends[0], ends[1],  num_bins+1, endpoint=True)
    
            for ki,key in enumerate(('red','green','blue')):
                cdict[key].extend((indices[i], colors_rgba[i-1,ki], colors_rgba[i,ki]) for i in xrange(num_bins+1))
                #    print cdict
        # Return colormap object.
        return cols.LinearSegmentedColormap(cmap.name + "_%d"%num_bins, cdict, 1024)

    
    
    def getColorMap(self, custom_cmap=''):
        
#        # example 2: use the "fromList() method
#        startcolor1 = '#0000ff'  # black
#        midcolor1 = '#000080'    # mid blue
#        endcolor1 = '#000000'    # bright blue
#        cmap1 = cols.LinearSegmentedColormap.from_list('own2',[startcolor1,midcolor1,endcolor1])
#    
#        # example 2: use the "fromList() method
#        startcolor2 = '#000000'  # black
#        midcolor2 = '#008000'    # mid green
#        endcolor2 = '#00ff00'    # light green
#        cmap2 = cols.LinearSegmentedColormap.from_list('own2',[startcolor2,midcolor2,endcolor2])
#        
#        bicmap = self.cmap_double_discretize(cmap1, cmap2, 10, 0.5)
        
        
        # example 2: use the "fromList() method
#        startcolor2 = '#ffffff'  # black
#        midcolor2 = '#3b7054'    # mid green
#        endcolor2 = '#123624'    # light green
#        cmap2 = cols.LinearSegmentedColormap.from_list('own2',[startcolor2,midcolor2,endcolor2])
        
        cmap2=plt.cm.PuOr_r
        
        
        return cmap2
        
    
    def plotGFP(self,cell, fileName=''):
        
        P.figure(num=None, figsize=(8, 4), dpi=300, facecolor='w', edgecolor='k')

        P.xlabel("Time (frames)")
        P.ylabel("GFP")
        P.title('Pos: %s Cell: %s ($ %s ^\circ C$)' %(cell.pos,cell.id, cell.temperature))
#        P.title('Cell: '+cell.label)
        
        #Plot divisions
        idivision = [item for item in range(len(cell.divisions)) if cell.divisions[item] == 1]   
        frame_division = [cell.frames[i] for i in idivision]
        GFP_division = [cell.GFP[i] for i in idivision]
        P.plot(frame_division, GFP_division, 'go', markersize=4)
         
        
        P.plot(cell.frames, cell.GFP, 'g-')
         
        
        P.ylim([0,100])
        P.xlim([0, 237])
        if len(fileName)>0:
            P.savefig(fileName)
        else:  
            P.show()       
            
    def plotNormGFP(self,cell, meanGFP=1, fileName=''):
        
        P.figure(num=None, figsize=(8, 4), dpi=300, facecolor='w', edgecolor='k')

        P.xlabel("Time (frames)")
        P.ylabel("Deviation from mean GFP")
        P.title('Pos: %s Cell: %s ($ %s ^\circ C$)' %(cell.pos,cell.id, cell.temperature))
        
        normGFP=[gfp-meanGFP for gfp in cell.GFP]
        
        #Plot divisions
        idivision = [item for item in range(len(cell.divisions)) if cell.divisions[item] == 1]   
        frame_division = [cell.frames[i] for i in idivision]
        GFP_division = [normGFP[i] for i in idivision]
        P.plot(frame_division, GFP_division, 'ko', markersize=4)
         
        P.fill_between(cell.frames, normGFP, 0, color='g')
         
        
        P.ylim([-50,50])
        P.xlim([0, 237])
        if len(fileName)>0:
            P.savefig(fileName)
        else:  
            P.show()     
            
            
    def plotAllGFP(self,cells, dirName=''):
        for cell in cells:
            fileName=dirName+''+str(cell.temperature)+'C_pos'+str(cell.pos)+'_cell'+str(cell.id)+'.png'
            self.plotGFP(cell, fileName)
            
    def plotAllNormGFP(self,cells, meanGFP, dirName=''):
        for cell in cells:
            fileName=dirName+'norm_'+str(cell.temperature)+'C_pos'+str(cell.pos)+'_cell'+str(cell.id)+'.png'
            self.plotNormGFP(cell, meanGFP, fileName)
               
                
    def plotHistogram(self,cells, meanGFP=1, minGFP=0, maxGFP=100, numBins=100,dirName=''):
        GFPs=[]
        for cell in cells:
            GFPs.extend(cell.GFP[:])
        
        GFPs=[gfp-meanGFP for gfp in GFPs]
        
        P.figure(num=None, figsize=(8, 4),dpi=300, facecolor='w', edgecolor='k')
        P.xlabel("Deviation from mean GFP ")
        P.ylabel("Frequency")
        P.title(' $'+str(cell.temperature)+'^\circ C$')
        
        bins=N.arange(minGFP-meanGFP, maxGFP-meanGFP, (maxGFP-minGFP)/numBins)
        n, bins, patches = P.hist(GFPs, bins, normed=1, histtype='stepfilled') #@UnusedVariable
        P.setp(patches, 'facecolor', 'g', 'alpha', 0.75)

        
#        P.xlim([N.min(bins),N.max(bins)])
        P.xlim([minGFP-meanGFP,maxGFP-meanGFP])
#        P.ylim([N.min(n),1.1*N.max(n)])
        P.ylim([0., .12])
        if len(dirName)>0:
            fileName=dirName+'hist_'+str(cells[0].temperature)+'C.png'
            P.savefig(fileName)
        else:  
            P.show()    
            
            
    def plotHistogram3D(self,temp_cells, meanGFP=1, minGFP=0, maxGFP=100, numBins=100,dirName=''):
        
        fig = P.figure(num=None, figsize=(8, 8),dpi=300, facecolor='w', edgecolor='k')
        ax = fig.add_subplot(111,projection='3d')
        
        font = {'family' : 'Arial',
        'weight' : 'normal',
        'size'   : 12}

        P.rc('font', **font)
        temperatures=[29, 31, 33, 35, 37]
        colors = cycle(["#feedde", "#fdbe85","#fd8d3c", "#e6550d", "#a63603"])
        cc = lambda arg: colorConverter.to_rgba(arg, alpha=0.6)
        verts = []
        for z, cells in zip(temperatures, temp_cells):
            
            GFPs=[]            
            for cell in cells:
                GFPs.extend(cell.GFP[:])
            
            GFPs=[gfp-meanGFP for gfp in GFPs] #Subtract background
            
            GFPs=N.log10(GFPs)
            
            maxGFP=2.  ####TEMP
            minGFP=N.min(GFPs)
                            
            bins=N.arange(minGFP-meanGFP, maxGFP-meanGFP, (maxGFP-minGFP)/numBins)

            #n, bins, patches = P.hist(GFPs, bins, normed=1, histtype='stepfilled') #@UnusedVariable
            histo, bin_edges = N.histogram(GFPs,bins,density=True)
                
            xs=bins[:-1]
            ys=histo
                
            #
            
            #ax.plot(xs, N.ones(xs.shape)*z, ys, color="red", alpha=.2)
            
            c=next(colors)
            ax.bar(xs, ys, zs=z, zdir='y', color=c, edgecolor='black', alpha=0.9, width=(maxGFP-minGFP)/numBins)
            ax.view_init(elev=16., azim=-56.)

            verts.append(list(zip(xs, ys)))

            
        poly = PolyCollection(verts, facecolors = [cc("Yellow"),cc("Orange"), cc("OrangeRed"), cc("Red"),cc("DarkRed")], closed=False)
        poly.set_alpha(.9)
        #ax.add_collection3d(poly, zs=temperatures, zdir='y')
    
        ax.set_yticks(temperatures)
        ax.set_xlabel('GFP intensity (log10 scale)', fontsize=14)
        ax.set_ylabel('Temperature  ($^\circ$C)', fontsize=14)
        ax.set_zlabel('Probability density', fontsize=14)
       
        if len(dirName)>0:
            fileName=dirName+'histogram_temperature.pdf'
            P.savefig(fileName)
        else:  
            P.show()    
            
            

            
    def plotHistogram3Dsim(self,simGFPs, meanGFP=1, minGFP=0, maxGFP=100, numBins=100,dirName=''):
        
        fig = P.figure(num=None, figsize=(8, 8),dpi=300, facecolor='w', edgecolor='k')
        ax = fig.add_subplot(111,projection='3d')
        
        font = {'family' : 'Arial',
        'weight' : 'normal',
        'size'   : 12}

        P.rc('font', **font)
        temperatures=[.12, .14, .16, .18, .2]
        colors = cycle(["#feedde", "#fdbe85","#fd8d3c", "#e6550d", "#a63603"])
        verts = []
        cc = lambda arg: colorConverter.to_rgba(arg, alpha=0.6)
        for z, GFPs in zip(temperatures, simGFPs):
            
            #GFPs=[]            
            #for cell in cells:
            #    GFPs.extend(cell.GFP[:])
            #GFPs=[gfp-meanGFP for gfp in GFPs] #Subtract background
            # 
            
            GFPs=N.log10(GFPs)
                
            bins=N.arange(minGFP-meanGFP, maxGFP-meanGFP, (maxGFP-minGFP)/numBins)
            #n, bins, patches = P.hist(GFPs, bins, normed=1, histtype='stepfilled') #@UnusedVariable
            histo, bin_edges = N.histogram(GFPs,bins,density=True)
                
                
            xs=bins[:-1]
            ys=histo
                
                #xs = N.arange(20)
                #ys = N.random.rand(20)
                # You can provide either a single color or an array. To demonstrate this,
                # the first bar of each set will be colored cyan.
            #cs = [c] * len(xs)
            #cs[0] = 'c'
            #ax.bar(xs, ys, zs=z, zdir='y', color=next(colors), alpha=0.7, width=(maxGFP-minGFP)/numBins)
            ax.plot(xs, N.ones(xs.shape)*z, ys, color="black", alpha=.2)
            #ax.fill_between(xs, N.ones(xs.shape)*z, ys, alpha=.5, antialiased=True, color=next(colors))
            ax.view_init(elev=16., azim=-56.)
            verts.append(list(zip(xs, ys)))
            
        poly = PolyCollection(verts, facecolors = [cc("#feedde"),cc("#fdbe85"), cc("#fd8d3c"), cc("#e6550d"),cc("#a63603")])
        poly.set_alpha(.9)
        ax.add_collection3d(poly, zs=temperatures, zdir='y')

        ax.set_yticks(temperatures)
        ax.set_xlabel('FliAZ  (log10 scale)', fontsize=14)
        ax.set_ylabel('Noise intensity ($\Omega$)', fontsize=14)
        ax.set_zlabel('Probability density', fontsize=14)
#        ax.set_zlim((0.02, 0.32))
       
        if len(dirName)>0:
            fileName=dirName+'histogram_noise.pdf'
            P.savefig(fileName)
        else:  
            P.show()    
              
            
    def plotHeatMap(self,all_cells, num=200, meanGFP=1, dirName=''):

        fig, ax1 = P.subplots(len(all_cells), figsize=(8,16), sharex=True, facecolor='w', edgecolor='k')

        gs = gridspec.GridSpec(5, 1, height_ratios=[0.76,0.82,0.84,1.33, 1.24])
        gs.update(hspace=0.07)
        
#        P.subplots_adjust(hspace = .05)
        font = {'family' : 'Arial',
        'weight' : 'normal',
        'size'   : 14}

        P.rc('font', **font)
        for i, celltemp in enumerate(all_cells):
            
            GFPs=[]
            mGFP=[]
            
            for cell in celltemp:
                timeGFP=[(gfp-meanGFP) for gfp in cell.GFP[0:num]]
                mGFP.append(N.mean(timeGFP))
                timeGFP.extend(list(N.NaN for i in xrange(0,num-len(cell.GFP))))
                
                GFPs.append(timeGFP)
                
            idx = N.array(mGFP).argsort()
            nGFPs=N.array(GFPs)
            D = N.ma.masked_invalid(N.transpose(nGFPs[idx]))
            
            ybin = N.linspace(0, len(GFPs), len(GFPs)+1)
            xbin = N.linspace(0, num, num+1)

            cmap = self.getColorMap()
            cmap.set_bad(color = [.25, .25, .25], alpha = 1.)
            
#            heatmap = ax.pcolor(N.array(GFPs[:]), cmap=self.getColorMap())
            ax = P.subplot(gs[i])

            cax=ax.pcolormesh(xbin, ybin, D.T, cmap = cmap, edgecolors = 'None', vmin = -meanGFP, vmax = meanGFP)
            ax.set_xlim([0, num])
            ax.set_ylim([0, len(GFPs)])
            ax.set_ylabel('Cells ($'+str(cell.temperature)+'^\circ C$)', fontsize=16)
            ax.set_xticks([])
            ax.set_yticks(range(0,len(GFPs),25))
        ax.set_xlabel("Time (frames)", fontsize=16)
        ax.set_xticks(range(0,num,50))
        
        cbaxes = fig.add_axes([0.125,0.908, 0.775, 0.015]) 

        cbar = fig.colorbar(cax, ticks=[-meanGFP, -meanGFP/2, 0, meanGFP/2, meanGFP], orientation='horizontal', cax = cbaxes)
        
        cbar.ax.set_xticklabels(['-100%','-50%', 'Mean', '50%', '100%'])# horizontal colorbar
        cbar.ax.xaxis.set_ticks_position('top')
        cbar.ax.text(0.5, 2.2,"Deviation from population-level mean GFP (%)",fontsize=16, ha='center')        
            
        if len(dirName)>0:
            fileName=dirName+'heatmap.png'
            P.savefig(fileName)
#        else:  
#            P.show()   
            
    def plotAverageGFP(self,all_cells, num=200, meanGFP=1, dirName=''):
        
        P.subplots(len(all_cells), figsize=(8,16), sharex=True, facecolor='w', edgecolor='k')

        gs = gridspec.GridSpec(5, 1, height_ratios=[0.76,0.82,0.84,1.33, 1.24])
        gs.update(hspace=0.07)
        
#        P.subplots_adjust(hspace = .05)
        font = {'family' : 'Arial',
        'weight' : 'normal',
        'size'   : 14}

        P.rc('font', **font)
        for i, celltemp in enumerate(all_cells):
            
            this_temperature=[]
            this_framesAboveMean=[]
            GFPs=[]
            
            for cell in celltemp:
                timeGFP=[(gfp-meanGFP) for gfp in cell.GFP[0:num]]
                timeGFP.extend(list(N.NaN for i in xrange(0,num-len(cell.GFP))))
                
                this_framesAboveMean.append(N.array(sum(i > 0 for i in timeGFP)))
                this_temperature.append(cell.temperature)
                
                GFPs.append(timeGFP)
            
            nGFPs = N.ma.masked_invalid(N.transpose(N.array(GFPs)))
            idx = N.mean(nGFPs,axis=0).argsort()
            mGFPs=N.mean(nGFPs,axis=0)
            
            ax = P.subplot(gs[i])
            
#            cax=ax.barh(range(0,len(idx)),mGFPs[idx],  height=1, color="black")
            cmap = self.getColorMap()
            for j, m in enumerate(mGFPs[idx]):
                r=(1+m/meanGFP)/2
                ax.barh(j,m, height=1,color=cmap(r), edgecolor=cmap(r))
            
            ax.set_xlim([-meanGFP, meanGFP])
            ax.set_ylim([0, len(GFPs)])
            ax.set_ylabel('Cells ($'+str(cell.temperature)+'^\circ C$)', fontsize=16)
            ax.set_xticks([])
            ax.set_yticks(range(0,len(GFPs),25))
            
            if i==0:
                ax.set_title("Average GFP in a %s-frame observation"%num)
        ax.set_xlabel("Deviation from population-level meanGFP (%)", fontsize=16)
        ax.set_xticks([-meanGFP, -meanGFP/2, 0, meanGFP/2, meanGFP])
        ax.set_xticklabels(['-100%','-50%', 'Mean', '50%', '100%'])
        
        
        if len(dirName)>0:
            fileName=dirName+'devmean.png'
            P.savefig(fileName)
#        else:  
#            P.show()   


    def plotMeanCoefficientVariation(self, all_cells,  dirName=''):
        CVs=[]
        temperature=[]
        OFFmax=30.
        for i, celltemp in enumerate(all_cells):
            this_CVs=[]
            this_temperature=[]
            
            for cell in celltemp:
                nGFP=N.array(cell.GFP)
                if N.amax(cell.GFP)>OFFmax:
                    CV=N.std(nGFP)/N.mean(nGFP)
                    this_CVs.append(CV)
                    this_temperature.append(cell.temperature)
            CVs.append(this_CVs)
            temperature.append(this_temperature)
        minCV= N.min(N.min(CVs))
        maxCV= N.max(N.max(CVs))
        
#        print temperature
#        idx = N.array(temperature).argsort()
#        print temperature
        
        temperatures=N.array([29., 31., 33., 35., 37.])
        P.figure(facecolor='w', edgecolor='k')
        P.ylabel("Coefficient of Variation (excluding OFF cells)", fontsize=16)
        P.xlabel("Temperature", fontsize=16)
        for i, temp in enumerate(temperature):

            P.errorbar(temp[0], N.mean(CVs[i]), yerr=N.std(CVs[i]), fmt='o',color='black')
            
            P.ylim([0, 1])    
            #ax.text(0.8,0.8,' $'+str(temp[0])+'^\circ C$', fontsize=16)
            P.xlim([28, 38])    
            P.xticks(temperatures)
            #ax.set_ylabel("Normalised frequency", fontsize=16)
            
        if len(dirName)>0:
            fileName=dirName+'CV_ON.pdf'
            P.savefig(fileName)
                

    def plotCoefficientVariation(self, all_cells, numBins, fileName=''):
        CVs=[]
        temperature=[]
        for i, celltemp in enumerate(all_cells):
            this_CVs=[]
            this_temperature=[]
            
            for cell in celltemp:
                nGFP=N.array(cell.GFP)
                CV=N.std(nGFP)/N.mean(nGFP)
                this_CVs.append(CV)
                this_temperature.append(cell.temperature)
            CVs.append(this_CVs)
            temperature.append(this_temperature)
        minCV= N.min(N.min(CVs))
        maxCV= N.max(N.max(CVs))
        
#        print temperature
#        idx = N.array(temperature).argsort()
#        print temperature
        
        fig, ax = P.subplots(len(all_cells),1, figsize=(8,16), sharex=True, facecolor='w', edgecolor='k')
        P.subplots_adjust(hspace = .08)
        P.xlabel("Coefficient of Variation", fontsize=16)
        for i, temp in enumerate(temperature):

            
            bins=N.arange(minCV, maxCV, (maxCV-minCV)/numBins)
                        
            hist, bin_edges=N.histogram(CVs[i],bins)

            wbin=(bin_edges[1]-bin_edges[0])
            xbins=wbin/2+bin_edges[:-1]


            hist=hist/float(N.max(hist))

            ax[i].bar(xbins, hist, wbin*.8, color='black')
            
            ax[i].set_ylim([0, 1])    
            ax[i].set_xlim([0, 1])    
            ax[i].text(0.8,0.8,' $'+str(temp[0])+'^\circ C$', fontsize=16)
            ax[i].set_ylabel("Normalised frequency", fontsize=16)
            
            
    def plotTotalVariation(self, all_cells, numBins, fileName=''):
        TVs=[]
        temperature=[]
        for i, celltemp in enumerate(all_cells):
            this_TVs=[]
            this_temperature=[]
            
            for cell in celltemp:
                nGFP=N.array(cell.GFP)
                p=2
                TV=N.sum(N.abs(N.diff(nGFP,n=1, axis=0))**p)**(1/p)
                this_TVs.append(TV)
                this_temperature.append(cell.temperature)
            TVs.append(this_TVs)
            temperature.append(this_temperature)
        minTV= N.min(N.min(TVs))
        maxTV= N.max(N.max(TVs))
        
#        print temperature
#        idx = N.array(temperature).argsort()
#        print temperature

        print TVs
        
        fig, ax = P.subplots(len(all_cells),1, figsize=(8,16), sharex=True, facecolor='w', edgecolor='k')
        P.subplots_adjust(hspace = .08)
        
        P.xlabel("Total Variation", fontsize=16)
        for i, temp in enumerate(temperature):

            
            bins=N.arange(minTV, maxTV, (maxTV-minTV)/numBins)
                        
            hist, bin_edges=N.histogram(TVs[i],bins)

            wbin=(bin_edges[1]-bin_edges[0])
            xbins=wbin/2+bin_edges[:-1]


            hist=hist/float(N.sum(hist))

            ax[i].bar(xbins, hist, wbin*.8, color='black')
            
            ax[i].set_ylim([0,1])    
            ax[i].set_ylim([0,1])       
            ax[i].set_xlim([minTV, maxTV])    
            ax[i].set_xlim([minTV, maxTV])    
            ax[i].text(1.1*minTV,0.8,' $'+str(temp[0])+'^\circ C$', fontsize=16)
            ax[i].set_ylabel("Normalised frequency", fontsize=16)            
        

             
    def plotFractionON(self, all_cells, dirName=''):   
        
        width = 1.       # the width of the bars
        temperatures=N.array([29., 31., 33., 35., 37.])
        fig, ax = P.subplots(facecolor='w', edgecolor='k')
       
        ax.bar(temperatures-width/2., N.array([1., 1., 1., 1.,1.]), width, color='#fcfcfc', edgecolor='#fcfcfc')
      
        frac_OFF=[]
        diffmax=30.
        for cell_temp in all_cells:
            cells_off=0.
            cells_on=0.
            for cell in cell_temp:
                #diff=N.amax(N.abs(cell.GFP- N.mean(cell.GFP[:])))
                #if diff<diffmax:
                if N.amax(cell.GFP)<diffmax:
                    #print '%s-%s'%(cell.pos,cell.id)
                    cells_off=cells_off+1.
                else:
                    cells_on=cells_on+1.
            print 'Fraction of cells OFF=%s'%(cells_off/(cells_on+cells_off))
            frac_OFF.append(100*cells_on/(cells_on+cells_off))

        barlist=ax.bar(temperatures-width/2., frac_OFF, width)
        barlist[0].set_color("#feedde")
        barlist[1].set_color("#fdbe85")
        barlist[2].set_color("#fd8d3c")
        barlist[3].set_color("#e6550d")
        barlist[4].set_color("#a63603")
        ax.set_ylim([0,100])       
        ax.set_xlim([28., 38.])   
        ax.set_ylabel("Cells with $\it{fliC-ON}$ ($\%$)", fontsize=12)    
        ax.set_xlabel("Temperature ($^\circ C$)", fontsize=12)    
        ax.set_xticks(temperatures)
                
        if len(dirName)>0:
            fileName=dirName+'fracOFF.pdf'
            P.savefig(fileName)
                
