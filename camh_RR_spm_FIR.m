function RR_spm(pt, ons)
base = ['f:\RR_TMSfMRI\' num2str(pt) '\'];
cd(base)

outdir = [base '/GLM/'];
mkdir(outdir)
mregress = []; 

for idx = 1:4
    
     ff=ls(['swudtep2d_p3_2100_35sl_' num2str(idx) '_*.nii']);
    for rdx = 1:295;
       
        fn = [base  ff ',' num2str(rdx)];
        files(rdx, 1:length(fn),idx) = fn;
       
    end
    
end

%%%%%%%%%%%%%%%%%%%%%%% generating mregress fname='sub-HCT201_ses-01_task-nbk_bold_confounds.tsv'
cd(outdir)
fname = deblank(ls(['*' tsk '*.tsv']))
mf=tdfread(fname);
dvars = [0; str2num(mf.stdDVARS(2:end,:))];
fd=[0; str2num(mf.FramewiseDisplacement(2:end,:))];
regress = [mf.CSF mf.WhiteMatter dvars fd mf.X mf.Y mf.X mf.RotX mf.RotY mf.RotZ];



analyze_spm12_design_hcp(outdir, files, 3, 2, ons, regress);




