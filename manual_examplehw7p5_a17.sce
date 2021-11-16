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


// select a design example 
//EXAMPLE = 1        // Simple plant
//EXAMPLE = 1.1         // Simple Plant with PD control
//EXAMPLE = 2         //  more complicated plant
//EXAMPLE = 3          // 3 real poles and no zeros
 
////////  Plant model
p1 = -0.1
p2 = -0.06667
pln = real(5.0*p1*p2)
pld = real((s-p1)*(s-p2))
plant = syslin('c', pln/pld)

//   Desired Performance Specs
Tsd = 40
Tspct = 0.02  // 2% Ts window
POSd = 1.10

//////  Controller
// PID Control zeros
z1 = -.3
z2 = -.4
 
// regularization pole
pr = 15 * min([real(z1),real(z2)])
// Make PID Controller 
ctn = real((s-z1)* (s-z2)*(-pr))
ctd = real(s*(s-pr))
ctl = syslin('c', ctn/ctd)
Kmax = 75.00
 
 
/////////////////////////////////////////////////////
//// Plot RL with Specs
rl447(ctl*plant, 1, Tsd, POSd, Kmax)
a = gca()
a.grid=[1,1]
//   Adjust plot ranges if nesc and set K value
 
a.data_bounds=[-1, -0.6 ; .2, .6]
K=0.208    // from hand computation
K=50.0

// Closed Loop Transfer Fcn
cltf = K*ctl*plant /. 1

tmax = 100.   // step function plot range
t = 0:tmax/150:tmax;   // note 'auto' step size

scf(2)
Y = csim('step', t, cltf)
plot(t,Y)

//  Draw Ts spec and 2% window
plot([Tsd, Tsd], [0, 2], 'r--')
if(POSd > 1.0) then        //   get rid of 1.05 eg.
    POSd = POSd - 1.0
end

wx = [0,tmax]
// Ts window
wy1 = [1.0+Tspct, 1.0+Tspct]
wy2 = [1.0-Tspct, 1.0-Tspct]
plot(wx, wy1, 'g')
plot(wx, wy2, 'g')
// overshoot line
wy3 = [1.0+POSd, 1.0+POSd]
plot(wx, wy3, 'r-.')
