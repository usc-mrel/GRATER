function [ adjusted_wfm ] = wfm_adjust_loop_fun( in )
% [ adjusted_wfm ] = wfm_adjust_loop_fun( in )
% loop function: calls wfm_adjust several times with different initial
% values for phi and df, and takes waveform results with least NRMSE
%       
%  
%  input struct in:    in.t         - time vector for waveforms
%                      in.ref       - reference waveform vetor
%                      in.tgt       - target waveform vector
%                      in.lg_FA_flag- change bounds if using large FAs
%                      in.plotflag  - flag to plot updated waveform or not
%                      in.init_vals - initial vals: [t0, phi, df, A, T2*];
%
%  output:             adjusted_waveform   - updated target waveform vector

%%% preallocate space %%%
NRMSE_opts = zeros(1,100);

% starting vals: phi and df
phi = linspace(-pi,pi,10);
df  = linspace(-600,600,10);

% loop: solve bounded MNLS problem for different initial vals
tgt3_opts = [];
for phi_idx = 1:length(phi)
    for df_idx = 1:length(df)
        % initial vals
        in.init_vals = [0e-6, phi(phi_idx), df(df_idx),...
            max(abs(in.tgt))/max(abs(in.ref)), 1e-3];
        
        % adjusted waveform solutions for init_vals
        [out] = wfm_adjust(in);
        
        % calculate NRMSE
        NRMSE = nrmse(in.ref,out.tgt_ud);
        
        % store adjusted waveforms & record NRMSE
        tgt3_opts(phi_idx +length(df)*(df_idx-1) ,:) = out.tgt_ud;
        NRMSE_opts(phi_idx+length(df)*(df_idx-1))    = NRMSE;
    end
end
toc

% take adjusted waveform that gave least NRMSE
best_wfm_loc = find(NRMSE_opts == min(NRMSE_opts));
tgt3         = tgt3_opts(best_wfm_loc(1),:);

%% plot updated wfm (flagged)
if in.plotflag == 1
    a = real(ref2);
    aa = imag(ref2);
    b = real(tgt3);
    c = imag((tgt3));
    
    figure(wfm);
    plot(1:npts,a,'r.', ...
        1:npts,aa,'c.', ...
        1:npts,b,'g.', ...
        1:npts,c,'b.')
    legend('re(ref)','im(ref)','re(tgt)','im(tgt)');
    grid on;
    
end

adjusted_wfm = tgt3;

end

