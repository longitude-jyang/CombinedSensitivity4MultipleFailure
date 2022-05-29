% cal_PfSen compute the Pf sensitivity, considering multiple failure modes 
% This is intended to compute results for the combined sensitivity paper
% Yang, J., Clot, A., Langley, R.S., 2022. Combined sensitivity analysis for multiple failure modes. Computer Methods in Applied Mechanics and Engineering 395, 115030. https://doi.org/10.1016/j.cma.2022.115030

% 18/09/2020 @ Franklin Court, Cambridge  [J Yang] 
% 27/05/2022 @ Franklin Court, Cambridge  [J Yang] --> checked for upload

% ---------------------
% download the data first !!!
% the data can be downloaded from here: https://www.dropbox.com/s/h5apdcgymz4yzfc/MR_RS2_FATIGUE_N5000_11-06-2020%2008-26.mat?dl=0
% more details here: https://github.com/longitude-jyang/CombinedSensitivity4MultipleFailure
% ---------------------

% ---------------------
% (0) options

    NsSelect = 5000;                 % select number of samples 
    iUPar    = [1 2 3 4 6 7 11 12];  % index for uncertain parameters
    nPar     = numel(iUPar);
    SeaState = 2;                    % the data has been calculated for a number of different sea states, the one corresponding to the paper resutls is from sea state 2
    
    % failure threshold z, can be vectors 
    nModes = 3; 

        % fatigue failure threshold, 80 years life 
        fatigueLife = 80;   
 
        % excessive displacement & rotation, failure threshold as percentile 
        % nominallay can be same as 80, but used different levels for the
        % paper results, can be vectors 
        yExLevel = 80;  
        nThresholdFactor    = numel(yExLevel);

        yExLevel1 = 88; 
        yExLevel2 = 85; 
   

% % ---------------------
% % (1) load data 
% 
%     % the data can be downloaded from here: https://www.dropbox.com/s/h5apdcgymz4yzfc/MR_RS2_FATIGUE_N5000_11-06-2020%2008-26.mat?dl=0
%     load('MR_RS2_FATIGUE_N5000_11-06-2020 08-26.mat');
%     PreCalc = R;
    
% ---------------------
% (2) from data: distribution parameters
    [ParSen, b_v] = parDist(PreCalc,Opts,iUPar,NsSelect);

% ---------------------
% (3) individual failure modes 
   
    % (a)  fatigue failure 
    [Pf_fatigue,PfMean_fatigue,PfSen_fatigue] = calPfFatigue(PreCalc,Opts,iUPar,NsSelect,ParSen);
     
        pF_Fatigue.pF = Pf_fatigue;
        pF_Fatigue.pFm = PfMean_fatigue;
        pF_Fatigue.pFs = PfSen_fatigue;
    
    % (b)  exssive displacement 
    yV = PreCalc.Syy; 
    [Pf_ExDisp,PfMean_ExDisp,PfSen_ExDisp] = calPfyEx(yV,Opts,yExLevel1,NsSelect,ParSen);

        pF_Disp.pF = Pf_ExDisp;
        pF_Disp.pFm = PfMean_ExDisp;
        pF_Disp.pFs = PfSen_ExDisp;
        
    % (c)  exssive rotation
    yV = PreCalc.Stheta; 
    [Pf_ExTheta,PfMean_ExTheta,PfSen_ExTheta] = calPfyEx(yV,Opts,yExLevel2,NsSelect,ParSen);

        pF_Theta.pF = Pf_ExTheta;
        pF_Theta.pFm = PfMean_ExTheta;
        pF_Theta.pFs = PfSen_ExTheta;    
    
% ---------------------
% (4) system failure s
    [Pf_Sys,PfMean_Sys,PfSen_Sys,rSys] = calPfSys(Opts,b_v,SeaState,pF_Fatigue,fatigueLife,pF_Disp,pF_Theta,NsSelect,ParSen);
    
        pF_Sys.pF = Pf_Sys;
        pF_Sys.pFm = PfMean_Sys;
        pF_Sys.pFs = PfSen_Sys;
        
% ---------------------
% (5) form sensitivity matrix R 
    [R,nR]= formR(Opts,b_v,SeaState,pF_Fatigue,fatigueLife,pF_Disp,pF_Theta,nThresholdFactor);

% ---------------------
% (6) eigen analysis of R 
    [Vtemp, Dtemp] = eig(R*R.');

    lambda = diag(Dtemp);
    [EigSorter,EigIndex] = sort(lambda,'descend');
    Vr = Vtemp(:,EigIndex);
    Dr = lambda(EigIndex);
    
    % or conduct SVD instead 
    [U,sigma,~] = svd(R,'econ');
    Sigma = diag(sigma);
    

% ---------------------
% (7) least square projetion of s onto R (pesdoinverse)

    [~,nSysF] = size(rSys);
    
    w = zeros(nModes,nSysF);
    rCom = zeros(nPar*2,nSysF);
    for ii = 1 : nSysF
        w(:,ii) = pinv(R)*rSys(:,ii);
        rCom(:,ii) = R*w(:,ii);  % combinations from individual r 
    end
    
%%    
% ---------------------
% (8) display results
    %-----------------------
    isExportFig = 0 ;
    %-----------------------
    dispResults; 