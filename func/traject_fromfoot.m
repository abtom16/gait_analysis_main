clc;
filedir = 'D:\1修士\６.Xsens_analysis\main_expariment\20241211\sub1';
% filedir = 'D:\1修士\６.Xsens_analysis\歩容特性分析_abe_健常者分析用\健常者データ';
allFiles = dir(fullfile(filedir, '*.xlsx*'));
modifiedFiles = allFiles(startsWith({allFiles.name}, 'Modified_'));


for i=1:length(modifiedFiles)
[~, filename, ~] = fileparts(modifiedFiles(i).name); 
input_file_name2 = fullfile(filedir, filename);

df2 = readmatrix(input_file_name2, 'Sheet','時系列データ 5m');
[path, name, ~]=fileparts(input_file_name2);
figure_path = fullfile(path, 'figure');

name = char(name);  %%文字列にしないと[]がリストになってしまう
export_filename = fullfile(figure_path, ['Figure_',name,'.pdf']);
indiv_figdir = fullfile(figure_path,name);
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

Rfoot_x = df2(:,13);
Lfoot_x = df2(:,14);
Rthigh_x = df2(2:end,36);
Rthigh_z = df2(2:end,37);
Lthigh_x = df2(2:end,41);
Lthigh_z = df2(2:end,42);

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

plot_jointvelo(export_filename,indiv_figdir,'左', Lhip_extension, '股関節角速度[m/s]', [-10,10], '屈曲方向','伸展方向',valid_Lcontact_frame);
plot_jointvelo(export_filename,indiv_figdir,'右', Rhip_extension, '股関節角速度[m/s]', [-10,10], '屈曲方向','伸展方向',valid_Rcontact_frame);



% traject(export_filename,indiv_figdir,Rthigh_x, Rthigh_z, '右大腿骨', [-0.5, 0.5], [0, 1.0], Rfoot_x, valid_Rcontact_frame, valid_Rcontact_end_frame);
% traject(export_filename,indiv_figdir,Lthigh_x, Lthigh_z, '左大腿骨', [-0.5, 0.5], [0, 1.0], Lfoot_x, valid_Lcontact_frame, valid_Lcontact_end_frame);
% compared_traject(export_filename,indiv_figdir,Rthigh_x, Rthigh_z, Lthigh_x, Lthigh_z, '大腿骨', [-0.5,0.5], [0,1], Rfoot_x, Lfoot_x, valid_Rcontact_frame, valid_Rcontact_end_frame, valid_Lcontact_frame, valid_Lcontact_end_frame)

end



function  plot_jointvelo(export_filename,indiv_figdir,side, angle_data, angle_label, y_lim, direction_max,direction_min,contact_frame)
    
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
        current_anglevelo = gradient(current_cycle);
        original_x = linspace(0, 1, length(current_anglevelo));
        uniform_x = linspace(0, 1, uniform_length);
        resampled_anglesvelo(:, j) = interp1(original_x, current_anglevelo, uniform_x);
        plot(uniform_x, resampled_anglesvelo(:,j), '-k', 'HandleVisibility', 'off');
    end
    
    % 平均線のプロット
    mean_resampled = mean(resampled_anglesvelo, 2);
    plot(uniform_x, mean_resampled, '-r', 'DisplayName', '平均', 'LineWidth', 2);
    
    % 凡例設定
    legend('Location','Best');


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
    
    angle_label_export = regexprep(angle_label, '\[.*?\]', '');
    exportgraphics(gcf, export_filename, 'Append', true);
    saveas(gcf, fullfile(indiv_figdir, [side, angle_label_export, '.jpeg']));
    close(gcf);
end

function traject(export_filename,indiv_figdir,angle_x, angle_z, joint_name, x_lim, y_lim, angle2_x, contact_frame, contact_end_frame)
    
    figure('Visible','off');
    for i = 1:length(contact_frame)-1
        % 関節位置と重心位置のデータ取得
        z_trajectory_stance = angle_z(contact_frame(i):contact_end_frame(i));
        x_trajectory_stance = angle_x(contact_frame(i):contact_end_frame(i));
        
        angle2_x_stance = angle2_x(contact_frame(i):contact_end_frame(i));
        if i==1
            plot(x_trajectory_stance(1)-angle2_x_stance(1), z_trajectory_stance(1),'Marker','o','DisplayName','初期値'); hold on;
            plot(0, 0, 'Marker','o', 'Color','k','DisplayName','足部位置'); hold on;
        end
        x_trajectory_stance_adj = x_trajectory_stance - angle2_x_stance;
        plot(x_trajectory_stance_adj, z_trajectory_stance, 'Color', [1,0.5,0],'HandleVisibility','off'); hold on;
        legend('Location','Best');
        % ラベル設定
        xlim(x_lim);
        ylim(y_lim);
        xlabel("足部位置に対する"+joint_name+"の位置　前後方向");
        ylabel('地面からの高さ m');
    end
    exportgraphics(gcf, export_filename, 'Append', true);
    saveas(gcf, fullfile(indiv_figdir, ['足部から見た軌跡_', joint_name, '.jpeg']));
    close(gcf);
end   

function compared_traject(export_filename,indiv_figdir,Rangle_x, Rangle_z, Langle_x, Langle_z, joint_name, x_lim, y_lim, Rangle2_x_5m, Langle2_x_5m, Rcontact_frame, Rcontact_end_frame, Lcontact_frame, Lcontact_end_frame)
    % 定義: 補間後の統一データ点数
    unified_length = 60;
    x_R_stance_interp = [];
    z_R_stance_interp = [];
    x_L_stance_interp = [];
    z_L_stance_interp = [];
    
    figure(Visible="off");
    hold on;
    
    % 右脚立脚期の軌道を処理
    for i = 1:length(Rcontact_frame)-1
        z_Rtrajectory_stance = Rangle_z(Rcontact_frame(i):Rcontact_end_frame(i));
        x_Rtrajectory_stance = Rangle_x(Rcontact_frame(i):Rcontact_end_frame(i));
        Rangle2_x_div_stance = Rangle2_x_5m(Rcontact_frame(i):Rcontact_end_frame(i));
        
        % 軌道補正
        x_Rtrajectory_stance_adj = x_Rtrajectory_stance - Rangle2_x_div_stance;
        
        % 線形補間
        lin_space = linspace(1, length(x_Rtrajectory_stance_adj), unified_length);
        x_R_stance_interp(:, i) = interp1(1:length(x_Rtrajectory_stance_adj), x_Rtrajectory_stance_adj, lin_space, 'linear');
        z_R_stance_interp(:, i) = interp1(1:length(z_Rtrajectory_stance), z_Rtrajectory_stance, lin_space, 'linear');
    end
    
    % 左脚の軌道を処理
    for i = 1:length(Lcontact_frame)-1
        z_Ltrajectory_stance = Langle_z(Lcontact_frame(i):Lcontact_end_frame(i));
        x_Ltrajectory_stance = Langle_x(Lcontact_frame(i):Lcontact_end_frame(i));
        Langle2_x_div_stance = Langle2_x_5m(Lcontact_frame(i):Lcontact_end_frame(i));
        
        % 軌道補正
        x_Ltrajectory_stance_adj = x_Ltrajectory_stance - Langle2_x_div_stance;
        
        % 線形補間
        lin_space = linspace(1, length(x_Ltrajectory_stance_adj), unified_length);
        x_L_stance_interp(:, i) = interp1(1:length(x_Ltrajectory_stance_adj), x_Ltrajectory_stance_adj, lin_space, 'linear');
        z_L_stance_interp(:, i) = interp1(1:length(z_Ltrajectory_stance), z_Ltrajectory_stance, lin_space, 'linear');
    end

    % 平均軌道を計算
    mean_x_Rstance = mean(x_R_stance_interp, 2, 'omitnan');
    mean_z_Rstance = mean(z_R_stance_interp, 2, 'omitnan');
    mean_x_Lstance = mean(x_L_stance_interp, 2, 'omitnan');
    mean_z_Lstance = mean(z_L_stance_interp, 2, 'omitnan');
    
    indices = [1, 10, 30, 50, 60];  %歩行周期０，10、30、50、60％に対応
    mean_x_Rpoint = mean_x_Rstance(indices);
    mean_z_Rpoint = mean_z_Rstance(indices);
    mean_x_Lpoint = mean_x_Lstance(indices);
    mean_z_Lpoint = mean_z_Lstance(indices);
    % 軌道のプロット
    plot(0, 0, 'ko','MarkerFaceColor','k','DisplayName','足部位置');
    plot(mean_x_Rstance, mean_z_Rstance, '-','Color', [1,0.5,0], 'LineWidth', 2, 'DisplayName', '右脚:立脚期　平均軌道');hold on;
    plot(mean_x_Rpoint, mean_z_Rpoint, 'bo', 'MarkerFaceColor','b','HandleVisibility','off');
    plot(mean_x_Lstance, mean_z_Lstance, '-', 'Color', [0,0,1],  'LineWidth', 2, 'DisplayName', '左脚:立脚期　平均軌道');hold on;
    plot(mean_x_Lpoint, mean_z_Lpoint, 'bo', 'MarkerFaceColor','b','HandleVisibility','off');

    % グラフ設定
    legend('Location','best');
    xlim(x_lim);
    ylim(y_lim);
    xlabel("重心位置に対する" + joint_name + "の位置 前後方向");
    ylabel('地面からの高さ m');
    title("左右脚の比較 - " + joint_name);

    exportgraphics(gcf, export_filename, 'Append', true);
    saveas(gcf, fullfile(indiv_figdir, ['足部から見た軌道左右比較_', joint_name, '.jpeg']));
    close(gcf);
    
    %%  拡大ver
    f1 = figure('Visible','off');
    set(f1, 'Units', 'pixels');
    plot(mean_x_Rstance, mean_z_Rstance*100, '-','Color', [1,0.5,0], 'LineWidth', 2, 'DisplayName', '右脚:立脚期　平均軌道');hold on;
    plot(mean_x_Rpoint, mean_z_Rpoint*100, 'ro', 'MarkerFaceColor','r','HandleVisibility','off');
    plot(mean_x_Lstance, mean_z_Lstance*100, '-', 'Color', [0,0,1],  'LineWidth', 2, 'DisplayName', '左脚:立脚期　平均軌道');hold on;
    plot(mean_x_Lpoint, mean_z_Lpoint*100, 'bo', 'MarkerFaceColor','b','HandleVisibility','off');
    
    focus_ylim_min = min(min(mean_z_Rstance*100),min(mean_z_Lstance*100));
    focus_ylim_min = floor(focus_ylim_min);
    focus_ylim_max = max(max(mean_z_Rstance*100),max(mean_z_Lstance*100));
    focus_ylim_max = ceil(focus_ylim_max);
    range = focus_ylim_max - focus_ylim_min;
    range_int = range + 1;
 
    pos = get(f1,'Position');
    pos(4) = range_int * 40;
    set(f1, 'Position', pos);

    legend('Location','best');
    xlim(x_lim);
    tick_interval = 0.5;
    ylim([focus_ylim_min,focus_ylim_max]);
    yticks(focus_ylim_min:tick_interval:focus_ylim_max);
    xlabel("重心位置に対する" + joint_name + "の位置 前後方向");
    ylabel('地面からの高さ cm');
    title("左右脚の比較 - " + joint_name);

    exportgraphics(gcf, export_filename, 'Append', true);
    saveas(gcf, fullfile(indiv_figdir, ['(focus)足部から見た軌道左右比較_', joint_name, '.jpeg']));
    close(gcf);
end

