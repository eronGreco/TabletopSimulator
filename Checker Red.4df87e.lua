-- GUIDs dos baralhos de cada nível
local decksGUID = {
    ["1"] = "998579",
    ["2"] = "38e2d7",
    ["3"] = "b2c07b",
    ["4"] = "ec94c4",
    ["5"] = "c64e45"
}

-- Coordenadas para cada carta de cada nível
local cardPositions = {
    ["1"] = {
        {-3.31971263885498, 0.987096071243286, -5.9852237701416},
        {-1.01115345954895, 0.987095892429352, -5.9852237701416},
        {1.2974054813385, 0.987095952033997, -5.9852237701416},
        {3.60596418380737, 0.987096011638641, -5.9852237701416}
    },
    ["2"] = {
        {-3.31840419769287, 0.987096011638641, -2.83985471725464},
        {-1.00984156131744, 0.987095892429352, -2.83985161781311},
        {1.29871737957001, 0.98709625005722, -2.83985137939453},
        {3.60727643966675, 0.987095892429352, -2.83985137939453}
    },
    ["3"] = {
        {-3.31872415542603, 0.987096071243286, 0.337962508201599},
        {-1.01016497612, 0.987096071243286, 0.337962508201599},
        {1.29839384555817, 0.987096071243286, 0.337962538003922},
        {3.60695266723633, 0.987096071243286, 0.337962478399277}
    },
    ["4"] = {
        {-2.17278981208801, 0.98709625005722, 3.52523589134216}
    },
    ["5"] = {
        {2.43987560272217, 0.987095952033997, 3.5435631275177}
    }
}

local lastClickTime = 0

function onload()
    createButton()
end

-- Cria um botão no objeto checker
function createButton()
    local checker = getObjectFromGUID("4df87e")
    checker.createButton({
        click_function = "dealCards",
        function_owner = self,
        label = "Distribuir Cartas",
        position = {0,1,0},
        scale = {0.5,0.5,0.5},
        width = 4000,
        height = 1000,
        font_size = 500
    })
end

-- Função chamada ao pressionar o botão
function dealCards(player_clicker_color, _)
    local currentTime = os.time()
    -- Verifica se passaram 3 segundos desde o último clique
    if currentTime - lastClickTime < 3 then
        -- Se não passaram, retorna e não faz nada
        return
    end
    -- Atualiza o tempo do último clique para o momento atual
    lastClickTime = currentTime

    -- Embaralha cada deck antes de distribuir as cartas
    for level, _ in pairs(decksGUID) do
        local deck = getObjectFromGUID(decksGUID[level])
        if deck then
            deck.shuffle()
        end
    end

    -- Distribui as cartas após o embaralhamento
    for level, positions in pairs(cardPositions) do
        dealLevelCards(level, positions)
    end
end


-- Assegura que todas as funções subsequentes estejam no escopo correto e sejam definidas corretamente
-- Lida com a distribuição das cartas de um determinado nível
function dealLevelCards(level, positions)
    local deck = getObjectFromGUID(decksGUID[level])
    if deck == nil then
        -- Se o deck não foi encontrado, emite um aviso e interrompe a função.
        broadcastToAll("Deck de nível " .. level .. " não encontrado.", {r=1, g=0, b=0})
        return
    end
    
    -- Aqui começa o loop para verificar e mover as cartas
    for i, pos in ipairs(positions) do
        local position = Vector(pos)
        if not isPositionOccupied(position) then
            local cardOrDeck = deck.takeObject({
                position = position,
                flip = true,
                callback_function = function(obj)
                    -- Callback opcional, caso precise tratar algo após a carta ser movida
                    if obj.tag == "Card" and deck.getQuantity() == 1 then
                        -- Este caso é quando restar apenas uma carta no deck.
                        broadcastToAll("Por favor, mova a última carta do deck de nível " .. level .. " manualmente.", {r=1, g=0.5, b=0})
                    end
                end
            })
            if cardOrDeck == nil then
                -- A chamada falhou, possivelmente porque o objeto não é mais um deck
                broadcastToAll("Falha ao mover a última carta automaticamente. Por favor, faça isso manualmente.", {r=1, g=0, b=0})
            end
            -- Removido o break para permitir que o loop continue e distribua todas as cartas.
        end
    end
end


function isPositionOccupied(position)
    local hitObjects = Physics.cast({
        origin = position,
        direction = {0, 1, 0},
        type = 3,
        max_distance = 1,
        size = {x = 0.5, y = 0.5, z = 0.5},
    })

    for _, hit in ipairs(hitObjects) do
        if hit.hit_object.tag == "Card" or hit.hit_object.tag == "Deck" then
            return true
        end
    end

    return false
end