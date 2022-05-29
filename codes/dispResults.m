% display the results for the paper 
% 27/05/2022 @ Franklin Court, Cambridge  [J Yang] --> checked for upload

nPar  = length(iUPar);
varName = {'C_a', 'C_d', '\rho', 'E', '\rho_o', 'T_0','\alpha','\delta'};

figNo = {'(1) ', '(2) ', '(3) ', '(4) '};

[~,indexYear] = min(abs(Opts.yearsLifeExp - fatigueLife ));
pF1 = round(pF_Fatigue.pFm(1,indexYear,SeaState(1))*1e2)/1e2;
pF2 = round(pF_Disp.pFm(1,SeaState(1))*1e2)/1e2;
pF3 = round(pF_Theta.pFm(1,SeaState(1))*1e2)/1e2;

sprintf(['Fatigue Pf: ' num2str(pF1)])
sprintf(['ExDisp Pf: ' num2str(pF2)])
sprintf(['ExRot Pf: ' num2str(pF3)])

%%
% ----------------------------------------------------------------
% disp failure sensitivities
    titleStr = [{['(1) Sensitivity-FatigueFailure ','[Pf = ',num2str(pF1),']']};...
        {['(2) Sensitivity-ExcessiveDisplacement ','[Pf = ',num2str(pF2),']']};...
        {['(3) Sensitivity-ExcessiveRotation ','[Pf = ',num2str(pF3),']']}];
    
    fig1 = figure; 

    for ii = 1 : nModes
        subplot(nModes,1,ii)

        b=bar([1:nPar*2],R(:,ii)); 

        ttl = title(titleStr{ii});
        ttl.Units = 'Normalize'; 
        ttl.Position(1) = 0; % use negative values (ie, -0.1) to move further left
        ttl.HorizontalAlignment = 'left';  

        set(gca,'xtick',[round(nPar/2) nPar+round(nPar/2)],'xticklabel',[{'Mean'},{'Std Dev'}]);
        xtips = b.XData;
        ytips = b.YData;
        ytips = ytips.*double(ytips>0);
        labels = [varName  varName];

        text(xtips,ytips,labels,'HorizontalAlignment','center',...
        'VerticalAlignment','bottom')
    
        ylim([min(b.YData)-2 max(b.YData)+5])
    
        ylabel('r [-]')

        set(gca,'FontSize',14)
    end

    figName ='PfSensitivity';
    figuresize(16, 18, 'centimeters');
    movegui(fig1, [50 40])
    set(gcf, 'Color', 'w');
    
    exportFig(isExportFig,paperPath,figName);

%%
% ----------------------------------------------------------------
% disp singular vectors
     fig1 = figure; 
    for ii = 1 : nR
        subplot (nR,1,ii)

        b=bar([1:nPar*2], U(:,ii).');    

        set(gca,'xtick',[round(nPar/2) nPar+round(nPar/2)],'xticklabel',[{'Mean'},{'Std Dev'}]);

        ylim([-1.2 1.2])

        xtips = b.XData;
        ytips = b.YData;
        ytips = ytips.*double(ytips>0);
        labels = [varName  varName];
        text(xtips,ytips,labels,'HorizontalAlignment','center',...
        'VerticalAlignment','bottom')

        ttl = title(['(',num2str(ii),')',' SingularVector-', num2str(ii),' of R ', '[s = ', num2str(round(Sigma(ii))),']']);
        ttl.Units = 'Normalize'; 
        ttl.Position(1) = 0; % use negative values (ie, -0.1) to move further left
        ttl.HorizontalAlignment = 'left';  

        set(gca,'FontSize',14)

    end

    figName ='singularVector';
    figuresize(16, 18, 'centimeters');
    movegui(fig1, [50 40])
    set(gcf, 'Color', 'w');
    
    exportFig(isExportFig,paperPath,figName);

%%
% projections to R singular vectors, from the individual failure modes 
    titleStr = [{'(1) Projection - Fatigue Failure '};...
        {'(2) Projection - Excessive Displacement'};...
        {'(3) Projection - Excessive Rotation'}];
    s = zeros(nR,nR);

     fig1 = figure; 
    for ii = 1 : nR
        s (:,ii) = R(:,ii).'*U/norm(R(:,ii));

        subplot(nR,1,ii)
        b = bar (1:nR , abs(s(:,ii)));

        ttl = title(titleStr{ii});
        ttl.Units = 'Normalize'; 
        ttl.Position(1) = 0; % use negative values (ie, -0.1) to move further left
        ttl.HorizontalAlignment = 'left';  
        
        
        xtips = b.XData;
        ytips = b.YData;
        ytips = ytips.*double(ytips>0);
        labels = string(round(b.YData*100)/100);
        text(xtips,ytips,labels,'HorizontalAlignment','center',...
        'VerticalAlignment','bottom')

        if ii == nR
            xlabel('Index of Singular Vector')
        end
        ylim ([0 1.2])

        set(gca,'FontSize',14)
    end

    figName ='projPf';
    figuresize(16, 18, 'centimeters');
    movegui(fig1, [50 40])
    set(gcf, 'Color', 'w');
    
    exportFig(isExportFig,paperPath,figName);


%%
% ----------------------------------------------------------------
% system failure 
   

    fig1 = figure; 
    
    for ii = 1 : nSysF
        
        subplot(2,2,ii)
        b=bar([1:nPar*2]',rSys(:,ii)) ;
        
        set(gca,'FontSize',14)
        set(gca,'xtick',[round(nPar/2) nPar+round(nPar/2)],'xticklabel',[{'Mean'},{'Std Dev'}]);

        xtips = b.XData;
        ytips = b.YData;
        ytips = ytips.*double(ytips>0);
        labels = [varName  varName]';
        text(xtips,ytips,labels,'HorizontalAlignment','center',...
        'VerticalAlignment','bottom')

        ylim([min(b.YData)-2 max(b.YData)+5])
    
        if ii <= 2
            title ([{'System Failure Sensitivity'};{[figNo{ii},'Case -',num2str(ii),' [Pf = ',num2str(round(PfMean_Sys(ii)*1e2)/1e2),']']}]);
        else
            title ([figNo{ii},'Case -',num2str(ii),' [Pf = ',num2str(round(PfMean_Sys(ii)*1e2)/1e2),']']);
        end
        ylabel('r [-]')

        set(gca,'FontSize',14)  
    end
    
    figName ='PfSys';
    figuresize(24, 18, 'centimeters');
    movegui(fig1, [50 40])
    set(gcf, 'Color', 'w');
    
    exportFig(isExportFig,paperPath,figName);

%%
% ----------------------------------------------------------------
% projections to  R singular vectors, from the system failure modes 

    fig1 = figure;  
    for ii = 1 : nSysF

        projSys = U.'*rSys(:,ii)/norm(rSys(:,ii));

        subplot(2,2,ii)
        b = bar (1:nR , abs(projSys));

        xtips = b.XData;
        ytips = b.YData;
        ytips = ytips.*double(ytips>0);
        labels = string(round(b.YData*100)/100);
        text(xtips,ytips,labels,'HorizontalAlignment','center',...
        'VerticalAlignment','bottom')

       if ii <= 2
            title ([{'System Sensitivity Projection'};{[figNo{ii},'Case -',num2str(ii)]}]);
        else
            title ([figNo{ii},'Case -',num2str(ii)]);
            xlabel('Index of Singular Vector')
        end

        ylim ([0 1.2])

        set(gca,'FontSize',14)
    end  
    
    figName ='projPfSys';
    figuresize(20, 18, 'centimeters');
    movegui(fig1, [50 40])
    set(gcf, 'Color', 'w');
    
    exportFig(isExportFig,paperPath,figName);