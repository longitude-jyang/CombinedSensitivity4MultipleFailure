% formR is to form the sensitivity matrix R, which is normalised
% sensitivity 

% 27/05/2022 @ Franklin Court, Cambridge  [J Yang] --> checked for upload

function [R,nR]= formR(Opts,b_v,SeaState,pF_Fatigue,yearV,pF_Disp,pF_Theta,nThresholdFactor)


    [nPar,~] = size(b_v);
    
    rFatigue = rPfFagitue (Opts,squeeze(pF_Fatigue.pFm),pF_Fatigue.pFs,b_v,nPar,yearV,SeaState(1));
    
    rExDisp = rEx (Opts,pF_Disp.pFm,pF_Disp.pFs,b_v,nPar,nThresholdFactor,SeaState(1));
    
    rExTheta = rEx (Opts,pF_Theta.pFm,pF_Theta.pFs,b_v,nPar,nThresholdFactor,SeaState(1));

    
    nYear = numel(yearV); 
    nR = nYear+nThresholdFactor*2;

    
    R = [rFatigue rExDisp rExTheta]; 

    R (isnan(R)) = 0; 
end

function rFatigue = rPfFagitue (Opts,pFMean,pFSen,b_v,nPar,yearV,SeaState)

    nYear   = numel(yearV);

    rFatigue = zeros(nPar*2, nYear);
    for ii = 1 : nYear
        yearSelect = yearV(ii); 

        [~,indexYear(ii)] = min(abs(Opts.yearsLifeExp - yearSelect )); 

        pFMeanIndex = pFMean (indexYear(ii), SeaState);

        % access data at the index position, each cell represents each
        % parameter
        pFSenIndex = cellfun(@(v) squeeze(v(:,indexYear(ii),SeaState)),pFSen);
        rFatigue(:,ii) = reshape(pFSenIndex.*b_v./pFMeanIndex, nPar*2, 1); % normalise , reshape to vector 
    end
end


function ry = rEx(Opts,pFMean,pFSen,b_v,nPar,nThresholdFactor,SeaState)

    ry = zeros(nPar*2, nThresholdFactor );
    for ii = 1 : nThresholdFactor   

        yFailSen_State = cellfun(@(v) squeeze(v(:,ii,SeaState)),pFSen); % pick up corresponding results for each sea states 

        ry(:,ii) = reshape(yFailSen_State .*b_v./pFMean(ii,SeaState), nPar*2, 1); % normalise , reshape to vector 

    end
end