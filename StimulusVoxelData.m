close all;

rois = {niftiread('ROI/ROI73.nii'), niftiread('ROI/ROI164.nii'), niftiread('ROI/ROI171.nii')}; % Find in Dataset->Fabo->Rat->Atlas->Waxholm->ROI->ORIGINAL
allignedfMRI = niftiread('DATA/741-50.nii'); % Find in Dataset->Experiment#->Frequency#->fmrialligned

for c = 1:length(rois)

    x = 1:122;
    y = zeros(1,122);
    sumoff = 0;
    sumon = 0;
    
    for i = 1:122
        m = imresize3(allignedfMRI(:,:,:,i), [256 256 62], 'nearest').*rois{c};
        y(i) = mean(nonzeros(m));
    end
    
    maxval = max(y);
    minval = min(y);
    
    for i = 1:length(y)
        y(i) = (y(i)-minval)/(maxval-minval);
        if (i >= 1 && i <= 20) || (i >= 31 && i <= 50) || (i >= 61 && i <= 80) || (i >= 91 && i <= 110)
            sumoff = sumoff + y(i);
        elseif i <= 120
            sumon = sumon + y(i);
        end
    end
    
    avoff = sumoff / 80;
    avon = sumon / 40;
    
    percentchange = ((avon-avoff)/avoff) * 100;
    if c == 1
        fprintf("ROI 73\n");
    elseif c == 2
        fprintf("ROI 164\n");
    elseif c == 3
        fprintf("ROI 171\n");
    else
        fprintf("Unknown ROI\n");
    end

    fprintf("Average voxel value with no stimulus: %.2f (normalized)\n", avoff);
    fprintf("Average voxel value with stimulus (800Pw, 5Pa): %.2f (normalized)\n", avon);
    fprintf("Percent Change: %.2f%%\n\n", percentchange);
    
    %plot(x,y);
end

%Call python script
%res = pyrunfile("FILENAME.py","RETURNVARIABLE",INPUTVARIABLE=SOMEINPUT);