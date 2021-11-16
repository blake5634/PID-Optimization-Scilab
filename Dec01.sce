// Some examples of 'manual' PID design
//    EE 447     Nov 2016
//

xdel(winsid()) // close all figures
clear all

s=%s
j=%i

cd ('/home/blake/Dropbox/447/Homework/A')  // where I want to actually work

DIR = '/home/blake/Dropbox/447/Scilab447/RootLocusTools/'  //  customize to the place you store the scripts

exec(DIR+'evans447.sci',-1)
exec(DIR+'rl447.sce',-1)


Ts = 1.0
POS = 1.10


pn = 100
p1 = -4+4*j
p2 = p1'
p3 = -1+j
p4 = p3'

pd = real((s-p1)*(s-p2)*(s-p3)*(s-p4))

plant = syslin('c', pn/pd)

Kd = .05
z1 = -3
z2 = -3

pp = -40

ctld = s*(s-pp)
ctln = -pp * Kd*real((s-z1)*(s-z2))

controller = syslin('c', ctln/ctld)

scf(1)
rl447(controller*plant,1,Ts, POS, 0)

t = 0:0.01:10;

cltf = controller*plant /. 1

//cltf = controller*plant / (1+controller*plant))

y = csim('step', t, cltf)

scf(2)

plot(t,y)
