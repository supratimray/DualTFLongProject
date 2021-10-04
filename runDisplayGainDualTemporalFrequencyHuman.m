clear;clf;clc

% Human Data
gridType = 'EEG';
timeRange = [0.3 0.8];
decimationFactor=10;
[subjectNames_all,expDates_all,protocolNames_all] = DTFProjectHumanData;
subtractNeighborsFlag=0;
displayFlag = 0;

%%%%%%%%%%%%%%%%%%%%%% Subject 1 data (Figure1) %%%%%%%%%%%%%%%%%%%%%%%%%%%
% i=1; displayAllData(subjectNames_all{i},expDates_all{i},protocolNames_all{i},gridType,timeRange,decimationFactor,subtractNeighborsFlag,displayFlag);

%%%%%%%%%%%%%%%%%%%%%%%%%%% Average Data %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
deltaThetaList = [0 30 60 90];

count=0;
for i=1:10
    disp(i);
    subjectName = subjectNames_all{i};
    protocolNames = protocolNames_all{i};
    expDate = expDates_all{i};

    [~,mPLDF0,~,~,~,mPLDF0_zscored,deltaTheta,maskFreqList] = displayAllData(subjectName,expDate,protocolNames,gridType,timeRange,decimationFactor,subtractNeighborsFlag,displayFlag);

    if ~isempty(mPLDF0)
        pos16 = find(maskFreqList==16);
        if isequal(deltaTheta,deltaThetaList)
            listOrder=1:4;
        else
            listOrder=4:-1:1;
        end
        
        count=count+1;
        mData16(count,:,:) = mPLDF0(listOrder,pos16-3:pos16+3); %#ok<*SAGROW>
        mData16_zscored(count,:,:) = mPLDF0_zscored(listOrder,pos16-3:pos16+3);
    end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
count = 0;
for i=11:20
    disp(i);
    subjectName = subjectNames_all{i};
    protocolNames = protocolNames_all{i};
    expDate = expDates_all{i};

    [~,mPLDF0,~,~,~,mPLDF0_zscored,deltaTheta,maskFreqList] = displayAllData(subjectName,expDate,protocolNames,gridType,timeRange,decimationFactor,subtractNeighborsFlag,displayFlag);

    if ~isempty(mPLDF0)
        pos15 = find(maskFreqList==15);
        pos7 = find(maskFreqList==7);
        if isequal(deltaTheta,deltaThetaList)
            listOrder=1:4;
        else
            listOrder=4:-1:1;
        end
        
        count=count+1;
        mData15(count,:,:) = mPLDF0(listOrder,pos15-3:pos15+3);
        mData15_zscored(count,:,:) = mPLDF0_zscored(listOrder,pos15-3:pos15+3);
        mData7(count,:,:) = mPLDF0(listOrder,pos7-3:pos7+3);
        mData7_zscored(count,:,:) = mPLDF0_zscored(listOrder,pos7-3:pos7+3);
    end
end

clf;
maskFreqList=10:2:22; 
h1=subplot(441); h2=subplot(442);
displayGainVsTFData(mData16,maskFreqList,deltaThetaList,[h1 h2]);
h3=subplot(443); h4=subplot(444);
displayGainVsTFData(mData16_zscored,maskFreqList,deltaThetaList,[h3 h4]);

maskFreqList=9:2:21; 
h1=subplot(445); h2=subplot(446);
displayGainVsTFData(mData15,maskFreqList,deltaThetaList,[h1 h2]);
h3=subplot(447); h4=subplot(448);
displayGainVsTFData(mData15_zscored,maskFreqList,deltaThetaList,[h3 h4]);

maskFreqList=1:2:13; 
h1=subplot(449); h2=subplot(4,4,10);
displayGainVsTFData(mData7,maskFreqList,deltaThetaList,[h1 h2]);
h3=subplot(4,4,11); h4=subplot(4,4,12);
displayGainVsTFData(mData7_zscored,maskFreqList,deltaThetaList,[h3 h4]);

maskFreqList=-6:2:6; 
mDataCombined = cat(1,mData16,mData15);
mDataCombined_zscored = cat(1,mData16_zscored,mData15_zscored);

h1=subplot(4,4,13); h2=subplot(4,4,14);
displayGainVsTFData(mDataCombined,maskFreqList,deltaThetaList,[h1 h2]);
h3=subplot(4,4,15); h4=subplot(4,4,16);
displayGainVsTFData(mDataCombined_zscored,maskFreqList,deltaThetaList,[h3 h4]);