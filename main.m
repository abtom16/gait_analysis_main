clc
addpath(genpath('./func'));   %処理をしている関数をfunc内に保存しており、これらの関数を実行するために必要

%% ver.ディレクトリ全部変換
% 進行状況バーの作成
try
fig = uifigure('Position', [100, 600, 400, 200], 'Name', 'ファイル処理アプリ');
set(fig, 'WindowStyle', 'alwaysontop')
progressBar = uiprogressdlg(fig, 'Title', '処理中', 'Message', '処理を開始しています...', 'Value', 0);

filepath = 'C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20251205\sub28';

% ディレクトリ内のすべてのファイルを取得
allFiles = dir(fullfile(filepath, '*.xlsx*'));
% Modified_ で始まるファイルがあるか確認
modifiedFiles = allFiles(startsWith({allFiles.name}, 'Modified_'));
without_modified_allFiles = allFiles(~startsWith({allFiles.name}, 'Modified_'));

%% 麻痺側確認ダイアログ
prompt = '麻痺側はどちらですか？ (右/左): ';
dlg_answer = questdlg(prompt, '麻痺側の選択', '右', '左','どちらでもない', '右');
if isempty(dlg_answer)
    error('麻痺側の選択がキャンセルされました。');
end
paralyzed_side = dlg_answer;

if ~isempty(modifiedFiles)
    % Modifiedファイルが存在する場合のメッセージと選択ダイアログ
    choice = questdlg('Modified_ で始まるファイルが見つかりました。modifingdata をスキップしますか？', ...
        '選択', 'スキップ', '実行する', 'スキップ');

    if strcmp(choice, 'スキップ')
        disp('modifingdata をスキップします。');
        skipModifying = true;
        total_steps = length(without_modified_allFiles) * 2;  % 各ファイルに2ステップ (Export_fig, Lyapunov)
    else
        disp('modifingdata を実行します。');
        skipModifying = false;
        total_steps = length(without_modified_allFiles) * 3;  % 各ファイルに3ステップ (modifing_data, Export_fig, Lyapunov)
    end
else
    % Modifiedファイルがない場合は通常通り実行
    skipModifying = false;
    total_steps = length(without_modified_allFiles) * 3;
end


current_step = 0;
% ファイルごとに処理を実行
for i = 1:length(without_modified_allFiles)
    clc;
    [~, filename, ~] = fileparts(without_modified_allFiles(i).name);
    fullfilename = fullfile(filepath, filename);

    progressBar.Message = sprintf('処理中: %s (%d/%d)', filename, i, length(without_modified_allFiles));

    if skipModifying == false
        % modifingdata 関数の実行
        modifing_data(fullfilename);
        progressBar.Message = sprintf('処理中: %s - Modifiedデータ処理完了 (%d/%d)', filename, i, length(without_modified_allFiles));
        current_step = current_step + 1;
        progressBar.Value = current_step / total_steps;
    end

    % Modified_ ファイルの出力名
    file_name = ['Modified_', filename, '.xlsx'];
    Modified_input_file = fullfile(filepath, file_name);

    % 他の処理
    if strcmp(dlg_answer,'どちらでもない')
        Export_fig_notparalyzed(Modified_input_file);
        progressBar.Message = sprintf('処理中: %s - 図の導出処理完了 (%d/%d)', filename, i, length(without_modified_allFiles));
        current_step = current_step + 1;
        progressBar.Value = current_step / total_steps;
    elseif strcmp(dlg_answer, '右') || strcmp(dlg_answer, '左')
        Export_fig(Modified_input_file, paralyzed_side);
        progressBar.Message = sprintf('処理中: %s - 図の導出処理完了 (%d/%d)', filename, i, length(without_modified_allFiles));
        current_step = current_step + 1;
        progressBar.Value = current_step / total_steps;
    end
    Lyapunov(Modified_input_file);
    progressBar.Message = sprintf('処理中: %s - Lyapunov指数導出完了 (%d/%d)', filename, i, length(without_modified_allFiles));
    current_step = current_step + 1;
    progressBar.Value = current_step / total_steps;
end

msgbox('処理が完了しました！');
delete(progressBar);
close(fig);

catch ME
    % エラーが発生した場合はエラーダイアログを表示
    if exist('progressBar', 'var')
        delete(progressBar);  %ダイアログが生成されているとき削除
    end
    if exist('fig', 'var')
        close(fig);  %ダイアログ用のfigureが生成されていたら削除
    end
    disp(['Error: ', ME.message]);
    
    disp('エラーが発生した箇所:');
    for k = 1:length(ME.stack)
        fprintf('ファイル: %s\n', ME.stack(k).file);
        fprintf('行番号: %d\n', ME.stack(k).line);
        fprintf('関数名: %s\n', ME.stack(k).name);
    end

    uialert(uifigure('WindowStyle', 'modal'), ME.message, 'エラー', 'Icon', 'error');
end
%% ver.ファイル選択

% initialDir = 'D:\1修士\６.Xsens_analysis';
% [file,path] = uigetfile({'*.xlsx'},'ファイルを選んでください', initialDir);
% file_path = [path, file];
% [~, filename, ~] = fileparts(file_path);
% input_file_name = fullfile(path, filename);
% 
% % file_path = 'D:\1修士\６.Xsens_analysis\main_experiment_1211\sub1\sub1_normal1.xlsx';  簡単に
% % [path, filename, ~] = fileparts(file_path);
% % input_file_name = fullfile(path, filename);
% 
% modifing_data(input_file_name);
% file_name = ['Modified_',filename, '.xlsx'];
% input_file_name2 = fullfile(path, file_name);
% Export_fig_notparalyzed(input_file_name2);
% Lyapunov(input_file_name2);

