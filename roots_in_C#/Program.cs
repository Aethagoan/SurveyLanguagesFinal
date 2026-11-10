

// initialization
List<MasterRoot> rootnetworks = new();
Dictionary<string,root> allroots = new();

// this is how to set up a root. could stand to be more elegant.
var startlocation = new Location(0,0);
allroots.Add(startlocation.stringify(),new root(1, startlocation));
rootnetworks.Add(new MasterRoot(1));

var startlocation2 = new Location(10,10);
allroots.Add(startlocation2.stringify(),new root (2, startlocation2));
rootnetworks.Add(new MasterRoot(2));

// this is for output



//frame
int i = 0;
while (check()){
    Console.WriteLine();
    Console.WriteLine($"frame {i}:");
    foreach (var network in rootnetworks)
    {
        if (network.alive) Console.WriteLine($"network {network.id}: alive");
    }
    OutputText();
    frame();
    i++;
}

// finally...
Console.WriteLine();
foreach (var network in rootnetworks)
{
    if (network.alive) Console.WriteLine($"network {network.id}: alive");
}
OutputText();


bool check() {
    foreach (var rootsys in rootnetworks){
        if (rootsys.alive) return true;
    }
    return false;
}

void OutputText() {
    // find limits of the thing
    int bigx = 0;
    int bigy = 0;
    int smallx = 0;
    int smally = 0;


    foreach (var proot in allroots.Values){
        // find biggest x
        if (proot.location.x > bigx) bigx = proot.location.x;
        // find smallest x
        if (proot.location.x < smallx) smallx = proot.location.x;
        // find biggest y
        if (proot.location.y > bigy) bigy = proot.location.y;
        // find smallest y
        if (proot.location.y < smally) smally = proot.location.y;
    }

    string outputstring = "";
    for (int x = smallx; x <= bigx; x++){
        outputstring += "\n";
        for (int y = smally; y <= bigy; y++){
            bool isroot = false;
            int rootid = 0;
            foreach (root qroot in allroots.Values) {
                if (new Location(x,y).stringify() != qroot.location.stringify()) {
                    continue;
                }
                isroot = true;
                rootid = qroot.id;
                break;
            }
            if (isroot) outputstring += $"{rootid}";
            else outputstring += '.';
        }
    }
    outputstring+='\n';
    Console.Write(outputstring);

    string terrainstring = "";
    for (int x = smallx; x <= bigx; x++) {
        terrainstring += "\n";
        for (int y = smally; y <= bigy; y++){
            if (allroots.ContainsKey(new Location(x,y).stringify())) terrainstring += allroots[new Location(x,y).stringify()].nutrientcount;
            else terrainstring += $"{Terrain.getTerrain(new Location(x,y))}";
        }
    }
    terrainstring += "\n";
    Console.Write(terrainstring);

    // File.AppendAllText("./rootsoutput.txt",outputstring);
    // File.AppendAllText("./rootsoutput.txt",terrainstring);

}

void frame()
{
    foreach (var network in rootnetworks)
    {
        if (!network.alive) continue;
        List<root> filteredlist = new();
        foreach (var aroot in allroots.Values)
        {
            if (aroot.id == network.id) filteredlist.Add(aroot);
        }
        int addedNutrients = 0;
        foreach (var broot in filteredlist)
        {
            // add to count
            addedNutrients += broot.nutrientcount;
            if (broot.nutrientcount > 0)
            {
                // reduce nutrient count
                broot.nutrientcount--;
                // attempt to grow.

                var neighbors = broot.getNeighbors();
                List<Location> validneighbors = new();

                // if a neighbor location is found in the list it is not added to validneighbors
                foreach (var neighbor in neighbors)
                {
                    bool inlist = false;
                    foreach (var croot in allroots.Values)
                    {
                        if (!(croot.location.stringify() == neighbor.stringify()))
                        {
                            // if this neighbor is not found at this root, continue.
                            continue;
                        }
                        // this is in the list >:(
                        inlist = true;
                        break;
                    }
                    if (!inlist) validneighbors.Add(neighbor);
                }

                // if there is a valid neighbor, pick a random one and create a new root.
                var therandomchoice = new Random().Next(validneighbors.Count);
                if (validneighbors.Count > 0) allroots.Add(validneighbors[therandomchoice].stringify(),new root(broot.id, validneighbors[therandomchoice]));
            }
        }
        if (filteredlist.Count > addedNutrients){
            network.alive = false;
            Console.WriteLine($"\nNetwork {network.id} died.");
        } 
        // Console.WriteLine($"network {network.id} total nutrients: {addedNutrients}, size: {filteredlist.Count}");
    }
}
















// class stuff

class programvalues {
    public const int SEED = 12323423;
    public const int MAXNUTRIENT = 4;
}


class Terrain
{

    public static int getTerrain(Location location)
    {
        return Math.Abs((new Random(location.x + programvalues.SEED * location.y).Next() + new Random(location.y + programvalues.SEED * location.x).Next()) % (programvalues.MAXNUTRIENT + 1));
    }

}

class Location {
    public int x;
    public int y;
    public Location(int _x,int _y){
        x = _x;
        y = _y;
    }
    public string stringify() {
        return $"{x},{y}";
    }
}

class root
{
    public int id;
    public Location location;
    public int nutrientcount;

    public root(int _id, Location _location)
    {
        id = _id;
        location = _location;
        nutrientcount = Terrain.getTerrain(_location);
    }

    public List<Location> getNeighbors()
    {
        return new List<Location> {
            new Location(location.x-1,location.y),
            new Location(location.x+1,location.y),
            new Location(location.x-1,location.y-1),
            new Location(location.x,location.y-1),
            new Location(location.x+1,location.y-1),
            new Location(location.x-1,location.y+1),
            new Location(location.x,location.y+1),
            new Location(location.x+1,location.y+1)
            };
    }

}


class MasterRoot
{
    public int id;
    public bool alive;

    public MasterRoot(int _id)
    {
        id = _id;
        alive = true;
    }
}

