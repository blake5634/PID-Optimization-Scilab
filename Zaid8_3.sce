// setup.sce

//   Set up key variables for control design search.
//
//  version: Sept-2017
//

//   Final:
//
//[Overshoot =  1.10] Kp: 17.146  Ki: 14.289  Kd:  4.899
//Settling Time:  1.68  Overshoot:  9.9 percent  SSE:  0.001 gain margin: 10000.0 dB, Ctl Effort: 293.93877
//  Search boundary reached:  Kp min Ki min Kd max 
//

clear all;
xdel(winsid());   // close all graphics windows which might be open
funcprot(0);      // allow functions to be redefined without warnings.
//
//// Customize this to where your scilab files are
//DIR = 'C:\Users\zaidg\Desktop\ee447' 
// 

//cd(DIR)

// correct this for your own computer (may be higher or lower!)
npermin = 1250;   //  how many step responses per min on this computer

/////////////////////
//  uncomment these lines to make time predictions more accurate

// load('simrate_optigain2','rate');
// npermin = rate;
// printf ("Found rate file: %d simulations per min.\n",npermin);



////////////////////////////////////////////////////////////////
//
//       plant definition
//
s=%s
j=%i

Htf = s/s;
H = syslin('c', Htf);

tmax =5*0.75;  // seconds
dt = tmax/100;


// Plant Transfer Function

p1 = -8 + j
p2 = - 8 - j
np =  real(50)
dp =  real((s-p1)*(s-p2)*(s+15));
plant =   syslin('c', np/dp);

////  set this about 10 times higher than highest plant pole/zero
    pp = 20*15;  //  pole to rationalize PID controller

////////////////////////////   Desired Performance

tsd =   0.75;   // Desired Settling Time
pod =  1.05;   // Desired Percent Overshoot
ssed =  0.0;   // Desired Steady State Error

cu_max = 30;  //  Normalization value for control effort.

gmd = 20;   // desired gain margin

////////////////////////////   Search range and step

nvals =20;  // number of gain values to try btwn kmax and kmin

//  Search region setting:   set K1-K3 for the "center" PID values

// Kp center value
Kp = 50   ;

// KI center value
Ki = 0 ;

// Kd center value
Kd = 1;

K1=Kp;K2=Ki;K3=Kd  //  K1-K3 is notation used by optimization
//   "center values" are logarithmic midpoint of search range

scale_range = 5;    // how big a range to search.


tsearch=((nvals+1)^3)/npermin;
if(tsearch < 120) then
   printf("\n\nEstimated search time: %4.1f minutes\n", tsearch);
   else
   printf("\n\nEstimated search time: %4.1f hours\n", tsearch/60.0);
 end

// start the optimzation run automatically
exec('optigain7.sce',-1);


