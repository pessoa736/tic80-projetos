-- [resumo]
-- neuralLibary: rede neural feed-forward minimalista.
-- sigmoid(x), generateRandomWeights(linhas, colunas) com pesos em [-1, 1],
-- NeuralNetwork.new e NeuralNetwork:predict (só inferência; não há treino).
-- Usada pelo dinogulugulu (bot que joga sozinho).
-- ------------------------------------------------------------
-- author:  xpudding

-- Função de ativação - Sigmoide
function sigmoid(x)
    return 1 / (1 + math.exp(-x))
end
  
-- Função para gerar uma matriz de pesos aleatórios
function generateRandomWeights(rows, cols)
    local weights = {}
    for i = 1, rows do
        local row = {}
        for j = 1, cols do
            table.insert(row, (math.random(-100, 100)/100))
        end
        table.insert(weights, row)
    end
    return weights
end

-- Classe da Rede Neural
NeuralNetwork = {}
NeuralNetwork.__index = NeuralNetwork

function NeuralNetwork.new(input_nodes, hidden_layers, output_nodes)
    local self = setmetatable({}, NeuralNetwork)
    
    self.input_nodes = input_nodes
    self.hidden_layers = hidden_layers
    self.output_nodes = output_nodes
  
    -- Inicialização dos pesos aleatórios
    self.weights = {}
    table.insert(self.weights, generateRandomWeights(input_nodes, hidden_layers[1]))
    for i = 2, #hidden_layers do
      table.insert(self.weights, generateRandomWeights(hidden_layers[i-1], hidden_layers[i]))
    end
    table.insert(self.weights, generateRandomWeights(hidden_layers[#hidden_layers], output_nodes))
  
    -- Inicialização dos bias aleatórios
    self.bias = {}
    for i = 1, #hidden_layers do
      table.insert(self.bias, {})
      for j = 1, hidden_layers[i] do
        table.insert(self.bias[i], math.random())
      end
    end
    table.insert(self.bias, {})
    for i = 1, output_nodes do
      table.insert(self.bias[#self.bias], math.random())
    end
  
    return self
end
  
function NeuralNetwork:predict(inputs)
    local output = inputs
  
    -- Propagação dos valores de entrada através das camadas ocultas
    for i = 1, #self.hidden_layers do
      local layer_output = {}
      for j = 1, self.hidden_layers[i] do
        local sum = 0
        for k = 1, #output do
          sum = sum + output[k] * self.weights[i][k][j]
        end
        sum = sum + math.random()--self.bias[i][j]
        table.insert(layer_output, sigmoid(sum))
      end
      output = layer_output
    end
  
    -- Propagação dos valores de saída
    local final_output = {}
    for i = 1, self.output_nodes do
      local sum = 0
      for j = 1, #output do
        sum = sum + output[j] * self.weights[#self.weights][j][i]
      end
      sum = sum + self.bias[#self.bias][i]
      table.insert(final_output, sigmoid(sum))
    end
  
    return final_output
end