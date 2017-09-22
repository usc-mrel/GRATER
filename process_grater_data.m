%% process grater data %%
clear all; close all;
addpath('./useful_functions');

%%%% choose an experiment number (1/2/3) & to plot results or not (1/0) %%%

% expno = 1 -- Exp 1A: Near-ideal conditions (Uniform Sphere phantom)
%                      fig 3A: averaged GRATER vs. averaged OVS+GRATER 
% expno = 2 -- Exp 1B: Near-ideal conditions (Uniform Sphere phantom)
%                      fig 3B: RGA=-G and RGA =-G/2 vs. # averages
% expno = 3 -- Exp 1C: Near-ideal conditions (Uniform Sphere phantom)
%                      fig 4:  5-band, TBW=8 pulse with & without OVS
% expno = 4 -- Exp 2: Non-ideal conditions: Large flip-anges
% expno = 5 -- Exp 3: Non-ideal conditions: Inhomogeneous volumes

expno = 5;
plotflag = 1; 



%% load target & reference data

switch expno

    case 1 
        % Experiment 1A
        
        load('./Exp_1/exp1_programmed');
        load('./Exp_1/exp1A_OVS')
        %load('./Exp_1/exp1A_no_OVS')
        
        %tgt = exp1A_no_OVS;
        tgt = exp1A_OVS;  
        ref = exp1_programmed; 
        
        lg_FA_flag = 0;
        
    case 2
        % Experiment 1B
        
        load('./Exp_1/exp1_programmed');
        %load('./Exp_1/exp1B_RGA_G')
        load('./Exp_1/exp1B_RGA_half_G')
        
        %tgt = exp1B_RGA_G;
        tgt = exp1B_RGA_half_G;
        ref = repmat(exp1_programmed(16,:),32,1);
        
        lg_FA_flag = 0;
         
    case 3  
        % Experiment 1C
        
        load('./Exp_1/exp1_programmed');
        %load('./Exp_1/exp1C_no_OVS');
        load('./Exp_1/exp1C_OVS');
        
        ref = exp1_programmed(16,:);
        %tgt = exp1C_no_OVS;
        tgt = exp1C_OVS;
        
        lg_FA_flag = 0;
        
    case 4
        % Experiment 2
        
        load('./Exp_2/exp2_grater');
        load('./Exp_2/exp2_programmed');
        
        tgt = exp2_grater;
        ref = exp2_programmed;
        
        lg_FA_flag = 1;
        
    case 5
        % Experiment 3
        
        load('./Exp_3/exp3_grater');
        load('./Exp_3/exp3_programmed');
        
        tgt = exp3_grater;
        ref = exp3_programmed;
        
        lg_FA_flag = 0;   



end

%%%  numbers of waveforms & points per waveform %%%
nwfms = size(tgt,1);    % # waveforms
npts = size(tgt,2);     % pts per waveform

nparams = 5;            % # adjustment params: [t0, phi, df, A, T2*]

%%% preallocate space %%%
NRMSE_vec = zeros(1,nwfms);
wfm_vec = zeros(nwfms,npts);
param_vec = zeros(nwfms,nparams);

%%% initial time-shift in waveform %%%
sft = repmat(-1,1,nwfms);
if expno == 3; sft = [-1 -2 -2 -2 -2 -2 3 3 2 2]; end;

%% adjust GRATER waveform %%
tic

for wfm = 1:nwfms
    
    if expno == 1 && wfm == 17; npts = 320; end; % special complex wfm
    
    %%%%%%% step 1: flip GRATER waveform %%%%%%%
    tgt2 = flip(tgt(wfm,1:npts));
    tgt2 = circshift(tgt2,sft(wfm));

    ref2 = ref(wfm,1:npts);%/max(abs(ref(wfm,1:npts)));
    


    %%%%%%% step 2: find adjustment parameters %%%%%%%
    % inputs for bounded MNLS problem
    in.t = linspace(4e-6,npts*4e-6,npts);
    in.ref = ref2;
    in.tgt = tgt2;
    in.lg_FA_flag = 0;
    in.plotflag = plotflag;
    
    % loop to solve bounded MNLS problem with different initial df & phi

    [ tgt3, params ] = wfm_adjust_loop_fun( in );
    
    % calculate NRMSE & if waveform is real, use real part



    if wfm == 17 && expno == 1
        NRMSE_vec(wfm)      = nrmse(ref2,tgt3);
        wfm_vec(wfm,:)      = zeros(1,500);
        wfm_vec(wfm,1:npts) = tgt3;
    else
        NRMSE_vec(wfm)      = nrmse(ref2,real(tgt3));
        wfm_vec(wfm,:)      = real(tgt3);
    end

    param_vec(wfm,:) = params;
    


end
%% display final NRMSE
NRMSE_vec

figure(1);
subplot(2,1,1)
plot(in.t,ref(wfm,:),'k',in.t,tgt3,'b--','LineWidth',1)
xlabel('t (s)'); ylabel('a.u.')
title('rect phantom')
legend('programmed','GRATER')
set(gca,'FontSize',16)

subplot(2,1,2)
plot(in.t,ref(wfm,:)-tgt3,'r','LineWidth',1)
xlabel('t (s)'); ylabel('a.u.'); ylim([-0.05 0.05]);
legend('programmed-GRATER')
set(gca,'FontSize',16)


