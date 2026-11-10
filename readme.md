
# Name: Roots

## How it works:
The idea is to have a bunch of objects represent roots in a world with randomly generated nutrients spread throughout.

### nutrient / terrain generation  
  A seed is given to a random generator, and when we have to interact with terrain we return the value from that class after passing in the location.  

  example:  
    int get_terrain(x,y){
      return Math.Abs((new Random(x + seed * y).Next() + new Random(y + seed * x).Next()) % (maxNutrientOnSpace + 1));
    }
  
  it should return an int, based on Maxnutrient  


## ROOT OBJECT SPECIFICATION:
  an object with  
  an ID, when it creates new roots it passes this ID.  
  a location  
  a nutrient count (decreases by 1 each frame.)  
  
  a function that returns neighbor spaces  


## MASTER ROOT OBJECT SPECIFICATION (put into a list):
  an object with  
  an ID  
  a bool saying whether this ID (network) is still alive  


# LIFE CYCLE:
  when we calculate the next frame, root networks either live or die.  
  If a root network has enough nutrients, it survives.  
  (enough nutrients is defined as the network size vs the total nutrients 'under' (actually in the root objects) roots).
  if a root has nutrients (1 or greater), it tries to create a new root.


PER FRAME:  
  there is a list of all roots.  
  list of root IDS:  
    for each root ID:  
      if this ID is alive:  
        in the list of all roots:    
          filter all root list for this ID,  
          add all the nutrients from those roots you get from the filter  
          compare it to the size of the network  
          if it dies (not enough nutrients), mark it as dead and jump out/break.  
          if it lives:  
            for each of those roots, if it has nutrients, try to create a new root.  


## RULES:
  roots can only grow to unoccupied spaces, and dead roots occupy spaces, even if the dead roots still have nutrients in them. (this makes the game a lot simpler)

### INTENDED USER:
  This project would count as a very basic simulation of cell growth,
  which might be of interest to those trying to simulate things like that.

### MOTIVATION:
  I liked the idea of this project, and it was similar to GOL
  I found that it was much more a simulation of 'life' than
  GOL is, which is fun to play with for me.
