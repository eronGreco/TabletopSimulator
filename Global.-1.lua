-- GUIDs das bags normais e infinitas das fichas
local bagGUIDs = {
    azul = {normal = "7a51ee", infinita = "3354a6"},
    vermelha = {normal = "a8642b", infinita = "7b94a9"},
    amarela = {normal = "b6febe", infinita = "24dcb5"},
    preta = {normal = "246366", infinita = "b43ee8"},
    roxa = {normal = "f6691f", infinita = "be3ea1"},
    rosa = {normal = "3a6620", infinita = "73d833"}
}

-- Quantidade de fichas a adicionar a cada bag normal, baseado no número de jogadores
local fichasPorJogador = {
    ["2"] = 4, -- 7 - 3 = 4 fichas de cada cor, exceto roxa
    ["3"] = 5, -- 7 - 2 = 5 fichas de cada cor, exceto roxa
    ["4"] = 7  -- Todas as 7 fichas de cada cor, exceto roxa
}

function onload()
    -- Garante que a UI com o ID 'playerCountUI' seja mostrada
    UI.show('playerCountUI')
end

function setPlayerCount(player, value, id)
    local numJogadores = tostring(id)
    if fichasPorJogador[numJogadores] then
        preencherBags(numJogadores)
    else
        broadcastToAll("Número de jogadores inválido. Por favor, selecione entre 2 e 4.", {r = 1, g = 0, b = 0})
    end
    -- Esconde a UI após processar a entrada ou em caso de erro
    UI.hide('playerCountUI')
end

function preencherBags(numJogadores)
    for cor, guids in pairs(bagGUIDs) do
        local bagInfinita = getObjectFromGUID(guids.infinita)
        local bagNormal = getObjectFromGUID(guids.normal)
        local fichasParaAdicionar = cor == "roxa" and 5 or fichasPorJogador[numJogadores]

        for i = 1, fichasParaAdicionar do
            local altura = 10 + (i * 2)  -- Aumenta a altura para cada ficha gerada
            bagInfinita.takeObject({
                position = bagNormal.getPosition() + Vector({x = 0, y = altura, z = 0}),
                rotation = {x = 0, y = 180, z = 0},
                smooth = false,
                callback_function = function(obj)
                    -- As fichas são adicionadas diretamente na bag sem atraso
                    bagNormal.putObject(obj)
                end
            })
        end
    end
end