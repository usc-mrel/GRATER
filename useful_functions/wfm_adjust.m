function [out] = wfm_adjust(in)

%  [out] = wfm_adjust(in)
%  corrects for amplitude, T2*, off-resonance, scaling, and time-shifts
%  using a bounded minimum norm least squares problems
%  
%  input struct in:    in.t         - time vector for waveforms
%                      in.ref       - reference waveform vetor
%                      in.tgt       - target waveform vector
%                      in.lg_FA_flag- change bounds if using large FAs
%                      in.plotflag  - flag to plot updated waveform or not
%                      in.init_vals - initial vals: [t0, phi, df, A, T2*];
%
%  output struct out:  out.est      - est params: [t0, phi, df, A, T2*];
%                      out.model    - model for correcting waveform
%                      out.tgt_ud   - updated target waveform vector

%% model setup
model = @wfm_adjust_fun;
options = optimset('Display', 'off') ;

time = in.t;
reference  = in.ref;
target = in.tgt;
init_vals = in.init_vals;

% specify lower and upper bounds for [t0, phi, df, A, t2*]
if in.lg_FA_flag
    lb = [0, -pi,  -600, init_vals(4)*0.1,  20000e-3];
    ub = [0,   pi,  600, init_vals(4)*5,    20000e-3];  
else
    lb = [-10e-6, -pi, -600, init_vals(4)*0.1,  1e-3]; 
    ub = [10e-6,   pi,  600, init_vals(4)*5,    20000e-3]; 
end


%% estimate time shift

[est, ~]= fmincon(model,init_vals,[],[],[],[],lb,ub,[],options);

tgt_ud_ft  = fft(1/est(4)*target.*exp(1j*est(2)).*exp(1i*2*pi*est(3)*time).*exp(-time/est(5))); 
tgt_ud_ft  = tgt_ud_ft.*exp(1i*2*pi.*linspace(-5000,5000,length(reference))*est(1));
tgt_ud_ft(isnan(tgt_ud_ft)) = 0;
tgt_ud = ifft(tgt_ud_ft);

%% function we want to minimize

    function [sse, FittedCurve] = wfm_adjust_fun(params)
        t0    = params(1);
        phase = params(2);
        df    = params(3);
        k     = params(4);
        t2star= params(5);
        
        FittedCurve = ifft(fft(k*reference.*exp(-1j*phase).* ...      %  scaling & phase
            exp(time/t2star).* ...  % T2star decay ...
            exp(-1i*2*pi*df*time)).* ... % off-resonance
            exp(-1i*2*pi.*linspace(-5000,5000,length(reference))*t0)); % time shift
        FittedCurve(isnan(FittedCurve)) = 0;
        ErrorVector = FittedCurve - target;

        sse = norm(ErrorVector);

    end

out.est = est;
out.model = model;
out.tgt_ud = tgt_ud;

end
