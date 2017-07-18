% Use this script to plot some examples of RF pulses!
clc; clear all; 
addpath('./useful_functions')

%% Some examples of things you can plot...
% Change which experiment data to load & which RF pulses you want to view
% Experiment data & RF parameters specified in last 3 sections of Readme.m

exampnum = 1; % choose exampnum = 1, 2, or 3 

switch exampnum
    case 1
        % view RF pulse 1 of experiment 1A
        % 2-band, TBW = 2 RF pulse with averaged OVS+GRATER measurements
        
        load('./Exp_1/exp1A_OVS_p.mat')
        load('./Exp_1/exp1_PUC_p.mat')
        load('./Exp_1/exp1_programmed.mat')
        
        rfnum = 1;  
        
        programmed = exp1_programmed(rfnum,:)/max(abs(exp1_programmed(rfnum,:)));
        PUC = exp1_PUC_p(rfnum,:);
        GRATER = exp1A_OVS_p(rfnum,:);
        
    case 2
        % view RF pulse 32 of experiment 1B
        % 5-band, TBW = 8 RF pulse with averaged OVS+GRATER and RGA=-G/2
        
        load('./Exp_1/exp1B_RGA_half_G_p.mat')
        load('./Exp_1/exp1_PUC_p.mat')
        load('./Exp_1/exp1_programmed.mat')
        
        rfnum = 16;  % 5-band, TBW = 8 rf pulse
        avgnum = 32; % 32*2 averages
        
        programmed = exp1_programmed(rfnum,:)/max(abs(exp1_programmed(rfnum,:)));
        PUC = exp1_PUC_p(rfnum,:);
        GRATER = exp1B_RGA_half_G_p(avgnum,:);
    case 3
        % view RF pulse in subject 1 from experiment 3, no OVS
        load('./Exp_3/exp3_grater_p.mat')
        load('./Exp_3/exp3_PUC_p.mat')
        load('./Exp_3/exp3_programmed.mat')
        
        rfnum = 7; % 7: 2-band, TBW = 4 RF pulse
        
        programmed = exp3_programmed(rfnum,:)/max(abs(exp3_programmed(rfnum,:)));
        PUC = exp3_PUC_p(rfnum,:);
        GRATER = exp3_grater_p(rfnum,:);
end
%% View programmed, reference, and GRATER waveforms togther

npts = size(programmed,2);
tms = linspace(0,2,npts);


figure(1);
plot(tms,programmed/max(abs(programmed)),'k',...
    tms,PUC/max(abs(PUC)),'g',...
    tms,GRATER/max(abs(GRATER)),'m',...
    'LineWidth',2)
set(gca,'FontSize',30,'FontWeight','bold','FontName','Arial');
axis tight; grid on;
xlabel('ms'); ylabel('a.u.');
legend('programmed','PUC','GRATER');

diff_pr_pc = programmed/max(abs(programmed)) - PUC/max(abs(PUC));
diff_pr_gr = programmed/max(abs(programmed)) - GRATER/max(abs(GRATER));
diff_pc_gr = PUC/max(abs(PUC)) -  GRATER/max(abs(GRATER));

pdiff_pr_pc = abs(diff_pr_pc)./abs(programmed/max(abs(programmed)));
pdiff_pr_pc(pdiff_pr_pc>1) = 1;
pdiff_pr_gr = abs(diff_pr_gr)./abs(programmed/max(abs(programmed)));
pdiff_pr_gr(pdiff_pr_gr>1) = 1;
pdiff_pc_gr = abs(diff_pc_gr)./abs(PUC/max(abs(PUC)));
pdiff_pc_gr(pdiff_pc_gr>1) = 1;

%% Calculate NRMSE

NRMSErg = nrmse(PUC,GRATER);
NRMSEpg = nrmse(programmed,GRATER);
NRMSEpr = nrmse(programmed,PUC);
disp(['NRMSE: PUC vs. GRATER = ' num2str(round(1000*NRMSErg)/1000) '.'])
disp(['NRMSE: programmed vs. GRATER = ' num2str(round(1000*NRMSEpg)/1000) '.'])
disp(['NRMSE: programmed vs. PUC = ' num2str(round(1000*NRMSEpr)/1000) '.'])

