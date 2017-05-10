% Use this script to plot some examples of RF pulses!
clc; clear all; close all;
addpath('./useful_functions')

%% Some examples of things you can plot...
% Change which experiment data to load & which RF pulses you want to view
% Experiment data & RF parameters specified in last 3 sections of Readme.m

exampnum = 3; % choose exampnum = 1, 2, or 3 

switch exampnum
    case 1
        % view RF pulse 1 of experiment 1 
        load('./Exp_1/Exp1p_grater.mat')
        load('./Exp_1/Exp1p_reference.mat')
        load('./Exp_1/Exp1r_programmed.mat')
        
        rfnum = 1;  % 2-band, TBW = 2 RF pulse
        
        programmed = Exp1r_programmed(rfnum,:)/max(abs(Exp1r_programmed(rfnum,:)));
        ref = Exp1p_reference(rfnum,:);
        GRATER = Exp1p_grater(rfnum,:);
    case 2
        % view RF pulse 16 from experiment 1
        load('./Exp_1/Exp1p_grater.mat')
        load('./Exp_1/Exp1p_reference.mat')
        load('./Exp_1/Exp1r_programmed.mat')
        
        rfnum = 16; % 5-band, TBW = 8 RF pulse
        
        programmed = Exp1r_programmed(rfnum,:)/max(abs(Exp1r_programmed(rfnum,:)));
        ref = Exp1p_reference(rfnum,:);
        GRATER = Exp1p_grater(rfnum,:);
    case 3
        % view RF pulse in subject 1 from experiment 3, no OVS
        load('./Exp_3/Exp3p_grater.mat')
        load('./Exp_3/Exp3p_reference.mat')
        load('./Exp_3/Exp3r_programmed.mat')
        
        rfnum = 7; % 2-band, TBW = 4 RF pulse
        
        programmed = Exp3r_programmed(rfnum,:)/max(abs(Exp3r_programmed(rfnum,:)));
        ref = Exp3p_reference(rfnum,:);
        GRATER = Exp3p_grater(rfnum,:);
end
%%

npts = size(programmed,2);

tms = linspace(0,2,npts);
figure();
% view programmed, reference, and GRATER waveforms togther
plot(tms,programmed/max(abs(programmed)),'k',...
    tms,ref/max(abs(ref)),'r',...
    tms,GRATER/max(abs(GRATER)),'b--',...
    'LineWidth',2)
set(gca,'FontSize',12,'FontWeight','bold');
axis tight; grid on;
xlabel('ms'); ylabel('a.u.');
legend('programmed','reference','GRATER');

NRMSErg = nrmse(ref,GRATER);
NRMSEpg = nrmse(programmed,GRATER);
NRMSEpr = nrmse(programmed,ref);
disp(['NRMSE: reference vs. GRATER = ' num2str(round(1000*NRMSErg)/1000) '.'])
disp(['NRMSE: programmed vs. GRATER = ' num2str(round(1000*NRMSEpg)/1000) '.'])
disp(['NRMSE: programmed vs. reference = ' num2str(round(1000*NRMSEpr)/1000) '.'])

