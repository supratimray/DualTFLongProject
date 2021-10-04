% This program displays the ERPs and FFTs of the data. Data from individual
% electrodes are shown, included electrodes that are rejected. 

% if displayFlag is on then all data is shown (takes longer time to plot).
% Otherwise only summary figures are shown

function [mGRAF0,mPLDF0,mGRA2F,numRepeatsGra,numRepeatsPld,mPLDF0_zscored,deltaTheta,maskFreqList] = displayAllData(subjectName,expDate,protocolNames,gridType,timeRange,decimationFactor,subtractNeighborsFlag,displayFlag)

if ~exist('subtractNeighborsFlag','var'); subtractNeighborsFlag=0;      end
if ~exist('displayFlag','var');           displayFlag=0;                end

if decimationFactor>1
    decimationStr = ['_decimated' num2str(decimationFactor)];
else
    decimationStr='';
end

if strcmp(gridType,'Microelectrode') % Monkey Data
    fileNameOut = fullfile('savedData',gridType,[subjectName expDate gridType protocolNames{1} decimationStr '.mat']);
else
    fileNameOut = fullfile('savedData',gridType,[subjectName expDate gridType decimationStr '.mat']);
end
    
data = load(fileNameOut);
nG = data.numRepeatsGra(:);
numRepeatsGra.min = min(nG);
numRepeatsGra.max = max(nG);
numRepeatsGra.mean = mean(nG);

nP = data.numRepeatsPld(:);
numRepeatsPld.min = min(nP);
numRepeatsPld.max = max(nP);
numRepeatsPld.mean = mean(nP);

disp(['Gratings: min: ' num2str(numRepeatsGra.min) ', max: ' num2str(numRepeatsGra.max) ', mean: ' num2str(numRepeatsGra.mean)]);
disp(['Plaids: min: ' num2str(numRepeatsPld.min) ', max: ' num2str(numRepeatsPld.max) ', mean: ' num2str(numRepeatsPld.mean)]);

% Frequency
timeVals = data.timeVals;
Fs = round(1/(timeVals(2)-timeVals(1)));
deltaT = diff(timeRange);
f = 0:1/deltaT:Fs-1/deltaT;
numPoints = Fs*deltaT;
N = length(f);

% Select stimulus and baseline periods
stPos = find(timeVals >= timeRange(1), 1 ) + (1:numPoints);
blPos = find(timeVals >= -deltaT, 1) + (1:numPoints);

[numGoodElectrodes,numOris,numMaskTFs,~] = size(data.erpAllGra);
maskFreqList = data.parameterCombinations.tValsUnique2;

tfPosGra = zeros(1,numMaskTFs);
tfPosPld = find(f==2*data.parameterCombinations.tValsUnique);
for t=1:numMaskTFs
    tfPosGra(t) = find(f==2*maskFreqList(t));
end

% Get Data
graSTFFT = zeros(numGoodElectrodes,numOris,numMaskTFs,length(f));
graBLFFT = zeros(numGoodElectrodes,numOris,numMaskTFs,length(f));
pldSTFFT = zeros(numGoodElectrodes,numOris,numMaskTFs,length(f));
pldBLFFT = zeros(numGoodElectrodes,numOris,numMaskTFs,length(f));

for o=1:numOris
    for t=1:numMaskTFs
        for elec=1:numGoodElectrodes
            
            % ERP Gratings
            graData = squeeze(data.erpAllGra(elec,o,t,:));
            graData = graData - mean(graData(blPos));
            
            % ERP Plaids
            pldData = squeeze(data.erpAllPld(elec,o,t,:));
            pldData = pldData - mean(pldData(blPos));
           
            % FFT Gratings
            graSTFFT(elec,o,t,:) = abs(fft(graData(stPos)))/(N/2);
            graBLFFT(elec,o,t,:) = abs(fft(graData(blPos)))/(N/2);
            
            % FFT Plaids
            pldSTFFT(elec,o,t,:) = abs(fft(pldData(stPos)))/(N/2);
            pldBLFFT(elec,o,t,:) = abs(fft(pldData(blPos)))/(N/2);
        end
    end
end

% Subtract baseline FFT from stimulus FFT. To reduce variability, we compute a common baseline for all conditions
graBLFFTcommon = squeeze(mean(mean(graBLFFT,2),3));
pldBLFFTcommon = squeeze(mean(mean(pldBLFFT,2),3));

graST2F = zeros(numGoodElectrodes,numOris,numMaskTFs);
pldSTF0 = zeros(numGoodElectrodes,numOris,numMaskTFs);

for o=1:numOris
    for t=1:numMaskTFs
        for elec=1:numGoodElectrodes
            
            graSTFFT(elec,o,t,:) = squeeze(graSTFFT(elec,o,t,:))'-graBLFFTcommon(elec,:);
            pldSTFFT(elec,o,t,:) = squeeze(pldSTFFT(elec,o,t,:))'-pldBLFFTcommon(elec,:);
            
            if subtractNeighborsFlag
                graST2F(elec,o,t) = graSTFFT(elec,o,t,tfPosGra(t)) - 0.5*(graSTFFT(elec,o,t,tfPosGra(t)+1)+graSTFFT(elec,o,t,tfPosGra(t)-1));
                pldSTF0(elec,o,t) = pldSTFFT(elec,o,t,tfPosPld) - 0.5*(pldSTFFT(elec,o,t,tfPosPld-1)+pldSTFFT(elec,o,t,tfPosPld+1));
            else
                graST2F(elec,o,t) = graSTFFT(elec,o,t,tfPosGra(t));
                pldSTF0(elec,o,t) = pldSTFFT(elec,o,t,tfPosPld);
            end
        end
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%% Display Summary Data %%%%%%%%%%%%%%%%%%%%%%%%%%%
electrodeColors = parula(numGoodElectrodes);

% FFT data
freqLims = [0 50]; 
if strcmp(gridType,'Microelectrode')
    cutoff=2.5;
    fftLims = [-5 15];
else
    cutoff=0.5;
    fftLims = [-1 3];
end
fftLims_zscore = [-4 4];

graSTF0 = mean(graST2F(:,:,data.parameterCombinations.tValsUnique == maskFreqList),2);
rejectedElectrodes = find(graSTF0<cutoff);
for i=1:length(rejectedElectrodes)
    electrodeColors(rejectedElectrodes(i),:)=[1 0 0]; % Mark as red
end

% Show SSVEP @ TF0
subplot('Position',[0.75 0.8 0.1 0.15]);
for elec=1:numGoodElectrodes
    plot(elec,graSTF0(elec),'color',electrodeColors(elec,:),'marker','o');
    hold on;
end
line([0 8],[cutoff cutoff],'color','r');
ylim(fftLims);
xlabel('Electrode Num'); ylabel('Amp (\muV)');

% Show SSVEP @ 2F
subplot('Position',[0.875 0.8 0.1 0.15]);
for elec=1:numGoodElectrodes
    plot(maskFreqList,squeeze(mean(graST2F(elec,:,:),2)),'color',electrodeColors(elec,:));
    hold on;
    plot(data.parameterCombinations.tValsUnique,graSTF0(elec),'color',electrodeColors(elec,:),'marker','o');
end
ylim(fftLims);
xlim([maskFreqList(1) maskFreqList(end)]);
xlabel('Temporal Freq');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% All Electrodes %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
hSummary1 = getPlotHandles(numOris,1,[0.750 0.35 0.1 0.375],0,0.02,1);
hSummary2 = getPlotHandles(numOris,1,[0.875 0.35 0.1 0.375],0,0.02,1);

pldSTF0_zscored = zscore(pldSTF0);
deltaTheta = zeros(1,numOris);
for o=1:numOris
    for elec=1:numGoodElectrodes
        plot(hSummary1(o,1),maskFreqList,squeeze(pldSTF0(elec,o,:)),'color',electrodeColors(elec,:));
        hold(hSummary1(o,1),'on');
        
        plot(hSummary2(o,1),maskFreqList,squeeze(pldSTF0_zscored(elec,o,:)),'color',electrodeColors(elec,:));
        hold(hSummary2(o,1),'on');
    end
    
    xlim(hSummary1(o,1),[maskFreqList(1) maskFreqList(end)]); ylim(hSummary1(o,1),fftLims);
    xlim(hSummary2(o,1),[maskFreqList(1) maskFreqList(end)]); ylim(hSummary2(o,1),fftLims_zscore);
    
    ylabel(hSummary1(o,1),'Amp (\muV)');
    ylabel(hSummary2(o,1),'Amp (z-score)');
    
    if o~=numOris
        set(hSummary1(o,1),'XTickLabel',[]);
        set(hSummary2(o,1),'XTickLabel',[]);
    end
    
    deltaTheta(o) = abs(data.parameterCombinations.oValsUnique-data.parameterCombinations.oValsUnique2(o));
    text(maskFreqList(1),fftLims(2)-0.5,['O1=' num2str(data.parameterCombinations.oValsUnique) ', O2=' num2str(data.parameterCombinations.oValsUnique2(o))],'Parent',hSummary1(o));
end
title(hSummary1(1,1),'All elecs (Raw)');
title(hSummary2(1,1),'All elecs (z)');

%%%%%%%%%%%%%%%%%%%% Average of good electrodes %%%%%%%%%%%%%%%%%%%%%%%%%%%
acceptedElectrodes = setdiff(1:numGoodElectrodes,rejectedElectrodes);

orientationColors = copper(numOris);
[~,I] = sort(deltaTheta);
sortedOrientationColors = orientationColors(I,:);

legendStr = cell(1,numOris);
if length(acceptedElectrodes)<2
    disp('Not enough good electrodes');
    
    mPLDF0 = {};
    mGRAF0 = {};
    mGRA2F = {};
    mPLDF0_zscored = {};
    
else
    mPLDF0 = squeeze(mean(pldSTF0(acceptedElectrodes,:,:),1));
    mGRAF0 = squeeze(mean(graSTF0(acceptedElectrodes,:,:),1));
    mGRA2F = squeeze(mean(graST2F(acceptedElectrodes,:,:),1));
    mPLDF0_zscored = squeeze(mean(pldSTF0_zscored(acceptedElectrodes,:,:),1));
    
    hSummaryAvg1 = subplot('Position',[0.750 0.05 0.1 0.25]);
    hSummaryAvg2 = subplot('Position',[0.875 0.05 0.1 0.25]);

    for o=1:numOris
        plot(hSummaryAvg1,maskFreqList,squeeze(mPLDF0(o,:)),'color',sortedOrientationColors(o,:)); hold(hSummaryAvg1,'on');
        plot(hSummaryAvg2,maskFreqList,squeeze(mPLDF0_zscored(o,:)),'color',sortedOrientationColors(o,:)); hold(hSummaryAvg2,'on'); 
        legendStr{o} = ['\delta\theta=' num2str(deltaTheta(o))];
    end
    
    xlim(hSummaryAvg1,[maskFreqList(1) maskFreqList(end)]); ylim(hSummaryAvg1,fftLims);
    xlim(hSummaryAvg2,[maskFreqList(1) maskFreqList(end)]); ylim(hSummaryAvg2,fftLims_zscore);
    xlabel(hSummaryAvg1,'Temporal Freq'); title(hSummaryAvg1,'Avg Good elecs');
    xlabel(hSummaryAvg2,'Temporal Freq'); title(hSummaryAvg2,'Z-Score Good elecs');
    
    legend(hSummaryAvg2,legendStr,'location','southeast');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if displayFlag
    % If needed, show raw data also
    
    % ERP data
    timeLims = [-0.5 1]; erpLims = [-50 50];
    hGra = getPlotHandles(numMaskTFs,numOris,[0.05 0.5 0.3 0.45],0.01,0.01,1);
    hPld = getPlotHandles(numMaskTFs,numOris,[0.05 0.05 0.3 0.4],0.01,0.01,1);
    
    hGraFFT = getPlotHandles(numMaskTFs,numOris,[0.4 0.5 0.3 0.45],0.01,0.01,1);
    hPldFFT = getPlotHandles(numMaskTFs,numOris,[0.4 0.05 0.3 0.4],0.01,0.01,1);
    
    for o=1:numOris
        for t=1:numMaskTFs
            disp([o t]);
            for elec=1:numGoodElectrodes
                
                % ERP Gratings
                graData = squeeze(data.erpAllGra(elec,o,t,:));
                graData = graData - mean(graData(blPos));
                
                plot(hGra(t,o),timeVals,graData,'color',electrodeColors(elec,:));
                hold(hGra(t,o),'on');
                text(timeLims(1)+0.1,erpLims(2)-10,['N=' num2str(data.numRepeatsGra(o,t))],'Parent',hGra(t,o));
                axis(hGra(t,o),[timeLims erpLims]);
                if ~(o==1 && t== numMaskTFs)
                    set(hGra(t,o),'XTickLabel',[],'YTickLabel',[]);
                else
                    xlabel(hGra(t,o),'Time (s)'); ylabel(hGra(t,o),'ERP (\muV)');
                end
                
                % ERP Plaids
                pldData = squeeze(data.erpAllPld(elec,o,t,:));
                pldData = pldData - mean(pldData(blPos));
                plot(hPld(t,o),timeVals,pldData,'color',electrodeColors(elec,:));
                hold(hPld(t,o),'on');
                text(timeLims(1)+0.1,erpLims(2)-10,['N=' num2str(data.numRepeatsPld(o,t))],'Parent',hPld(t,o));
                axis(hPld(t,o),[timeLims erpLims]);
                if ~(o==1 && t== numMaskTFs)
                    set(hPld(t,o),'XTickLabel',[],'YTickLabel',[]);
                else
                    xlabel(hPld(t,o),'Time (s)'); ylabel(hPld(t,o),'ERP (\muV)');
                end
                
                % FFT Gratings
                plot(hGraFFT(t,o),f,squeeze(graSTFFT(elec,o,t,:)),'color',electrodeColors(elec,:));
                hold(hGraFFT(t,o),'on');
                axis(hGraFFT(t,o),[freqLims fftLims]);
                if ~(o==1 && t== numMaskTFs)
                    set(hGraFFT(t,o),'XTickLabel',[],'YTickLabel',[]);
                else
                    xlabel(hGraFFT(t,o),'Freq (Hz)'); ylabel(hGraFFT(t,o),'Amp (\muV)');
                end
                if (t==1)
                    title(hGraFFT(t,o),['Ori=' num2str(data.parameterCombinations.oValsUnique2(o))]);
                end
                if (o==numOris)
                    ylabel(hGraFFT(t,o),['TF=' num2str(maskFreqList(t))]);
                    set(hGraFFT(t,o),'YAxisLocation','right');
                end
                
                % FFT Plaids
                
                plot(hPldFFT(t,o),f,squeeze(pldSTFFT(elec,o,t,:)),'color',electrodeColors(elec,:));
                hold(hPldFFT(t,o),'on');
                axis(hPldFFT(t,o),[freqLims fftLims]);
                if ~(o==1 && t== numMaskTFs)
                    set(hPldFFT(t,o),'XTickLabel',[],'YTickLabel',[]);
                else
                    xlabel(hPldFFT(t,o),'Freq (Hz)'); ylabel(hPldFFT(t,o),'Amp (\muV)');
                end
                if (t==1)
                    title(hPldFFT(t,o),['O1=' num2str(data.parameterCombinations.oValsUnique) ', O2=' num2str(data.parameterCombinations.oValsUnique2(o))]);
                end
                if (o==numOris)
                    ylabel(hPldFFT(t,o),['TF=' num2str(maskFreqList(t))]);
                    set(hPldFFT(t,o),'YAxisLocation','right');
                end
            end
        end
    end
end
end

function X_zscored = zscore(X)

numElecs = size(X,1);
X_zscored = zeros(size(X));

for i=1:numElecs
    Xtmp = squeeze(X(i,:,:));
    m = mean(Xtmp(:));
    s = std(Xtmp(:));
    X_zscored(i,:,:) = (Xtmp-m)/s;
end
end