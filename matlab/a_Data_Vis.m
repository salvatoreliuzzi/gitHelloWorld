
%{
You are provided with 5 ECG recordings acquired in full-term neonates and 
sampled at 500 Hz.
Each recording also contains the indication of infant sleep state 
(second column of the data table).

E.g., the sleep state of the first participants is reported as: 
38	218	2	291	471	1,
which reads that from seconds 28 to 218 the newborn was in active sleep, 
whereas from seconds 291 to 471 the state was quiet sleep.
%}


clear all
close all
clc

load DATA.mat;

sf = 500; % sampling frequency

LPT04 = LPT_ALLDATA{1,1}; % from table to cell
LPT04 = cell2mat(LPT04); % from cell to array sssoucy 

LPT05 = LPT_ALLDATA{2,1}; % from table to cell
LPT05 = cell2mat(LPT05); % from cell to array 

LPT37 = LPT_ALLDATA{3,1}; % from table to cell
LPT37 = cell2mat(LPT37); % from cell to array 

LPT51 = LPT_ALLDATA{4,1}; % from table to cell
LPT51 = cell2mat(LPT51); % from cell to array 

LPT55 = LPT_ALLDATA{5,1}; % from table to cell
LPT55 = cell2mat(LPT55); % from cell to array 


[Q,R,S] = QRSauto (LPT04,500);
[Q,R,S] = QRSauto (LPT05,500);
[Q,R,S] = QRSauto (LPT37,500);
[Q,R,S] = QRSauto (LPT51,500);
[Q,R,S] = QRSauto (LPT55,500);


