% Experiments 1A, 1B, and 1C

%% Experiment 1A (Figure 3A)

load('./Exp_1/exp1A_OVS_NRMSE') %ovs
load('./Exp_1/exp1A_no_OVS_NRMSE'); % avg
load('./Exp_1/exp1A_PUC_NRMSE');

NRMSE_mat = [exp1A_no_OVS_NRMSE; ...
    exp1A_OVS_NRMSE; ...
    exp1A_PUC_NRMSE]*100;

nwfm = 1:length(exp1A_PUC_NRMSE);

figure(1)

plot(nwfm,NRMSE_mat(1,:), 'hr', ...
    nwfm,NRMSE_mat(2,:), 'dm', ...
    nwfm,NRMSE_mat(3,:), 'sg', ....
    0:17, ones(1,18)*2.4, ...
    '--k', 'LineWidth' , 3,'MarkerSize',8)

g = legend('GRATER','OVS+GRATER','PUC','Location','best');

set(g,'Interpreter','LaTex', ...
    'LineWidth',2, ...
    'FontWeight','bold', ...
    'FontName','Arial')
 
xticks(1:17)
xticklabels({'2,2','2,4','2,6','2,8' ...
             '3,2','3,4','3,6','3,8' ...
             '4,2','4,4','4,6','4,8' ...
             '5,2','5,4','5,6','5,8','cplx'});
ylabel(' NRMSE (%) ')
set(gca,'FontSize',20,'FontWeight','bold','DefaultAxesFontName', 'Arial');
xlim([0.5 16.5]); % 17.5]); 
ylim([0 6.2]);
xlabel('pulse (# bands, TBW) ')

%% Experiment 1B (Figure 3B)

load('./Exp_1/exp1B_RGA_G_NRMSE.mat')
load('./Exp_1/exp1B_RGA_half_G_NRMSE.mat')

numav = [1 2:2:64];
figure(2)
plot( numav,exp1B_RGA_G_NRMSE, 'bo',...
     numav,exp1B_RGA_half_G_NRMSE, 'c^',...
     'LineWidth',3,'MarkerSize',8);
xlabel(' # averages '); ylabel(' NRMSE (%) ');
set(gca,'FontSize',20, ...
        'FontWeight','bold',...
        'DefaultAxesFontName', 'Arial');
xlim([0 65]); ylim([0 6.1]);
legend(' 5 bands, TBW=8' ,...
       ' 5 bands, TBW=8, 2usec ')
 
hold on;
a=lsqcurvefit(@(a,numav) a(1)./sqrt(numav) + a(2),[5 2],numav,exp1B_RGA_G_NRMSE);
plot(numav,a(1)./sqrt(numav) + a(2),'b','LineWidth',2) %fit

b=lsqcurvefit(@(b,numav) b(1)./sqrt(numav) + b(2),[5 2],numav,exp1B_RGA_half_G_NRMSE);
plot(numav,b(1)./sqrt(numav) + b(2),'c','LineWidth',2) %fit


 h = legend('  RGA = -G ', ...
            '  RGA = -G/2 ' , ... 
            '  NRMSE = 1.9$\%$ + 3.7$\%$/$\sqrt{Navg} $ ', ...
            '  NRMSE = 0.9$\%$ + 4.2$\%$/$\sqrt{Navg} $ ');
 set(h,'Interpreter','LaTex', ...
     'LineWidth',2, ...
     'FontWeight','bold', ...
     'FontName','Arial')

%% Experiment 1C (Figure 4)

load('./Exp_1/exp1_programmed.mat')
load('./Exp_1/exp1_PUC_p.mat')
load('./Exp_1/exp1C_OVS_p');
load('./Exp_1/exp1C_no_OVS_p');

t = linspace(0,2,500);
figure(3)
subplot(2,1,1)
plot(t, exp1_programmed(16,:),'k', 'LineWidth',2);
hold on;
plot(t, exp1C_no_OVS_p,'b', ...
     t, exp1C_OVS_p,'c',...
     'LineWidth',2)
plot(t, exp1_PUC_p(16,:),'g', ...
     'LineWidth',1)
legend('programmed','GRATER','OVS+GRATER','PUC');
set(gca,'FontSize',20,'FontWeight','bold','DefaultAxesFontName', 'Arial');
axis tight; ylim([-0.23,0.15]);
ylabel(' a.u.'); 

subplot(2,1,2)
plot(t, (exp1_programmed(16,:) - exp1C_no_OVS_p),'b', ... 
     t, (exp1_programmed(16,:) - exp1C_OVS_p),'c', ...
     'LineWidth',2)
 hold on;
 plot(t, (exp1_programmed(16,:) - exp1_PUC_p(16,:)),'g', ...
     'LineWidth' , 1)
legend('GRATER','OVS+GRATER', 'PUC');
set(gca,'FontSize',20,'FontWeight','bold','DefaultAxesFontName', 'Arial');
axis tight; ylim([-0.05,0.05]);
ylabel(' programmed - measured (a.u.)'); xlabel(' time (ms) ')
