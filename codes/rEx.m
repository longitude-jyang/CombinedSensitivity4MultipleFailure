function ry = rEx(Opts,pFMean,pFSen,b_v,nPar,nThresholdFactor,SeaState)

    ry = zeros(nPar*2, nThresholdFactor );
    for ii = 1 : nThresholdFactor   

        yFailSen_State = cellfun(@(v) squeeze(v(:,ii,SeaState)),pFSen); % pick up corresponding results for each sea states 

        ry(:,ii) = reshape(yFailSen_State .*b_v./pFMean(ii,SeaState), nPar*2, 1); % normalise , reshape to vector 
%          ry(:,ii) = reshape(yFailSen_State .*b_v, nPar*2, 1); % normalise without divding the Pf

    end
end