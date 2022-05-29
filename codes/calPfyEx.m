
function [pF,pFMean,pFSen] = calPfyEx(yV,Opts,dispExLevel,NsSelect,ParSen)

   
    % rms displacement 
        y = yV(1 : NsSelect,:,:); 
        yPeak = squeeze(max(yV,[],3)); % get peak  along the riser, as a vector for all samples 
        yPeakMax = max(yPeak);   % get peak  along the riser & of all samples, for each sea state
        [Ns,NT,Ne]  = size(y); 

    % failure threshold 
        nThresholdFactor = numel(dispExLevel);
        PeakThresholdFactor = dispExLevel ; %+ (rand(1)-0.5) add small noise to randomise the percentile every time the function is called

        pF  = zeros(NsSelect,nThresholdFactor,NT);

        for ii = 1 : nThresholdFactor
            
            yPeakThreshold = prctile(yPeak ,PeakThresholdFactor(ii)); % use percentile

            yPeakThresholdGrid = repmat (yPeakThreshold,NsSelect,1);  % put the threshold into grid for comparison

            pF(:,ii,:) = yPeak >= yPeakThresholdGrid;   % Indicator for failure        

        end
        pFMean = squeeze(mean(pF, 1, 'omitnan'));% Unconditional probability of failure 
        
        if iscolumn(pFMean)
            
            pFMean = pFMean.';  % if only one threshold, the squeeze gives column vector; put it as row vector
        end
    
    % sensitivity
        pFSen = cell(size(ParSen));
        [N_UPar,~]=size(ParSen);
        for kk = 1 : N_UPar
               pFSen {kk,1} = mean(pF.*ParSen{kk,1},1,'omitnan');  
               pFSen {kk,2} = mean(pF.*ParSen{kk,2},1,'omitnan'); 
        end 
  
