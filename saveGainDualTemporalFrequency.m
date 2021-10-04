% This program is modified from getGainDualTemporalFrequency. This program
% saves ERP data in appropriate format

function saveGainDualTemporalFrequency(subjectName,expDate,protocolNames,folderSourceString,gridType,electrodeNums,decimationFactor) 

% Find the number of orientation and temporal frequency combinations and
% make sure that each protocol has the same set of combinations
for protName = 1:length(protocolNames)
    folderName = fullfile(folderSourceString,'data',subjectName,gridType,expDate,protocolNames{protName});        
    folderExtract = fullfile(folderName,'extractedData');
    if protName==1
        parameterCombinations=load(fullfile(folderExtract,'parameterCombinations.mat'));
        parameterCombinations.parameterCombinations=[]; parameterCombinations.parameterCombinations2=[]; 
    else
        p=load(fullfile(folderExtract,'parameterCombinations.mat'));
        p.parameterCombinations=[]; p.parameterCombinations2=[];
        if ~isequal(p,parameterCombinations)
            error('ParameterCombinations do not match across protocols');
        end
    end
end

numOri = length(parameterCombinations.oValsUnique2);
numMaskFreq = length(parameterCombinations.tValsUnique2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Find out a common set of good electrodes
commonBadElectrodes = [];
for protName = 1:length(protocolNames)
    folderName = fullfile(folderSourceString,'data',subjectName,gridType,expDate,protocolNames{protName});        
    folderSegment = fullfile(folderName,'segmentedData');
    
    if strcmp(gridType,'Microelectrode') % Monkey Data
        b = load(fullfile(folderSegment,'badTrials.mat'),'badElecs');
        commonBadElectrodes = cat(1,commonBadElectrodes,b.badElecs);
    else
        b = load(fullfile(folderSegment,'badTrials_v6.mat'),'badElecs');
        commonBadElectrodes = cat(1,commonBadElectrodes,b.badElecs.badImpedanceElecs,b.badElecs.flatPSDElecs,b.badElecs.noisyElecs,b.badElecs.badImpedanceElecs,b.badElecs.declaredBadElectrodes);
    end
end

goodElectrodeNums = setdiff(electrodeNums,unique(commonBadElectrodes));
disp(['numOri: ' num2str(numOri) ', numTFs: ' num2str(numMaskFreq) ', using ' num2str(length(goodElectrodeNums)) ' good electrodes.']);

%%%%%%%%%%%%%%%%%%%%%%%%% Get Full Dataset %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Check if all protocols have the same time duration
for protName = 1:length(protocolNames)
    folderName = fullfile(folderSourceString,'data',subjectName,gridType,expDate,protocolNames{protName});
    folderSegment = fullfile(folderName,'segmentedData');
    clear t
    t = load(fullfile(folderSegment,'LFP','lfpInfo.mat'),'timeVals');

    if protName==1
        timeVals = t.timeVals;
    else
        if ~isequal(t.timeVals,timeVals)
            error('timeVals do not match');
        end
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%% Downsample timeVals if needed %%%%%%%%%%%%%%%%%%
if decimationFactor>1
    timeVals = downsample(timeVals,decimationFactor);
    decimationStr = ['_decimated' num2str(decimationFactor)];
else
    decimationStr='';
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Get Data %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
numGoodElectrodes = length(goodElectrodeNums);

erpAllGra = zeros(numGoodElectrodes,numOri,numMaskFreq,length(timeVals));
erpAllPld = zeros(numGoodElectrodes,numOri,numMaskFreq,length(timeVals));
numRepeatsGra = zeros(numOri,numMaskFreq);
numRepeatsPld = zeros(numOri,numMaskFreq);

for i = 1:numGoodElectrodes
    elec = goodElectrodeNums(i);
    disp(['electrode ' num2str(elec)]);
    
    analogDataAllGra = cell(numOri,numMaskFreq);
    analogDataAllPld = cell(numOri,numMaskFreq);

    for protName = 1:length(protocolNames)

        %load data
        folderName = fullfile(folderSourceString,'data',subjectName,gridType,expDate,protocolNames{protName});        
        folderExtract = fullfile(folderName,'extractedData');
        folderSegment = fullfile(folderName,'segmentedData');
        p = load(fullfile(folderExtract,'parameterCombinations.mat')); 
        
        if length(p.cValsUnique)==1
            onlyPlaidFlag=1;
            onlyPlaidStr = '_onlyPlaid';
        else
            onlyPlaidFlag=0;
            onlyPlaidStr = '';
        end
        
        %load and remove bad trials
        if strcmp(gridType,'Microelectrode')
            b = load(fullfile(folderSegment,'badTrials.mat'),'badTrials');
        else
            b = load(fullfile(folderSegment,'badTrials_v6.mat'),'badTrials');
        end
        
        clear analogData
        analogData = load(fullfile(folderSegment,'LFP',['elec' num2str(elec)]),'analogData');
        
        for o = 1:numOri
            for t = 1:numMaskFreq
                
                if onlyPlaidFlag
                    % plaid case
                    trialNums = p.parameterCombinations{1,1,1,1,1,1,1};
                    trialNums = intersect(trialNums,p.parameterCombinations2{1,1,1,1,o,1,t});
                    trialNums = setdiff(trialNums,b.badTrials);
                    analogDataAllPld{o,t} = cat(1,analogDataAllPld{o,t},analogData.analogData(trialNums,:));
                else
                    
                    % Grating case
                    trialNums = p.parameterCombinations{1,1,1,1,1,1,1};
                    trialNums = intersect(trialNums,p.parameterCombinations2{1,1,1,1,o,1,t});
                    trialNums = setdiff(trialNums,b.badTrials);
                    analogDataAllGra{o,t} = cat(1,analogDataAllGra{o,t},analogData.analogData(trialNums,:));
                    
                    % plaid case
                    trialNums = p.parameterCombinations{1,1,1,1,1,2,1};
                    trialNums = intersect(trialNums,p.parameterCombinations2{1,1,1,1,o,1,t});
                    trialNums = setdiff(trialNums,b.badTrials);
                    analogDataAllPld{o,t} = cat(1,analogDataAllPld{o,t},analogData.analogData(trialNums,:));
                end
            end
        end
    end
    
    for o = 1:numOri
        for t = 1:numMaskFreq
            if i==1
                numRepeatsGra(o,t) = size(analogDataAllGra{o,t},1);
                numRepeatsPld(o,t) = size(analogDataAllPld{o,t},1);
            end
            
            if onlyPlaidFlag
                if decimationFactor>1
                    erpAllPld(i,o,t,:) = resample(mean(analogDataAllPld{o,t},1),1,decimationFactor);
                else
                    erpAllPld(i,o,t,:) = mean(analogDataAllPld{o,t},1);
                end
            else
                if decimationFactor>1
                    erpAllGra(i,o,t,:) = resample(mean(analogDataAllGra{o,t},1),1,decimationFactor);
                    erpAllPld(i,o,t,:) = resample(mean(analogDataAllPld{o,t},1),1,decimationFactor);
                else
                    erpAllGra(i,o,t,:) = mean(analogDataAllGra{o,t},1);
                    erpAllPld(i,o,t,:) = mean(analogDataAllPld{o,t},1);
                end
            end
        end
    end
end

% Saving data at an appropriate place
makeDirectory(fullfile('savedData',gridType));

if strcmp(gridType,'Microelectrode') % Monkey Data
    fileNameOut = fullfile('savedData',gridType,[subjectName expDate gridType protocolNames{1} decimationStr onlyPlaidStr '.mat']);
else
    fileNameOut = fullfile('savedData',gridType,[subjectName expDate gridType decimationStr onlyPlaidStr '.mat']);
end
save(fileNameOut,'parameterCombinations','timeVals','goodElectrodeNums','erpAllGra','erpAllPld','numRepeatsGra','numRepeatsPld');
