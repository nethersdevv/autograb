local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

-- CONFIGURATION DIRECTE
local stealCooldown = 0.2  -- Vitesse de vol
local HOLD_DURATION = 0.5  -- Temps de maintien du prompt
local stealingEnabled = true -- Activé par défaut

-- LOGIQUE D'EXTRACTION
local function getCharacter()
    return player.Character or player.CharacterAdded:Wait()
end

local function getHRP()
    local char = getCharacter()
    return char:WaitForChild("HumanoidRootPart", 5)
end

local function getPromptPart(prompt)
    local parent = prompt.Parent
    if parent:IsA("BasePart") then return parent end
    if parent:IsA("Model") then
        return parent.PrimaryPart or parent:FindFirstChildWhichIsA("BasePart")
    end
    if parent:IsA("Attachment") then return parent.Parent end
    return parent:FindFirstChildWhichIsA("BasePart", true)
end

local function findNearestStealPrompt(hrp)
    local nearestPrompt = nil
    local minDist = math.huge
    local plots = workspace:FindFirstChild("Plots")
    if not plots then return nil end
    
    for _, desc in pairs(plots:GetDescendants()) do
        if desc:IsA("ProximityPrompt") and desc.Enabled and desc.ActionText == "Steal" then
            local part = getPromptPart(desc)
            if part then
                local dist = (hrp.Position - part.Position).Magnitude
                if dist < minDist then
                    minDist = dist
                    nearestPrompt = desc
                end
            end
        end
    end
    return nearestPrompt
end

local function triggerPrompt(prompt)
    if not prompt or not prompt:IsDescendantOf(workspace) then return end
    
    -- Bypass des restrictions de distance
    prompt.MaxActivationDistance = 9e9
    prompt.RequiresLineOfSight = false
    
    local usedFire = pcall(function()
        fireproximityprompt(prompt, 9e9, HOLD_DURATION)
    end)
    
    if not usedFire then
        pcall(function()
            prompt:InputHoldBegin()
            task.wait(HOLD_DURATION)
            prompt:InputHoldEnd()
        end)
    end
end

-- BOUCLE D'ACTIVATION DIRECTE
task.spawn(function()
    print("NOKS AUTO GRAB : Activation directe (Sans UI)")
    while stealingEnabled do
        local hrp = getHRP()
        if hrp then
            local prompt = findNearestStealPrompt(hrp)
            if prompt then
                triggerPrompt(prompt)
            end
        end
        task.wait(stealCooldown)
    end
end)
