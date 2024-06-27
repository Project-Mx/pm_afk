local QuestionsAnswered = {}

CreateThread(function()
    while true do
        Citizen.Wait(1000)

        local ped = GetPlayerPed(-1)
        local currPos = GetEntityCoords(ped, true)

        if prevPos then
            -- Check if player is AFK
            if Vdist(currPos.x, currPos.y, currPos.z, prevPos.x, prevPos.y, prevPos.z) < 0.1 then
                if time then
                    if time > 0 then
                        time = time - 1
                    else
                        -- Handle AFK kick logic
                        AFKKickHandler()
                    end
                else
                    time = config.AfkTimer
                end
            else
                time = config.AfkTimer
            end
        end

        prevPos = currPos
    end
end)

function AFKKickHandler()
    if config.UseOx then
        QuestionsAnswered = {}
        local TaskSolved = false
        local questions = {}

        for i = 1, config.QuestionNumber do
            local first = math.random(1, 10)
            local last = math.random(1, 5)
            QuestionsAnswered[i] = first + last
            table.insert(questions, config.Lang[config.LangType]['questions'] .. first .. '+' .. last)
        end

        CreateThread(function()
            local input = lib.inputDialog('[AFK] Avoid Getting kicked by answering this question', questions)
            
            if input then
                local count = 0
                
                for i = 1, config.QuestionNumber do
                    if QuestionsAnswered[i] == tonumber(input[i]) then
                        count = count + 1
                    end
                end

                if count == config.QuestionNumber then
                    TaskSolved = true
                    TriggerEvent('chatMessage', '', {255, 255, 255}, '^1[AFK]:^0 You have answered ^4correctly.^0 You may stay in the city.')
                else
                    TriggerServerEvent('afkkick')
                end
            else
                TriggerServerEvent('afkkick')
            end
        end)

        Citizen.Wait(config.QuestionTime * 1000)

        if not TaskSolved then
            TriggerServerEvent('afkkick')
        end
    else
        local TaskSolved = false
        local questions = {}

        for i = 1, config.QuestionNumber do
            local first = math.random(1, 10)
            local last = math.random(1, 10)
            QuestionsAnswered[i] = first + last
            table.insert(questions, config.Lang[config.LangType]['questions'] .. first .. '+' .. last)
        end

        CreateThread(function()
            local question = 0
            
            local function UseCommand()
                local first = math.random(1, 10)
                local last = math.random(1, 10)

                TriggerEvent('chatMessage', '', {255, 255, 255}, '^1[AFK]:^0 Answer ^3' .. config.Lang[config.LangType]['questions'] .. first .. '+' .. last .. '^0 in order to not get kicked from the server, use ^4 /afk [Answer]')

                RegisterCommand('afk', function(_, args)
                    if args[1] and tonumber(args[1]) then
                        if first + last == tonumber(args[1]) then
                            question = question + 1

                            if question == config.QuestionNumber then
                                TaskSolved = true
                                TriggerEvent('chatMessage', '', {255, 255, 255}, '^1[AFK]:^0 You have answered ^4correctly.^0 You may stay in the city.')
                                RegisterCommand('afk', function(_, args) end) -- Unregister command after successful completion
                            else
                                UseCommand()
                            end
                        else
                            TriggerServerEvent('afkkick')
                        end
                    end
                end)
            end

            UseCommand()
        end)

        Citizen.Wait(config.QuestionTime * 1000)

        if not TaskSolved then
            TriggerServerEvent('afkkick')
        end
    end
end


TriggerEvent('chat:addSuggestion', '/afk', 'Answer question', {
    { name="Answer", help=" " }
})