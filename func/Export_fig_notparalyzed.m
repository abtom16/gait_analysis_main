function[] = Export_fig_notparalyzed(input_file_name2) 
%%ファイル選択の時はこっち
%input_file_name = "D:\1修士\Xsens_analysis\20241107\Modified_1107asari_halfparalyzed.xlsx";
df = readmatrix(input_file_name2, 'Sheet','時系列データ 11m');
[path, name, ~]=fileparts(input_file_name2);
figure_path = fullfile(path, 'figure');
if ~exist(figure_path, 'dir')
    mkdir(figure_path);
    disp('figureフォルダーがなかったので、作成しました!');
end
name = char(name);  %%文字列にしないと[]がリストになってしまう
export_filename = fullfile(figure_path, ['Figure_',name,'.pdf']);
indiv_figdir = fullfile(figure_path,name);
if ~exist(indiv_figdir,'dir')
    mkdir(indiv_figdir);
    disp([name,'の図のフォルダーを作成しました!']);
end
if exist(export_filename, 'file') == 2
    % ファイルが存在する場合、削除する
    choice = questdlg(...
        {'指定したファイルは既に存在します。削除して新しいファイルを保存しますか？  削除せず図を追加することも可能です', '実行キャンセルは✕ボタン'}, ...
        'ファイルの確認', ...
        '古いファイルを削除', '既存ファイルに図を追加', '古いファイルを削除');

    if isempty(choice)
        % ユーザーが✕ボタンを押した場合の処理
        disp('処理を中止しました。');
        return;
    end
    if strcmp(choice, '古いファイルを削除')
        % ファイルを削除
        delete(export_filename);
        disp('古いファイルを削除して上書き保存します')
    elseif strcmp(choice, '既存ファイルに図を追加')
        disp('既存ファイルに図を追加します');
    end
end


%% --重心軌跡-- %%
CoM_x = df(:,1);
CoM_y = df(:,2);
CoM_z = df(:,3);
Rfoot_x = df(:,13);
Rfoot_y = df(:,15);
Lfoot_x = df(:,14);
Lfoot_y = df(:,16);
RToe_x = df(:,46);
RToe_z = df(:,33);  %　トゥクリアランス
LToe_x = df(:,47);
LToe_z = df(:,34);
Rthigh_x = df(:,36);
Rthigh_z = df(:,37);
Lthigh_x = df(:,41);
Lthigh_z = df(:,42);
start_frame = find(CoM_x > 3, 1, 'first');
end_frame = find(CoM_x > 8, 1, 'first');
gray_black = [0.5, 0.5, 0.5];

% 水平面-重心軌跡 %
figure('Visible', 'off');
ax = axes;
set(ax, 'Position', [0.3, 0.05, 0.4, 0.9]);
bg1 = fill([-0.5,0.5,0.5,-0.5],[0,0,3,3],[0.9,0.9,0.9],'EdgeColor', 'none','FaceAlpha', 0.5,'HandleVisibility','off');hold on;
bg_main = fill([-0.5,0.5,0.5,-0.5],[3,3,8,8], [0,0,1], 'EdgeColor', 'none','FaceAlpha', 0.1,'HandleVisibility','off');hold on;
bg2 = fill([-0.5,0.5,0.5,-0.5],[8,8,11,11],[0.9,0.9,0.9],'EdgeColor', 'none','FaceAlpha', 0.5,'HandleVisibility','off');
uistack(bg1, 'bottom');
uistack(bg_main, 'bottom');
uistack(bg2, 'bottom');

plot(CoM_y(1:start_frame), CoM_x(1:start_frame), '--','Color', gray_black, 'LineWidth',1.2,'HandleVisibility','off');hold on;
plot(CoM_y(start_frame:end_frame), CoM_x(start_frame:end_frame), '-k', 'LineWidth',2,'DisplayName','重心位置');hold on;
plot(CoM_y(end_frame:end), CoM_x(end_frame:end), '--','Color', gray_black, 'LineWidth',1.2,'HandleVisibility','off');hold on;
p1 = plot(Rfoot_y(1:start_frame), Rfoot_x(1:start_frame), '-b','LineWidth',1,'HandleVisibility','off');hold on;
plot(Rfoot_y(start_frame:end_frame), Rfoot_x(start_frame:end_frame), '-b', 'LineWidth',1.2,'DisplayName','右足');hold on;
p2 = plot(Rfoot_y(end_frame:end), Rfoot_x(end_frame:end), '-b', 'LineWidth',1,'HandleVisibility','off');hold on;
p3 = plot(Lfoot_y(1:start_frame), Lfoot_x(1:start_frame), '-g','LineWidth',1,'HandleVisibility','off');hold on;
plot(Lfoot_y(start_frame:end_frame), Lfoot_x(start_frame:end_frame), '-g', 'LineWidth',1.2,'DisplayName','左足');hold on;
p4 = plot(Lfoot_y(end_frame:end), Lfoot_x(end_frame:end), '-g', 'LineWidth',1,'HandleVisibility','off');

p1.Color = [0,0,1,0.2];
p2.Color = [0,0,1,0.2];
p3.Color = [0,1,0,0.2];
p4.Color = [0,1,0,0.2];

legend('Location','Best');
xlim([-0.5,0.5]);
ylim([0,11]);
xlabel('重心位置 左右方向(m)');
ylabel('重心位置 進行方向(m)');
title('水平面　重心移動の軌跡');

yline(3, '--b', '測定開始位置','HandleVisibility','off');
yline(8, '--b', '測定終了位置','HandleVisibility','off');
exportgraphics(gcf, export_filename, 'Append', true);
saveas(gcf,fullfile(indiv_figdir, '重心軌跡水平面.jpeg'))
close(gcf);

% 矢状面-重心軌跡 %
figure('Visible', 'off');
bg1 = fill([0,3,3,0],[0,0,1,1],[0.9,0.9,0.9],'EdgeColor', 'none','FaceAlpha',0.5,'HandleVisibility','off');hold on;
bg_main = fill([3,8,8,3],[0,0,1,1],[0,0,1],'EdgeColor', 'none','FaceAlpha',0.1,'HandleVisibility','off');hold on;
bg2 = fill([8,11,11,8],[0,0,1,1],[0.9,0.9,0.9],'EdgeColor', 'none','FaceAlpha',0.5,'HandleVisibility','off');
uistack(bg1, 'bottom');
uistack(bg_main, 'bottom');
uistack(bg2, 'bottom');

plot(CoM_x(1:start_frame), CoM_z(1:start_frame), '--','Color', gray_black, 'LineWidth',1.2, 'HandleVisibility','off');hold on;
plot(CoM_x(start_frame:end_frame), CoM_z(start_frame:end_frame), '-k', 'LineWidth',2, 'Marker', 'x', 'MarkerIndices',1:60:end_frame-start_frame,'MarkerSize', 8,'DisplayName','重心位置');hold on;
plot(CoM_x(end_frame:end), CoM_z(end_frame:end), '--','Color', gray_black, 'LineWidth',1.2,'HandleVisibility','off');hold on;
p5 = plot(RToe_x(1:start_frame), RToe_z(1:start_frame), '-','Color', gray_black, 'LineWidth',1.2,'HandleVisibility','off');hold on;
plot(RToe_x(start_frame:end_frame), RToe_z(start_frame:end_frame), '-b', 'LineWidth',1.2,'Marker', 'x', 'MarkerIndices',1:60:end_frame-start_frame,'MarkerSize', 8,'DisplayName','右つま先');hold on;
p6 = plot(RToe_x(end_frame:end), RToe_z(end_frame:end), '-','Color', gray_black, 'LineWidth',1.2,'HandleVisibility','off');hold on;
p7 = plot(LToe_x(1:start_frame), LToe_z(1:start_frame), '-','Color', gray_black, 'LineWidth',1.2,'HandleVisibility','off');hold on;
plot(LToe_x(start_frame:end_frame), LToe_z(start_frame:end_frame), '-g', 'LineWidth',1.2,'Marker', 'x', 'MarkerIndices',1:60:end_frame-start_frame,'MarkerSize', 8,'DisplayName','左つま先');hold on;
p8 = plot(LToe_x(end_frame:end), LToe_z(end_frame:end), '-','Color', gray_black, 'LineWidth',1.2,'HandleVisibility','off');


p5.Color = [0,0,1,0.4];
p6.Color = [0,0,1,0.4];
p7.Color = [0,1,0,0.4];
p8.Color = [0,1,0,0.4];


legend('Location','Best');
xlim([0,11]);
ylim([0,1]);
xlabel('重心位置 進行方向(m)');
ylabel('重心位置 上下方向(m)');
title('矢状面　重心移動の軌跡');

xline(3, '--b', '測定開始位置','HandleVisibility','off');
xline(8, '--b', '測定終了位置','HandleVisibility','off');
set(gcf, 'Position', [100, 100, 900, 300]);
exportgraphics(gcf, export_filename, 'Append', true);
saveas(gcf,fullfile(indiv_figdir, '重心軌跡矢状面.jpeg'))
close(gcf);


%% --関節角度計算-- %%
df2 = readmatrix(input_file_name2, 'Sheet','時系列データ 5m');
Rfootcontact = df2(2:end,11);
Lfootcontact = df2(2:end,12);
Rcontact_frame = find([0;diff(Rfootcontact)==1;0]);
Rcontact_end_frame = find([0; diff(Rfootcontact) == -1; 0]);
if Rcontact_end_frame(1) < Rcontact_frame(1)
    Rcontact_end_frame = Rcontact_end_frame(2:end);
end
Lcontact_frame = find([0;diff(Lfootcontact)==1;0]);
Lcontact_end_frame = find([0; diff(Lfootcontact) == -1; 0]);
if Lcontact_end_frame(1) < Lcontact_frame(1)
    Lcontact_end_frame = Lcontact_end_frame(2:end);
end

% すり足対策として、連続する1の数をカウントし、10回未満の接地を除外
min_contact_duration = 20; % 最小連続接地フレーム数
valid_Rcontact_frame = [];
valid_Rcontact_end_frame = [];
for i = 1:length(Rcontact_frame)-1
    if (Rcontact_end_frame(i) - Rcontact_frame(i)) >= min_contact_duration
        valid_Rcontact_frame = [valid_Rcontact_frame, Rcontact_frame(i)];
        valid_Rcontact_end_frame = [valid_Rcontact_end_frame, Rcontact_end_frame(i)];
    end
end
valid_Lcontact_frame = [];
valid_Lcontact_end_frame = [];
for i = 1:length(Lcontact_frame)-1
    if (Lcontact_end_frame(i) - Lcontact_frame(i)) >= min_contact_duration
        valid_Lcontact_frame = [valid_Lcontact_frame, Lcontact_frame(i)];
        valid_Lcontact_end_frame = [valid_Lcontact_end_frame, Lcontact_end_frame(i)];
    end
end

CoM_x_5m = df2(2:end,1);
CoM_z_5m = df2(2:end,3);
CoM_z_5m_mean = mean(CoM_z_5m);
Rknee_angle = df2(2:end,7);
Lknee_angle = df2(2:end,8);
Rankle_angle = df2(2:end,9);
Lankle_angle = df2(2:end,10);
Rhip_abduction = df2(2:end,29); % 外転
Lhip_abduction = df2(2:end,30);
Rhip_rotation = df2(2:end,48);
Lhip_rotation = df2(2:end,50);
Rhip_extension = df2(2:end,49);
Lhip_extension = df2(2:end,51);
L5_ay_5 = df2(2:end,22);


Rtoe_x_5 = df2(2:end,46);
Rtoe_z_5 = df2(2:end,33);  %　トゥクリアランス
Ltoe_x_5 = df2(2:end,47);
Ltoe_z_5 = df2(2:end,34);
Rthigh_x_5 = df2(2:end,36);
Rthigh_z_5 = df2(2:end,37);
Lthigh_x_5 = df2(2:end,41);
Lthigh_z_5 = df2(2:end,42);
Lumber_lateralFlex = df2(2:end, 53);

function plot_joint_angle(export_filename,indiv_figdir,side, angle_data, angle_label, y_lim, direction_max,direction_min,contact_frame)
    % angle_data: 各関節の角度データ
    % joint_name: 関節名 ('足関節' など)
    % angle_label: 関節角度のラベル ('足関節角度(°)' など)
    % y_lim: y軸の範囲
    % x_labels: x軸の目盛りラベル 
    % 図の作成
    figure('Visible', 'off');
    set(gcf,'defaultLegendAutoUpdate','off');
    hold on;
    
    
    bg5 = fill([0,0.6,0.6,0],[y_lim(1),y_lim(1),y_lim(2),y_lim(2)],'b','EdgeColor', 'none','FaceAlpha',0.05,'DisplayName','立脚期');hold on;
    bg6 = fill([0.6,1,1,0.6],[y_lim(1),y_lim(1),y_lim(2),y_lim(2)],[1, 0.5, 0],'EdgeColor', 'none','FaceAlpha',0.05,'DisplayName','遊脚期');
    uistack(bg5, 'bottom');
    uistack(bg6, 'bottom');
    
    uniform_length = 100;
    % 線形補間とプロット
    for j = 1:length(contact_frame)-1
        current_cycle = angle_data(contact_frame(j):contact_frame(j+1));
        original_x = linspace(0, 1, length(current_cycle));
        uniform_x = linspace(0, 1, uniform_length);
        resampled_angles(:, j) = interp1(original_x, current_cycle, uniform_x);
        plot(uniform_x, resampled_angles(:,j), '-k', 'HandleVisibility', 'off');
    end
    
    % 平均線のプロット
    mean_resampled = mean(resampled_angles, 2);
    plot(uniform_x, mean_resampled, '-r', 'DisplayName', '平均', 'LineWidth', 2);
    
    % 凡例設定
    legend('Location','Best');
    
    % 軸ラベル、目盛り設定
    xlabel('歩行周期(%)');
    xticks(0.1:0.1:1); 
    xticklabels(arrayfun(@(v) sprintf('%.0f%%', v*100), xticks, 'UniformOutput', false));
    ylabel([side,'　',angle_label]);
    ylim(y_lim);
    
    % 方向のテキストと矢印
    text(-0.09, max(ylim)-0.1, direction_max, 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'Rotation', 90);
    annotation('arrow', [0.09, 0.09], [0.85, 0.95]);
    text(-0.09, min(ylim), direction_min, 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'Rotation', 90);
    annotation('arrow', [0.09, 0.09], [0.15, 0.05]);
    
    % 地面接触時のライン
    l_x = line(xlim, [0 0], 'LineStyle', '-', 'Color', [0, 0, 0, 0.3], 'LineWidth', 0.7);
    uistack(l_x, "bottom");
    line([0 0], ylim, 'LineStyle', '-', 'Color', [0, 0, 1, 0.2], 'LineWidth', 1);
    text(0.03, max(ylim), '初期接地', 'Rotation', 90,'Color', 'blue', 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
    line([0.1 0.1], ylim, 'LineStyle', '-', 'Color', [0, 0, 1, 0.2], 'LineWidth', 1);
    text(0.13, max(ylim), '反対側離地', 'Rotation', 90,'Color', 'blue', 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
    line([0.3 0.3], ylim, 'LineStyle', '-', 'Color', [0, 0, 1, 0.2], 'LineWidth', 1);
    text(0.33, max(ylim), '踵離地', 'Rotation', 90,'Color', 'blue', 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
    line([0.5 0.5], ylim, 'LineStyle', '-', 'Color', [0, 0, 1, 0.2], 'LineWidth', 1);
    text(0.53, max(ylim), '両脚支持', 'Rotation', 90, 'Color', 'blue', 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
    line([0.6 0.6], ylim, 'LineStyle', '-', 'Color', [0, 0, 1, 0.2], 'LineWidth', 1);
    text(0.63, max(ylim), 'つま先離地', 'Rotation', 90,'Color', 'blue', 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
    line([0.85 0.85], ylim, 'LineStyle', '-', 'Color', [0, 0, 1, 0.2], 'LineWidth', 1);
    text(0.83, max(ylim), '下腿垂直', 'Rotation', 90, 'Color', 'blue', 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
    % グラフを保存
    angle_label_export = regexprep(angle_label, '\[.*?\]', '');
    exportgraphics(gcf, export_filename, 'Append', true);
    saveas(gcf, fullfile(indiv_figdir, [side, angle_label_export, '.jpeg']));
    close(gcf);
end
function Rplot_joint_angle_adjcycle(export_filename, indiv_figdir, angle_data, angle_label, y_lim, direction_max,direction_min, valid_Rcontact_frame)
    % angle_data: 各関節の角度データ
    % joint_name: 関節名 ('足関節' など)
    % angle_label: 関節角度のラベル ('足関節角度(°)' など)
    % y_lim: y軸の範囲
    % x_labels: x軸の目盛りラベル
    
    % 図の作成
    figure('Visible', 'off');
    
    xwidth = (valid_Rcontact_frame(2)-valid_Rcontact_frame(1)) * 20;
    set(gcf,'defaultLegendAutoUpdate','off',"Position", [100,100,xwidth,400]);
    hold on;
    bg7 = fill([0,0.6,0.6,0],[y_lim(1),y_lim(1),y_lim(2),y_lim(2)],'b','EdgeColor', 'none','FaceAlpha',0.05,'DisplayName','立脚期');hold on;
    bg8 = fill([0.6,1,1,0.6],[y_lim(1),y_lim(1),y_lim(2),y_lim(2)],[1, 0.5, 0],'EdgeColor', 'none','FaceAlpha',0.05,'DisplayName','遊脚期');
    uistack(bg7, 'bottom');
    uistack(bg8, 'bottom');

    uniform_length = 100;
    % 線形補間とプロット
    for j = 1:length(valid_Rcontact_frame)-1
        current_cycle = angle_data(valid_Rcontact_frame(j):valid_Rcontact_frame(j+1));
        original_x = linspace(0, 1, length(current_cycle));
        uniform_x = linspace(0, 1, uniform_length);
        resampled_angles(:, j) = interp1(original_x, current_cycle, uniform_x);
        plot(uniform_x, resampled_angles(:,j), '-k', 'HandleVisibility', 'off');
    end
    
    % 平均線のプロット
    mean_resampled = mean(resampled_angles, 2);
    plot(uniform_x, mean_resampled, '-r', 'DisplayName', '平均', 'LineWidth', 2);
    
    % 凡例設定
    legend('Location','Best');
    
    % 軸ラベル、目盛り設定
    xlabel('歩行周期(%)');
    xticks(0.1:0.1:1); 
    xticklabels(arrayfun(@(v) sprintf('%.0f%%', v*100), xticks, 'UniformOutput', false));
    ylabel(['右　',angle_label]);
    ylim(y_lim);
    
    % 方向のテキストと矢印
    text(-0.09, max(ylim)-0.1, direction_max, 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'Rotation', 90);
    annotation('arrow', [0.09, 0.09], [0.85, 0.95]);
    text(-0.09, min(ylim), direction_min, 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'Rotation', 90);
    annotation('arrow', [0.09, 0.09], [0.15, 0.05]);
    
    % 地面接触時のライン
    l_x = line(xlim, [0 0], 'LineStyle', '-', 'Color', [0, 0, 0, 0.3], 'LineWidth', 0.7);
    uistack(l_x, "bottom");
    line([0 0], ylim, 'LineStyle', '-', 'Color', [0, 0, 1, 0.2], 'LineWidth', 1);
    text(0.03, max(ylim), '初期接地', 'Rotation', 90,'Color', 'blue', 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
    line([0.1 0.1], ylim, 'LineStyle', '-', 'Color', [0, 0, 1, 0.2], 'LineWidth', 1);
    text(0.13, max(ylim), '反対側離地', 'Rotation', 90,'Color', 'blue', 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
    line([0.3 0.3], ylim, 'LineStyle', '-', 'Color', [0, 0, 1, 0.2], 'LineWidth', 1);
    text(0.33, max(ylim), '踵離地', 'Rotation', 90,'Color', 'blue', 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
    line([0.5 0.5], ylim, 'LineStyle', '-', 'Color', [0, 0, 1, 0.2], 'LineWidth', 1);
    text(0.53, max(ylim), '両脚支持', 'Rotation', 90, 'Color', 'blue', 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
    line([0.6 0.6], ylim, 'LineStyle', '-', 'Color', [0, 0, 1, 0.2], 'LineWidth', 1);
    text(0.63, max(ylim), 'つま先離地', 'Rotation', 90,'Color', 'blue', 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
    line([0.85 0.85], ylim, 'LineStyle', '-', 'Color', [0, 0, 1, 0.2], 'LineWidth', 1);
    text(0.83, max(ylim), '下腿垂直', 'Rotation', 90, 'Color', 'blue', 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
    
    % グラフを保存
    if strcmp(angle_label, 'L5左右方向の加速度 [m/s^2]')
        angle_label_export = 'L5左右方向の加速度';
    else
        angle_label_export = angle_label;
    end
    exportgraphics(gcf, export_filename, 'Append', true);
    saveas(gcf, fullfile(indiv_figdir, ['右', angle_label_export, '_歩行周期調整.jpeg']));
    close(gcf);
end
function compare_joint_angle(export_filename, indiv_figdir, Rangle_data, Langle_data, angle_label, y_lim, direction_max,direction_min,Rcontact_frame, Lcontact_frame)
    % angle_data: 各関節の角度データ
    % joint_name: 関節名 ('足関節' など)
    % angle_label: 関節角度のラベル ('足関節角度(°)' など)
    % y_lim: y軸の範囲
    % x_labels: x軸の目盛りラベル
    
    % 図の作成
    figure('Visible','off');
    set(gcf,'defaultLegendAutoUpdate','off');
    hold on;
    bg9 = fill([0,0.6,0.6,0],[y_lim(1),y_lim(1),y_lim(2),y_lim(2)],'b','EdgeColor', 'none','FaceAlpha',0.05,'DisplayName','立脚期');hold on;
    bg10 = fill([0.6,1,1,0.6],[y_lim(1),y_lim(1),y_lim(2),y_lim(2)],[1, 0.5, 0],'EdgeColor', 'none','FaceAlpha',0.05,'DisplayName','遊脚期');
    uistack(bg9, 'bottom');
    uistack(bg10, 'bottom');
    uniform_length = 100;
    % 線形補間とプロット
    for i = 1:length(Rcontact_frame)-1
        Rcurrent_cycle = Rangle_data(Rcontact_frame(i):Rcontact_frame(i+1));
        Roriginal_x = linspace(0, 1, length(Rcurrent_cycle));
        Runiform_x = linspace(0, 1, uniform_length);
        Rresampled_angles(:, i) = interp1(Roriginal_x, Rcurrent_cycle, Runiform_x);
        % plot(Runiform_x, Rresampled_angles(:,i), '-k', 'HandleVisibility', 'off');
    end
    for i = 1:length(Lcontact_frame)-1
        Lcurrent_cycle = Langle_data(Lcontact_frame(i):Lcontact_frame(i+1));
        Loriginal_x = linspace(0, 1, length(Lcurrent_cycle));
        Luniform_x = linspace(0, 1, uniform_length);
        Lresampled_angles(:, i) = interp1(Loriginal_x, Lcurrent_cycle, Luniform_x);
        % plot(Luniform_x, Lresampled_angles(:,i), '-k', 'HandleVisibility', 'off');
    end
    right_label = '右平均';
    left_label = '左平均';
    % 平均線のプロット
    Rmean_resampled = mean(Rresampled_angles, 2);
    plot(Runiform_x, Rmean_resampled, '-', 'Color',[1, 0.5, 0], 'DisplayName', right_label, 'LineWidth', 2);hold on;
    Lmean_resampled = mean(Lresampled_angles, 2);
    plot(Luniform_x, Lmean_resampled, '-b', 'DisplayName', left_label, 'LineWidth', 2); hold on;
    
    % 凡例設定
    legend('Location', 'Best');
    
    % 軸ラベル、目盛り設定
    xlabel('歩行周期(%)');
    xticks(0.1:0.1:1); 
    xticklabels(arrayfun(@(v) sprintf('%.0f%%', v*100), xticks, 'UniformOutput', false));
    ylabel(angle_label);
    ylim(y_lim);
    
    % 方向のテキストと矢印
    text(-0.09, max(ylim)-0.1, direction_max, 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'Rotation', 90);
    annotation('arrow', [0.09, 0.09], [0.85, 0.95]);
    text(-0.09, min(ylim), direction_min, 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'Rotation', 90);
    annotation('arrow', [0.09, 0.09], [0.15, 0.05]);
    
    % 地面接触時のライン
    l_x = line(xlim, [0 0], 'LineStyle', '-', 'Color', [0, 0, 0, 0.3], 'LineWidth', 0.7);
    uistack(l_x, "bottom");
    line([0 0], ylim, 'LineStyle', '-', 'Color', [0, 0, 1, 0.2], 'LineWidth', 1);
    text(0.03, max(ylim), '初期接地', 'Rotation', 90,'Color', 'blue', 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
    line([0.1 0.1], ylim, 'LineStyle', '-', 'Color', [0, 0, 1, 0.2], 'LineWidth', 1);
    text(0.13, max(ylim), '反対側離地', 'Rotation', 90,'Color', 'blue', 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
    line([0.3 0.3], ylim, 'LineStyle', '-', 'Color', [0, 0, 1, 0.2], 'LineWidth', 1);
    text(0.33, max(ylim), '踵離地', 'Rotation', 90,'Color', 'blue', 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
    line([0.5 0.5], ylim, 'LineStyle', '-', 'Color', [0, 0, 1, 0.2], 'LineWidth', 1);
    text(0.53, max(ylim), '両脚支持', 'Rotation', 90, 'Color', 'blue', 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
    line([0.6 0.6], ylim, 'LineStyle', '-', 'Color', [0, 0, 1, 0.2], 'LineWidth', 1);
    text(0.63, max(ylim), 'つま先離地', 'Rotation', 90,'Color', 'blue', 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
    line([0.85 0.85], ylim, 'LineStyle', '-', 'Color', [0, 0, 1, 0.2], 'LineWidth', 1);
    text(0.83, max(ylim), '下腿垂直', 'Rotation', 90, 'Color', 'blue', 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
    
    % グラフを保存
    exportgraphics(gcf, export_filename, 'Append', true);
    saveas(gcf, fullfile(indiv_figdir, ['左右比較', angle_label, '.jpeg']));
    close(gcf);
end

function compare_joint_angle_addsomething_Rfootcontact(export_filename, indiv_figdir, Rangle_data, Langle_data, something_z,angle_label, y_lim, direction_max,direction_min,Rcontact_frame,comparing_label)
    % 元々はCOMの高さの変位と比較を行いたかったのでcomとなっていま
    
    % 図の作成
    uniform_length = 100;
    % 線形補間とプロット
    for i = 1:length(Rcontact_frame)-1
        Rcurrent_cycle = Rangle_data(Rcontact_frame(i):Rcontact_frame(i+1));
        Lcurrent_cycle = Langle_data(Rcontact_frame(i):Rcontact_frame(i+1));
        something_current_cycle = something_z(Rcontact_frame(i):Rcontact_frame(i+1));

        Roriginal_x = linspace(0, 1, length(Rcurrent_cycle));
        Runiform_x = linspace(0, 1, uniform_length);
        Rresampled_angles(:, i) = interp1(Roriginal_x, Rcurrent_cycle, Runiform_x);
        something_resampled(:, i) = interp1(Roriginal_x, something_current_cycle, Runiform_x);
        Lresampled_angles(:, i) = interp1(Roriginal_x, Lcurrent_cycle, Runiform_x);
    end
    figure('Position',[100,100,560,560],'Visible','off');
    subplot(3,1,1);
    
    something_mean_resampled = mean(something_resampled, 2);
    mean_for_ylim = mean(something_mean_resampled);
    range_ofylim = max(something_mean_resampled) - min(something_mean_resampled);
    cm_range_ofylim = 100 * range_ofylim;
    min_ofylim = mean_for_ylim - 0.5*range_ofylim - 0.005;
    max_ofylim = mean_for_ylim + 0.5*range_ofylim + 0.005;

    title_name = ['高さ移動範囲 : ',num2str(cm_range_ofylim), 'cm'];
    bga = fill([0,0.1,0.1,0],[min_ofylim,min_ofylim,max_ofylim,max_ofylim],'b','EdgeColor', 'none','FaceAlpha',0.05,'DisplayName','両脚支持期');hold on;
    bgb = fill([0.5,0.6,0.6,0.5],[min_ofylim,min_ofylim,max_ofylim,max_ofylim],'b','EdgeColor', 'none','FaceAlpha',0.05,'DisplayName','両脚支持期');
    uistack(bga, 'bottom');
    uistack(bgb, 'bottom');
    name_plot = [comparing_label,' 高さ'];
    plot(Runiform_x, something_mean_resampled, '-k','DisplayName', name_plot, 'LineWidth',2);

    xticks(0.1:0.1:1); 
    xticklabels(arrayfun(@(v) sprintf('%.0f%%', v*100), xticks, 'UniformOutput', false));
    title(title_name);
    ylim([min_ofylim, max_ofylim]);
    ylabel(comparing_label);
    legend('Location','best');

    subplot(3,1,[2,3]);
    set(gcf,'defaultLegendAutoUpdate','off');
    hold on;
    bg9 = fill([0,0.6,0.6,0],[y_lim(1),y_lim(1),y_lim(2),y_lim(2)],'b','EdgeColor', 'none','FaceAlpha',0.05,'DisplayName','立脚期');hold on;
    bg10 = fill([0.6,1,1,0.6],[y_lim(1),y_lim(1),y_lim(2),y_lim(2)],[1, 0.5, 0],'EdgeColor', 'none','FaceAlpha',0.05,'DisplayName','遊脚期');
    uistack(bg9, 'bottom');
    uistack(bg10, 'bottom');

    right_label = '右平均';
    left_label = '左平均';

    % 平均線のプロット
    
    Rmean_resampled = mean(Rresampled_angles, 2);
    plot(Runiform_x, Rmean_resampled, '-', 'Color',[1, 0.5, 0], 'DisplayName', right_label, 'LineWidth', 2); hold on;
    Lmean_resampled = mean(Lresampled_angles, 2);
    plot(Runiform_x, Lmean_resampled, '-b', 'DisplayName', left_label, 'LineWidth', 2); hold on;
    
    % 軸ラベル、目盛り設定
    xlabel('歩行周期(%)');
    xticks(0.1:0.1:1); 
    xticklabels(arrayfun(@(v) sprintf('%.0f%%', v*100), xticks, 'UniformOutput', false));
    ylabel(angle_label);
    ylim(y_lim);

    % 凡例設定
    legend('Location', 'Best');  
    
    % 方向のテキストと矢印
    text(-0.09, max(ylim)-0.2, direction_max, 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'Rotation', 90);
    annotation('arrow', [0.09, 0.09], [0.56, 0.66]);
    text(-0.09, min(ylim), direction_min, 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'Rotation', 90);
    annotation('arrow', [0.09, 0.09], [0.15, 0.05]);
    
    % 地面接触時のライン
    l_x = line(xlim, [0 0], 'LineStyle', '-', 'Color', [0, 0, 0, 0.3], 'LineWidth', 0.7);
    uistack(l_x, "bottom");
    line([0 0], ylim, 'LineStyle', '-', 'Color', [1, 0.5, 0, 0.2], 'LineWidth', 1);
    text(0.03, max(ylim), '右脚:初期接地', 'Rotation', 90,'Color', [1,0.5,0], 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
    line([0.1 0.1], ylim, 'LineStyle', '-', 'Color', [0, 0, 1, 0.2], 'LineWidth', 1);
    text(0.13, max(ylim), '左脚:反対側離地', 'Rotation', 90,'Color', 'blue', 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
    line([0.3 0.3], ylim, 'LineStyle', '-', 'Color', [1, 0.5, 0, 0.2], 'LineWidth', 1);
    text(0.33, max(ylim), '右脚:踵離地', 'Rotation', 90,'Color', [1,0.5,0], 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
    line([0.5 0.5], ylim, 'LineStyle', '-', 'Color', [0, 0, 1, 0.2], 'LineWidth', 1);
    text(0.53, max(ylim), '両脚支持', 'Rotation', 90, 'Color', 'blue', 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
    line([0.6 0.6], ylim, 'LineStyle', '-', 'Color', [1, 0.5, 0, 0.2], 'LineWidth', 1);
    text(0.63, max(ylim), '右脚:つま先離地', 'Rotation', 90,'Color', [1, 0.5, 0], 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
    line([0.85 0.85], ylim, 'LineStyle', '-', 'Color', [1, 0.5, 0, 0.2], 'LineWidth', 1);
    text(0.83, max(ylim), '右脚：下腿垂直', 'Rotation', 90, 'Color', [1, 0.5, 0], 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');

    exportgraphics(gcf, export_filename, 'Append', true);
    saveas(gcf, fullfile(indiv_figdir, ['左右比較_', angle_label,'_',comparing_label, 'あり_右脚接地基準', '.jpeg']));
    close(gcf);
end
function compare_joint_angle_addsomething(export_filename, indiv_figdir, Rangle_data, Langle_data, something_z,something_side,angle_label, y_lim, direction_max,direction_min,Rcontact_frame,Lcontact_frame,comparing_label)
    % 元々はCOMの高さの変位と比較を行いたかったのでcomとなっていま
    
    % 図の作成
    uniform_length = 100;
    % 線形補間とプロット
    for i = 1:length(Rcontact_frame)-1
        Rcurrent_cycle = Rangle_data(Rcontact_frame(i):Rcontact_frame(i+1));
        Roriginal_x = linspace(0, 1, length(Rcurrent_cycle));
        Runiform_x = linspace(0, 1, uniform_length);
        Rresampled_angles(:, i) = interp1(Roriginal_x, Rcurrent_cycle, Runiform_x);
    end
    for i = 1:length(Lcontact_frame)-1
        Lcurrent_cycle = Langle_data(Lcontact_frame(i):Lcontact_frame(i+1));
        Loriginal_x = linspace(0, 1, length(Lcurrent_cycle));
        Luniform_x = linspace(0, 1, uniform_length);
        Lresampled_angles(:, i) = interp1(Loriginal_x, Lcurrent_cycle, Luniform_x);
        % plot(Luniform_x, Lresampled_angles(:,i), '-k', 'HandleVisibility', 'off');
    end
    if strcmp(something_side, '左')
        for i = 1:length(Lcontact_frame)-1
        something_current_cycle = something_z(Lcontact_frame(i):Lcontact_frame(i+1));
        some_original_x = linspace(0,1,length(something_current_cycle));
        some_uniform_x = linspace(0,1,uniform_length);
        something_resampled(:, i) = interp1(some_original_x, something_current_cycle, some_uniform_x);
        end
    else
        for i = 1:length(Rcontact_frame)-1
        something_current_cycle = something_z(Rcontact_frame(i):Rcontact_frame(i+1));
        some_original_x = linspace(0,1,length(something_current_cycle));
        some_uniform_x = linspace(0,1,uniform_length);
        something_resampled(:, i) = interp1(some_original_x, something_current_cycle, some_uniform_x);
        end
    end


    figure('Position',[100,100,560,560],'Visible','off');
    subplot(3,1,1);
    
    something_mean_resampled = mean(something_resampled, 2);
    mean_for_ylim = mean(something_mean_resampled);
    range_ofylim = max(something_mean_resampled) - min(something_mean_resampled);
    cm_range_ofylim = 100 * range_ofylim;
    min_ofylim = mean_for_ylim - 0.5*range_ofylim - 0.005;
    max_ofylim = mean_for_ylim + 0.5*range_ofylim + 0.005;

    title_name = ['高さ移動範囲 : ',num2str(cm_range_ofylim), 'cm'];
    bga = fill([0,0.1,0.1,0],[min_ofylim,min_ofylim,max_ofylim,max_ofylim],'b','EdgeColor', 'none','FaceAlpha',0.05,'DisplayName','両脚支持期');hold on;
    bgb = fill([0.5,0.6,0.6,0.5],[min_ofylim,min_ofylim,max_ofylim,max_ofylim],'b','EdgeColor', 'none','FaceAlpha',0.05,'DisplayName','両脚支持期');
    uistack(bga, 'bottom');
    uistack(bgb, 'bottom');
    name_plot = [comparing_label,' 高さ'];
    plot(Runiform_x, something_mean_resampled, '-k','DisplayName', name_plot, 'LineWidth',2);

    xticks(0.1:0.1:1);
    xticklabels(arrayfun(@(v) sprintf('%.0f%%', v*100), xticks, 'UniformOutput', false));
    title(title_name);
    ylim([min_ofylim, max_ofylim]);
    ylabel(comparing_label);
    legend('Location','best');

    subplot(3,1,[2,3]);
    set(gcf,'defaultLegendAutoUpdate','off');
    hold on;
    bg9 = fill([0,0.6,0.6,0],[y_lim(1),y_lim(1),y_lim(2),y_lim(2)],'b','EdgeColor', 'none','FaceAlpha',0.05,'DisplayName','立脚期');hold on;
    bg10 = fill([0.6,1,1,0.6],[y_lim(1),y_lim(1),y_lim(2),y_lim(2)],[1, 0.5, 0],'EdgeColor', 'none','FaceAlpha',0.05,'DisplayName','遊脚期');
    uistack(bg9, 'bottom');
    uistack(bg10, 'bottom');

    % 平均線のプロット
    right_label = '右平均';
    left_label = '左平均';

    Rmean_resampled = mean(Rresampled_angles, 2);
    plot(Runiform_x, Rmean_resampled, '-', 'Color',[1, 0.5, 0], 'DisplayName', right_label, 'LineWidth', 2); hold on;
    Lmean_resampled = mean(Lresampled_angles, 2);
    plot(Runiform_x, Lmean_resampled, '-b', 'DisplayName', left_label, 'LineWidth', 2); hold on;
    
    % 軸ラベル、目盛り設定
    xlabel('歩行周期(%)');
    xticks(0.1:0.1:1); 
    xticklabels(arrayfun(@(v) sprintf('%.0f%%', v*100), xticks, 'UniformOutput', false));
    ylabel(angle_label);
    ylim(y_lim);

    % 凡例設定
    legend('Location', 'Best');  
    
    % 方向のテキストと矢印
    text(-0.09, max(ylim)-0.2, direction_max, 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'Rotation', 90);
    annotation('arrow', [0.09, 0.09], [0.56, 0.66]);
    text(-0.09, min(ylim), direction_min, 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'Rotation', 90);
    annotation('arrow', [0.09, 0.09], [0.15, 0.05]);
    
    % 地面接触時のライン
    l_x = line(xlim, [0 0], 'LineStyle', '-', 'Color', [0, 0, 0, 0.3], 'LineWidth', 0.7);
    uistack(l_x, "bottom");
    line([0 0], ylim, 'LineStyle', '-', 'Color', [1, 0.5, 0, 0.2], 'LineWidth', 1);
    text(0.03, max(ylim), '右脚:初期接地', 'Rotation', 90,'Color', [1,0.5,0], 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
    line([0.1 0.1], ylim, 'LineStyle', '-', 'Color', [0, 0, 1, 0.2], 'LineWidth', 1);
    text(0.13, max(ylim), '左脚:反対側離地', 'Rotation', 90,'Color', 'blue', 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
    line([0.3 0.3], ylim, 'LineStyle', '-', 'Color', [1, 0.5, 0, 0.2], 'LineWidth', 1);
    text(0.33, max(ylim), '右脚:踵離地', 'Rotation', 90,'Color', [1,0.5,0], 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
    line([0.5 0.5], ylim, 'LineStyle', '-', 'Color', [0, 0, 1, 0.2], 'LineWidth', 1);
    text(0.53, max(ylim), '両脚支持', 'Rotation', 90, 'Color', 'blue', 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
    line([0.6 0.6], ylim, 'LineStyle', '-', 'Color', [1, 0.5, 0, 0.2], 'LineWidth', 1);
    text(0.63, max(ylim), '右脚:つま先離地', 'Rotation', 90,'Color', [1, 0.5, 0], 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
    line([0.85 0.85], ylim, 'LineStyle', '-', 'Color', [1, 0.5, 0, 0.2], 'LineWidth', 1);
    text(0.83, max(ylim), '右脚：下腿垂直', 'Rotation', 90, 'Color', [1, 0.5, 0], 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');

    exportgraphics(gcf, export_filename, 'Append', true);
    saveas(gcf, fullfile(indiv_figdir, ['左右比較_', angle_label,'_',comparing_label, 'あり', '.jpeg']));
    close(gcf);
end

function traject(export_filename, indiv_figdir,angle_x, angle_z, joint_name, x_lim, y_lim, CoM_x_5m, CoM_z_5m_mean, contact_frame, contact_end_frame)
    figure('Visible','off');
    for i = 1:length(contact_frame)-1
        % 関節位置と重心位置のデータ取得
        z_trajectory_stance = angle_z(contact_frame(i):contact_end_frame(i));
        x_trajectory_stance = angle_x(contact_frame(i):contact_end_frame(i));
        z_trajectory_swing = angle_z(contact_end_frame(i):contact_frame(i+1));
        x_trajectory_swing = angle_x(contact_end_frame(i):contact_frame(i+1));
        
        CoM_x_div_stance = CoM_x_5m(contact_frame(i):contact_end_frame(i));
        CoM_x_div_swing = CoM_x_5m(contact_end_frame(i):contact_frame(i+1));
        if i==1
            plot(x_trajectory_stance(1)-CoM_x_div_stance(1)-3, z_trajectory_stance(1),'Marker','o','DisplayName','初期値'); hold on;
            plot(0, CoM_z_5m_mean, 'k.','MarkerSize', 20,'DisplayName','重心位置'); hold on;
        end
        x_trajectory_stance_adj = x_trajectory_stance - CoM_x_div_stance;
        plot(x_trajectory_stance_adj, z_trajectory_stance, 'Color', [1,0.5,0],'HandleVisibility','off'); hold on;
        x_trajectory_swing_adj = x_trajectory_swing - CoM_x_div_swing;
        plot(x_trajectory_swing_adj, z_trajectory_swing, 'Color', [0,0,1], 'HandleVisibility','off');hold on;
        legend;
        % ラベル設定
        xlim(x_lim);
        ylim(y_lim);
        xlabel("重心位置に対する"+joint_name+"の位置　前後方向");
        ylabel('地面からの高さ m');
    end
    exportgraphics(gcf, export_filename, 'Append', true);
    saveas(gcf, fullfile(indiv_figdir, ['軌跡_', joint_name, '.jpeg']));
    close(gcf);
end    
function compared_traject(export_filename, indiv_figdir,Rangle_x, Rangle_z, Langle_x, Langle_z, joint_name, x_lim, y_lim, CoM_x_5m, CoM_z_5m_mean, Rcontact_frame, Rcontact_end_frame, Lcontact_frame, Lcontact_end_frame)
    % 定義: 補間後の統一データ点数
    unified_length = 100;
    x_R_stance_interp = [];
    z_R_stance_interp = [];
    x_L_stance_interp = [];
    z_L_stance_interp = [];
    
    figure('Visible','off');
    hold on;
    
    % 右脚立脚期の軌道を処理
    for i = 1:length(Rcontact_frame)-1
        z_Rtrajectory_stance = Rangle_z(Rcontact_frame(i):Rcontact_end_frame(i));
        x_Rtrajectory_stance = Rangle_x(Rcontact_frame(i):Rcontact_end_frame(i));
        RCoM_x_div_stance = CoM_x_5m(Rcontact_frame(i):Rcontact_end_frame(i));
        
        % 軌道補正
        x_Rtrajectory_stance_adj = x_Rtrajectory_stance - RCoM_x_div_stance;
        
        % 線形補間
        lin_space = linspace(1, length(x_Rtrajectory_stance_adj), unified_length);
        x_R_stance_interp(:, i) = interp1(1:length(x_Rtrajectory_stance_adj), x_Rtrajectory_stance_adj, lin_space, 'linear');
        z_R_stance_interp(:, i) = interp1(1:length(z_Rtrajectory_stance), z_Rtrajectory_stance, lin_space, 'linear');
    end
    % 右脚遊脚期の軌道を処理
    for i = 1:length(Rcontact_frame)-1
        z_Rtrajectory_swing = Rangle_z(Rcontact_end_frame(i):Rcontact_frame(i+1));
        x_Rtrajectory_swing = Rangle_x(Rcontact_end_frame(i):Rcontact_frame(i+1));
        RCoM_x_div_swing = CoM_x_5m(Rcontact_end_frame(i):Rcontact_frame(i+1));
        
        % 軌道補正
        x_Rtrajectory_swing_adj = x_Rtrajectory_swing - RCoM_x_div_swing;
        
        % 線形補間
        lin_space = linspace(1, length(x_Rtrajectory_swing_adj), unified_length);
        x_R_swing_interp(:, i) = interp1(1:length(x_Rtrajectory_swing_adj), x_Rtrajectory_swing_adj, lin_space, 'linear');
        z_R_swing_interp(:, i) = interp1(1:length(z_Rtrajectory_swing), z_Rtrajectory_swing, lin_space, 'linear');
    end
    
    % 左脚の軌道を処理
    for i = 1:length(Lcontact_frame)-1
        z_Ltrajectory_stance = Langle_z(Lcontact_frame(i):Lcontact_end_frame(i));
        x_Ltrajectory_stance = Langle_x(Lcontact_frame(i):Lcontact_end_frame(i));
        LCoM_x_div_stance = CoM_x_5m(Lcontact_frame(i):Lcontact_end_frame(i));
        
        % 軌道補正
        x_Ltrajectory_stance_adj = x_Ltrajectory_stance - LCoM_x_div_stance;
        
        % 線形補間
        lin_space = linspace(1, length(x_Ltrajectory_stance_adj), unified_length);
        x_L_stance_interp(:, i) = interp1(1:length(x_Ltrajectory_stance_adj), x_Ltrajectory_stance_adj, lin_space, 'linear');
        z_L_stance_interp(:, i) = interp1(1:length(z_Ltrajectory_stance), z_Ltrajectory_stance, lin_space, 'linear');
    end
    for i = 1:length(Lcontact_frame)-1
        z_Ltrajectory_swing = Langle_z(Lcontact_end_frame(i):Lcontact_frame(i+1));
        x_Ltrajectory_swing = Langle_x(Lcontact_end_frame(i):Lcontact_frame(i+1));
        LCoM_x_div_swing = CoM_x_5m(Lcontact_end_frame(i):Lcontact_frame(i+1));
        
        % 軌道補正
        x_Ltrajectory_swing_adj = x_Ltrajectory_swing - LCoM_x_div_swing;
        
        % 線形補間
        lin_space = linspace(1, length(x_Ltrajectory_swing_adj), unified_length);
        x_L_swing_interp(:, i) = interp1(1:length(x_Ltrajectory_swing_adj), x_Ltrajectory_swing_adj, lin_space, 'linear');
        z_L_swing_interp(:, i) = interp1(1:length(z_Ltrajectory_swing), z_Ltrajectory_swing, lin_space, 'linear');
    end

    % 平均軌道を計算
    mean_x_Rstance = mean(x_R_stance_interp, 2, 'omitnan');
    mean_z_Rstance = mean(z_R_stance_interp, 2, 'omitnan');
    mean_x_Rswing = mean(x_R_swing_interp, 2, 'omitnan');
    mean_z_Rswing = mean(z_R_swing_interp, 2, 'omitnan');
    mean_x_Lstance = mean(x_L_stance_interp, 2, 'omitnan');
    mean_z_Lstance = mean(z_L_stance_interp, 2, 'omitnan');
    mean_x_Lswing = mean(x_L_swing_interp, 2, 'omitnan');
    mean_z_Lswing = mean(z_L_swing_interp, 2, 'omitnan');

    % 軌道のプロット
    plot(mean_x_Rstance, mean_z_Rstance, '-','Color', [1,0,0], 'Marker', 'x','MarkerIndices', 1:20:100,'MarkerSize',8,'LineWidth', 1, 'DisplayName', '右脚:立脚期　平均軌道');hold on;
    plot(mean_x_Rswing, mean_z_Rswing, '-','Color', [1,0.5,0], 'Marker', 'x','MarkerIndices', 1:20:100,'MarkerSize',8,'LineWidth', 1, 'DisplayName', '右脚:遊脚期　平均軌道');hold on;
    plot(mean_x_Lstance, mean_z_Lstance, '-', 'Color', [0,0,1], 'Marker', '^','MarkerIndices', 1:20:100,'MarkerSize',3, 'LineWidth', 1, 'DisplayName', '左脚:立脚期　平均軌道');hold on;
    plot(mean_x_Lswing, mean_z_Lswing, '-', 'Color', [0,0.5,1], 'Marker', '^','MarkerIndices', 1:20:100,'MarkerSize',3,'LineWidth', 1, 'DisplayName', '左脚:遊脚期　平均軌道');hold on;

    % 重心位置をプロット
    plot(0, CoM_z_5m_mean, 'k.', 'MarkerSize', 20, 'DisplayName', '重心位置');
    
    % グラフ設定
    legend;
    xlim(x_lim);
    ylim(y_lim);
    xlabel("重心位置に対する" + joint_name + "の位置 前後方向");
    ylabel('地面からの高さ m');
    title("左右脚の比較 - " + joint_name);

    exportgraphics(gcf, export_filename, 'Append', true);
    saveas(gcf, fullfile(indiv_figdir, ['左右比較_', joint_name, '.jpeg']));
    close(gcf);
end
function compared_traject_onlyswing(export_filename, indiv_figdir,Rangle_x, Rangle_z, Langle_x, Langle_z, joint_name, x_lim, y_lim, CoM_x_5m, CoM_z_5m_mean, Rcontact_frame, Rcontact_end_frame, Lcontact_frame, Lcontact_end_frame)
    % 定義: 補間後の統一データ点数
    unified_length = 100;
    x_R_swing_interp = [];
    z_R_swing_interp = [];
    x_L_swing_interp = [];
    z_L_swing_interp = [];
    
    figure('Visible','off');
    hold on;
    % 右脚遊脚期の軌道を処理
    for i = 1:length(Rcontact_frame)-1
        z_Rtrajectory_swing = Rangle_z(Rcontact_end_frame(i):Rcontact_frame(i+1));
        x_Rtrajectory_swing = Rangle_x(Rcontact_end_frame(i):Rcontact_frame(i+1));
        RCoM_x_div_swing = CoM_x_5m(Rcontact_end_frame(i):Rcontact_frame(i+1));
        
        % 軌道補正
        x_Rtrajectory_swing_adj = x_Rtrajectory_swing - RCoM_x_div_swing;
        
        % 線形補間
        lin_space = linspace(1, length(x_Rtrajectory_swing_adj), unified_length);
        x_R_swing_interp(:, i) = interp1(1:length(x_Rtrajectory_swing_adj), x_Rtrajectory_swing_adj, lin_space, 'linear');
        z_R_swing_interp(:, i) = interp1(1:length(z_Rtrajectory_swing), z_Rtrajectory_swing, lin_space, 'linear');
    end
    
    for i = 1:length(Lcontact_frame)-1
        z_Ltrajectory_swing = Langle_z(Lcontact_end_frame(i):Lcontact_frame(i+1));
        x_Ltrajectory_swing = Langle_x(Lcontact_end_frame(i):Lcontact_frame(i+1));
        LCoM_x_div_swing = CoM_x_5m(Lcontact_end_frame(i):Lcontact_frame(i+1));
        
        % 軌道補正
        x_Ltrajectory_swing_adj = x_Ltrajectory_swing - LCoM_x_div_swing;
        
        % 線形補間
        lin_space = linspace(1, length(x_Ltrajectory_swing_adj), unified_length);
        x_L_swing_interp(:, i) = interp1(1:length(x_Ltrajectory_swing_adj), x_Ltrajectory_swing_adj, lin_space, 'linear');
        z_L_swing_interp(:, i) = interp1(1:length(z_Ltrajectory_swing), z_Ltrajectory_swing, lin_space, 'linear');
    end

    % 平均軌道を計算
    mean_x_Rswing = mean(x_R_swing_interp, 2, 'omitnan');
    mean_z_Rswing = mean(z_R_swing_interp, 2, 'omitnan');
    mean_x_Lswing = mean(x_L_swing_interp, 2, 'omitnan');
    mean_z_Lswing = mean(z_L_swing_interp, 2, 'omitnan');

    % 軌道のプロット
    plot(mean_x_Rswing, mean_z_Rswing, '-','Color', [1,0.5,0], 'LineWidth', 1, 'DisplayName', '右脚:遊脚期　平均軌道');hold on;
    plot(mean_x_Lswing, mean_z_Lswing, '-', 'Color', [0,0.5,1], 'LineWidth', 1, 'DisplayName', '左脚:遊脚期　平均軌道');hold on;

    % 重心位置をプロット
    plot(0, CoM_z_5m_mean, 'k.', 'MarkerSize', 20, 'DisplayName', '重心位置');
    
    % グラフ設定
    legend;
    xlim(x_lim);
    ylim(y_lim);
    xlabel("重心位置に対する" + joint_name + "の位置 前後方向");
    ylabel('地面からの高さ m');
    title("左右脚の比較 - " + joint_name);

    exportgraphics(gcf, export_filename, 'Append', true);
    saveas(gcf, fullfile(indiv_figdir, ['左右比較(立脚期なし)_', joint_name, '.jpeg']));
    close(gcf);
end

compare_joint_angle(export_filename, indiv_figdir,Rknee_angle,Lknee_angle, '膝関節角度 [°]', [-10,60],'屈曲方向','伸展方向', valid_Rcontact_frame,valid_Lcontact_frame);
compare_joint_angle(export_filename, indiv_figdir,Rankle_angle,Lankle_angle, '足関節角度 [°]', [-45,30],'背屈方向','底屈方向', valid_Rcontact_frame,valid_Lcontact_frame);
compare_joint_angle(export_filename, indiv_figdir,Rhip_extension,Lhip_extension, '股関節伸展角度 [°]', [-30,30],'屈曲方向','伸展方向', valid_Rcontact_frame,valid_Lcontact_frame);
compare_joint_angle(export_filename, indiv_figdir,Rhip_abduction,Lhip_abduction, '股関節外転角度 [°]', [-12,12],'外転方向','内転方向', valid_Rcontact_frame,valid_Lcontact_frame);
compare_joint_angle(export_filename, indiv_figdir,Rhip_rotation,Lhip_rotation, '股関節内旋角度 [°]', [-45,45],'内旋方向','外旋方向', valid_Rcontact_frame,valid_Lcontact_frame);

compare_joint_angle_addsomething(export_filename, indiv_figdir, Rknee_angle, Lknee_angle, CoM_z_5m,'両方','膝関節角度 [°]', [-10,60],'屈曲方向','伸展方向', valid_Rcontact_frame,valid_Lcontact_frame,'重心位置');
compare_joint_angle_addsomething(export_filename, indiv_figdir, Rhip_extension, Lhip_extension, CoM_z_5m,'両方','股関節角度 [°]', [-30,30],'屈曲方向','伸展方向', valid_Rcontact_frame,valid_Lcontact_frame,'重心位置');
compare_joint_angle_addsomething(export_filename, indiv_figdir, Rknee_angle, Lknee_angle, Rthigh_z_5,'右','膝関節角度 [°]', [-10,60],'屈曲方向','伸展方向', valid_Rcontact_frame,valid_Lcontact_frame,'右大腿');
compare_joint_angle_addsomething(export_filename, indiv_figdir, Rhip_extension, Lhip_extension, Rthigh_z_5,'右','股関節角度 [°]', [-30,30],'屈曲方向','伸展方向', valid_Rcontact_frame,valid_Lcontact_frame,'右大腿');
compare_joint_angle_addsomething(export_filename, indiv_figdir, Rknee_angle, Lknee_angle, Lthigh_z_5,'左','膝関節角度 [°]', [-10,60],'屈曲方向','伸展方向', valid_Rcontact_frame,valid_Lcontact_frame,'左大腿');
compare_joint_angle_addsomething(export_filename, indiv_figdir, Rhip_extension, Lhip_extension, Lthigh_z_5,'左','股関節角度 [°]', [-30,30],'屈曲方向','伸展方向', valid_Rcontact_frame,valid_Lcontact_frame,'左大腿');

compare_joint_angle_addsomething_Rfootcontact(export_filename, indiv_figdir, Rknee_angle, Lknee_angle, CoM_z_5m,'膝関節角度 [°]', [-10,60],'屈曲方向','伸展方向', valid_Rcontact_frame,'重心位置');
compare_joint_angle_addsomething_Rfootcontact(export_filename, indiv_figdir, Rhip_extension, Lhip_extension, CoM_z_5m,'股関節角度 [°]', [-30,30],'屈曲方向','伸展方向', valid_Rcontact_frame,'重心位置');
compare_joint_angle_addsomething_Rfootcontact(export_filename, indiv_figdir, Rknee_angle, Lknee_angle, Rthigh_z_5,'膝関節角度 [°]', [-10,60],'屈曲方向','伸展方向', valid_Rcontact_frame,'右大腿');
compare_joint_angle_addsomething_Rfootcontact(export_filename, indiv_figdir, Rhip_extension, Lhip_extension, Rthigh_z_5,'股関節角度 [°]', [-30,30],'屈曲方向','伸展方向', valid_Rcontact_frame,'右大腿');
compare_joint_angle_addsomething_Rfootcontact(export_filename, indiv_figdir, Rknee_angle, Lknee_angle, Lthigh_z_5,'膝関節角度 [°]', [-10,60],'屈曲方向','伸展方向', valid_Rcontact_frame,'左大腿');
compare_joint_angle_addsomething_Rfootcontact(export_filename, indiv_figdir, Rhip_extension, Lhip_extension, Lthigh_z_5,'股関節角度 [°]', [-30,30],'屈曲方向','伸展方向', valid_Rcontact_frame,'左大腿');


plot_joint_angle(export_filename, indiv_figdir,'右', Rknee_angle, '膝関節角度 [°]', [-10,60],'屈曲方向','伸展方向', valid_Rcontact_frame);
plot_joint_angle(export_filename, indiv_figdir,'左', Lknee_angle, '膝関節角度 [°]', [-10,60],'屈曲方向','伸展方向', valid_Lcontact_frame);
plot_joint_angle(export_filename, indiv_figdir,'右', Rankle_angle, '足関節角度 [°]', [-45,30],'背屈方向','底屈方向', valid_Rcontact_frame);
plot_joint_angle(export_filename, indiv_figdir,'左', Lankle_angle, '足関節角度 [°]', [-45,30],'背屈方向','底屈方向', valid_Lcontact_frame);

plot_joint_angle(export_filename, indiv_figdir,'右', Rhip_extension, '股関節伸展角度 [°]', [-30,30],'屈曲方向','伸展方向', valid_Rcontact_frame);
plot_joint_angle(export_filename, indiv_figdir,'左', Lhip_extension, '股関節伸展角度 [°]', [-30,30],'屈曲方向','伸展方向', valid_Lcontact_frame);
plot_joint_angle(export_filename, indiv_figdir,'右', Rhip_rotation, '股関節内旋角度 [°]', [-45,45],'内旋方向','外旋方向', valid_Rcontact_frame);
plot_joint_angle(export_filename, indiv_figdir,'左', Lhip_rotation, '股関節内旋角度 [°]', [-45,45],'内旋方向','外旋方向', valid_Lcontact_frame);
plot_joint_angle(export_filename, indiv_figdir,'右', Rhip_abduction, '股関節外転角度 [°]', [-12,12],'外転方向','内転方向', valid_Rcontact_frame);
plot_joint_angle(export_filename, indiv_figdir,'左', Lhip_abduction, '股関節外転角度 [°]', [-12,12],'外転方向','内転方向', valid_Lcontact_frame);
Rplot_joint_angle_adjcycle(export_filename, indiv_figdir, Rhip_abduction, '股関節外転角度 [°]', [-12,12],'外転方向','内転方向', valid_Rcontact_frame);

plot_joint_angle(export_filename, indiv_figdir,'右', L5_ay_5, 'L5左右方向の加速度 [m/s^2]', [-6,6],'右','左方向', valid_Rcontact_frame);
Rplot_joint_angle_adjcycle(export_filename, indiv_figdir, L5_ay_5, 'L5左右方向の加速度 [m/s^2]', [-6,6],'右方向','左方向', valid_Rcontact_frame);
plot_joint_angle(export_filename, indiv_figdir,'', Lumber_lateralFlex, '腰椎側屈角度 [°]', [-20,20],'右方向','左方向', valid_Rcontact_frame);

%% -- 関節の軌跡導出 -- %%
traject(export_filename, indiv_figdir,Rthigh_x_5, Rthigh_z_5, '右大腿', [-0.2,0.2], [0.8,1], CoM_x_5m, CoM_z_5m_mean, valid_Rcontact_frame, valid_Rcontact_end_frame);
traject(export_filename, indiv_figdir,Lthigh_x_5, Lthigh_z_5, '左大腿', [-0.2,0.2], [0.8,1], CoM_x_5m, CoM_z_5m_mean, valid_Lcontact_frame, valid_Lcontact_end_frame);
compared_traject(export_filename, indiv_figdir,Rthigh_x_5, Rthigh_z_5, Lthigh_x_5, Lthigh_z_5, '大腿部の軌道比較', [-0.2,0.2], [0.8,1], CoM_x_5m, CoM_z_5m_mean, valid_Rcontact_frame, valid_Rcontact_end_frame, valid_Lcontact_frame, valid_Lcontact_end_frame);
traject(export_filename, indiv_figdir,Rtoe_x_5, Rtoe_z_5, '右つま先', [-0.5,0.5], [0,1], CoM_x_5m, CoM_z_5m_mean, valid_Rcontact_frame, valid_Rcontact_end_frame);
traject(export_filename, indiv_figdir,Ltoe_x_5, Ltoe_z_5, '左つま先', [-0.5,0.5], [0,1], CoM_x_5m, CoM_z_5m_mean, valid_Lcontact_frame, valid_Lcontact_end_frame);
compared_traject(export_filename, indiv_figdir,Rtoe_x_5, Rtoe_z_5, Ltoe_x_5, Ltoe_z_5, 'つま先の軌道比較', [-0.5,0.5], [0,1], CoM_x_5m, CoM_z_5m_mean, valid_Rcontact_frame, valid_Rcontact_end_frame, valid_Lcontact_frame, valid_Lcontact_end_frame);
compared_traject_onlyswing(export_filename, indiv_figdir,Rtoe_x_5, Rtoe_z_5, Ltoe_x_5, Ltoe_z_5, 'つま先の軌道比較', [-0.5,0.5], [0,1], CoM_x_5m, CoM_z_5m_mean, valid_Rcontact_frame, valid_Rcontact_end_frame, valid_Lcontact_frame, valid_Lcontact_end_frame);

disp('図の出力が完了しました')

end