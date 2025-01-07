local function close_teleport_window(player)
    if player.gui.screen.teleport_window then
        player.gui.screen.teleport_window.destroy()
    end
end

local function close_window(player, window_name)
    if player.gui.screen[window_name] then
        player.gui.screen[window_name].destroy()
    end
end

local function add_coordinate_fields(window)
    window.add({type = "label", caption = "Digite a coordenada X:"})
    window.add({type = "textfield", name = "coord_x", text = "0"})

    window.add({type = "label", caption = "Digite a coordenada Y:"})
    window.add({type = "textfield", name = "coord_y", text = "0"})
end

local function window_to_center(window,screen_gui)
    -- Centraliza a janela na tela do jogador, se possível
        if screen_gui and screen_gui.absolute_size then
            local screen_width = screen_gui.absolute_size.width
            local screen_height = screen_gui.absolute_size.height
            -- Define um valor padrão se a largura não estiver disponível
            local window_width = window.style.minimal_width or 300 
            -- Define um valor padrão se a altura não estiver disponível
            local window_height = window.style.minimal_height or 200 
    
            window.location = {
                x = (screen_width - window_width) / 2,
                y = (screen_height - window_height) / 2
            }
        end
end

-- Função para criar a janela com campos de entrada
local function create_input(player)
    local screen_gui = player.gui.screen
    local window = screen_gui.add({type = "flow", direction = "vertical", name = "window"})

    if screen_gui.window then
        screen_gui.window.destroy()
    end
    -- Título da janela
    window.add({type = "label", caption = "Digite o nome da superfície para teletransporte:"})

    -- Campo de texto para o nome da superfície
    window.add({type = "textfield", name = "surface_name", text = ""})

    -- Botão para confirmar
    window.add({type = "button", name = "confirm_button", caption = "Teletransportar"})
    window_to_center(window,screen_gui)
end

local function create_input_window(player)
    local screen_gui = player.gui.screen

    if screen_gui.window then
        screen_gui.window.destroy()
    end
    -- Adiciona um frame para a janela, com fundo e bordas
    local window =
        screen_gui.add(
        {
            type = "frame",
            name = "window",
            direction = "vertical",
            caption = "Teletransporte",
            style = "frame",
            visible = true
        }
    )

    -- Adiciona a opção de fechar a janela no canto superior direito
    window.add(
        {
            type = "button",
            name = "close_button",
            caption = "X",
            style = "close_button"
        }
    )

    -- Adiciona a área para digitar o nome da superfície
    window.add({type = "label", caption = "Digite o nome da superfície para teletransporte:"})
    window.add({type = "textfield", name = "surface_name", text = ""})

    add_coordinate_fields(window)

    -- Adiciona o botão de teletransporte
    window.add({type = "button", name = "confirm_button", caption = "Teletransportar"})

    -- Centraliza a janela na tela do jogador
    window_to_center(window,screen_gui)
end

-- Função para criar a janela com fundo e botão de fechar
local function create_teleport_window(player)
    local screen_gui = player.gui.screen

    if screen_gui.teleport_window then
        close_teleport_window(player)
    end
    -- Adiciona um frame para a janela, com fundo e bordas
    local window =
        screen_gui.add(
        {
            type = "frame",
            name = "teleport_window",
            direction = "vertical",
            caption = "Teletransporte",
            style = "frame",
            visible = true
        }
    )

    -- Adiciona a área para digitar o nome da superfície
    window.add({type = "label", caption = "Digite o nome da superfície para teletransporte:"})
    window.add({type = "textfield", name = "surface_name", text = ""})

    add_coordinate_fields(window)

    -- Adiciona o botão de teletransporte
    window.add({type = "button", name = "confirm_button", caption = "Teletransportar"})

    -- Centraliza a janela na tela do jogador
    window_to_center(window,screen_gui)
end

return {
    create_input = create_input,
    create_input_window = create_input_window,
    create_teleport_window = create_teleport_window,
    close_teleport_window = close_teleport_window,
    add_coordinate_fields = add_coordinate_fields,
    window_to_center = window_to_center,
    close_window = close_window
}
