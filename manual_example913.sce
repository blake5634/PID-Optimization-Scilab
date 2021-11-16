//design example 9.13
//   Nov 2016

xdel(winsid()) // close all figures

s=%s
j=%i

exec('rl447.sce')   // load the root locus tool

////////////   Plant
pn = (s+3)
pd = real(s*(s+1+1.5*j)*(s+1-1.5*j))

////////////   Specs
Ts = 1.333
POS = 0.01

/////////////   PID Controller
pr = 50
z1 = -3
z2 = -3
ctn = real(pr*(s-z1)*(s-z2))
ctd = s*(s+pr)

plant = syslin('c', pn/pd)
ctl   = syslin('c', ctn/ctd)

//////   Plot the RL with specs
// rl447 args:   System,
//               # regularization poles
//               Settling Time spec
//               Percent Overshoot spec
//               Kmax
//
rl447(ctl*plant, 0, Ts, POS, 100)
a = gca()
a.data_bounds = [-55,-20; 5, 20]
STEP = 1

if(STEP) then
    //ctl2 = syslin('c', K*ctn*pln, 1+K*ctd*pld)
    
    K = 50
    
    cltf = K*ctl*plant /. 1
    
    t = 0:0.05:8;
    
    scf(2)
    
    Y = csim('step', t, cltf)
 
    plot(t,Y)   
    //  Draw Ts spec and 2% window
    plot([Ts, Ts], [0, 2], 'r--')
    wx = [0,8]
    wy1 = [1.02, 1.02]
    wy2 = [0.98, 0.98]
    plot(wx, wy1, 'g')
    plot(wx, wy2, 'g')
end

 
