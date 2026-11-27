-- [resumo]
-- button: botão de mouse com detecção de clique (Release) e função de desenho
-- configurável (drawfunction). Usado pelo cookieTICker.
-- ------------------------------------------------------------

button={
    drawfunction = function(x, y, w, h) end,
    leftpressed = false,
    Release = function(s, x, y, w, h, mx, my, mouse_click)

        local mx, my, mouse_click = mouse
        local pressed 

        if x < mx and mx < x+w then
            if y<my and my < y + h then
                if s.leftpressed ~= mouse_click and mouse_click then
                    pressed = true
                end
            else
                pressed = false
            end
        end

        s.leftpressed = mouse_click
        s.drawfunction(x,y,w,h,pressed)
        return pressed
    end,
    pressed = function(s, x, y, w, h, mx, my, mouse_click)

        local mx, my, mouse_click = mouse()
        local pressed 

        if x < mx and mx < x+w then
            if y<my and my < y + h then
                if mouse_click then
                    pressed = true
                end
            else
                pressed = false
            end
        end

        
        s.drawfunction(x,y,w,h,pressed)
        return pressed
    end
}

return button