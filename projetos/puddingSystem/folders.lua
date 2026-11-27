-- [resumo]
-- folders: createFolder(nome) -- pasta como tabela com __meta (nome, extensão,
-- pai, ícone), addFolder e addFiles. Base do 'sistema de arquivos' do PuddingSystem.
-- ------------------------------------------------------------

local function createFolder(name)
    return {
        
        __meta = {name = name, exten = "folder", parent = "nil", icon = nil},
        
        addFolder = function(s, name, icon)
            s[name] = createFolder(name)
            s[name].__meta.parent = s.__meta.name
            s[name].__meta.icon = icon or 2
        end,
        
        --[[move = function(s, dest)
            dest[s.__meta.name] = s
            dest[s.__meta.name].__meta.parent = dest.__meta.name
            s = nil
        end,]]
        
        addFiles = function(s, name, exten, data)
            s[name] = {
                __meta = {
                    name = name.."."..exten, 
                    exten = exten,
                    parent = s.__meta.name,
                },
                getdata = function(s)
                    return s.data
                end,
                data = data 
            }
        end,
        
        --[[delete = function(s)
            s.move(s,windows.user.default.workspace.trash)
        end]]
   }
end

return createFolder