function[peak_f_tab] = calculate_period(Fs,data)

data = data - mean(data);%周波数が0の山を消す
% Fs = 60;            % Sampling frequency                    
T = 1/Fs;             % Sampling period       
L = length(data);             % Length of signal　Lは偶数だと望ましい

% t = (0:L-1)*T;        % Time vector
% com_x = 2*sin(2*pi*0.8*t);　%試験的に

Y = fft(data);
P2 = abs(Y/L);
P1 = P2(1:round(L/2)+1);
P1(2:end-1) = 2*P1(2:end-1);

% 極大かつ最大のものをみつける
[pks,locs] = findpeaks(P1);
[max_pks,max_index] = max(pks);
% max_pks = max(pks);
% [pks,locs] = findpeaks(P1,Fs,'MinPeakHeight',max_pks*0.9);

%% -- グラフの描画
% figure;
% f = Fs*(0:round(L/2))/L;
% plot(f,P1) 
% title('Single-Sided Amplitude Spectrum of X(t)')
% xlabel('f (Hz)')
% ylabel('|P1(f)|')
% hold on
% disp(length(f))
% 
% plot((locs(max_index)-1)*Fs/L,pks(max_index),'o','MarkerSize',5)%matlabは1からスタートするので-1が必要
% hold off
%%  --
peak_f = (locs(max_index)-1)*Fs/L;

locs = (locs-1)*Fs/L;
peak_f_tab = sortrows([pks locs]);