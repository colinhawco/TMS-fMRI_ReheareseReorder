function tmsfmri_RR_reinter_slices(pt, ons)

basedir = ['E:\RR_TMSfRMI\']
cd([basedir 'NEUR_YU_HCT'  num2str(pt) '_01' ]);
nfiles = ls('*TMS-FMRI*.nii.gz');

sliceorder = [1:2:35 2:2:35];

for rdx = 1:4
    
    time = ons(ons(:,1) == rdx, 3)+2.5;
    
   tr=ceil(time/2.1);
   trtime = time - (tr-1)*2.1
   slice = ceil(trtime/.06)
   echo = mod(trtime, 0.06);
   
    slice(echo > 0.03) = slice(echo > 0.03)+1; 
    replace = [tr slice];
    
    for idx = 1:size(replace,1)
        if replace(idx,2) == 0
            replace(idx,:) = [replace(idx,1)-1 35];
        elseif replace(idx,2) == 36
             replace(idx,:) = [replace(idx,1)+1 1];
        end
    end
    
    replace(end+1,1:2) = [0 0];
    ii=1; 
    
    data = load_untouch_nii(nfiles(rdx,:));
    
    for tdx = 1:290
        if tdx > size(data.img,4)
            break
        end
%         if tdx == 254
%              pause
%         end 
        disp([pt '_Run' num2str(rdx) '    TR ' num2str(tdx)]);
        if tdx == replace(ii,1)
            pre = data.img(:,:,:,tdx-1);
            post = data.img(:,:,:,tdx+1);
            meandata = (pre+post)/2;
            
            data.img(:,:,sliceorder(replace(ii,2)),tdx)= meandata(:,:,sliceorder(replace(ii,2)));
            if replace(ii,2) == 35
                pre = data.img(:,:,:,tdx);
                post = data.img(:,:,:,tdx+2);
                meandata = (pre+post)/2;
                data.img(:,:,sliceorder(1),tdx+1) = meandata(:,:,sliceorder(1));
                data.img(:,:,sliceorder(2),tdx+1) = meandata(:,:,sliceorder(2));
                
            elseif replace(ii,2) == 34
                data.img(:,:,sliceorder(35),tdx)= meandata(:,:,sliceorder(35));
                
                pre = data.img(:,:,:,tdx);
                post = data.img(:,:,:,tdx+2);
                meandata = (pre+post)/2;
                data.img(:,:,sliceorder(1),tdx+1) = meandata(:,:,sliceorder(1));
                
            else
                data.img(:,:,sliceorder(replace(ii,2)+1),tdx)= meandata(:,:,sliceorder(replace(ii,2)+1));
                data.img(:,:,sliceorder(replace(ii,2)+2),tdx)= meandata(:,:,sliceorder(replace(ii,2)+2));
            end
%           check_tr(data.img)
            ii = ii+1;
        end
        
        
    end % end tdx through TRs
    save_untouch_nii(data,['t' nfiles(rdx,:)])
    
%     check_tr(data)

end % end rdx through runs



function check_tr(data)

% origonal images
xmax=64;
ymax=64;
zmax=35;
% figure
% pause

d2=zeros(xmax*7,ymax*5);

for tdx = 1:285
    slice = zmax;
    for xdx = 1:xmax:size(d2,1)
        for ydx=1:ymax:size(d2,2)
            d2(xdx:xdx+xmax-1, ydx:ydx+ymax-1) = squeeze(data.img(:,:,slice, tdx));
            slice = slice -1;
        end
    end
    
    d2(d2>100) = 100;
    
    imagesc(d2')
    pause(0.25)
    
end

