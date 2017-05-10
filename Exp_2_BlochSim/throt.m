
function Rth=throt(phi,theta)
% function Rth=throt(phi,theta)
% rotate magnetization vector by some angle theta

Rz = zrot(-theta);
Rx = xrot(phi);
Rth = inv(Rz)*Rx*Rz;

end

