function [SubjectName,expDate,protocolNames] = DTFProjectHumanData

%%%%%%%%%%%%%%%%%%%%%%%%%% Short protocol %%%%%%%%%%%%%%%%%%%%%%%%%% 
%Target Frequency - 16 Hz, Target Orientation - 90,  Mask Frequency = 10:2:22 Hz, Mask Orientaion - 0,30,60,90
clear index; index=1; SubjectName{index} = 'WS'; expDate{index} = '190219'; protocolNames{index} = {'GRF_001','GRF_002','GRF_004','GRF_005','GRF_006'};
clear index; index=2; SubjectName{index} = 'SK'; expDate{index} = '280319'; protocolNames{index} = {'GRF_001','GRF_002','GRF_003','GRF_004'}; %,'GRF_005',}; 
clear index; index=3; SubjectName{index} = 'MK'; expDate{index} = '210219'; protocolNames{index} = {'GRF_001','GRF_004','GRF_005','GRF_006','GRF_007', 'GRF_008','GRF_009'}; 

%Target Frequency - 16 Hz, Target Orientation - 0,  Mask Frequency = 10:2:22 Hz, Mask Orientaion - 0,30,60,90
clear index; index=4; SubjectName{index} = 'DG'; expDate{index} = '110319'; protocolNames{index} = {'GRF_001','GRF_002','GRF_004','GRF_006','GRF_007','GRF_008'};
clear index; index=5; SubjectName{index} = 'KKR'; expDate{index} = '130319'; protocolNames{index} = {'GRF_003','GRF_004','GRF_005','GRF_006','GRF_007'};
clear index; index=6; SubjectName{index} = 'SGJ'; expDate{index} = '290319'; protocolNames{index} =  {'GRF_001','GRF_002'};

%%%%%%%%%%%%%%%%%%%%%%%%%% Long protocol %%%%%%%%%%%%%%%%%%%%%%%%%% 
%Target Frequency - 16 Hz, Target Orientation - 90,  Mask Frequency = 2:2:30 Hz, Mask Orientaion - 0,30,60,90
clear index; index=7; SubjectName{index} = 'SJ'; expDate{index} = '190319'; protocolNames{index} = {'GRF_001','GRF_003','GRF_005','GRF_008','GRF_009','GRF_010','GRF_011'}; %{'GRF_001','GRF_003','GRF_004','GRF_005','GRF_008','GRF_009','GRF_010','GRF_011'};
clear index; index=8; SubjectName{index} = 'KL'; expDate{index} = '230219'; protocolNames{index} = {'GRF_002','GRF_003','GRF_004','GRF_005','GRF_006','GRF_007'};

%Target Frequency - 16 Hz, Target Orientation - 0,  Mask Frequency = 2:2:30 Hz, Mask Orientaion - 0,30,60,90
clear index; index=9; SubjectName{index} = 'KM'; expDate{index} = '070319'; protocolNames{index} = {'GRF_001','GRF_002','GRF_003','GRF_004','GRF_008','GRF_010','GRF_011','GRF_012','GRF_013'};
clear index; index=10; SubjectName{index} = 'AB'; expDate{index} = '270319'; protocolNames{index} = {'GRF_001','GRF_002','GRF_003','GRF_004','GRF_005'};

%Target Frequency - 15 Hz, Target Orientation - 90,  Mask Frequency = 1:2:29 Hz, Mask Orientaion - 0,30,60,90
clear index; index=11; SubjectName{index} = 'AS'; expDate{index} = '080619'; protocolNames{index} = {'GRF_001','GRF_002','GRF_003'};
clear index; index=12; SubjectName{index} = 'JB'; expDate{index} = '140619'; protocolNames{index} = {'GRF_004','GRF_005','GRF_006'}; 
clear index; index=13; SubjectName{index} = 'LE'; expDate{index} = '190619'; protocolNames{index} = {'GRF_001','GRF_002','GRF_003','GRF_004','GRF_005','GRF_006','GRF_008','GRF_009'};
clear index; index=14; SubjectName{index} = 'JS'; expDate{index} = '260619'; protocolNames{index} = {'GRF_001','GRF_002','GRF_003','GRF_004','GRF_005','GRF_006'};
clear index; index=15; SubjectName{index} = 'JH'; expDate{index} = '050719'; protocolNames{index} = {'GRF_001','GRF_002','GRF_003','GRF_004','GRF_005'};

%Target Frequency - 15 Hz, Target Orientation - 0,  Mask Frequency = 1:2:29 Hz, Mask Orientaion - 0,30,60,90
clear index; index=16; SubjectName{index} = 'SN'; expDate{index} = '060719'; protocolNames{index} = {'GRF_004','GRF_005'};
clear index; index=17; SubjectName{index} = 'SP'; expDate{index} = '180719'; protocolNames{index} = {'GRF_001','GRF_002','GRF_003','GRF_004','GRF_005'};
clear index; index=18; SubjectName{index} = 'AK'; expDate{index} = '230719'; protocolNames{index} = {'GRF_002','GRF_003','GRF_004','GRF_005','GRF_006'};
clear index; index=19; SubjectName{index} = 'DA'; expDate{index} = '230719'; protocolNames{index} = {'GRF_001','GRF_002','GRF_003','GRF_004','GRF_006'};
clear index; index=20; SubjectName{index} = 'SAK'; expDate{index} = '290719'; protocolNames{index} = {'GRF_001','GRF_002','GRF_003'};

%%%%%%%%%%%%%%%%%%%% Multiple Target Frequency %%%%%%%%%%%%%%%%%%%%
%Target Frequency - 15 Hz, Target Orientation - 0,  Mask Frequency = 1:2:29 Hz, Mask Orientaion - 0,90
clear index; index=21; SubjectName{index} = 'KL'; expDate{index} = '080421'; protocolNames{index} = {'GRF_001','GRF_002'};
clear index; index=22; SubjectName{index} = 'SVP'; expDate{index} = '160321'; protocolNames{index} = {'GRF_001','GRF_002','GRF_003'};
clear index; index=23; SubjectName{index} = 'ARD'; expDate{index} = '300321'; protocolNames{index} = {'GRF_002'};
clear index; index=24; SubjectName{index} = 'SB'; expDate{index} = '140421'; protocolNames{index} = {'GRF_001','GRF_002'};
clear index; index=25; SubjectName{index} = 'WS'; expDate{index} = '170421'; protocolNames{index} = {'GRF_001','GRF_002'};
clear index; index=26; SubjectName{index} = 'NM'; expDate{index} = '240621'; protocolNames{index} = {'GRF_001','GRF_002','GRF_003','GRF_005'};
clear index; index=27; SubjectName{index} = 'SP'; expDate{index} = '250621'; protocolNames{index} = {'GRF_001','GRF_002'};
clear index; index=28; SubjectName{index} = 'PS'; expDate{index} = '280621'; protocolNames{index} = {'GRF_001','GRF_002'};
clear index; index=29; SubjectName{index} = 'VS'; expDate{index} = '020721'; protocolNames{index} = {'GRF_001','GRF_002'};
clear index; index=30; SubjectName{index} = 'AM'; expDate{index} = '030721'; protocolNames{index} = {'GRF_001','GRF_002'};
clear index; index=31; SubjectName{index} = 'UG'; expDate{index} = '100721'; protocolNames{index} = {'GRF_001','GRF_002'};

%Target Frequency - 7 Hz, Target Orientation - 0,  Mask Frequency = 1:2:29 Hz, Mask Orientaion - 0,90
clear index; index=32; SubjectName{index} = 'KL'; expDate{index} = '080421'; protocolNames{index} = {'GRF_003'};
clear index; index=33; SubjectName{index} = 'SVP'; expDate{index} = '160321'; protocolNames{index} = {'GRF_004'};
clear index; index=34; SubjectName{index} = 'ARD'; expDate{index} = '300321'; protocolNames{index} = {'GRF_003'};
clear index; index=35; SubjectName{index} = 'SB'; expDate{index} = '140421'; protocolNames{index} = {'GRF_003'};
clear index; index=36; SubjectName{index} = 'WS'; expDate{index} = '170421'; protocolNames{index} = {'GRF_003'};
clear index; index=37; SubjectName{index} = 'NM'; expDate{index} = '240621'; protocolNames{index} = {'GRF_004'};
clear index; index=38; SubjectName{index} = 'SP'; expDate{index} = '250621'; protocolNames{index} = {'GRF_003'};
clear index; index=39; SubjectName{index} = 'PS'; expDate{index} = '280621'; protocolNames{index} = {'GRF_003'};
clear index; index=40; SubjectName{index} = 'VS'; expDate{index} = '020721'; protocolNames{index} = {'GRF_003'};
clear index; index=41; SubjectName{index} = 'AM'; expDate{index} = '030721'; protocolNames{index} = {'GRF_003'};
clear index; index=42; SubjectName{index} = 'UG'; expDate{index} = '100721'; protocolNames{index} = {'GRF_003'};
end