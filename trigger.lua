function (allstates, event, ...)
    local runeOfDamnationDebuffID = 360281

    -- local runeOfDamnationDebuffID = 101643 -- Transcendence - Monk TEST

    if (event == "COMBAT_LOG_EVENT_UNFILTERED") then
        local _, subEvent, _, _, sourceName, _, _, destGUID, destName, _, _,
              spellID = ...

        if (subEvent == "SPELL_AURA_APPLIED" and spellID ==
            runeOfDamnationDebuffID) then
            -- Order matters 
            aura_env.incrementCount()

            if (UnitIsUnit(destName, "player")) then
                allstates[destName] = {
                    show = true,
                    changed = true,
                    assignmentText = aura_env.assignmentTextMap[aura_env.count],
                    count = aura_env.count
                }
                return true
            end
        elseif (subEvent == "SPELL_AURA_REMOVED" and spellID ==
            runeOfDamnationDebuffID) then
            -- Order matters
            aura_env.resetCount()

            if (UnitIsUnit(destName, "player")) then
                allstates[destName] = {
                    show = false,
                    changed = true,
                    count = aura_env.count
                }
                return true
            end
        end
    end
end
