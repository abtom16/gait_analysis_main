clc;
addpath(genpath('../func'));
%{
    研究していく中で欲しいデータが増える場合がある
    欲しいデータが増えたときに、その都度modifing_data.mを修正した後、実行するためだけのプログラム

使い方-各患者バージョン：
filepathに、modifingしたい患者のデータのあるファイルパスを入力して、実行するだけ

使い方-各歩行条件バージョン：
1．データの準備
　・nw_paths：通常歩行のデータ
　・as_paths：アシスト歩行のデータ
　・dr_paths：歩行リハのデータ
左片麻痺の患者は、leftに追加し、右片麻痺の患者は、rightに追加する
2．filepathsをmodifingしたいデータ群に変更する

%}


%% -- 各患者 ver.
% filepath = 'C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250825\sub17';
% % ディレクトリ内のすべてのファイルを取得
% allFiles = dir(fullfile(filepath, '*.xlsx*'));
% % Modified_ で始まるファイルがあるか確認
% modifiedFiles = allFiles(startsWith({allFiles.name}, 'Modified_'));
% without_modified_allFiles = allFiles(~startsWith({allFiles.name}, 'Modified_'));
% 
% f = waitbar(0, 'Progressing...');
% 
% for i = 1:length(without_modified_allFiles)
%     [~, filename, ~] = fileparts(without_modified_allFiles(i).name);
%     fullfilename = fullfile(filepath, filename);
%     modifing_data(fullfilename);
%     progress = i / length(without_modified_allFiles);
%     waitbar(progress, f, 'Progressing...');
% end
% close(f);
%% --

%% -- 1 file ver.
filepath = 'C:\\abe_backup\\backup\\01_修士\\06_Xsens_analysis\\Gait_Analysis_Xsens\\gait_analysis_main\\subroutine\\sub20dr-001';
% ****** ! ↓変更忘れない ! *******
affected_side = 'Left';
modifing_data(filepath,affected_side);


%% -- 各歩行条件 ver.
% nw_paths_left = {
%     % 'C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20241211\sub1\sub1_normal1';
%     % 'C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20241211\sub1\sub1_normal2';
%     % 'C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20241211\sub3\sub3_normal1';
%     % 'C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20241211\sub3\sub3_normal2';
%     % 'C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250318\sub4\sub4_normal1';
%     % 'C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250318\sub4\sub4_normal2';
%     % 'C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250318\sub5\sub5_normal-001';
%     % 'C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250318\sub5\sub5_normal-002';
%     % 'C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250318\sub6\sub6_normal-001';
%     % 'C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250318\sub6\sub6_normal-002';
%     % 'C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250514\sub7\sub7_NW1';
%     % 'C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250514\sub7\sub7_NW2';
%     % 'C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250514\sub8\sub8_NW1';
%     % 'C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250514\sub8\sub8_NW2';
%     % 'C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250630\sub10\sub10_nw-001';
%     % 'C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250630\sub10\sub10_nw-002';
%     % 'C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250630\sub11\sub11_nw-001';
%     % 'C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250630\sub11\sub11_nw-002';
%     % 'C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250630\sub12\sub12_nw-001';
%     % 'C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250630\sub12\sub12_nw-002';
%     % 'C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250728\sub13\nw-001';
%     % 'C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250728\sub13\nw-002';
%     % 'C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250728\sub14\nw_short-001';
%     % 'C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250728\sub14\nw_short-002';
%     'C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250728\sub14\nw_long-001';
%     'C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250728\sub14\nw_long-002';
%     % 'C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250825\sub16\nw-001';
%     % 'C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250825\sub16\nw-002';
%     % 'C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250825\sub17\nw-001';
%     % 'C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250825\sub17\nw-002';
%     };
% 
% nw_paths_right = {
%     'C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20241211\sub2\sub2_normal1';
%     'C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20241211\sub2\sub2_normal2';
%     'C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250514\sub9\sub9_NW1';
%     'C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250514\sub9\sub9_NW2';
%     'C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250728\sub13\nw-001';
%     'C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250728\sub13\nw-002';
%     'C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250825\sub15\nw-001';
%     'C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250825\sub15\nw-002';
%     };
% 
% nw_paths_nondisabled = {
%     'C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\able_bodied\1107asari_normal';
%     'C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\able_bodied\1205_abe';
%     'C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\able_bodied\kitahara_sub1';
%     'C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\able_bodied\kitahara_sub2';
%     'C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\able_bodied\kitahara_sub3';
%     'C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\able_bodied\kitahara_sub4';
%     'C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\able_bodied\kitahara_sub5';
%     'C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\able_bodied\kitahara_sub6';
%     'C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\able_bodied\kitahara_sub7';
%     'C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\able_bodied\kitahara_sub9';
%     'C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\able_bodied\kitahara_sub10';
%     'C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\able_bodied\kitahara_sub11';
%     'C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\able_bodied\kitahara_sub12';
%     'C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\able_bodied\kitahara_sub13';
% };
% 
% as_paths_left = {
%     % 'C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20241211\sub1\sub1_assist1';
%     % 'C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20241211\sub1\sub1_assist2';
%     % 'C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20241211\sub3\sub3_assist3';
%     % 'C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20241211\sub3\sub3_assist4';
%     % 'C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250318\sub4\sub4_assist1';
%     % 'C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250318\sub4\sub4_assist2';
%     % 'C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250318\sub5\sub5_assist-001';
%     % 'C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250318\sub5\sub5_assist-002';
%     % 'C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250318\sub6\sub6_assist-001';
%     % 'C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250318\sub6\sub6_assist-002';
%     % 'C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250514\sub7\sub7_AS1';
%     % 'C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250514\sub7\sub7_AS2';
%     % 'C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250514\sub7\sub7_AS3';
%     % 'C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250514\sub7\sub7_AS4';
%     % 'C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250514\sub8\sub8_AS1';
%     % 'C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250514\sub8\sub8_AS2';
%     % 'C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250514\sub8\sub8_AS3';
%     % 'C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250514\sub8\sub8_AS4';
%     % 
%     % 'C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250630\sub10\sub10_as-001';
%     % 'C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250630\sub10\sub10_as-001'
%     % 'C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250630\sub10\sub10_as-002';
%     % 'C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250630\sub10\sub10_as-003';
%     % 'C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250630\sub10\sub10_as-004';
%     % 'C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250630\sub11\sub11_as-002';
%     % 'C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250630\sub11\sub11_as-003';
%     % 'C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250630\sub11\sub11_as-004';
%     % 'C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250630\sub11\sub11_as-005';
%     % 'C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250630\sub12\sub12_as-001';
%     % 'C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250630\sub12\sub12_as-002';
%     % 'C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250630\sub12\sub12_as-003';
%     % 'C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250630\sub12\sub12_as-004';
%     % 
%     % 'C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250728\sub14\as_long-001';
%     % 'C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250728\sub14\as_long-002';
%     % 'C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250728\sub14\as_short-001';
%     % 'C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250728\sub14\as_short-002';
%     % 
%     % 'C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250825\sub16\as-002';
%     % 'C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250825\sub16\as-003';
%     'C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250825\sub17\as-001';
%     'C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250825\sub17\as-002';
% };
% as_paths_right = {
%     'C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20241211\sub2\as-005(change_pos)';
%     'C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20241211\sub2\as-006(change_pos)';
%     'C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250514\sub9\sub9_AS1';
%     'C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250514\sub9\sub9_AS2';
%     'C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250514\sub9\sub9_AS3';
%     'C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250514\sub9\sub9_AS4';
%     'C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250728\sub13\as-001';
%     'C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250728\sub13\as-002';
%     'C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250825\sub15\as-001';
%     'C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250825\sub15\as-002';
%     'C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250825\sub15\as-003';
%     'C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250825\sub15\as-004';  
% };
% 
% dr_paths_left = {
%     % 'C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20241211\sub1\sub1_handle1';
%     % 'C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20241211\sub1\sub1_handle2';
%     % 'C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20241211\sub3\sub3_handle2';
%     % 'C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20241211\sub3\sub3_handle3';
%     % 'C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250318\sub4\sub4_handling1';
%     % 'C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250318\sub4\sub4_handling2';
%     % 'C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250318\sub5\sub5_handling-001';
%     % 'C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250318\sub5\sub5_handling-002';
%     % 'C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250318\sub5\sub5_handling_ver2-001';
%     % 'C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250318\sub5\sub5_handling_ver2-002';
%     % 'C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250318\sub6\sub6_handling-001';
%     % 'C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250318\sub6\sub6_handling-002';
%     % 'C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250318\sub6\sub6_handling_ver3-001';
%     % 'C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250318\sub6\sub6_handling_ver3-002';
%     % 'C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250514\sub7\sub7_DR1';
%     % 'C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250514\sub7\sub7_DR2';
%     % 'C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250514\sub8\sub8_DR1';
%     % 'C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250514\sub8\sub8_DR2';
%     % 'C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250514\sub8\sub8_DR3';
%     % 'C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250514\sub8\sub8_DR4';
%     % 'C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250630\sub10\sub10_dr-001';
%     % 'C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250630\sub10\sub10_dr-002';
%     % 'C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250630\sub10\sub10_dr-003';
%     % 'C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250630\sub10\sub10_dr-004';
%     % 'C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250630\sub11\sub11_dr-001';
%     % 'C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250630\sub11\sub11_dr-002';
%     % 'C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250630\sub11\sub11_dr-003';
%     % 'C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250630\sub11\sub11_dr-004';
%     % 'C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250630\sub12\sub12_dr-001';
%     % 'C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250630\sub12\sub12_dr-002';
%     % 'C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250630\sub12\sub12_dr-003';
%     % 'C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250630\sub12\sub12_dr-004';
%     % 'C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250825\sub16\dr-001';
%     % 'C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250825\sub16\dr-002';
%     'C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250825\sub17\dr-001';
%     'C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250825\sub17\dr-002';
% };
% 
% dr_paths_right = {
%     'C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20241211\sub2\sub2_dr1';
%     'C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20241211\sub2\sub2_dr2';
%     'C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250514\sub9\sub9_DR1';
%     'C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250514\sub9\sub9_DR2';
%     'C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250728\sub13\dr-001';
%     'C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250728\sub13\dr-002';
%     'C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250825\sub15\dr-001';
%     'C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250825\sub15\dr-002';
% };
% f = waitbar(0, 'Progressing...');
% 
% %% ========== ここを変更 ============
% filepaths = nw_paths_left;
% affected_side = 'Left';
% %% ==================================
% 
% % for i = 1:length(filepaths)
% %     modifing_data(filepaths{i}, affected_side);
% %     progress = i / length(filepaths);
% %     waitbar(progress, f, 'Progressing...');
% % end
% % close(f);
% %% --
% 
% disp('処理が完了しました!');
% clear all;