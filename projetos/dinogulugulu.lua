-- title:   Dinogulugulu
-- author:  xpudding
-- desc:    Chrome dino clone played by a neural-network bot
-- site:    https://github.com/pessoa736/tic80-projetos
-- license: MIT License
-- version: 0.1
-- script:  lua
-- [resumo]
-- dinogulugulu: clone do jogo do dinossauro do Chrome com bot de IA.
-- Classes dino e Cacto, gravidade, e um 'brain bot' (initBrainBot / botmoviment)
-- que usa neuralLibary e o objeto mais próximo (ObjetoMaisProximo) para decidir pular.
-- Nota: addPath usa H:/Meu Drive/... (caminho do Windows antigo).
-- ------------------------------------------------------------

maindir="H:/Meu Drive/tic-80/appdata/"
function addPath(dir)
	package.path = package.path ..";" .. maindir.. dir .. "/?.lua"
end

addPath("libraries")
addPath("libraries/code_of_TIC80")

require "neuralLibary"
require "erroLibary"

-- gravity
grav = 9.8/75
-- classe dino

dino = {}
dino.__index = dino

function dino.new(spawpos, moveSystem)
    local self = {}
    setmetatable(self, dino)
    function self.add(x, y)
        local d = {}
            d.x = x or spawpos.x
            d.y = y or spawpos.y
            d.vy = 0 
            d.ay = 0
            d.jumpforce = 18
            d.status = "alive"
            d.brain = initBrainBot(d)
        table.insert(self, d)
    end
    function self.update()
        for k, d in ipairs(self) do
            local upm, downm = moveSystem(d)
            if d.y+d.vy+(d.ay/2) >= (16-2)*8 then
                d.vy = 0
                d.ay = 0
                if upm and d.status=="alive" then
                    d.ay = (-10/60)*d.jumpforce
                end
            else 
                d.ay = grav
            end
            if cacto.check(d) then
                d.status = "dead"
            end
            d.vy = d.vy + d.ay
            d.y = d.y + d.vy
            if d.status == "dead" then
                d.x = d.x - speed
            end
        end
    end
    function self.draw()
        for k, d in ipairs(self) do
            rect(d.x, d.y, 8, 16, 2)
        end
    end

    return self
end

Cacto = {}
Cacto.__index = Cacto

function Cacto.new()
    local self = {}
    setmetatable(self, Cacto)

    function self.add(x)
        local c = {}
        c.h = math.random(1,2)*8
        c.x = x or math.random(240, 255)
        c.y = (16)*8

        table.insert(self, c)
    end
    function self.update(speed)
        for k, c in ipairs(self) do
            c.x = c.x - speed
            if c.x<=-8 then
                self.remove(k)
            end
        end
    end
    function self.draw()
        for k, c in ipairs(self) do
            rect(c.x, c.y-c.h, 8, c.h, 12)
        end
    end
    function self.remove(id)
        table.remove(self, id)
    end

    function self.check(object)
        local bol=false
        for _, c in ipairs(self) do
            if  math.abs(object.x-c.x)<=8 then
                if  math.abs(object.y-c.y)<=24 then
                    bol = true
                end
            end
        end
        return bol
    end

    return self
end

function playermoviment()
    local up, down=false, false;
    if btn(0) then 
        up = true
    else
        up = false
    end
    if btn(1) then 
        down = true
    else
        down = false
    end
    return up, down
end

function ObjetoMaisProximo(p, classe)
    local objetoMaisProximo = math.huge
    local distanciaMaisProxima = math.huge
    
    for _, c in ipairs(classe) do
        local distancia = (c.x - p)
        if distancia < distanciaMaisProxima and distancia > p then
            distanciaMaisProxima = distancia
            objetoMaisProximo = c.x
        end
    end
   return objetoMaisProximo 
end


function initBrainBot()
    local hidden_layers = {2,2} 
    local output_nodes = 2
  
    local nn = NeuralNetwork.new(2, hidden_layers, output_nodes)
    return nn
end
function botmoviment(bot)
    local dx =  ObjetoMaisProximo(bot.x, cacto)
    local inputs = {dx, speed}
    
    local output = bot.brain:predict(inputs)

    local up, down = false, false
    if output[1] >= 0.91 then
        up = true
     else
        up = false
    end
    if output[2] >= 0.91 then
        down = true
    else
        down = false
    end
    print(output[1])
    return up, down
end


bot = dino.new({x=8, y=0},botmoviment)
bot.add()


player = dino.new({x=128, y=0},playermoviment)
--player.add()


cacto = Cacto.new()
t=0
speed = 0
function TIC()
    speed = 1.0001^t
    if t%(60//speed)==0 then
        local n = math.random(1, 4)
        for i =1, n do
            cacto.add(240+(i-1)*10)
        end
    end
    cls()
    cacto.update(speed)
    --player.update()
    bot.update()
  --  player.draw()
    bot.draw()
    cacto.draw()
    t = t+1
end

-- <TILES>
-- 001:eccccccccc888888caaaaaaaca888888cacccccccacc0ccccacc0ccccacc0ccc
-- 002:ccccceee8888cceeaaaa0cee888a0ceeccca0ccc0cca0c0c0cca0c0c0cca0c0c
-- 003:eccccccccc888888caaaaaaaca888888cacccccccacccccccacc0ccccacc0ccc
-- 004:ccccceee8888cceeaaaa0cee888a0ceeccca0cccccca0c0c0cca0c0c0cca0c0c
-- 017:cacccccccaaaaaaacaaacaaacaaaaccccaaaaaaac8888888cc000cccecccccec
-- 018:ccca00ccaaaa0ccecaaa0ceeaaaa0ceeaaaa0cee8888ccee000cceeecccceeee
-- 019:cacccccccaaaaaaacaaacaaacaaaaccccaaaaaaac8888888cc000cccecccccec
-- 020:ccca00ccaaaa0ccecaaa0ceeaaaa0ceeaaaa0cee8888ccee000cceeecccceeee
-- </TILES>

-- <WAVES>
-- 000:00000000ffffffff00000000ffffffff
-- 001:0123456789abcdeffedcba9876543210
-- 002:0123456789abcdef0123456789abcdef
-- </WAVES>

-- <SFX>
-- 000:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000304000000000
-- </SFX>

-- <TRACKS>
-- 000:100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- </TRACKS>

-- <PALETTE>
-- 000:1a1c2c5d275db13e53ef7d57ffcd75a7f07038b76425717929366f3b5dc941a6f673eff7f4f4f494b0c2566c86333c57
-- </PALETTE>

