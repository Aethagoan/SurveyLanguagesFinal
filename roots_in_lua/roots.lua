-- simulation parameters
TERRAINSEED = 10299223798
MAXNUTRIENT = 5


-- structures
testlist = { list = {}}
testlist.__index = testlist
function testlist:new()
    local newlist = { list = {}}
    setmetatable(newlist,self)
    return newlist
end
function testlist:add(key, data)
    if self.list[key] == nil then
        -- print("adding " .. n)
        self.list[key] = data
    -- else
        -- print(n .. " already in there\n")
    end
end
function testlist:includes(key)
    if self.list[key] ~= nil then
        -- print("found " .. n)
        return true
    else
        -- print(n .. " not found")
        return false
    end
end
function testlist:set(key, value)
    if self:includes(key) then
        self.list[key] = value
    end
end

location = {}
location.__index = location
function location:new(_x,_y)
    local newloc = {x = _x, y = _y}
    setmetatable(newloc,self)
    return newloc
end
function location:getneighbors()
    return {location:new(self.x-1,self.y+1),location:new(self.x,self.y+1),location:new(self.x+1,self.y+1),location:new(self.x-1,self.y),location:new(self.x+1,self.y),location:new(self.x-1,self.y-1),location:new(self.x,self.y-1),location:new(self.x+1,self.y-1)}
end
function location:toString()
    return self.x .. "," .. self.y
end

terrain = {}
function terrain.getlocation(passedinlocation)
    -- print("getting loc " .. passedinlocation.x .. " " .. passedinlocation.y)
    math.randomseed(passedinlocation.x + TERRAINSEED * passedinlocation.y)
    first = math.random(1000)
    math.randomseed(passedinlocation.y + TERRAINSEED * passedinlocation.x)
    second = math.random(1000)
    return math.abs(math.floor((first + second)%(MAXNUTRIENT+1)))
end

root = {}
root.__index = root
function root:new(_id, _loc, _nutrients)
    local newroot = {id = _id, loc = _loc, nutrients = _nutrients}
    setmetatable(newroot,self)
    return newroot
end



-- root setup
masterrootlist = testlist:new()
function masterrootlist:hasliving()
    for id, lives in pairs(masterrootlist.list) do
        -- print(id," ",lives)
        if lives then return true
        end
    end
    return false
end

allrootlist = testlist:new()

-- insert into them
masterrootlist:add(1, true)
startlocation = location:new(2,1)
allrootlist:add(startlocation:toString(),root:new(1,startlocation,terrain.getlocation(startlocation)))

masterrootlist:add(2,true)
secondstartlocation = location:new(10,10)
allrootlist:add(secondstartlocation:toString(),root:new(2,secondstartlocation,terrain.getlocation(secondstartlocation)))



-- other functions

-- print function
-- takes in allrootlist
function printroots()
    mins_and_maxs = {}
    local max_x = "max_x"
    local min_x = "min_x"
    local max_y = "max_y"
    local min_y = "min_y"
    for loc, aroot in pairs(allrootlist.list) do
        -- print("type of loc " .. type(aroot.loc))
        -- print("type of loc.x " .. type(aroot.loc.x))
        -- print("type of loc.y " .. type(aroot.loc.y))

        if mins_and_maxs[max_x] == nil then
            mins_and_maxs[max_x] = aroot.loc.x
        elseif mins_and_maxs[max_x] < aroot.loc.x then
            mins_and_maxs[max_x] = aroot.loc.x
        end
        if mins_and_maxs[max_y] == nil then
            mins_and_maxs[max_y] = aroot.loc.y
        elseif mins_and_maxs[max_y] < aroot.loc.y then
            mins_and_maxs[max_y] = aroot.loc.y
        end
        if mins_and_maxs[min_x] == nil then
            mins_and_maxs[min_x] = aroot.loc.x
        elseif mins_and_maxs[min_x] > aroot.loc.x then
            mins_and_maxs[min_x] = aroot.loc.x
        end
        if mins_and_maxs[min_y] == nil then
            mins_and_maxs[min_y] = aroot.loc.y
        elseif mins_and_maxs[min_y] > aroot.loc.y then
            mins_and_maxs[min_y] = aroot.loc.y
        end
    end
    outstring = ""
    for i = mins_and_maxs[min_x], mins_and_maxs[max_x] do
        for j = mins_and_maxs[min_y], mins_and_maxs[max_y] do
            checklocation = location:new(i,j)
            if allrootlist:includes(checklocation:toString()) then 
                -- print("included!")
                outstring = outstring .. allrootlist.list[checklocation:toString()].id
            else
                outstring = outstring .. "."
            end
        end
        outstring = outstring .. "\n"
    end
    print(outstring)
    outstring2 = ""
    for i = mins_and_maxs[min_x], mins_and_maxs[max_x] do
        for j = mins_and_maxs[min_y], mins_and_maxs[max_y] do
            checklocation = location:new(i,j)
            if allrootlist:includes(checklocation:toString()) then 
                -- print("included!")
                outstring2 = outstring2 .. allrootlist.list[checklocation:toString()].nutrients
            else
                outstring2 = outstring2 .. terrain.getlocation(location:new(i,j))
            end
        end
        outstring2 = outstring2 .. "\n"
    end
    print(outstring2)
end


-- copy function
function shallow_copy(orig)
    local copy = {}
    for k, v in pairs(orig) do
        copy[k] = v
    end
    return copy
end


-- -- -- main loop!
if masterrootlist:hasliving() then 
    repeat
    
    -- print the next frame
    printroots()
    
    -- then calculate the next frame
    for id, living in pairs(masterrootlist.list) do
        -- print(id)
        if living then 
            -- count the nutrients in root networks and the size of network
            nutr_cnt = 0
            netw_cnt = 0
            for loc, aroot in pairs(allrootlist.list) do
                if aroot.id == id then 
                    nutr_cnt = nutr_cnt + aroot.nutrients
                    netw_cnt = netw_cnt + 1
                end
            end
            print("nutrient count network " .. id .. ": " .. nutr_cnt)
            print("network size network " .. id .. ": " .. netw_cnt)
            if netw_cnt > nutr_cnt then 
                masterrootlist:set(id,false)
                print("network " .. id .. " died" )
                print("\n")
                goto jumpout -- continue
            end
            for loca, aroot in pairs(shallow_copy(allrootlist.list)) do
                -- print("look at " .. loc.x .. " " .. loc.y)
                if aroot.id == id then
                    if aroot.nutrients > 0 then
                        neighbors = aroot.loc:getneighbors()
                        validneighbors = {}
                        for i, neighbor in pairs(neighbors) do
                            -- print(neighbor.x .. " " .. neighbor.y)
                            if not allrootlist:includes(neighbor:toString()) then
                                table.insert(validneighbors,neighbor)
                            end
                        end
                        math.randomseed(os.time() + os.clock() * 100000)
                        if #validneighbors > 1 then
                            randneighbornumber = math.random(1,#validneighbors)
                            allrootlist:add(validneighbors[randneighbornumber]:toString(),root:new(id, validneighbors[randneighbornumber], terrain.getlocation(validneighbors[randneighbornumber])))
                        end
                        aroot.nutrients = aroot.nutrients - 1
                    end
                end
            end

        end

        ::jumpout::
    end

until not masterrootlist:hasliving()
end

printroots()