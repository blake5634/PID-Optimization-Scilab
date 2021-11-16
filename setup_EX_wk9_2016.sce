// Lec8Prob2.sce

//   Set up key variables for control design search.
//
//  version: 27-Sept-2011
//


clear all;
xdel(winsid());   // close all graphics windows which might be open
funcprot(0);      // allow functions to be redefined without warnings.
DIR = '/home/blake/Dropbox/447/Scilab447/PID_Design/'  //  customize to the place you store the

cd(DIR)

// correct this for your own computer (may be higher or lower!)
npermin = 1250;   //  how many step responses per min on this computer

/////////////////////
//  uncomment these lines to make time predictions more accurate

load('simrate_optigain','rate');
npermin = rate;
printf ("Found rate file: %d simulations per min.\n",npermin);


////////////////////////////////////////////////////////////////
//
//       plant definition
//
s = poly(0,'s');

Htf = s/s;
H = syslin('c', Htf);

tmax = 3.5;  // seconds
dt = tmax/100;

wn = 6, z =0.7
// Plant Transfer Function 
ptf =   235/(s*(s+8)*(s^2 + 2*z*wn*s + wn^2));
plant =      syslin('c', ptf);

////  set this about 10 times higher than highest plant pole/zero
    pp = 150;  //  pole to rationalize PID controller

////////////////////////////   Desired Performance

tsd =   0.001;   // Desired Settling Time
pod =  1.10;   // Desired Percent Overshoot
ssed =  0.0;   // Desired Steady State Error
gmd = 20.00
cu_max = 200.0;  //  Normalization value for control effort.



////////////////////////////   Search range and step

nvals = 12;  // number of gain values to try btwn kmax and kmin
 
//  Search region setting:   set K1-K3 for the "center" PID values 
//
//// Kp center value
//K1 = 4;  
//                           Good soln but osciliatory 
//// KI center value
//K2 = .4 ;  
//
//// Kd center value 
//K3 = 1.35;


// Kp center value
K1 = 400;  

// KI center value
K2 = 40 ;  

// Kd center value 
K3 = 135;


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


