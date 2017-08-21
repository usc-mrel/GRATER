MATLAB Scripts for GRATER experiments
============================================================

*Vanessa Landes*, *Krishna Nayak*, August 2017.

[Magnetic Resonance Engineering Laboratory](https://mrel.usc.edu)

**University of Southern California**

Code Structure
--------------



### scripts in main folder:
   1. **process_grater_data.m** <br />
      This script will adjust GRATER data for amplitude A, angle phi,
      off-resonance df, sub-sample time shift t0, and T2* decay. Choose
      expno = 1, 2, or 3 to process data for the uniform sphere, large 
      flip angle, or non-homogeneous volume experiments, respectively. <br />
   2. **process_reference_data.m** <br />
       This script will process raw refererence (pick-up coil) data.
       Choose expno = 1 or expno = 3 to process data for the uniform
       sphere or non-homogeneous volume experiments, respectively. <br />
   3. **run_exp2_sm_lg_FA.m** <br />
       Run this script to simulate GRATER for different flip angles in a
       single-band pulse (choose different RF envelopes by changing
       b1 vector, or play around with simuation parameters) <br />
   4. **plot_some_examples.m** <br />
       Run this script to see some examples of the reference, programmed,
       and GRATER waveforms.
   4. **plot_exp1_figs.m** <br />
       Run this script to generate figures 3 and 4 from the GRATER manuscript.
   
### In folder Exp_2_BlochSim 
    (functions 2-6 are from http://mrsrl.stanford.edu/~brian/bloch/)

   1. **built_in_wfm_func.m** <br />
           *function [ rf_env] = built_in_wfm_func( dt, res,sinccyc,ext,numbands,slthk,ampgrad )* <br />
            generates 'programmed' or 'desired' multiband pulse 
   2. **freeprecess.m** <br />
           *function [Afp,Bfp]=freeprecess(T,T1,T2,df)* <br />
           Function simulates free precession and decay
           over a time interval T, given relaxation times T1 and T2 (ms)
           and off-resonance df.  Times in ms, off-resonance (Hz)
   3. **throt.m** <br />
           *function Rth=throt(phi,theta)* <br />
           rotate magnetization vector by some angle theta
   4. **xrot.m** <br />
           *function Rx=xrot(phi)* <br />
           rotate magetizatoin vector about x by angle phi
   5. **yrot.m** <br />
           *function Ry=yrot(phi)* <br />
           rotate magetizatoin vector about y by angle phi
   6. **zrot.m** <br />
           *function Rz=zrot(phi)* <br />
           rotate magetizatoin vector about z by angle phi

### In folder 'useful_functions':

  1. **nrmse.m** <br />
          *function nn = nrmse(xtrue, xhat)* <br />
          finds the nrmse between the true and estimated vectors 
   2. **wfm_adjust.m** <br />
          *function [out] = wfm_adjust(in)* <br />
          corrects for amplitude, T2*, off-resonance, scaling, and time-shifts
          using a bounded minimum norm least squares problems
   3. **wfm_adjust_loop_fun.m** <br />
          *function [ adjusted_wfm ] = wfm_adjust_loop_fun( in )* <br />
          loop function: calls wfm_adjust several times with different initial
          values for phi and df, and takes waveform results with least NRMSE
   4. **wfm_demod.m** <br />
          *function [ demod_wfm, demod_wfmi ] = wfm_demod(f_c,reference,npts)* <br />
          demodulates, filters, and downsamples the pick-up coil data

### In folder Exp_1 
    Data for exp 1: Near-ideal conditions (uniform sphere phantom)
    Each row of .mat files contain data for a different waveform, except
    exp1_PUC.mat which contains a struct, each cell entry with data
    for a different waveform. 
 
 Raw data files: 
   1. exp1_programmed.mat
   2. exp1A_no_OVS.mat
   3. exp1A_OVS.mat
   4. exp1B_RGA_G.mat
   5. exp1B_RGA_half_G.mat
   6. exp1C_no_OVS.mat
   7. exp1C_OVS.mat
   8. exp1_PUC.mat <- Raw PUC file available on dropbox:
 https://www.dropbox.com/sh/hczepl51ff58co4/AACj-fC93daV5tF1vTejIDH5a?dl=0

Processed data files:  
   1. exp1_PUC_p.mat
   2. exp1A_no_OVS_p.mat
   3. exp1A_OVS_p.mat
   4. exp1B_RGA_G_p.mat
   5. exp1B_RGA_half_G_p.mat
   6. exp1C_no_OVS_p.mat
   7. exp1C_OVS_p.mat
   
 NRMSE .mat files:
   1. exp1A_no_OVS_NRMSE.mat
   2. exp1A_OVS_NRMSE.mat
   3. exp1A_PUC_NRMSE.mat
   4. exp1B_RGA_G_NRMSE.mat
   5. exp1B_RGA_half_G_NRMSE.mat

Each row of the exp1 and exp1A.mat files contain data for a different waveform. 
Exp1 .mat files contain data for one waveform. 
Exp1A .mat files contain data for 64 averages of GRATER and OVS+GRATER with RGA=-G 
(see figure 3A of GRATER manuscript):
   1.  2 bands, TBW = 2
   2.  2 bands, TBW = 4
   3.  2 bands, TBW = 6
   4.  2 bands, TBW = 8
   5.  3 bands, TBW = 2
   6.  3 bands, TBW = 4
   7.  3 bands, TBW = 6
   8.  3 bands, TBW = 8
   9.  4 bands, TBW = 2
   10. 4 bands, TBW = 4
   11. 4 bands, TBW = 6
   12. 4 bands, TBW = 8
   13. 5 bands, TBW = 2
   14. 5 bands, TBW = 4
   15. 5 bands, TBW = 6
   16. 5 bands, TBW = 8
  
  Each row of the exp1B .mat files contain data for the 5-band, TBW=8 RF pulse with 
  64 averages of OVS+GRATER with RGA=-G and RGA=-G/2 (see figure 3B of GRATER manuscript).
  
  Each row of the exp1C .mat files ocntain data for the 5-band, TBW=8 RF pulse with 64 
  averages of GRATER and OVS+GRATER for RGA=-G/2 (see figure 4 of GRATER manuscript).

### In folder Exp_2
    Data for exp 2: Non-ideal conditions: Large Flip-Angles (uniform sphere)
    Each row of .mat files contain data for a different waveform 
    (see figrue 5 of GRATER manuscript).
 
 Raw data files: 
   1. exp2_grater.mat
   2. exp2_programmed.mat 

 Processed data files: 
   1. exp2_grater_p.mat

 Simulated data files:
   1. exp2_grater_s.mat

 Each row contains data for a different waveform: 
   1.  1 band, 5 deg FA
   2.  1 band, 10 deg FA
   3.  1 band, 15 deg FA
   4.  1 band, 20 deg FA
   5.  1 band, 25 deg FA
   6.  1 band, 30 deg FA
   7.  1 band, 45 deg FA
   8.  1 band, 50 deg FA
   9.  1 band, 55 deg FA
   10. 1 band, 60 deg FA
   11. 1 band, 65 deg FA
   12. 1 band, 70 deg FA
   13. 1 band, 75 deg FA
   14. 1 band, 80 deg FA
   15. 1 band, 85 deg FA
   16. 1 band, 90 deg FA

### In folder Exp_3
    Data for exp 3: Non-ideal conditions: Inhomoengeous volumes (FW phantoms & in-vivo)
    Each row of .mat files contain data for a different waveform, except
    Exp3r_reference.mat which contains a struct, each cell entry with data
    for a different waveform (see figures 6-8 of GRATER manuscript). 
  
  Raw data files: 
   1. exp3_grater.mat
   2. exp3_programmed.mat
   3. exp3_PUC.mat  <- Raw reference file available on dropbox:
         https://www.dropbox.com/sh/hczepl51ff58co4/AACj-fC93daV5tF1vTejIDH5a?dl=0
 
  Processed data files: 
   1. exp3_grater_p.mat
   2. exp3_PUC_p.mat
 
  Each row of the .mat files contain data for measurements of a 2-band, 
  TBW = 4 rf pulse in a different setting: 
   1.  FW phantom (water only) - no ovs
   2.  FW phantom (water only) - ovs
   3.  FW phantom (fat only)   - no ovs
   4.  FW phantom (fat only)   - ovs
   5.  FW phantom (fat & water)- no ovs
   6.  FW phantom (fat & water)- ovs
   7.  Subject 1 (brain)       - no ovs 
   8.  Subject 1 (brain)       - ovs 
   9.  Subject 2 (brain)       - no ovs
   10. Subject 2 (brain)       - ovs
