'''
Created on Jun 30, 2010

@author: rp2007
'''
class Mother(object):
    

    DEBUG=0

    def __init__(self, pos,id_cell):
        self.pos=pos
        self.id=id_cell
        self.label= '%03d%03d' % (int(pos), int(id_cell))
        if(self.DEBUG): 
            print("%s :: %s" % (self.ps, self.id))  
            
    def setDATA(self, frames, GFP, divisions, temperature):
        self.frames=frames
        self.GFP=GFP
        self.divisions=divisions 
        self.temperature=temperature
        
