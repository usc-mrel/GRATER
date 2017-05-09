%% Experiment 2: Non-ideal conditions (large flip angles)

clc; clear all;
addpath('./Exp_2_BlochSim/');
load('./Exp_2/Exp2r_programmed');

%% simulation parameters

b1 = Exp2r_programmed(1,:);     % RF envelope                 (to simulate)
b1res = length(b1);             % RF resolution               (points)
dT = .004;                      % RF dwell time               (ms)
t = dT:dT:(dT*2*b1res);         % RF pulse duration           (ms)

T1 = 2000;                      % longitudinal relaxation time(ms)
T2 = 200;                       % transverse relaxation time  (ms)

zpos = -30:0.2:30;              % selected locations          (cm)
zmid = round(length(zpos)/2);   % middle location             (cm)
G = 0.733983;                   % gradient amplitude          (G/cm)

n_FA = 16;                      % # of flip angles to test    (points)
FAvec = linspace(5,90,n_FA);    % flip angle values           (degrees)

M = zeros(3,length(t),n_FA,length(zpos));  % magnetization vector M
[A,B] = freeprecess(dT,T1,T2,0);           % Cayley-Klien parameters 

%% Bloch simulations of GRATER

for FA=1:n_FA
    
    %%% adjust FA for RF pulse %%%
    rf = 2*pi*4258*b1*(dT/1000);
    rf = rf/(sum(rf)*180/pi);
    rf = rf*FAvec(FA); 
    
    %%% Bloch simulation of GRATER for each position %%%
    for z = 1:length(zpos)
        M(:,1,FA,z) = [0;0;1]; % assume thermal equilibrium
        M(:,1,FA,z) = throt(abs(rf(1)),angle(rf(1)))*M(:,1,FA,z); 
        
        %%% RF excitation with constant gradient %%%
        for k = 2:length(rf)
            %%% gradient with amplitude G %%%
            gradrot = 4258*2*pi*(dT/1000)*G*zpos(z);
            M(:,k,FA,z) = zrot(gradrot)*M(:,k-1,FA,z);
            %%% RF excitation %%%
            M(:,k,FA,z) = A*M(:,k,FA,z)+B; 
            M(:,k,FA,z) = throt(abs(rf(k)),angle(rf(k)))*M(:,k,FA,z); 
        end;
        
        %%% signal reception with inverted gradient %%%
        for k = length(rf)+1: 2*length(rf)
            %%% gradient with amplitude -G %%%
            gradrot = 4258*2*pi*(dT/1000)*-G*zpos(z);
            M(:,k,FA,z) = zrot(gradrot)*M(:,k-1,FA,z);
            %%% readout %%%
            M(:,k,FA,z) = A*M(:,k,FA,z)+B;
        end;
        
    end;
end;

% GRATER signal: 1D temporal signal averaged over whole excited volume 
%%%%%%%%%%%%%%%%%%%%% i.e. s(t) = int(M(r,t))dV  %%%%%%%%%%%%%%%%%%%%%

s = zeros(3,n_FA,length(t));
for FA = 1:n_FA
    for k = 1:length(t)
        for r = 1:3
            s(r,FA,k) = squeeze(sum(M(r,k,FA,:)* ...
                        exp(4258*2*pi*(dT/1000)*G*zpos(zmid))));
        end
    end
end

%% plot results

% choose green/blue color order for plotting GRATER simulations
co = [];
for itr = n_FA:-1:1
    co = [co; 0 itr/n_FA (n_FA-itr)/n_FA ];
end
set(groot,'defaultAxesColorOrder',co)

figure(100); clf;
% plot GRATER simulations for each flip angle
for ii = 1:n_FA
    scaled(ii,:) = squeeze(s(2,ii,:))/max(squeeze(s(2,ii,(321:end))));
    p.im(ii) = plot(linspace(0,1.28,320),scaled(ii,321:end),'LineWidth',1.5);
    hold on; axis tight; axis square;
end

% plot programmed waveform in red
p.ref = plot(linspace(0,1.28,320),b1/max(b1),'r--','LineWidth',2);

% legends, labels, formatting
legend([ p.im(1) p.im(n_FA) p.ref], ...
        'FA = 5 (sim)',' FA = 90 (sim)','programmed')
ylabel('a.u.'); xlabel('time (ms)')
title('simulated GRATER measurements')
axis tight;
ax = gca;
set(ax,'FontSize',14,'FontWeight','bold','LineWidth',1);
ax.XAxis.MinorTick = 'on';
ax.XAxis.MinorTickValues = 0:0.05:1.28;
ax.YAxis.MinorTick = 'on';
ax.YAxis.MinorTickValues = 0:0.05:1.28;

