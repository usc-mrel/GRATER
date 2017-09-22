%% process coax (reference) data for experiment 1 or 3
clear all; close all;
addpath('./useful_functions');

%%%% choose an experiment number (1 or 3) & to plot or not (1 or 0) %%%
% Exp 1: Near-ideal conditions:(Uniform Sphere phantom)
% Exp 2: Non-ideal conditions: Large flip-anges - no pick-up coil data used
% Exp 3: Non-ideal conditions: Inhomogeneous volumes

expno = 3;
plotflag = 0;

%% load target & reference data

switch expno
    case 1    

        nwfms = 16; % # waveforms
        npts = 500; % pts per waveform
        
        load('./Exp_1/exp1_PUC'); % load pick-up coil data
        load('./Exp_1/exp1_programmed');% load EPIC data
        
        tgt = exp1_PUC;
        ref = exp1_programmed;

        
        fc = 127717363; % center frequency of experiment
              
    case 2
         % no pick-up coil data used
    case 3
        nwfms = 5; % # waveforms
        npts = 320; % pts per waveform

        load('./Exp_3/exp3_PUC'); % load pick-up coil data
        load('./Exp_3/exp3_programmed');% load EPIC data
        
        tgt = exp3_PUC;
        ref = exp3_programmed;

        
        fc = 127717606; % center frequency of experiment

end

%%% preallocate space %%%
NRMSE_vec = zeros(1,nwfms); 
wfm_vec = zeros(nwfms,npts);

%% adjust GRATER waveform %%
tic 
for wfm = 1:nwfms
    
    if expno == 1 && wfm == 17; npts = 320; end; % special complex wfm
  
    %%%%%%% step 1: bandpass filter, demodulate, & low-pass filter waveform
    [re_wfm, im_wfm] = wfm_demod(fc,tgt{wfm},npts);
    tgt2 = re_wfm.' + 1i*im_wfm.';
    tgt2 = tgt2/max(abs(tgt2));
    ref2 = ref(wfm,1:npts)/max(abs(ref(wfm,1:npts)));
    
    %%%%%%% step 2: find adjustment parameters %%%%%%%
    % inputs for bounded MNLS problem
    in.t = linspace(4e-6,npts*4e-6,npts);
    in.ref = ref2;
    in.tgt = tgt2;
    in.lg_FA_flag = 0;
    in.plotflag = plotflag;
    
    % loop to solve bounded MNLS problem with different initial df & phi
    [ tgt3 ] = wfm_adjust_loop_fun( in );
    
     % calculate NRMSE: if waveform is real, take real part  
    if wfm == 17 && expno == 1
        NRMSE_vec(wfm)      = nrmse(ref2,tgt3);
        wfm_vec(wfm,:)      = zeros(1,500);
        wfm_vec(wfm,1:npts) = tgt3;
    else
        NRMSE_vec(wfm)      = nrmse(ref2,real(tgt3));
        wfm_vec(wfm,:)      = real(tgt3);
    end
    
end
%% display final NRMSE
NRMSE_vec