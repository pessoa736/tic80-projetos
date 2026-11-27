# title:   game title
# author:  game developers, email, etc.
# desc:    short description
# site:    website link
# license: MIT License (change this to your license of choice)
# version: 0.1
# script:  python


scrw: float = 240
scrh: float = 136

def lerp(a,b,t):
    return int(a*(1-t)+b*t)

class window():
    x: int
    y: int
    w: int
    h: int

    def __init__(s,x, y, w, h):
        s.x = x; s.y = y; s.w = w; s.h = h
    
    def draw(s):
        rect(s.x, s.y, s.w, s.h, 0)
        rectb(s.x, s.y, s.w, s.h, 12)

    def change_pos(s, x, y):
        s.x = lerp(s.x, x, 0.5)
        s.y = lerp(s.y, y, 0.5)

class workspace:
    items = []
    visual = window(0,0,240, 136)

    def update(self):
        t=0
    
    def draw(s):
        s.visual.draw()

class Mouse:
    x = 0
    y = 0

    def update(self):
        self.x, self.y, self.l, self.m, self.r, self.scrollx,  self.scrolly = mouse() 
        poke(0x03ffb, -1)

    def draw(self):
        line(self.x, self.y, self.x + 3, self.y + 4, 12)
        line(self.x, self.y, self.x + 3, self.y + 1, 12)
        line(self.x, self.y, self.x, self.y + 3, 12)


class menu:
    visual = window(0, int(scrh/2), int(scrw/4), int(scrh/2)-8)
    opened = 0
    def icon(s, x, y):
        rectb(x, y,8,8, 12)

    def update(s):
        
        
        
        if s.opened == 0 :
            s.visual.change_pos(0, scrh)
        if s.opened == 1 :
            s.visual.change_pos(0, int(scrh/2))
        

    def draw(s):
        s.visual.draw()

class TaskBar:
    visual = window(0, 128, 240, 8)
    itens = []
    
    def __init__(s):
        s.itens.insert(1, menu())

    def add(self, link):
        self.itens.insert(len(self.itens), link)

    
    def update(s):
        t= 0
        for i in s.itens:
            i.update()

    def draw(s):
        s.visual.draw()
        for i in s.itens:
            i.draw()
            

tasks = []

def BOOT():
    global tasks
    tasks.insert(len(tasks),workspace())
    tasks.insert(len(tasks),TaskBar())
    tasks.insert(len(tasks), Mouse())

def TIC():
    global tasks
    for t in tasks:
        t.update()
    cls()
    for t in tasks:
        t.draw()


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

