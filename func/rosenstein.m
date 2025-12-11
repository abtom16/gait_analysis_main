function [di] = rosenstein(tss, tau, Fs, max_i, Fg)
%% Rosenstein et al / Lyapunov exponents from small data sets

%% Estimate lag and mean period using the FFT
% Lag value calculated from MI (see fraser / swinney, "independent
% coordinates for strange attractors from mutual information" )

% 歩行は右足左足を分けるとだいたい2Hzである．
% FFTで得た周波数を代入している．(引数を渡すときに2倍している)
mean_period = 1/Fg;
mean_lag = floor(mean_period*Fs*1);  %となりのアトラクタの輪が該当するように

%% 遅れ時差を用いた状態空間ベクトルの
N = length(tss(:,1));
x1 = tss(1:(N-4*tau-1));
x2 = tss((1:N-4*tau-1)+tau);
x3 = tss((1:N-4*tau-1)+2*tau);
x4 = tss((1:N-4*tau-1)+3*tau);
x5 = tss((1:N-4*tau-1)+4*tau);
%% 
X = [x1 x2 x3 x4 x5];

%% Find nearest neighbors, constrain temporal separation
%{
TODO: can speed this up quite a bit using pdist() & then the temporal constraint.
- actually pdist uses too much memory, subsample X

How many i can we use?ここは適宜変更．2だと直線になる．size(X,1) - max_iは正にならないとエラー．
max_i = 500;
size(X,1) - max_i

Number of points to use
npts = 204;
npts = max_iで実行している
%}
nn = [];
samp = 1:size(X,1) - max_i;
for k=samp  % for each point in X
    x = X(k,:);
    
    dists = sqrt(sum(abs(repmat(x, [size(X,1) 1]) - X).^2,2));
    % find set of points w/ temporal separation greater than 1 mean period
    % 範囲指定で外れたものと同じ楕円の軌道を除外
    unacceptable_idxs = ((abs((1:length(dists)) - k) < mean_lag) | (1:length(dists) > length(dists) - max_i));
    dists(unacceptable_idxs) = max(dists);
    %最小距離のインデックスを見つける
    nn_idx = find((dists == min(dists))');
    nn_idx = nn_idx(1);
    %nn配列に足していく
    nn = [nn; nn_idx];
end

% テスト用ーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーー
k = 50;
x = X(50,:);
dists = sqrt(sum(abs(repmat(x, [size(X,1) 1]) - X).^2,2));
% find set of points w/ temporal separation greater than 1 mean period
% 範囲指定で外れたものと同じ楕円の軌道を除外
unacceptable_idxs = ((abs((1:length(dists)) - k) < mean_lag) | (1:length(dists) > length(dists) - max_i));
dists(unacceptable_idxs) = max(dists);
%最小距離のインデックスを見つける
nn_idx = find((dists == min(dists))');
nn_idx = nn_idx(1);
ii = 1;
dists = sqrt(sum(abs(X(samp+ii,:) - X(nn+ii,:)).^2,2));
mean(dists);

% テスト用終ーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーー
%%  
%     nn
di = zeros(max_i, 1);
for ii=1:max_i
    % Compute distance between nns
    dists = sqrt(sum(abs(X(samp+ii,:) - X(nn+ii,:)).^2,2));
    di(ii) = mean(dists);
end

end
