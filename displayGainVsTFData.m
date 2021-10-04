function displayGainVsTFData(mData,maskFreqList,deltaThetaList,plotHandles)

if ~exist('plotHandles','var')
    h1 = subplot(121);
    h2 = subplot(122);
else
    h1 = plotHandles(1);
    h2 = plotHandles(2);
end
hold(h1,'on'); hold(h2,'on');

sqrtN = sqrt(size(mData,1));
numOris = size(mData,2);
numTFs = size(mData,3);
colorNames = copper(numOris);

legendStr=cell(1,numOris);
for o=1:numOris
    plot(h1,maskFreqList,squeeze(mean(mData(:,o,:),1)),'color',colorNames(o,:),'linewidth',2);
    legendStr{o} = ['\delta\theta=' num2str(deltaThetaList(o))];
end

for o=1:numOris 
    for t=1:numTFs
        x = squeeze(mData(:,o,t));
        plot(h1,maskFreqList(t),mean(x),'color',colorNames(o,:),'marker','o');
        errorbar(h1,maskFreqList(t),mean(x),std(x)/sqrtN,'color',colorNames(o,:));
    end
end
legend(h1,legendStr);
title(h1,['N=' num2str(size(mData,1))]);
xlabel(h1,'Mask frequency');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
centrePoint = (numTFs+1)/2;
p=zeros(1,numOris);
for o=1:numOris
    x = squeeze(mean(mData(:,o,(centrePoint+1):numTFs),3) - mean(mData(:,o,1:(centrePoint-1)),3));
    bar(h2,o,mean(x),'FaceColor',colorNames(o,:),'EdgeColor',colorNames(o,:));
    errorbar(h2,o,mean(x),std(x)/sqrtN,'color','k');
    [~,p(o)] = ttest(x);
    
    if p(o)<0.05/numOris
        plot(h2,o,mean(x)+1.5*(std(x)/sqrtN),'color','k','marker','*'); % Bonferroni
    elseif p(o)<0.05
        plot(h2,o,mean(x)+1.5*(std(x)/sqrtN),'color','g','marker','*'); % No Bonferroni
    end
%    plot(h2,o,x,'color',colorNames(o,:),'marker','o');
end
set(h2,'XTick',1:numOris,'XTickLabel',deltaThetaList);
xlabel(h2,'\delta\theta');
disp(p);
end