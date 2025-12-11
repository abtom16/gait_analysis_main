clc;
addpath(genpath('./func'));
% filename1 = 'C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\able_bodied\Modified_1107asari_normal.xlsx';
% filename2 = 'C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\able_bodied\Modified_1205_abe.xlsx';
% filename3 = 'C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\able_bodied\Modified_kitahara_sub1.xlsx';
% filename4 = 'C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\able_bodied\Modified_kitahara_sub2.xlsx';
% filename5 = 'C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\able_bodied\Modified_kitahara_sub3.xlsx';
% filename6 = 'C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\able_bodied\Modified_kitahara_sub4.xlsx';
% filename7 = 'C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\able_bodied\Modified_kitahara_sub5.xlsx';
% filename8 = 'C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\able_bodied\Modified_kitahara_sub6.xlsx';
% filename9 = 'C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\able_bodied\Modified_kitahara_sub7.xlsx';
% filename10 = 'C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\able_bodied\Modified_kitahara_sub9.xlsx';
% filename11 = 'C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\able_bodied\Modified_kitahara_sub10.xlsx';
% filename12 = 'C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\able_bodied\Modified_kitahara_sub11.xlsx';
% filename13 = 'C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\able_bodied\Modified_kitahara_sub12.xlsx';
% filename14 = 'C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\able_bodied\Modified_kitahara_sub13.xlsx';
% 
% filenames = {filename12, filename13, filename14};
% for i=1:length(filenames)
%     Export_fig(filenames{i}, 'なし');
% end

filename = "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250514\sub9\Modified_sub9_NW1.xlsx";
Export_fig(filename, '右');
disp('Completely Processed!');