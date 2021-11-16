clear all

kp = 1.0
ki = 0
kd = 1.0

K1  = kp
K2 =  ki
K3 = kd
scale_range = 4

nvals = 3

scalef = sqrt(scale_range);

kmin  = K1/scalef ;  kmax = K1*scalef;
kimin = K2/scalef;   kimax = K2*scalef;
kdmin = K3/scalef;   kdmax = K3*scalef;


// Increments
dk  = (kmax-kmin)/nvals;
dki = (kimax-kimin)/nvals;
dkd = (kdmax-kdmin)/nvals;

if(kd == 0) then
    dkd =1 
end
if(kp == 0) then
    dkp = 1
end
if(ki == 0) then
    dki = 1
end

  
for Kp = kmin:dk:kmax,
    for Ki = kimin:dki:kimax,
        for Kd = kdmin:dkd:kdmax,
            printf "got there\n"
        end
    end
end
