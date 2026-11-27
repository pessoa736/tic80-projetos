# title:   game title
# author:  game developers, email, etc.
# desc:    short description
# site:    website link
# license: MIT License (change this to your license of choice)
# version: 0.1
# script:  python
# [resumo]
# Cart Python do TIC-80 que contém um script de treino de GPT-2 (PyTorch +
# transformers). Não é um jogo e não roda no TIC-80 (as libs não existem lá);
# parece um trecho colado de outra fonte (cabeçalho: /mnt/data/simple_gpt.py).
# ------------------------------------------------------------

# /mnt/data/simple_gpt.py
import torch
import torch.nn as nn
import torch.optim as optim
from torch.utils.data import DataLoader, Dataset
from transformers import GPT2Tokenizer, GPT2LMHeadModel

class TextDataset(Dataset):
    def __init__(self, texts, tokenizer, max_length):
        self.texts = texts
        self.tokenizer = tokenizer
        self.max_length = max_length

    def __len__(self):
        return len(self.texts)

    def __getitem__(self, idx):
        text = self.texts[idx]
        inputs = self.tokenizer.encode_plus(
            text,
            max_length=self.max_length,
            truncation=True,
            padding='max_length',
            return_tensors='pt'
        )
        return inputs['input_ids'].squeeze(), inputs['attention_mask'].squeeze()

def train_model(model, dataloader, optimizer, criterion, device):
    model.train()
    total_loss = 0
    for batch in dataloader:
        input_ids, attention_mask = [x.to(device) for x in batch]
        optimizer.zero_grad()
        outputs = model(input_ids, attention_mask=attention_mask, labels=input_ids)
        loss = outputs.loss
        loss.backward()
        optimizer.step()
        total_loss += loss.item()
    return total_loss / len(dataloader)

def main():
    # Hiperparâmetros
    epochs = 3
    batch_size = 2
    max_length = 512
    learning_rate = 5e-5

    # Dados de exemplo
    texts = ["Este é um exemplo de texto.", "Aqui está outro exemplo."]

    # Inicializar tokenizer e modelo
    tokenizer = GPT2Tokenizer.from_pretrained('gpt2')
    model = GPT2LMHeadModel.from_pretrained('gpt2')

    # Preparar dados
    dataset = TextDataset(texts, tokenizer, max_length)
    dataloader = DataLoader(dataset, batch_size=batch_size, shuffle=True)

    # Configurar otimizador e critério de perda
    optimizer = optim.AdamW(model.parameters(), lr=learning_rate)
    criterion = nn.CrossEntropyLoss()

    # Treinamento
    device = torch.device('cuda' if torch.cuda.is_available() else 'cpu')
    model.to(device)
    for epoch in range(epochs):
        loss = train_model(model, dataloader, optimizer, criterion, device)
        print(f'Epoch {epoch+1}, Loss: {loss}')

    # Salvar o modelo
    model.save_pretrained('/mnt/data/gpt_model')
    tokenizer.save_pretrained('/mnt/data/gpt_model')

if __name__ == '__main__':
    main()

# <TILES>
# 001:eccccccccc888888caaaaaaaca888888cacccccccacc0ccccacc0ccccacc0ccc
# 002:ccccceee8888cceeaaaa0cee888a0ceeccca0ccc0cca0c0c0cca0c0c0cca0c0c
# 003:eccccccccc888888caaaaaaaca888888cacccccccacccccccacc0ccccacc0ccc
# 004:ccccceee8888cceeaaaa0cee888a0ceeccca0cccccca0c0c0cca0c0c0cca0c0c
# 017:cacccccccaaaaaaacaaacaaacaaaaccccaaaaaaac8888888cc000cccecccccec
# 018:ccca00ccaaaa0ccecaaa0ceeaaaa0ceeaaaa0cee8888ccee000cceeecccceeee
# 019:cacccccccaaaaaaacaaacaaacaaaaccccaaaaaaac8888888cc000cccecccccec
# 020:ccca00ccaaaa0ccecaaa0ceeaaaa0ceeaaaa0cee8888ccee000cceeecccceeee
# </TILES>

# <WAVES>
# 000:00000000ffffffff00000000ffffffff
# 001:0123456789abcdeffedcba9876543210
# 002:0123456789abcdef0123456789abcdef
# </WAVES>

# <SFX>
# 000:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000304000000000
# </SFX>

# <TRACKS>
# 000:100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
# </TRACKS>

# <PALETTE>
# 000:1a1c2c5d275db13e53ef7d57ffcd75a7f07038b76425717929366f3b5dc941a6f673eff7f4f4f494b0c2566c86333c57
# </PALETTE>

