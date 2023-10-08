local remotes = {}

-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Get folders
local folder = ReplicatedStorage:WaitForChild("WesTimingRemotes")
local events = folder:WaitForChild("Events")
local funcs = folder:WaitForChild("Functions")

function remotes:GetRemoteEvent(name: string): RemoteEvent

    local remote = events:WaitForChild(name, 10)

    if remote == nil then
        warn("Could not find RemoteEvent " .. name)
    end

    return remote

end

function remotes:GetRemoteFunction(name: string): RemoteFunction

    local remote = funcs:WaitForChild(name, 10)

    if remote == nil then
        warn("Could not find RemoteFunction " .. name)
    end

    return remote

end

return remotes