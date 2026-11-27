-- title:   game title
-- author:  game developer, email, etc.
-- desc:    short description
-- site:    website link
-- license: MIT License (change this to your license of choice)
-- version: 0.1
-- script:  lua
local diretorio = "G:/Meu Drive/tic-80/appdata/projetos/puddingSystem/?.lua"
package.path = package.path .. ";" .. diretorio

devMode = true

display = {w = 240, h = 136} -- max 

spr_extencions = {
  ["file"] = 1,
  ["folder"] = 2,
  ["lua"] = 17,
  ["image"] = 18
}

createFolder = require("folders")
imagens = require("packimagem") 

--gerando o windows
windows = createFolder("Windows")
windows:addFolder("windows")

  --gerando o system
windows.windows:addFolder("system")
       
--gerando o workspace
windows.windows.system:addFolder("workspace")
windows.windows.system.workspace:addFiles( 
  "wallpaper", "image",
  imagens.wallpapers[1]
)

windows.windows.system.workspace:addFiles( 
 "visual", "lua", 
 function(s)
  local data = windows.windows.system.workspace.wallpaper:getdata()
  for i = 1, #data do
   rect(((i%30)*8)-1, (((i//30)%17)*8)-1, 8, 8, data[i])
  end
  
  local j = 0
  for k, i in pairs(windows.user.default.workspace) do
   if type(i)~="function" and k ~= "__meta" then
    local spr_
    if i.__meta.icon~=nil then
     spr_ = i.__meta.icon
    else
     spr_ = spr_extencions[i.__meta.exten] or 1
    end  
    
    local x = 8+((j//16)%4)*24
    local y = (8*(j%4))+j*24
    spr(spr_, x, y, 0, 3)
       
    local w = print(i.__meta.name, -100,-100)
    print(i.__meta.name, x+(24*0.5 - w*0.5), 25+y,12)
    
    j=j+1
   end
  end
  
 end
)

--gerando a taskbar
windows.windows.system:addFolder("taskbar")

function taskbar(s)
  
  rect(0, display.h-display.h*0.1, display.w, display.h,2)
end

windows:addFolder("user")
windows.user:addFolder("default")
windows.user.default:addFolder("workspace")
windows.user.default.workspace:addFolder("trash",3)

windows.user.default.workspace:addFolder("bolsonaro")

windows:addFolder("programFiles")


tasks={
 add = function(s, name, newtasks)
  table.insert(s, {name = name, task = newtasks})
 end,
 stop = function(s, name)
  for k, t in ipairs(s) do
   if t.name == name then
    table.remove(s, k)
   end
  end
 end,
 update = function(s)
  for i, t in ipairs(s) do
   t.task()
  end
 end
}

function BOOT()
end

local t = 0
function TIC()

 cls()
 tasks:update()
 t=t+1
end

-- <TILES>
-- 000:099009909aa99aa99aa00aa9090aa090090aa0909aa00aa99aa99aa909900990
-- 001:000dddd000ddccd00ddcccd00dccccd00dccccd00dccccd00dddddd000000000
-- 002:0333000044433333444444434444444344444443444444434444444344444440
-- 003:ddeeeeddddddddeddedededdddededed0ddeded00dededd00ddeded000dddd00
-- 017:0004444000444440044343400434344004444440043334400444444000000000
-- 018:0000000000000000099aaaa009aa44a0088a49a0088899900888999000000000
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

