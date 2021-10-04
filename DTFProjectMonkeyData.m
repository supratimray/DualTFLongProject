function [SubjectName,expDate,protocolNames] = DTFProjectMonkeyData

%alpaH ECoG and EEG
%Parallel Condition
%Target Frequency - 7 Hz, Target Orientation - 0,  Mask Frequency = 1:1:29 Hz, Mask Orientaion - 0
clear index; index=1; SubjectName{index} = 'alpaH'; expDate{index} = '201020'; protocolNames{index} = {'GRF_001'};    %Elec 82 is noisy
clear index; index=2; SubjectName{index} = 'alpaH'; expDate{index} = '211020'; protocolNames{index} = {'GRF_003'};    %Elec 85 is noisy  

%Target Frequency - 11 Hz, Target Orientation - 0,  Mask Frequency = 1:1:29 Hz, Mask Orientaion - 0
clear index; index=3; SubjectName{index} = 'alpaH'; expDate{index} = '221020'; protocolNames{index} = {'GRF_001'};

%Target Frequency - 15 Hz, Target Orientation - 0,  Mask Frequency = 1:1:29 Hz, Mask Orientaion - 0
clear index; index=4; SubjectName{index} = 'alpaH'; expDate{index} = '211020'; protocolNames{index} = {'GRF_001'}; 
clear index; index=5; SubjectName{index} = 'alpaH'; expDate{index} = '211020'; protocolNames{index} = {'GRF_002'}; 

%Orthogonal Condition
%Target Frequency - 7 Hz, Target Orientation - 0,  Mask Frequency = 1:1:29 Hz, Mask Orientaion - 0
clear index; index=6; SubjectName{index} = 'alpaH'; expDate{index} = '271020'; protocolNames{index} = {'GRF_001'};    %noisy data
clear index; index=7; SubjectName{index} = 'alpaH'; expDate{index} = '281020'; protocolNames{index} = {'GRF_001'};      

%Target Frequency - 11 Hz, Target Orientation - 0,  Mask Frequency = 1:1:29 Hz, Mask Orientaion - 0
clear index; index=8; SubjectName{index} = 'alpaH'; expDate{index} = '291020'; protocolNames{index} = {'GRF_001'};
clear index; index=9; SubjectName{index} = 'alpaH'; expDate{index} = '041120'; protocolNames{index} = {'GRF_002'};

%Target Frequency - 15 Hz, Target Orientation - 0,  Mask Frequency = 1:1:29 Hz, Mask Orientaion - 0
clear index; index=10; SubjectName{index} = 'alpaH'; expDate{index} = '261020'; protocolNames{index} = {'GRF_001'};    %noisy data
clear index; index=11; SubjectName{index} = 'alpaH'; expDate{index} = '041120'; protocolNames{index} = {'GRF_001'};

%%%%Coco Data 
clear index; index=12; SubjectName{index} = 'coco'; expDate{index} = '090421'; protocolNames{index} = {'GRF_002'};      % Target Frequency - 11 Hz
clear index; index=13; SubjectName{index} = 'coco'; expDate{index} = '100421'; protocolNames{index} = {'GRF_002'};      % Target Frequency - 15 Hz
clear index; index=14; SubjectName{index} = 'coco'; expDate{index} = '110421'; protocolNames{index} = {'GRF_002'};      % Target Frequency - 7 Hz

end