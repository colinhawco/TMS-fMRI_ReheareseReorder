for pdx = [201 203 204 216]
    ff = ls(['p' num2str(pdx) '*.txt'])
    ons = [];
    for rdx = size(ff,1)
        out = camh_RR_read_vpixx(ff(rdx,:), rdx);
        ons = [ons; out];
    end
    eval(['ons_' num2str(pdx) '= ons']);
end

% 
% 
% tt=[]
% for pdx = [201 203 204 216]
%     eval(['time = ons_' num2str(pdx) '(:,3)+2.5'])
%     tr=floor(time/2.1);
%     trtime = time - (tr)*2.1
%     slice = ceil(trtime/.06)
%     echo = mod(trtime, 0.06);
%     tt = [tt tr+1 slice echo*1000]
% end