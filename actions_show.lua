aura_env.initializeRings()

if (aura_env.config.isGraphicEnabled) then
    aura_env.highlightRing(aura_env.count)
else
    aura_env.hideAllRings()
end
