function[] = Lyapunov(input_file_name2)
clc
%input_file_name2 = "C:\abe_backup\backup\01_修士\06_Xsens_analysis\Gait_Analysis_Xsens\test\Modified_1107asari_normal.xlsx";
[path, name, ~]=fileparts(input_file_name2);
figure_path = fullfile(path, 'figure');
name = char(name);
export_filename = fullfile(figure_path, ['Figure_',name,'.pdf']);
indiv_figdir = fullfile(figure_path,name);

%% 解析に必要な諸元の設定9530120
%% パラメータ
%{

以下，[]内の番号は修論の参考文献番号
Bizovska ら [38] の研究をもとに m = 6次元
埋め込み次元 m = 6 なので状態空間はX(t) = (x(t), x(t + τ ), x(t + 2τ ), x(t + 3τ ), x(t + 4τ ), x(t + 5τ )) (3.8)
以下，遅れ時差 τについての説明
1 歩行周期は約 1 秒．本研究で扱うデータはサンプリング周波数 60Hz のため，1 歩行周期で約 60 サンプル取得できる．
ML 方向の取得データは状態空間内に 1歩行周期を反映させるためには 5τ ≤ 60 サンプル，すなわち τ ≤ 12 サンプルであることが必要条件
Bizovska ら [38] の研究で，1 歩行周期あたり約 100 点計測時，τ = 8サンプルとしていることを参考に，本研究が 1 歩行周期あたり 60 サンプル計測することを考慮し，τ = 5 とする．

%}

Fs = 60; %周波数
MAX_I_5 = 100; %5mが分析区間の場合のI 100
% max_i_11 = 250; %11mが分析区間の場合のI 250
TAU = 5;  
% 各ファイル名に対してフルパスを作成
ranges = {'A:A', 'B:B', 'C:C', 'V:V', 'AA:AA', 'AI:AI'};  %　AがAP, BがML, CがVT、    
variable_names = ["LyE CoM_(AP)", "LyE CoM(ML)","LyE CoM(VT)", "LyE accel L5(ML)", "LyE accel CoM(ML)", "LyE accel CoM(AP)"];
p1_cell = cell(1, length(variable_names));

for i=1:numel(ranges)
    data_analysis = readmatrix(input_file_name2,'Sheet','時系列データ 5m','Range',ranges{i});  
    data_FFT = readmatrix(input_file_name2,'Sheet','時系列データ 5m','Range','C:C');  %ストライド計算用，zなのでC

    data_analysis = data_analysis(2:end);
    data_analysis = double(data_analysis);
    data_FFT = data_FFT(2:end);
    data_FFT = double(data_FFT);
    peak_f_tab = calculate_period(Fs,data_FFT);
    pf_tab_index = size(peak_f_tab);
    pf_tab_index = pf_tab_index(1);  
    stride = 60.0/peak_f_tab(pf_tab_index,2)*2.0;
    
    Fg = Fs/stride;
    f = figure('Visible','off');
    f.Position = [400 50 600 550];%[left bottom width height]
    
    %% --
    t1 = tiledlayout(3,1);
    ax1 = nexttile;
    N = length(data_analysis);
    plot(ax1,(1:N)/Fs, data_analysis);
    title_name = [variable_names(i),"リアプノフ指数分析"];
    title(t1,title_name);
    t1.Padding = 'compact';
    t1.TileSpacing = 'compact';
    title('Displacement')
    xlabel('t[s]')
    ylabel('displacement[m]')
    %% --

    %% --アトラクタ描画
    ax2 = nexttile;
    N = length(data_analysis);
    X = [data_analysis((1:N - 5*TAU)), data_analysis((1:N - 5*TAU) + TAU), data_analysis((1:N - 5*TAU) + 2*TAU), data_analysis((1:N - 5*TAU) + 3*TAU), data_analysis((1:N - 5*TAU) + 4*TAU), data_analysis((1:N - 5*TAU) + 5*TAU)];
    plot(ax2,X(:,1), X(:,2));
    title(append('Reconstructed attractor',' \tau=',num2str(TAU)));
    xlabel('z(n)[m]')
    ylabel({'z(n+\tau)[m]'})
    %% --

    %% --リアプノフ指数描画
    ax3 = nexttile;
    di1 = rosenstein(data_analysis, TAU, Fs, MAX_I_5, Fg)+0.0000001; %左右で別々で考える場合周波数は2倍する
    log(di1);
    plot(ax3,(1:length(di1)) / stride, log(di1));
    xlabel({'Time (strides)'});
    ylabel('L_n');
    % Fitting a linear approximation
    x1 = 1;
    x2 = round(stride*0.5);
    x2 = min(x2, 100);  % 20250816: 歩行周期が長いとデータ点が100を超えてしまい、p1の近似式の線を引く際エラーが生じたのでこの処理を行う
    p1 = polyfit((x1:x2)/stride, log(di1(x1:x2)), 1);
    h1 = refline(ax3,p1);
    set(h1, 'LineStyle', ':');
    %% --

    title({['Divergence - Average distance between nearest neighbors',' \tau=',num2str(TAU)],['λ=',num2str(p1(1))]});
    exportgraphics(gcf, export_filename, 'Append', true);
    saveas(gcf,fullfile(indiv_figdir, [variable_names{i},'.jpeg']))
    close(gcf);
    p1_cell{i} = p1(1);
end

% 既存のテーブルに新しいデータを結合
new_data_table = cell2table(p1_cell, 'VariableNames',variable_names);
% 更新されたテーブルをファイルに書き込む
writetable(new_data_table, input_file_name2, 'Sheet', '歩容特性', 'Range', 'A3');
disp('リアプノフ指数を入力し,すべての処理が完了しました')

end