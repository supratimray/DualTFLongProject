clear;clc;

% Human Data
folderSourceString = 'N:\data\human\DualTFLongProject';
gridType = 'EEG';
electrodeNums=1:8;
decimationFactor=10;
[subjectNames_all,expDates_all,protocolNames_all] = DTFProjectHumanData;

for i=21:42 % Need more work for 32-42
    subjectName = subjectNames_all{i};
    expDate = expDates_all{i};
    protocolNames = protocolNames_all{i};
    disp([num2str(i) subjectName expDate]);
    saveGainDualTemporalFrequency(subjectName,expDate,protocolNames,folderSourceString,gridType,electrodeNums,decimationFactor);
end

% % Monkey data
% folderSourceString = 'N:\commonData\Non_Standard\DualTFLong';
% gridType = 'Microelectrode';
% decimationFactor=8;
% 
% [subjectNames_all,expDates_all,protocolNames_all] = DTFProjectMonkeyData;
% 
% for i=1:length(subjectNames_all)
%     disp(i);
%     subjectName = subjectNames_all{i};
%     expDate = expDates_all{i};
%     protocolNames = protocolNames_all{i};
%     
%     if strcmp(subjectName,'alpaH')
%         electrodeNums = [82 85 86 88 89];
%     elseif strcmp(subjectName,'coco')
%         rfData = load([subjectName gridType 'RFData.mat']);
%         electrodeNums = rfData.highRMSElectrodes;
%     end
%     saveGainDualTemporalFrequency(subjectName,expDate,protocolNames,folderSourceString,gridType,electrodeNums,decimationFactor);
% end