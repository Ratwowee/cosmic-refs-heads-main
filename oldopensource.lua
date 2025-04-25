-- Cosmic Hub FTAP
Players = game:GetService("Players")
RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Debris = game:GetService("Debris")

local GrabEvents = ReplicatedStorage:WaitForChild("GrabEvents")
local MenuToys = ReplicatedStorage:WaitForChild("MenuToys")
local CharacterEvents = ReplicatedStorage:WaitForChild("CharacterEvents")
local SetNetworkOwner = GrabEvents:WaitForChild("SetNetworkOwner")
local Struggle = CharacterEvents:WaitForChild("Struggle")
local CreateLine = GrabEvents:WaitForChild("CreateGrabLine")
local DestroyLine = GrabEvents:WaitForChild("DestroyGrabLine")
local DestroyToy = MenuToys:WaitForChild("DestroyToy")

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local localPlayer = Players.LocalPlayer
local CharacterEvents = ReplicatedStorage:WaitForChild("CharacterEvents")
local StruggleRemote = CharacterEvents:WaitForChild("Struggle")
local RagdollRemote = CharacterEvents:WaitForChild("RagdollRemote")
local BeingHeld = localPlayer:WaitForChild("IsHeld")
_G.antiBlobmanActive = false
_G.toggleActiveAntiKick = false
_G.initialPosition = nil
_G.velocityThreshold = 1000
_G.grabDistanceThreshold = 10

local selectedPlayer

local function getAllPlayers()
    local playerNames = {}
    for _, player in ipairs(Players:GetPlayers()) do
        table.insert(playerNames, player.Name)
    end
    return playerNames
end

local playerDropdown
Players.PlayerAdded:Connect(function()
    if playerDropdown then
        playerDropdown:Refresh(getAllPlayers(), true)
    end
end)
Players.PlayerRemoving:Connect(function()
    if playerDropdown then
        playerDropdown:Refresh(getAllPlayers(), true)
    end
end)


-- // Helper Functions
function runAntiKickLoop()
    while _G.toggleActiveAntiKick do
        local humanoidRootPart = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
        if humanoidRootPart then
            RagdollRemote:FireServer(humanoidRootPart, 0)
        end
        task.wait(1)
    end
end

local antiKickCoroutine
function toggleAntiKick(state)
    _G.toggleActiveAntiKick = state
    if state and not antiKickCoroutine then
        antiKickCoroutine = coroutine.create(runAntiKickLoop)
        coroutine.resume(antiKickCoroutine)
    elseif not state and antiKickCoroutine then
        antiKickCoroutine = nil
    end
end
function resetVelocityAndPosition(humanoidRootPart)
    humanoidRootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
    humanoidRootPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
    humanoidRootPart.CFrame = CFrame.new(_G.initialPosition)
end
function antiBlobmanLoop()
    while _G.antiBlobmanActive do
        local char = localPlayer.Character
        local humanoidRootPart = char and char:FindFirstChild("HumanoidRootPart")
        
        if humanoidRootPart and BeingHeld.Value then
            local velocity = humanoidRootPart.AssemblyLinearVelocity
            local distanceMoved = (humanoidRootPart.Position - _G.initialPosition).Magnitude
            
            -- Check for excessive movement
            if velocity.Magnitude > _G.velocityThreshold or distanceMoved > _G.grabDistanceThreshold then
                resetVelocityAndPosition(humanoidRootPart)
                StruggleRemote:FireServer(localPlayer) 
            end
        end
        task.wait(0.05) 
    end
end

local antiBlobmanCoroutine
function toggleAntiBlobman(state)
    _G.antiBlobmanActive = state
    _G.initialPosition = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") and localPlayer.Character.HumanoidRootPart.Position or Vector3.new(0, 0, 0)
    if state and not antiBlobmanCoroutine then
        antiBlobmanCoroutine = coroutine.create(antiBlobmanLoop)
        coroutine.resume(antiBlobmanCoroutine)
    elseif not state and antiBlobmanCoroutine then
        antiBlobmanCoroutine = nil
    end
end

function toggleProtections(state)
    toggleAntiKick(state)
    toggleAntiBlobman(state)
end



local localPlayer = Players.LocalPlayer
local playerCharacter = localPlayer.Character or localPlayer.CharacterAdded:Wait()

localPlayer.CharacterAdded:Connect(function(character)
playerCharacter = character
end)

local ragdollAllCoroutine
local fireAllCoroutine







local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/BlizTBr/scripts/main/Orion%20X')))()
OrionLib:MakeNotification({
Name = "Welcome to Cosmic Hub!",
Content = "wink wink",
Image = "rbxassetid://4483345998",
Time = 20
})

local Window = OrionLib:MakeWindow({Name = "Cosmic Hub FTAP", HidePremium = false, SaveConfig = true, ConfigFolder = "CosmicHubFTAPConfig"})

local Tab = Window:MakeTab({
Name = "Player",
Icon = "rbxassetid://4483345998",
PremiumOnly = false
})

local Tab = Window:MakeTab({
Name = "Invincibility",
Icon = "rbxassetid://4483345998",
PremiumOnly = false
})

local Section = Tab:AddSection({
Name = "Anti"
})

Tab:AddButton({
Name = "Anti Grab",
Callback = function()
local PS = game:GetService("Players")
local Player = PS.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local RS = game:GetService("ReplicatedStorage")
local CE = RS:WaitForChild("CharacterEvents")
local R = game:GetService("RunService")
local BeingHeld = Player:WaitForChild("IsHeld")
local PlayerScripts = Player:WaitForChild("PlayerScripts")

--[[ Remotes ]]
local StruggleEvent = CE:WaitForChild("Struggle")

--[[ Anti-Explosion ]]
workspace.DescendantAdded:Connect(function(v)
if v:IsA("Explosion") then
v.BlastPressure = 0
end
end)

--[[ Anti-grab ]]
local initialPosition -- Variable to store the initial position

BeingHeld.Changed:Connect(function(C)
if C == true then
local char = Player.Character

if BeingHeld.Value == true then
local Event
Event = R.RenderStepped:Connect(function()
if BeingHeld.Value == true then
char["HumanoidRootPart"].AssemblyLinearVelocity = Vector3.new()
StruggleEvent:FireServer(Player)
elseif BeingHeld.Value == false then
Event:Disconnect()
end
end)

-- Store the initial position when grabbed
initialPosition = char.HumanoidRootPart.Position
end
end
end)

local function reconnect()
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:FindFirstChildWhichIsA("Humanoid") or Character:WaitForChild("Humanoid")
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

HumanoidRootPart:WaitForChild("FirePlayerPart"):Remove()

Humanoid.Changed:Connect(function(C)
if C == "Sit" and Humanoid.Sit == true then
if Humanoid.SeatPart ~= nil and tostring(Humanoid.SeatPart.Parent) == "CreatureBlobman" then
elseif Humanoid.SeatPart == nil then
Humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)
Humanoid.Sit = false
end
end
end)
end

reconnect()

Player.CharacterAdded:Connect(reconnect)

-- Function to teleport the player back to the initial position when grabbed
local function teleportToInitialPosition()
if initialPosition then
local Character = Player.Character
if Character then
local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
if HumanoidRootPart then
HumanoidRootPart.CFrame = CFrame.new(initialPosition)
end
end
end
end

-- Connect the teleport function to the StruggleEvent
StruggleEvent.OnClientEvent:Connect(teleportToInitialPosition)

end
})

Tab:AddButton({
Name = "Anti Lag",
Callback = function()
game.ReplicatedStorage.GrabEvents.CreateGrabLine:Destroy()
end
})

Tab:AddToggle({
    Name = "Anti Blobman",
    Default = false,
    Callback = toggleProtections
})
function resetPositionIfNeeded()
    if _G.antiBlobmanActive and localPlayer.Character then
        local humanoidRootPart = localPlayer.Character:FindFirstChild("HumanoidRootPart")
        if humanoidRootPart and BeingHeld.Value then
            local distanceMoved = (humanoidRootPart.Position - _G.initialPosition).Magnitude
            if distanceMoved > _G.grabDistanceThreshold then
                resetVelocityAndPosition(humanoidRootPart)
            end
        end
    end
end

RunService.Heartbeat:Connect(resetPositionIfNeeded)


local  function setupAntiExplosion(character)
     local partOwner = character:WaitForChild("Humanoid"):FindFirstChild("Ragdolled")
     if partOwner then
         local partOwnerChangedConn
         partOwnerChangedConn = partOwner:GetPropertyChangedSignal("Value"):Connect(function()
             if partOwner.Value then
                 for _, part in ipairs(character:GetChildren()) do
                     if part:IsA("BasePart") then
                         part.Anchored = true
                     end
                 end
             else
                 for _, part in ipairs(character:GetChildren()) do
                     if part:IsA("BasePart") then
                         part.Anchored = false
                     end
                 end
             end
         end)
         antiExplosionConnection = partOwnerChangedConn
     end
 end
 
 Tab:AddToggle({
     Name = "Anti Explosion",
     Default = false,
     Callback = function(enabled)
         local localPlayer = game.Players.LocalPlayer
 
         if enabled then
             if localPlayer.Character then
                 setupAntiExplosion(localPlayer.Character)
             end
           local  characterAddedConn = localPlayer.CharacterAdded:Connect(function(character)
                 if antiExplosionConnection then
                     antiExplosionConnection:Disconnect()
                 end
                 setupAntiExplosion(character)
             end)
         else
             if antiExplosionConnection then
                 antiExplosionConnection:Disconnect()
                 antiExplosionConnection = nil
             end
             if characterAddedConn then
                 characterAddedConn:Disconnect()
                 local characterAddedConn = nil
             end
         end
     end
 })

local Tab = Window:MakeTab({
Name = "Blobman",
Icon = "rbxassetid://4483345998",
PremiumOnly = false
})

local Section = Tab:AddSection({
Name = "Server Fucker"
})

Tab:AddParagraph("WARNING","make sure to ride the blobman BEFORE looping, you will go flying into space. THERE IS NO WHITELIST FOR GOD BLOBMAN LOOP")

Tab:AddButton({
Name = "God Blobman Loop All",
Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/cooldawg123/FTAP/refs/heads/main/crashing.lua",true))()
end
})

local Tab = Window:MakeTab({
Name = "Auras",
Icon = "rbxassetid://4483345998",
PremiumOnly = false
})

local Tab = Window:MakeTab({
Name = "Fun",
Icon = "rbxassetid://4483345998",
PremiumOnly = false
})

local Section = Tab:AddSection({
Name = "Spiderman"
})

Tab:AddLabel("(reset to cancel effects)")


Tab:AddButton({
Name = "Walk on walls",
Callback = function()
loadstring(game:HttpGet("https://pastebin.com/raw/zXk4Rq2r"))()
end
})

local Tab = Window:MakeTab({
Name = "Spy",
Icon = "rbxassetid://4483345998",
PremiumOnly = false
})

local Section = Tab:AddSection({
Name = "Chatspy"
})

Tab:AddLabel("Chat “/spy”to enable/disable")

Tab:AddButton({
Name = "Chatspy",
Callback = function()
enabled = true --chat "/spy to toggle!
spyOnMyself = true --if true will check your messages too
public = false --if true will chat the logs publicly (fun, risky)
publicItalics = true --if true will use /me to stand out
privateProperties = { --customize private logs
Color = Color3.fromRGB(0,255,255);
Font = Enum.Font.SourceSansBold;
TextSize = 18;
}
local StarterGui = game:GetService("StarterGui")
local Players = game:GetService("Players")
local player = Players.LocalPlayer or Players:GetPropertyChangedSignal("LocalPlayer"):Wait() or Players.LocalPlayer
local saymsg = game:GetService("ReplicatedStorage"):WaitForChild("DefaultChatSystemChatEvents"):WaitForChild("SayMessageRequest")
local getmsg = game:GetService("ReplicatedStorage"):WaitForChild("DefaultChatSystemChatEvents"):WaitForChild("OnMessageDoneFiltering")
local instance = (_G.chatSpyInstance or 0) + 1
_G.chatSpyInstance = instance
local function onChatted(p,msg)
if _G.chatSpyInstance == instance then
if p==player and msg:lower():sub(1,4)=="/spy" then
enabled = not enabled
wait(0.3)
privateProperties.Text = "{SPY "..(enabled and "EN" or "DIS").."ABLED}"
StarterGui:SetCore("ChatMakeSystemMessage",privateProperties)
elseif enabled and (spyOnMyself==true or p~=player) then
msg = msg:gsub("[\n\r]",''):gsub("\t",' '):gsub("[ ]+",' ')
local hidden = true
local conn = getmsg.OnClientEvent:Connect(function(packet,channel)
if packet.SpeakerUserId==p.UserId and packet.Message==msg:sub(#msg-#packet.Message+1) and (channel=="All" or (channel=="Team" and public==false and Players[packet.FromSpeaker].Team==player.Team)) then
hidden = false
end
end)
wait(1)
conn:Disconnect()
if hidden and enabled then
if public then
saymsg:FireServer((publicItalics and "/me " or '').."{SPY} [".. p.Name .."]: "..msg,"All")
else
privateProperties.Text = "{SPY} [".. p.Name .."]: "..msg
StarterGui:SetCore("ChatMakeSystemMessage",privateProperties)
end
end
end
end
end
for _,p in ipairs(Players:GetPlayers()) do
p.Chatted:Connect(function(msg) onChatted(p,msg) end)
end
Players.PlayerAdded:Connect(function(p)
p.Chatted:Connect(function(msg) onChatted(p,msg) end)
end)
privateProperties.Text = "{SPY "..(enabled and "EN" or "DIS").."ABLED}"
StarterGui:SetCore("ChatMakeSystemMessage",privateProperties)
if not player.PlayerGui:FindFirstChild("Chat") then wait(3) end
local chatFrame = player.PlayerGui.Chat.Frame
chatFrame.ChatChannelParentFrame.Visible = true
chatFrame.ChatBarParentFrame.Position = chatFrame.ChatChannelParentFrame.Position+UDim2.new(UDim.new(),chatFrame.ChatChannelParentFrame.Size.Y)
end
})

Tab:AddButton({
Name = "Chatspy (Log Publicly)",
Callback = function()
enabled = true --chat "/spy to toggle!
spyOnMyself = true --if true will check your messages too
public = true --if true will chat the logs publicly (fun, risky)
publicItalics = true --if true will use /me to stand out
privateProperties = { --customize private logs
Color = Color3.fromRGB(0,255,255);
Font = Enum.Font.SourceSansBold;
TextSize = 18;
}
local StarterGui = game:GetService("StarterGui")
local Players = game:GetService("Players")
local player = Players.LocalPlayer or Players:GetPropertyChangedSignal("LocalPlayer"):Wait() or Players.LocalPlayer
local saymsg = game:GetService("ReplicatedStorage"):WaitForChild("DefaultChatSystemChatEvents"):WaitForChild("SayMessageRequest")
local getmsg = game:GetService("ReplicatedStorage"):WaitForChild("DefaultChatSystemChatEvents"):WaitForChild("OnMessageDoneFiltering")
local instance = (_G.chatSpyInstance or 0) + 1
_G.chatSpyInstance = instance
local function onChatted(p,msg)
if _G.chatSpyInstance == instance then
if p==player and msg:lower():sub(1,4)=="/spy" then
enabled = not enabled
wait(0.3)
privateProperties.Text = "{SPY "..(enabled and "EN" or "DIS").."ABLED}"
StarterGui:SetCore("ChatMakeSystemMessage",privateProperties)
elseif enabled and (spyOnMyself==true or p~=player) then
msg = msg:gsub("[\n\r]",''):gsub("\t",' '):gsub("[ ]+",' ')
local hidden = true
local conn = getmsg.OnClientEvent:Connect(function(packet,channel)
if packet.SpeakerUserId==p.UserId and packet.Message==msg:sub(#msg-#packet.Message+1) and (channel=="All" or (channel=="Team" and public==false and Players[packet.FromSpeaker].Team==player.Team)) then
hidden = false
end
end)
wait(1)
conn:Disconnect()
if hidden and enabled then
if public then
saymsg:FireServer((publicItalics and "/me " or '').."{SPY} [".. p.Name .."]: "..msg,"All")
else
privateProperties.Text = "{SPY} [".. p.Name .."]: "..msg
StarterGui:SetCore("ChatMakeSystemMessage",privateProperties)
end
end
end
end
end
for _,p in ipairs(Players:GetPlayers()) do
p.Chatted:Connect(function(msg) onChatted(p,msg) end)
end
Players.PlayerAdded:Connect(function(p)
p.Chatted:Connect(function(msg) onChatted(p,msg) end)
end)
privateProperties.Text = "{SPY "..(enabled and "EN" or "DIS").."ABLED}"
StarterGui:SetCore("ChatMakeSystemMessage",privateProperties)
if not player.PlayerGui:FindFirstChild("Chat") then wait(3) end
local chatFrame = player.PlayerGui.Chat.Frame
chatFrame.ChatChannelParentFrame.Visible = true
chatFrame.ChatBarParentFrame.Position = chatFrame.ChatChannelParentFrame.Position+UDim2.new(UDim.new(),chatFrame.ChatChannelParentFrame.Size.Y)
end
})

local Tab = Window:MakeTab({
    Name = "Teleport",
    Icon = "rbxassetid://4483345998", 
    PremiumOnly = false
})

local Section = Tab:AddSection({
Name = "Teleport"
})


Tab:AddDropdown({
Name = "Select Player",
Default = getAllPlayers(),
Options = getAllPlayers(),
Callback = function(value)
selectedPlayer = value
end    
})

Tab:AddButton({
    Name = "Teleport to Player",
    Callback = function()
        if selectedPlayer then
            local targetPlayer = Players:FindFirstChild(selectedPlayer)
            if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local targetPosition = targetPlayer.Character.HumanoidRootPart.Position
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(targetPosition)
                else
                    OrionLib:MakeNotification({
                        Name = "Error",
                        Content = "Your character's HumanoidRootPart was not found.",
                        Time = 5
                    })
                end
            else
                OrionLib:MakeNotification({
                    Name = "Error",
                    Content = "Target player's HumanoidRootPart not found.",
                    Time = 5
                })
            end
        else
            OrionLib:MakeNotification({
                Name = "Error",
                Content = "No player selected.",
                Time = 5
            })
        end
    end
})

local Tab = Window:MakeTab({
Name = "Random",
Icon = "rbxassetid://4483345998",
PremiumOnly = false
})

Tab:AddLabel("Beta")

Tab:AddToggle({
Name = "Ragdoll All",
Color = Color3.fromRGB(240, 0, 0),
Default = false,
Callback = function(enabled)
if enabled then
ragdollAllCoroutine = coroutine.create(ragdollAll)
coroutine.resume(ragdollAllCoroutine)
else
if ragdollAllCoroutine then
coroutine.close(ragdollAllCoroutine)
ragdollAllCoroutine = nil
end
end
end
})

Tab:AddToggle({
Name = "Fire All",
Default = false,
Color = Color3.fromRGB(240, 0, 0),
Callback = function(enabled)
if enabled then
fireAllCoroutine = coroutine.create(fireAll)
coroutine.resume(fireAllCoroutine)
else
if fireAllCoroutine then
coroutine.close(fireAllCoroutine)
fireAllCoroutine = nil
end
end
end
})

local Tab = Window:MakeTab({
Name = "Whitelist",
Icon = "rbxassetid://4483345998",
PremiumOnly = false
})

local Tab = Window:MakeTab({
Name = "Credits",
Icon = "rbxassetid://4483345998",
PremiumOnly = false
})

Tab:AddLabel("CREATOR: Cosmic_TCU")


OrionLib:Init()

