function [pF,pFMean,pFSen,rSys] = calPfSys(Opts,b_v,SeaState,pF_Fatigue,yearSelect,pF_Disp,pF_Theta,NsSelect,ParSen)
% calPfSys calculates the system failure for different failure configurations, as listed in
% the paper Table 2

% 27/05/2022 @ Franklin Court, Cambridge  [J Yang] --> checked for upload
    
    [~,indexYear] = min(abs(Opts.yearsLifeExp - yearSelect )); 

    Pf_fatigue = squeeze(pF_Fatigue.pF(:,indexYear,SeaState));
    Pf_ExDisp  = squeeze(pF_Disp.pF(:,1,SeaState));
    Pf_ExTheta  = squeeze(pF_Theta.pF(:,1,SeaState));
    
    
    % system failure  
    nSysF = 4; 
    pF = zeros(NsSelect,nSysF);
    
    ab = [{'|'},{'&'}];

    kk = 0;
    for ii = 1 : 2 
        
        a = ab{ii};
        
        for jj = 1 : 2
            kk = kk + 1;
            
            b = ab{jj};
            
            eval(strcat('pF (Pf_fatigue == 1', a, 'Pf_ExDisp  == 1', b, 'Pf_ExTheta  == 1,kk ) = 1;'))
        end
    
    end
    
    % Unconditional probability of failure
    pFMean = mean(pF, 1, 'omitnan');
    
    % system sensitivity        
    pFSen = cell(size(ParSen));
    [N_UPar,~]=size(ParSen);
    for kk = 1 : N_UPar
           pFSen {kk,1} = mean(pF.*ParSen{kk,1},1,'omitnan');  
           pFSen {kk,2} = mean(pF.*ParSen{kk,2},1,'omitnan'); 
    end 
    
    rSys = zeros(N_UPar*2,nSysF);
    for ii = 1 : nSysF
        sysFail = cellfun(@(v) squeeze(v(ii)),pFSen); 

        rSys(:,ii) = reshape(sysFail .*b_v./pFMean(ii), N_UPar*2, 1); % normalise , reshape to vector 
    end