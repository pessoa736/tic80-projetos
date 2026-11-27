-- [resumo]
-- bullet_heavem: protótipo de 'bullet hell' (nome com typo de bullet heaven).
-- New_entity / New_player com aceleração, velocidade e movimento suavizado por
-- coslerp (interpolação por cosseno), entrada por btn_bin. Muda a paleta via poke.
-- Com `biuld = false` carrega vec2 de ~/.local/share/com.nesbox.tic/...;
-- com true assume que vec2 já foi concatenado no build.
-- ------------------------------------------------------------
biuld = false




if biuld == false then 
    package.path = package.path .. ';/home/davi/.local/share/com.nesbox.tic/TIC-80/bullet_heavem/include/?.lua'

    require('vec2')
end

pi =math.pi
cos = math.cos

poke(0x03fc3, 0xff)
poke(0x03fc4, 0xff)
poke(0x03fc5, 0xff)


settings = {
    display_size = vec2(240, 136),
    display_proportion = 240/136
}

function coslerp(a, b, t)
    local f = (1-cos(t*pi)) * 0.5
    return a*(1-f)+b*f
end

function btn_bin(n)
    local result = 0

    if btn(n) then
        result = 1
    else
        result = 0
    end
    
    return result
end

function New_entity()
    local En = {
        class = "entity",
        life = 100,
        MaxLife = 100,
        pos = vec2(0, 0),
        vel = vec2(0, 0),
        acel = vec2(0, 0),
        spd = settings.display_proportion,
        
        dead = function(s)
            
        end,
        draw = function(s)
            rect(s.pos.x, s.pos.y, 8, 8, 1)
        end
    }
    return En
end

function New_player(pos, spd)
    local plr = New_entity() 
        plr.class = "player"
        plr.pos = pos or settings.display_size / vec2(2,2)
        plr.spd = spd or 0.8*settings.display_proportion

    function plr:moviment()
        local acex = (btn_bin(3) - btn_bin(2)) * self.spd
        local acey = (btn_bin(1) - btn_bin(0)) * self.spd
        

        self.acel = vec2(acex, acey)

        self.vel = coslerp(self.vel, self.acel, 0.8)
        self.pos = self.pos + self.vel
    end

    return plr
end


function BOOT(s)
    plr = New_player(vec2(120, 60), 1)
end

function TIC()
    --print(s)
    plr:moviment()
    cls()
    plr:draw()   
end