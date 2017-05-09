function [ rf_env ] = built_in_wfm_func( dt, res, sinccyc,ext,numbands,slthk,ampgrad )
% [ rf_env] = built_in_wfm_func( dt, res, ...
%               sinccyc,ext,numbands,slthk,ampgrad )
% generates 'programmed' or 'desired' multiband pulse 
%       inputs:     dt - dwell time
%                   res - resolution of RF pulse
%                   sinccyc - number of sinc cycles
%                   ext - total extent of multiband pulses
%                   numbands - number of multiband pulses
%                   slthk - slice thickness of each band
%                   ampgrad - amplitude of slice select gradient
%
%       outputs:    rf_env - envelope of programmed RF pulse


scale    = 0.2; % scale real part of waveform 
scalei	= 1/(pi); % scale phase 
GAM = 4257.59; % gyromagnetic ratio
max_iamp = 32767; % max instruction amplitude

spacing = ext/numbands;
for band = 1:numbands
    sliceloc(band) = -spacing/2*(numbands-1) + spacing*(band-1);
end

for itr = 1:res
    % create a single-band sinc function
    x(itr) = ((itr) - res/2.0)*2.0/res;
    snc(itr) = sin(sinccyc*2*pi*x(itr) + 0.00001)/(sinccyc*2*pi*x(itr) + 0.00001);
    ms(itr) = snc(itr)*(0.54+0.46*cos(pi*x(itr)));
    ms(itr) = 4.0*ms(itr)/res;
    
    % crease sum of cosines 
    re_rf = 0.0;
    for band = 1:numbands
        re_rf = re_rf + cos(GAM*2*pi*ampgrad*sliceloc(band)*(itr)*dt);
    end
    re_rf = ms(itr)*re_rf;
    
    % real waveform
    B(itr) = 0.0;
    B(itr) = re_rf; 
   
    % scale multiband waveform for scanner use
    re_mb_wfm(mb_itr3,itr) = 0;
    re_mb_wfm(mb_itr3,itr) = (max_iamp*res/numbands*scale*B(itr)); 
    re_mb_wfm(mb_itr3,itr) = (2*((re_mb_wfm(mb_itr3,itr)/2))); %/* EVENIZE */
    if (re_mb_wfm(mb_itr3,itr) == 0)
        re_mb_wfm(mb_itr3,itr) = 2;
    end
    
end

rf_env = re_mb_wfm;



end

