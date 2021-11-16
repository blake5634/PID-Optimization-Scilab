// Example 9.12 design 
//

xdel(winsid()) // close all figures

s=%s
j=%i

exec('../RootLocusTools/evans447.sci',-1)
exec('../RootLocusTools/rl447.sce',-1)


//EXAMPLE = 1         // Simple plan
// EXAMPLE = 1.1         // Simple Plant with PD control
EXAMPLE = 2         //  Harrier plant

if(EXAMPLE == 1) then
    ////////  Plant model
    p1 = -2
    p2 = -2
    pln = real(1)
    pld = real((s-p1)*(s-p2))
    plant = syslin('c', pln/pld)
    
    //   Desired Performance Specs
    Tsd = 1
    POSd = 0.05
    
    //////  Controller
    // PID Control zeros
    z1 = -6
    z2 = -8
     
    // regularization pole
    pr = 15 * min([real(z1),real(z2)])
    // Make PID Controller 
    ctn = real((s-z1)* (s-z2)*(-pr))
    ctd = real(s*(s-pr))
    ctl = syslin('c', ctn/ctd)
    Kmax = 1000
end


if(EXAMPLE == 1.1) then
    ////////  Plant model
    p1 = -2
    p2 = -2
    pln = real(1)
    pld = real((s-p1)*(s-p2))
    plant = syslin('c', pln/pld)
    
    //   Desired Performance Specs
    Tsd = 1
    POSd = 0.05
    
    //////  Controller
    // PD Control zero
    z1 = -6.5
     
    // regularization pole
    pr = 15 * z1
    // Make PD Controller 
    ctn = real((s-z1)*(-pr))
    ctd = real((s-pr))
    ctl = syslin('c', ctn/ctd)
    Kmax = 1000
end


if(EXAMPLE == 2) then
    ////////  Plant model
    p1 = -0.7+0.2*j
    p2 = -0.7-0.2*j
    pln = real((s+1))
    pld = real((s+2)*(s-p1)*(s-p2))
    plant = syslin('c', pln/pld)
    
    //   Desired Performance Specs
    Tsd = 1.333
    POSd = 0.10
    
    //////  Controller
    // PID Control zeros 
    z1 = -6+2*j
    z2 = z1'
    
    // regularization pole
    pr = 15 * min([real(z1),real(z2)])
    
    // Make PID Controller 
    ctn = real((s-z1)* (s-z2)*(-pr))
    ctd = real(s*(s-pr))
    ctl = syslin('c', ctn/ctd)
    Kmax = 1000
end

//// Plot RL with Specs
rl447(ctl*plant, 1, Tsd, POSd, Kmax)
a = gca()

//   Adjust plot ranges if nesc and set K value

if(EXAMPLE == 1) then
    a.data_bounds=[-140, -40 ; 20, 40]
    K=36
end
if(EXAMPLE == 1.1) then
    a.data_bounds=[-140, -40 ; 20, 40]
    K=13.6
end
if(EXAMPLE == 2) then
//    a.data_bounds=[-8 -5 ;1 5]
    K=20
end 

//
////////////////////////   Now lets Plot actual step response
//
//ctl2 = syslin('c', K*ctn*pln, 1+K*ctd*pld)

// Nifty scilab 'slashdot' operator
cltf = K*ctl*plant /. 1

t = 0:0.05:8;

scf(2)

Y = csim('step', t, cltf)

plot(t,Y)

a = gca()
a.data_bounds = [0, 0;  max(t), 1.5]

if(1)  then
   //  Draw Ts spec and 2% window
    plot([Tsd, Tsd], [0, 2], 'r--')
    wx = [0,8]
    wy1 = [1.0+POSd, 1.0+POSd]
    wy2 = [1.0-POSd, 1.0-POSd]
    plot(wx, wy1, 'g')
    plot(wx, wy2, 'g')
end
