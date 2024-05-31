local bagGUID = "b6febe"  -- GUID da bolsa

function updateLabel()
    local bag = getObjectFromGUID(bagGUID)
    if bag then
        local numItems = bag.getQuantity()
        self.editButton({
            index = 0,
            label = tostring(numItems)
        })
    else
        print("Bolsa não encontrada!")
    end
end

function onObjectEnterContainer(container, entered_object)
    if container.getGUID() == bagGUID then
        updateLabel()
    end
end

function onObjectLeaveContainer(container, exited_object)
    if container.getGUID() == bagGUID then
        updateLabel()
    end
end

function onLoad()
    local labelParams = {
        click_function = "noAction",
        function_owner = self,
        label = "0",
        position = {0, 1, 0},
        rotation = {0, 0, 0},
        width = 0,
        height = 0,
        font_size = 500,
        color = {1, 1, 1},
        font_color = {1, 1, 1}
    }

    self.createButton(labelParams)
    updateLabel()
end

function noAction()
    -- Função vazia, não faz nada
end