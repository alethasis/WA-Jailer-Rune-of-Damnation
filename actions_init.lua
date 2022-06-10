-- CONSTANTS
aura_env.assignmentTextMap = {
    "CENTER", "LEFT", "RIGHT", "BACK LEFT", "BACK CENTER", "BACK RIGHT"
}
aura_env.orange = {1, 0.6, 0}
aura_env.offwhite = {0.8, 0.8, 0.8}

-- UTIL
aura_env.inverse = function(v) return v * -1 end

aura_env.startsWith =
    function(str, start) return str:sub(1, #start) == start end

aura_env.createCircle = function(diameter, color, frameLevel, ofsx, ofsy)
    local red = color[1]
    local green = color[2]
    local blue = color[3]
    local alpha = color[4] or 1

    local frame = CreateFrame("Frame", nil, aura_env.region)

    frame:SetPoint("CENTER", aura_env.region, "CENTER", ofsx, ofsy)
    frame:SetSize(diameter, diameter)
    frame:SetFrameLevel(frameLevel)

    frame.texture = frame:CreateTexture(nil, "ARTWORK")
    frame.texture:SetTexture(
        "Interface\\AddOns\\WeakAuras\\Media\\Textures\\Circle_White.tga")
    frame.texture:SetVertexColor(red, green, blue, alpha)
    frame.texture:SetAllPoints(frame)

    return frame
end

aura_env.animateRing = function(frame)
    local ag = frame:CreateAnimationGroup()

    local fadeOut = ag:CreateAnimation("Alpha")
    fadeOut:SetFromAlpha(1)
    fadeOut:SetToAlpha(0.4)
    fadeOut:SetDuration(0.4)
    fadeOut:SetOrder(1)
    fadeOut:SetSmoothing("IN_OUT")

    local fadeIn = ag:CreateAnimation("Alpha")
    fadeIn:SetFromAlpha(0.4)
    fadeIn:SetToAlpha(1)
    fadeIn:SetDuration(0.4)
    fadeIn:SetOrder(2)
    fadeIn:SetSmoothing("IN_OUT")

    ag:SetLooping("REPEAT")
    ag:Play()
end

aura_env.showFrames = function(frames)
    for _, frame in ipairs(frames) do frame:Show() end
end

aura_env.hideFrames = function(frames)
    for _, frame in ipairs(frames) do frame:Hide() end
end

---------------------------------------------------------------------------------------------------

aura_env.highlightRing = function(index)
    aura_env.hideFrames(aura_env.highlightRings)
    aura_env.showFrames(aura_env.baseRings)
    aura_env.highlightRings[index]:Show()
end

aura_env.hideAllRings = function()
    if (aura_env.baseRings) then aura_env.hideFrames(aura_env.baseRings) end

    if (aura_env.highlightRings) then
        aura_env.hideFrames(aura_env.highlightRings)
    end
end

aura_env.createRingPairs = function(index, backdropColor, highlightColor)
    local frameLevel = 500 - (index * 5)
    local diameter = 20
    local diameterHighlightRing = diameter + 8
    local margin = 10

    local startingX = 0
    local startingY = -40

    local offsets = {
        [1] = {
            startingX, -- X
            startingY -- Y
        },
        [2] = {
            aura_env.inverse((diameter + margin) / 2), -- X
            aura_env.inverse(diameter + margin) + startingY -- Y
        },
        [3] = {
            (diameter + margin) / 2, -- X
            aura_env.inverse(diameter + margin) + startingY -- Y
        },
        [4] = {
            aura_env.inverse(diameter + margin), -- X
            aura_env.inverse((diameter + margin) * 2) + startingY -- Y
        },
        [5] = {
            startingX, -- X
            aura_env.inverse((diameter + margin) * 2) + startingY -- Y
        },
        [6] = {
            diameter + margin, -- X
            aura_env.inverse((diameter + margin) * 2) + startingY -- Y
        }
    }

    local ofs = offsets[index]
    local ofsx = ofs[1]
    local ofsy = ofs[2]

    local baseRing = aura_env.createCircle(diameter, backdropColor, frameLevel,
                                           ofsx, ofsy)

    local highlightedRing = aura_env.createCircle(diameterHighlightRing,
                                                  highlightColor,
                                                  frameLevel + 2, ofsx, ofsy)
    aura_env.animateRing(highlightedRing)

    return baseRing, highlightedRing
end

-- STATE
aura_env.initializeRings = function()
    if (not aura_env.baseRings or not aura_env.highlightedRings) then
        local baseRings = {}
        local highlightRings = {}

        local maxNumRings = table.getn(aura_env.assignmentTextMap)
        local baseRingColor = aura_env.config.circleColors.ringColorBase or
                                  aura_env.offwhite
        local highlightRingColor = aura_env.config.circleColors
                                       .ringColorHighlight or aura_env.orange

        for i = 1, maxNumRings do
            local baseRing, highlightRing =
                aura_env.createRingPairs(i, baseRingColor, highlightRingColor)

            table.insert(baseRings, baseRing)
            table.insert(highlightRings, highlightRing)
        end

        aura_env.baseRings = baseRings
        aura_env.highlightRings = highlightRings
    end
end

aura_env.resetCount = function() aura_env.count = 0 end

aura_env.incrementCount = function()
    if not aura_env.count then aura_env.resetCount() end
    aura_env.count = aura_env.count + 1
end

-- INIT
aura_env.initializeRings()
aura_env.hideAllRings()
aura_env.resetCount()

-- MOCK
if (WeakAuras.IsOptionsOpen() and aura_env.config.isGraphicEnabled) then
    aura_env.initializeRings()
    aura_env.highlightRing(1)
end
