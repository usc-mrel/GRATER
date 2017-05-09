%% process grater data %%
clear all; close all;
addpath('./useful_functions');

%%%% choose an experiment number (1/2/3) & to plot results or not (1/0) %%%
% Exp 1: Near-ideal conditions (Uniform Sphere phantom)
% Exp 2: Non-ideal conditions: Large flip-anges
% Exp 3: Non-ideal conditions: Inhomogeneous volumes

expno = 3;
plotflag = 0; 

%% load target & reference data

switch expno
    case 1
        load('./Exp_1/Exp1r_grater');
        load('./Exp_1/Exp1p_reference');
  
        tgt = Exp1r_grater;
        ref = Exp1p_reference;
        
        lg_FA_flag = 0;
        sft = repmat(-1,1,nwfms);
        
    case 2
        load('./Exp_2/Exp2r_grater');
        load('./Exp_2/Exp2r_programmed');
        
        tgt = Exp2r_grater;
        ref = Exp2r_programmed;
        
        lg_FA_flag = 1;
        sft = repmat(-1,1,nwfms);
        
    case 3
        load('./Exp_3/Exp3r_grater');
        load('./Exp_3/Exp3p_reference');
        
        tgt = Exp3r_grater;
        ref = Exp3p_reference;
        
        lg_FA_flag = 0;
        sft = [-1 -2 -2 -2 -2 -2 3 3 2 2];
end

%%%  numbers of waveforms & points per waveform %%%
nwfms = size(tgt,1);    % # waveforms
npts = size(tgt,2);     % pts per waveform

%%% preallocate space %%%
NRMSE_vec = zeros(1,nwfms); 
wfm_vec = zeros(nwfms,npts);

%% adjust GRATER waveform %%
tic 
for wfm = 1:nwfms
    
    if expno == 1 && wfm == 17; npts = 320; end; % special complex wfm
    
    %%%%%%% step 1: flip GRATER waveform %%%%%%%
    tgt2 = flip(tgt(wfm,1:npts));
    tgt2 = circshift(tgt2,sft(wfm));
    ref2 = ref(wfm,1:npts);
  
    %%%%%%% step 2: find adjustment parameters %%%%%%%
    % inputs for bounded MNLS problem
    in.t = linspace(4e-6,npts*4e-6,npts);
    in.ref = ref2;
    in.tgt = tgt2;
    in.lg_FA_flag = 0;
    in.plotflag = plotflag;
    
    % loop to solve bounded MNLS problem with different initial df & phi
    [ tgt3 ] = wfm_adjust_loop_fun( in );
    
    % calculate NRMSE & if waveform is real, use real part  
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

