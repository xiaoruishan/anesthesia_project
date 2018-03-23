

figure
boundedline(R_awake_SS_pre.f,mean(R_awake_SS_pre.Power{5,1}),std(R_awake_SS_pre.Power{5,1})./sqrt(9),'b')
hold on
boundedline(R_awake_SS_pre.f,mean(R_awake_SS_post.Power{5,1}),std(R_awake_SS_post.Power{5,1})./sqrt(9),'r')
% boundedline(R_awake_SS_pre.f,mean(R_awakeR_SS.Power{5,1}),std(R_awakeR_SS.Power{5,1})./sqrt(18),'g')


figure
boundedline(R_awake_SS_pre.f,mean(R_awake_DD.Power{5,1}),std(R_awake_DD.Power{5,1})./sqrt(38),'b')
hold on
boundedline(R_awake_SS_pre.f,mean(R_awake_DD.Power{5,1}),std(R_awake_DD.Power{5,1})./sqrt(18),'r')
% boundedline(R_awake_SS_pre.f,mean(R_awakeR_DD.Power{5,1}),std(R_awake_DD.Power{5,1})./sqrt(18),'g')


Power=vertcat(R_awake_SS_pre.Power{5,1},R_awake_SS_post.Power{5,1});%,R_awakeR_SS.Power{5,1});
theta=mean(Power(:,find(R_awake_SS_pre.f>4,1):find(R_awake_SS_pre.f<12,1,'last')),2);
beta=mean(Power(:,find(R_awake_SS_pre.f>12,1):find(R_awake_SS_pre.f<30,1,'last')),2);
gamma=mean(Power(:,find(R_awake_SS_pre.f>30,1):find(R_awake_SS_pre.f<100,1,'last')),2);

Power=vertcat(R_awake_DD.Power{5,1},R_awake_DD.Power{5,1},R_awakeR_DD.Power{5,1});
theta_deep=mean(Power(:,find(R_awake_SS_pre.f>4,1):find(R_awake_SS_pre.f<12,1,'last')),2);
beta_deep=mean(Power(:,find(R_awake_SS_pre.f>12,1):find(R_awake_SS_pre.f<30,1,'last')),2);
gamma_deep=mean(Power(:,find(R_awake_SS_pre.f>30,1):find(R_awake_SS_pre.f<100,1,'last')),2);

tblR=table(age,categorical(condition),round(1000*theta),round(1000*beta),round(1000*gamma),round(1000*theta_deep),...
    round(1000*beta_deep),round(1000*gamma_deep),'VariableNames',{'age','condition','theta',...
    'beta','gamma','theta_deep','beta_deep','gamma_deep'});