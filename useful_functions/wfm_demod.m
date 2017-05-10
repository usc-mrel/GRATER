function [ demod_wfm, demod_wfmi ] = wfm_demod(f_c,reference,npts)
% function [ demod_wfm, demod_wfmi ] = wfm_demod(f_c,reference,npts)
% demodulates, filters, and downsamples the pick-up coil (reference) data
% waveform
%
% inputs:       f_c        - carrier frequency
%               reference  - reference waveform struct:
%                           reference.out_descript.Fs = sampling frequency
%                           reference.outdata = modulated waveform vector
%               npts       - resolution of demodulated waveform (# of pts)
%
% outputs:      demod_wfm  - real part of demodulated waveform
%               demod_wfmi - imaginary part of demodulated waveform
%

f_s = reference.out_descript.Fs; % easier way to call samp. freq...
dt = 4e-6; % dt of transmitted rf waveform

%% bandpass filter, 25MHz range around center frequency
f_cut_low = f_c - 5e6; 
f_cut_high = f_c + 5e6;
Wn_low = f_cut_low/(1/2*f_s); 
Wn_high = f_cut_high/(1/2*f_s); 
[B_l,A_l] = cheby2(6,40,Wn_low,'low'); % Chebyshev type 2 filter, 6rd order
[B_h,A_h] = cheby2(6,40,Wn_high,'high'); % flat passband

Y_l = filter(B_l,A_l,reference.outdata);
Y_h = filter(B_h,A_h,Y_l);

%% demodulate to center frequency
[rf rfi]= demod(Y_h,f_c,f_s,'qam');

%% 500 KHz lowpass filter signal
f_cut = 200e3; % 500 kHz cutoff frequency
Wn = f_cut/(1/2*f_s); 
[B,A] = butter(3,Wn,'low'); % lowpass Butterworth filter

Y = filter(B,A,rf);
Yi = filter(B,A,rfi);

%%  downsample 
Y = downsample(Y,ceil(length(Y)/npts)); % closest downsamp value to npts...
Yi = downsample(Yi,ceil(length(Yi)/npts));

%% output data
demod_wfm = Y(1:npts); 
demod_wfmi = Yi(1:npts);

end

