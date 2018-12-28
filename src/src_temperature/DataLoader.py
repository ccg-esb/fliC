'''
Created on Jun 27, 2011

@author: rp2007
'''

import numpy as N #@UnusedImport
import csv
from collections import defaultdict
from Mother import *


class DataLoader(object):
        
    def __init__(self, dirName):
        self.dirName=dirName   
        
            
    def loadData(self, fileName):
        
        columns = defaultdict(list) #we want a list to append each value in each column to
        
        with open(self.dirName+fileName) as f:
            reader = csv.DictReader(f) #create a reader which represents rows in a dictionary form
            for row in reader: #this will read a row as {column1: value1, column2: value2,...}
                for (k,v) in row.items(): #go over each column name and value 
                    columns[k].append(v) #append the value into the appropriate list based on column name k
        

        all_ids=[int(list_item) for list_item in columns['id_cell']] 
        all_frames=[int(list_item) for list_item in columns['Frame']] 
        all_intensities=[float(list_item) for list_item in columns['Intensity']] 
        all_pos=[int(list_item) for list_item in columns['pos']] 
        all_divisions=[int(list_item) for list_item in columns['Division']] 
        all_temperatures=[int(list_item) for list_item in columns['C']] 
        all_labels=['%03d%03d' % t for t in zip(all_pos, all_ids)]


        unique_pos=set(all_pos)
        mothers=[]
#        
        
        for pos in unique_pos:
            indx_pos=[item for item in range(len(all_pos)) if all_pos[item] == pos]
            id_pos = [all_ids[i] for i in indx_pos]    
            unique_idpos=set(id_pos)
            for this_id in unique_idpos:
                label_idpos= '%03d%03d' % (int(pos), int(this_id))
                idx=[item for item in range(len(all_labels)) if all_labels[item] == label_idpos]
                
                this_frames = [all_frames[i] for i in idx]
                this_intensities=[all_intensities[i] for i in idx]
                this_divisions=[all_divisions[i] for i in idx]
                this_temperature=[all_temperatures[i] for i in idx]
                    
                this_mother = Mother(pos, this_id)
                this_mother.setDATA(this_frames, this_intensities, this_divisions, this_temperature[0])
                mothers.append(this_mother)


        print 'Loaded',len(mothers),'cells from ',self.dirName+fileName

        return mothers
    
    def getStatsData(self, cells):
        
        GFPs=[]
        for ctemp in cells:
            for cell in ctemp:
                GFPs.extend(cell.GFP[:])
            
        meanGFP=N.mean(GFPs)
        minGFP=N.min(GFPs)
        maxGFP=N.max(GFPs)
        
            
        return (minGFP, meanGFP, maxGFP)
    
    