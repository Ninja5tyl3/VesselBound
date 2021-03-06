species = {"generic", "human", "glitch", "hylotl", "apex", "avian", "floran", "novakid"}

function init(args)
  if not virtual then
    activate()
  end
end

-- Change Animation
function applySpeciesId()
  if storage.speciesId==nil then storage.speciesId = 1 
  elseif storage.speciesId > #species then storage.speciesId = 1 end  
    animator.setAnimationState("raceState", species[storage.speciesId])
end

function nextSpeciesId()
  if storage.speciesId==nil then storage.speciesId = 0 end
  storage.speciesId = storage.speciesId+1
  applySpeciesId()
end 

function activate()
--  sb.logInfo("activating!")
  object.setInteractive(true)
  applySpeciesId()
end

function onInteraction(args)
--  sb.logInfo("interaction")
  nextSpeciesId()
--  object.say(species[storage.speciesId])
end

function isActive()
  return not object.isInputNodeConnected(0) or object.getInputNodeLevel(0) and #pipeUtil.getOutputIds()>0
end 

function getRace(itemDescriptor)
  local inRootConfig = pipeUtil.itemConfig(itemDescriptor)

  if inRootConfig then 
    if inRootConfig.config.race ~= nil then
      return inRootConfig.config.race
    else 
      for _,v in pairs(species) do
        if string.find(itemDescriptor.name, v) or string.find(inRootConfig.directory, v) then 
          return v
        end 
      end
    end
  end

  return "generic"
end

function canReceiveItem(itemDescriptor)
  if isActive() and itemDescriptor ~= nil then
    local race = species[storage.speciesId];
    local itemRace = getRace(itemDescriptor)
    --object.say("selector:"..race.." vs ".."item:"..itemRace)
    return itemRace==race
  end   

  return false
end

function canReceiveLiquid(liquidId, liquidLevel)
  local itemDescriptor = pipeUtil.liquidToItemDescriptor(liquidId, liquidLevel)
  return canReceiveItem(itemDescriptor)
end

function receiveItem(itemDescriptor, pathIds)
  return pipeUtil.sendItem(itemDescriptor, entity.id(), pathIds)
end

function receiveLiquid(liquidId, liquidLevel, pathIds)
  return pipeUtil.sendLiquid(liquidId, liquidLevel, entity.id(), pathIds)
end