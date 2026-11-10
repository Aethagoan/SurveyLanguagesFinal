import random
import datetime

# program values

SEED =  19387043232
MAXNUTRIENT = 5

# class definitions

class Location:
    def __init__(self,_x: "int", _y: "int"):
        self.x:int = _x
        self.y:int = _y
    
    def __str__(self):
        return str(self.x) +","+str(self.y)


class root:
    def __init__ (self,_id:int, _location:"Location"):
        self.id:int = _id
        self.location:"Location" = _location
        self.nutrients:int = getTerrain(_location)

    def getNeighbors(self):
        return [
                Location(self.location.x-1, self.location.y+1),
                Location(self.location.x,   self.location.y+1),
                Location(self.location.x-1, self.location.y),
                Location(self.location.x+1, self.location.y+1),
                Location(self.location.x+1, self.location.y),
                Location(self.location.x-1, self.location.y-1),
                Location(self.location.x,   self.location.y-1),
                Location(self.location.x+1, self.location.y-1)
            ]

class MasterRoot:
    def __init__(self,_id:int):
        self.id:int = _id
        self.alive:bool = True


# functions


def getTerrain(_location:"Location"):
    random.seed(_location.x + SEED * _location.y)
    x = random.randint(0,MAXNUTRIENT)
    random.seed(_location.y + SEED * _location.x)
    y = random.randint(0,MAXNUTRIENT)
    f = (x+y)%MAXNUTRIENT
    # print(f)
    return f


# program

# - setup
rootnetworks:MasterRoot = []
allroots = {}

allroots[str(Location(1,1))] = root(1,Location(1,1))
rootnetworks.append(MasterRoot(1))

# - check
def check():
    for net in rootnetworks:
        if net.alive:
            return True
    return False

# - printer
def outputText():
    bigx:int | None = None
    bigy:int | None = None
    smallx:int | None = None
    smally:int | None = None

    for strloc, aroot in allroots.items():
        if bigx is None:
            bigx = aroot.location.x
        elif aroot.location.x > bigx:
            bigx = bigx = aroot.location.x
        
        if smallx is None:
            smallx = aroot.location.x
        elif aroot.location.x < smallx:
            smallx = aroot.location.x

        if bigy is None:
            bigy = aroot.location.y
        elif aroot.location.y > bigy:
            bigy = aroot.location.y

        if smally is None:
            smally = aroot.location.y
        elif aroot.location.y < smally:
            smally = aroot.location.y

    outputstring:str = ""
    for x in range(smallx,bigx+1):
        outputstring += "\n"
        for y in range(smally,bigy+1):
            isroot:bool = False
            rootid:int
            for loc, broot in allroots.items():
                if (str(Location(x,y)) != str(broot.location)):
                    continue
                isroot = True
                rootid = broot.id
                break
            if isroot:
                outputstring += str(rootid)
            else:
                outputstring += '.'
    print(outputstring)

    terrainstring:str = ""
    for x in range(smallx,bigx+1):
        terrainstring += "\n"
        for y in range(smally,bigy+1):
            if str(Location(x,y)) in allroots:
                terrainstring += str(allroots[str(Location(x,y))].nutrients)
            else:
                terrainstring += str(getTerrain(Location(x,y)))
    terrainstring += '\n'
    print(terrainstring)
        




# - main loop
frame:int = 1
outputText()
while check():
    print("frame ",frame)
    for network in rootnetworks:
        if not network.alive:
            continue
        print("network ", network.id, " alive")

    outputText()

    for network in rootnetworks:
        if not network.alive:
            continue
        addednutrients:int = 0
        filteredlist = []
        for loc, val in allroots.items():
            if val.id == network.id:
                filteredlist.append(val)

        for croot in filteredlist:
            addednutrients += croot.nutrients
            if croot.nutrients > 0:
                croot.nutrients -= 1
                neighbors = croot.getNeighbors()
                validneighbors = list(filter(lambda rt: str(rt) not in allroots, neighbors))
                if len(validneighbors) > 0:
                    random.seed(datetime.datetime.now().timestamp())
                    randomchoice = random.randint(1,len(validneighbors))-1
                    allroots[str(validneighbors[randomchoice])] = root(network.id,validneighbors[randomchoice])

        if len(filteredlist) > addednutrients:
            network.alive = False
            print("network ", network.id, " dies.")
    frame+=1















