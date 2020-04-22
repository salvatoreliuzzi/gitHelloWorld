function [Q,R,S] = QRSauto (RAW,sf)

%.
%   dP                                .d888b.
%   88                                Y8' `8P
% d8888P .d8888b. .d8888b. 88d8b.d8b. d8bad8b
%   88   88ooood8 88'  `88 88'`88'`88 88` `88
%   88   88.  ... 88.  .88 88  88  88 8b. .88
%   dP   `88888P' `88888P8 dP  dP  dP Y88888P
%
% QRSauto is a numerical method which detects QRS complex.
%
% [Q,R,S] = QRSauto (RAW,sf)
%
% RAW:      raw data (array), it assumes that the signal goes around 0
% sf:       sampling frequency
% Q:        estimated Q peaks array
% R:        estimated Q peaks array
% S:        estimated S peaks array

%% Output
Q = zeros(1,length(RAW));
R = zeros(1,length(RAW));
S = zeros(1,length(RAW));

%% RAW Peak Enhancer
%RAW=(RAW./1);
%RAW=RAW.^(3);
%RAW=(RAW./1000);

%% Plot RAW signal
t_RAW = 0: 1/sf : length(RAW)/sf - 1/sf; % time domain
figure,
subplot(2,2,1);
plot(t_RAW,RAW,'k','linewidth',1.5);
title('RAW');
ylabel('Amplitude [mV]');
xlabel('Time [sec]');
grid on
box off

%% Window Selection (first 2 sec)
% it allows to find the first QRS complex of reference
eW = 2./(1./sf); % number of samples that correspond to 2 sec in time (eW = end Window)
t_fW = 0 : 1/sf : eW/sf - 1/sf; % 2 sec window in time
fW = 1:eW; % (fW = Full Window)
sWD = RAW(fW); % (sWD= Signal WindoweD)

subplot(2,2,2);
plot(t_fW,sWD,'k','linewidth',1.5);
title('WINDOW');
ylabel('Amplitude [mV]');
xlabel('Time [sec]');

%% most prominent R peak in 2 seconds time window
Rref=max(sWD); % value of the maximum peak in the first 2 seconnd window
t_Rs = 0; % time R peak Sample domain
for i = fW
    if (sWD(i)==Rref)
        t_Rs = i;
    end
end
t_R = (t_Rs./sf - 1/sf) % time R peak in time domain
hold on
plot(t_R,sWD(t_Rs),'or','linewidth',1.5);


%% Q peak related to the most prominent R peak
t_Qs = 0;
for i = t_Rs-1 : -1 : 1
    if (sWD(i)<sWD(i+1) && sWD(i)<sWD(i-1))
        t_Qs = i;
        break
    end
end
t_Q = (t_Qs./sf - 1/sf) % time Q peak in time domain
plot(t_Q,sWD(t_Qs),'or','linewidth',1.5);


%% S peak related to the most prominent R peak
t_Ss = 0;
for i = t_Rs+1 : eW
    if (sWD(i)<sWD(i+1) && sWD(i)<sWD(i-1))
        t_Ss = i;
        break
    end
end
t_S = (t_Ss./sf - 1/sf) % time S peak in time domain
plot(t_S,sWD(t_Ss),'or','linewidth',1.5);

%% start QRS related to the most prominent R peak
ss = 0; % start QRS - sample index
for i = t_Qs : -1 : 1
    if (sWD(i)>sWD(i+1) && sWD(i)>sWD(i-1))
        ss = i;
        break
    end
end
s = (ss./sf - 1/sf) % start QRS - time domain
plot(s,sWD(ss),'^g','linewidth',1.5);

%% end QRS related to the most prominent R peak
es = 0;
for i = t_Ss : eW
    if (sWD(i)>sWD(i+1) && sWD(i)>sWD(i-1))
        es = i;
        break
    end
end
e = (es./sf - 1/sf) % start QRS - time domain
plot(e,sWD(es),'xg','linewidth',1.5);
grid on
box off

%% first QRS reference
QRSref=sWD(ss:es);
subplot(2,2,4);
plot([s:1/sf:e],QRSref,'k','linewidth',1.5);
title('QRS reference');
hold on
labels = {'s'};
plot(s,sWD(ss),'^g','linewidth',1.5);
text(s,sWD(ss),labels,'VerticalAlignment','top','HorizontalAlignment','left')
hold on
labels = {'Q'};
plot(t_Q,sWD(t_Qs),'or','linewidth',1.5);
text(t_Q,sWD(t_Qs),labels,'VerticalAlignment','top','HorizontalAlignment','right')
hold on
labels = {'R'};
plot(t_R,sWD(t_Rs),'or','linewidth',1.5);
text(t_R,sWD(t_Rs),labels,'VerticalAlignment','bottom','HorizontalAlignment','right')
hold on
labels = {'S'};
plot(t_S,sWD(t_Ss),'or','linewidth',1.5);
text(t_S,sWD(t_Ss),labels,'VerticalAlignment','top','HorizontalAlignment','left')
hold on
labels = {'e'};
plot(e,sWD(es),'xg','linewidth',1.5);
text(e,sWD(es),labels,'VerticalAlignment','top','HorizontalAlignment','left')
ylabel('Amplitude [mV]');
xlabel('Time [sec]');
grid on
box off

%% epsilon
eps = zeros(1,length(sWD));

for i = 1 : length(sWD)-length(QRSref)
    error=0;
    for j = 1 : length(QRSref)
        error = error + abs(sWD(i+j-1) - QRSref(j));
    end
    eps(i)=error/5;
end
subplot(2,2,3);
plot(t_fW,sWD,'k','linewidth',1.5);
title('QRS reference Comparison');
hold on
plot(t_fW,eps,'r','linewidth',1.5);
grid on
box off

end