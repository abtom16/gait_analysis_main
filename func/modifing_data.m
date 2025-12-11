function[] = modifing_data(input_file_name)
clc
%input_file_name = 'D:\1修士\６.Xsens_analysis\main_expariment\20241211\sub1\sub1_normal1';
% 5m歩行テストデータ分析用
% 計測方法：Xsens
% 作成：abe ＠小竹研究室
input_file_name_xlsx = [input_file_name,'.xlsx'];
input_file_name_mvnx = [input_file_name,'.mvnx'];

%% --sheet Information-- %%
% Information = 1;
Segment_Orientation_Euler = 4;
Segment_Position = 5;
Segment_Acceleration = 7;
Joint_Angles_ZXY = 10;
Center_of_Mass = 14;

%{
　使わないシート
Makers = 2;
Segment_Orientation_Quat = 3;
Segment_Velocity = 6;
Segment_Angular_Velocity = 8;
Segment_Angular_acceleration = 9;
Joint_Angles_XZY = 11;
Ergonomic_Joint_Angles_ZXY = 12;
Ergonomic_Joint_Angles_XZY = 13;
%}

%% --Reading Data-- %%
% data_inf = readmatrix(input_file_name_xlsx,'Sheet',Information,'Range','B5');
data_CoM = readmatrix(input_file_name_xlsx,'Sheet',Center_of_Mass);
data_SegOrieEuler = readmatrix(input_file_name_xlsx,'Sheet',Segment_Orientation_Euler);
data_Position = readmatrix(input_file_name_xlsx,'Sheet',Segment_Position);
data_Joint_Angle = readmatrix(input_file_name_xlsx,'Sheet',Joint_Angles_ZXY);
data_Acceleration = readmatrix(input_file_name_xlsx,'Sheet',Segment_Acceleration);

% 時間の定義
FrameRate = 60;
dt = 1/FrameRate;   
t = data_CoM(:,1) *dt;
FrameNumber = length(t);

%% ********** 以下,データ計算 **********
% 重心位置
CoM_x = data_CoM(:,2);
CoM_y = data_CoM(:,3);
CoM_z = data_CoM(:,4);

L5_x = data_Position(:,5);
L5_y = data_Position(:,6);
L5_ax = data_Acceleration(:,5);
L5_ay = data_Acceleration(:,6);
Right_Hip_abad = data_Joint_Angle(:,44);
Right_Hip_rotation = data_Joint_Angle(:,45);
Right_Hip_Extention = data_Joint_Angle(:,46);
Left_Hip_abad = data_Joint_Angle(:,56);
Left_Hip_rotation = data_Joint_Angle(:,57);
Left_Hip_Extension = data_Joint_Angle(:,58);

% 膝位置
%　大腿骨の長さ40から45cm
Rthigh_x = data_Position(:,47); % 大腿部中心X座標
Rthigh_y = data_Position(:,48);
Rthigh_z = data_Position(:,49); % 大腿部中心Y座標
Rshank_x = data_Position(:,50); % 下腿中心X座標
Rshank_y = data_Position(:,51); 
Rshank_z = data_Position(:,52);
Lthigh_x = data_Position(:,59); % 大腿部中心X座標
Lthigh_y = data_Position(:,60);
Lthigh_z = data_Position(:,61); % 大腿部中心Y座標
Lshank_x = data_Position(:,62); % 下腿中心X座標
Lshank_y = data_Position(:,63); 
Lshank_z = data_Position(:,64);

% 足位置
Right_Foot_x = data_Position(:,53);
Right_Foot_y = data_Position(:,54);
Right_Foot_z = data_Position(:,55);
Left_Foot_x = data_Position(:,65);
Left_Foot_y = data_Position(:,66);
Left_Foot_z = data_Position(:,67);
% 足先位置
Right_Toe_x = data_Position(:,56);
Right_Toe_y = data_Position(:,57);
Right_Toe_z = data_Position(:,58);
Left_Toe_x = data_Position(:,68);
Left_Toe_y = data_Position(:,69);
Left_Toe_z = data_Position(:,70);

%腰椎の側屈角度
L5_z = data_Position(:,7);
T12_x = data_Position(:,11);
T12_y = data_Position(:,12);
T12_z = data_Position(:,13);
neck_x = data_Position(:,17);
neck_y = data_Position(:,18);
neck_z = data_Position(:,19);

Pelvis_ratation_z = data_SegOrieEuler(:,4);

% velocity and acceleration of CoM z-axis
CoM_az = data_CoM(:, 10);
CoM_vz = data_CoM(:, 7);


%% --原点に各位置の初期値を合わせる --%%
offset_x = CoM_x(1);
offset_y = CoM_y(1);
offset_Right_Foot_z = min(Right_Foot_z);
offset_Left_Foot_z = min(Left_Foot_z);
offset_Right_Toe_z = min(Right_Toe_z);
offset_Left_Toe_z = min(Left_Toe_z);

for k = 1:FrameNumber
    CoM_x(k) = CoM_x(k) - offset_x;
    CoM_y(k) = CoM_y(k) - offset_y;
    
    Rthigh_x(k) = Rthigh_x(k) - offset_x;
    Rthigh_y(k) = Rthigh_y(k) - offset_y;
    Lthigh_x(k) = Lthigh_x(k) - offset_x;
    Lthigh_y(k) = Lthigh_y(k) - offset_y;
    Rshank_x(k) = Rshank_x(k) - offset_x;
    Rshank_y(k) = Rshank_y(k) - offset_y;
    Lshank_x(k) = Lshank_x(k) - offset_x;
    Lshank_y(k) = Lshank_y(k) - offset_y;


    Right_Foot_x(k) = Right_Foot_x(k) - offset_x;
    Right_Foot_y(k) = Right_Foot_y(k) - offset_y;
    Left_Foot_x(k) = Left_Foot_x(k) - offset_x;
    Left_Foot_y(k) = Left_Foot_y(k) - offset_y;
    
    Right_Foot_z(k) = Right_Foot_z(k) - offset_Right_Foot_z;
    Left_Foot_z(k) = Left_Foot_z(k) - offset_Left_Foot_z;

    
    Right_Toe_x(k) = Right_Toe_x(k) - offset_x;
    Right_Toe_y(k) = Right_Toe_y(k) - offset_y;
    Left_Toe_x(k) = Left_Toe_x(k) - offset_x;
    Left_Toe_y(k) = Left_Toe_y(k) - offset_y;

    Right_Toe_z(k) = Right_Toe_z(k) - offset_Right_Toe_z;
    Left_Toe_z(k) = Left_Toe_z(k) - offset_Left_Toe_z;

    L5_x(k) = L5_x(k) - offset_x;
    L5_y(k) = L5_y(k) - offset_y;
    
    T12_x(k) = T12_x(k) - offset_x;
    T12_y(k) = T12_y(k) - offset_y;

    neck_x(k) = neck_x(k) - offset_x;
    neck_y(k) = neck_y(k) - offset_y;
end

%% --測定区間に入った時のフレーム数を取得
Len_wlk = zeros(size(t));
maxLen_wlk = 0;
walk_frame = 0;
threshold_3m = 9;
threshold_8m = 64;
threshold_11m = 121;
[row_count, ~] = size(data_CoM);
final_frame = row_count;

frame_11m_start = 1;
frame_11m_end = 0;
frame_5m_end = 0;
frame_5m_start = 0;


maxLen_wlk(final_frame) = CoM_x(final_frame)^2 + CoM_y(final_frame)^2;

while true
    walk_frame = walk_frame + 1;
    if walk_frame > final_frame
        break;
    end
    Len_wlk(walk_frame) = CoM_x(walk_frame)^2 + CoM_y(walk_frame)^2;
    if frame_5m_start == 0
        if Len_wlk(walk_frame) > threshold_3m
            frame_5m_start = walk_frame;
        end
    end
    if frame_5m_end == 0
        if Len_wlk(walk_frame) > threshold_8m
            frame_5m_end = walk_frame;
        end
    end
    if frame_11m_end == 0
        if maxLen_wlk(final_frame) < threshold_11m
            fprintf('フレーム数: %d\n 歩行距離が%.2fmで11m以下である可能性があります。',final_frame, sqrt(maxLen_wlk(final_frame)));  %歩行距離が足りないときのデバッグのため
            frame_11m_end = final_frame;
        end
        if Len_wlk(walk_frame) > threshold_11m
            frame_11m_end = walk_frame;
            break
        end
    end
end

% fprintf('3m:%d, 8m:%d, last:%d',frame_5m_start,frame_5m_end,frame_11m_end);
% fprintf('3m:%d, 8m:%d, last:%d',CoM_x(frame_5m_start),CoM_x(frame_5m_end),CoM_x(frame_11m_end));

%% --角度がずれるため補正-- %%
tan_alfa = - CoM_y(frame_11m_end) / CoM_x(frame_11m_end);
alfa = atan(tan_alfa);


%% --位置・速度・加速度矯正-- %%
if CoM_x(frame_11m_end) < 0  %受信機の位置によって原点が決まっているのでoffsetによって位置がマイナスの時修正
    for k = 1:FrameNumber
        CoM_x(k) = -CoM_x(k);
        CoM_y(k) = -CoM_y(k);
        Rthigh_x(k) = -Rthigh_x(k);
        Rthigh_y(k) = -Rthigh_y(k);
        Rshank_x(k) = -Rshank_x(k);
        Rshank_y(k) = -Rshank_y(k);
        Lthigh_x(k) = -Lthigh_x(k);
        Lthigh_y(k) = -Lthigh_y(k);
        Lshank_x(k) = -Lshank_x(k);
        Lshank_y(k) = -Lshank_y(k);
        Right_Foot_x(k) = -Right_Foot_x(k);
        Right_Foot_y(k) = -Right_Foot_y(k);
        Left_Foot_x(k) = -Left_Foot_x(k);
        Left_Foot_y(k) = -Left_Foot_y(k);
        Right_Toe_x(k) = -Right_Toe_x(k);
        Right_Toe_y(k) = -Right_Toe_y(k);
        Left_Toe_x(k) = -Left_Toe_x(k);
        Left_Toe_y(k) = -Left_Toe_y(k);
        neck_x(k) = -neck_x(k);
        neck_y(k) = -neck_y(k);
        L5_x(k) = -L5_x(k);
        L5_y(k) = -L5_y(k);
        L5_ax(k) = -L5_ax(k);
        L5_ay(k) = -L5_ay(k);
    end
end

Correct_CoM_x = zeros(FrameNumber,1);
Correct_CoM_y = zeros(FrameNumber,1);
Correct_L5_x = zeros(FrameNumber,1);
Correct_L5_y = zeros(FrameNumber,1);
Correct_L5_ax = zeros(FrameNumber,1);
Correct_L5_ay = zeros(FrameNumber,1);
Correct_Right_Foot_x = zeros(FrameNumber,1);
Correct_Right_Foot_y = zeros(FrameNumber,1);
Correct_Left_Foot_x = zeros(FrameNumber,1);
Correct_Left_Foot_y = zeros(FrameNumber,1);
Correct_Right_Toe_x = zeros(FrameNumber,1);
Correct_Left_Toe_x = zeros(FrameNumber,1);
Correct_Right_Toe_y = zeros(FrameNumber,1);
Correct_Left_Toe_y = zeros(FrameNumber,1);
Correct_Rthigh_x = zeros(FrameNumber,1);
Correct_Rthigh_y = zeros(FrameNumber,1);
Correct_Rshank_x = zeros(FrameNumber, 1);
Correct_Rshank_y = zeros(FrameNumber, 1);
Correct_Lthigh_x = zeros(FrameNumber,1);
Correct_Lthigh_y = zeros(FrameNumber,1);
Correct_Lshank_x = zeros(FrameNumber, 1);
Correct_Lshank_y = zeros(FrameNumber, 1);
Correct_Pelvis_ratation_z = Pelvis_ratation_z;
Correct_T12_y = zeros(FrameNumber, 1);
Correct_neck_x = zeros(FrameNumber, 1);
Correct_neck_y = zeros(FrameNumber, 1);

for k = 1:FrameNumber

    %%--二次元での回転座標変換(左手系であることに注意)--%%
    Correct_CoM_x(k) = cos(alfa) * CoM_x(k) - sin(alfa) * CoM_y(k);
    Correct_CoM_y(k) = sin(alfa) * CoM_x(k) + cos(alfa) * CoM_y(k);
    %{
    Correct_CoM_x = (CoM_x - CoM_y * tan(alfa)) * cos(alfa);  姜さんの式残しておきます
    tan=sin/cosなのでcosがかなり小さい時tanの影響が大きくなり真値から誤差が大きくなるのではないかと考えました
    Correct_CoM_y = Correct_CoM_x * tan(alfa) + CoM_y / cos(alfa);
    %}
    Correct_L5_x(k) = cos(alfa) * L5_x(k) - L5_y(k) * sin(alfa);
    Correct_L5_y(k) = sin(alfa) * L5_x(k) + L5_y(k) * cos(alfa);
    Correct_L5_ax(k) = (L5_ax(k) - L5_ay(k) * tan(alfa)) * cos(alfa);
    Correct_L5_ay(k) = Correct_L5_ax(k) * tan(alfa) + L5_ay(k) / cos(alfa);

    Correct_Rthigh_x(k) = cos(alfa) * Rthigh_x(k) - Rthigh_y(k) * sin(alfa);
    Correct_Rthigh_y(k) = sin(alfa) * Rthigh_x(k) + Rthigh_y(k) * cos(alfa);
    Correct_Rshank_x(k) = cos(alfa) * Rshank_x(k) - Rshank_y(k) * sin(alfa);
    Correct_Rshank_y(k) = sin(alfa) * Rshank_x(k) + Rshank_y(k) * cos(alfa);
    Correct_Lthigh_x(k) = cos(alfa) * Lthigh_x(k) - Lthigh_y(k) * sin(alfa);
    Correct_Lthigh_y(k) = sin(alfa) * Lthigh_x(k) + Lthigh_y(k) * cos(alfa);
    Correct_Lshank_x(k) = cos(alfa) * Lshank_x(k) - Lshank_y(k) * sin(alfa);
    Correct_Lshank_y(k) = sin(alfa) * Lshank_x(k) + Lshank_y(k) * cos(alfa);
    % foot
    Correct_Right_Foot_x(k) = cos(alfa) * Right_Foot_x(k) - sin(alfa) * Right_Foot_y(k);
    Correct_Right_Foot_y(k) = sin(alfa) * Right_Foot_x(k) + cos(alfa) * Right_Foot_y(k);
    Correct_Left_Foot_x(k) = cos(alfa) * Left_Foot_x(k) - sin(alfa) * Left_Foot_y(k);
    Correct_Left_Foot_y(k) = sin(alfa) * Left_Foot_x(k) + cos(alfa) * Left_Foot_y(k);
    %toe
    Correct_Right_Toe_x(k) = cos(alfa) * Right_Toe_x(k) - sin(alfa) * Right_Toe_y(k);
    Correct_Right_Toe_y(k) = sin(alfa) * Right_Toe_x(k) + cos(alfa) * Right_Toe_y(k);
    Correct_Left_Toe_x(k) = cos(alfa) * Left_Toe_x(k) - sin(alfa) * Left_Toe_y(k);
    Correct_Left_Toe_y(k) = sin(alfa) * Left_Toe_x(k) + cos(alfa) * Left_Toe_y(k);

    % Correct_Pelvis_ratation_z(k) = Pelvis_ratation_z(k) - rad2deg(alfa);
    Correct_T12_y(k) = sin(alfa) * T12_x(k) + cos(alfa) * T12_y(k);

    Correct_neck_x(k) = cos(alfa) * neck_x(k) - sin(alfa) * neck_y(k);
    Correct_neck_y(k) = sin(alfa) * neck_x(k) + cos(alfa) * neck_y(k);
end


%% 体幹角度（側屈・前屈）　導出
tanbeta = - (Correct_T12_y - Correct_L5_y) ./ (T12_z - L5_z);  %%要素ごとの除算は./ そうしないと行列^2のサイズになります
beta = atan(tanbeta);
Lumber_lateralFlex = rad2deg(beta);

tangamma = - (Correct_neck_y - Correct_L5_y) ./ (neck_z - L5_z);
gamma = atan(tangamma); 
toneck_lateralFlex = rad2deg(gamma);

tandelta =  (Correct_neck_x - Correct_L5_x) ./ (neck_z - L5_z);
delta = atan(tandelta); 
toneck_Flex = rad2deg(delta);

mean_lateralFlex = mean(Lumber_lateralFlex);
mean_lateralFlex_2neck = mean(toneck_lateralFlex); 

%% --ZMP算出 --%%
flt_z=IMUdata_filter(60,2,CoM_z(frame_11m_start:FrameNumber-3));

for i = 2 : FrameNumber-1
    % 2階微分の3,5,7点公式による重心加速度を計算
    CoM_ax(i) = (Correct_CoM_x(i-1) - 2*Correct_CoM_x(i) + Correct_CoM_x(i+1))/(dt*dt);
    CoM_ay(i) = (Correct_CoM_y(i-1) - 2*Correct_CoM_y(i) + Correct_CoM_y(i+1))/(dt*dt);
    % 式4.53(教科書)によるZMPを算出
    px(i) = Correct_CoM_x(i) - CoM_z(i)*CoM_ax(i)/9.8;
    py(i) = Correct_CoM_y(i) - CoM_z(i)*CoM_ay(i)/9.8;
end
if frame_11m_end > length(CoM_ay)
    frame_11m_end = length(CoM_ay)-2;
end
ZMP_x = IMUdata_filter(60,2,px(frame_11m_start:FrameNumber-3));
ZMP_y = IMUdata_filter(60,5,py(frame_11m_start:FrameNumber-3));
ZMP_x = ZMP_x';
ZMP_y = ZMP_y';

flt_ax = IMUdata_filter(60,5,CoM_ax(frame_11m_start:FrameNumber-3));
flt_ay = IMUdata_filter(60,5,CoM_ay(frame_11m_start:FrameNumber-3));
flt_ax = flt_ax';  %% 'は転置
flt_ay = flt_ay';

% max_ax = max(abs(flt_ax(frame_5m_start:frame_5m_end)));  %%加速度の最大値
% max_ay = max(abs(flt_ay(frame_5m_start:frame_5m_end)));


mean_CoM_y_3m = mean(Correct_CoM_y(1:frame_5m_start));  %姜さんの実験では加速区間での横のずれの平均を軸としている
deviation_y = abs(Correct_CoM_y - mean_CoM_y_3m)  ;
max_com_y = max(Correct_CoM_y(frame_5m_start:frame_5m_end));
min_com_y = min(Correct_CoM_y(frame_5m_start:frame_5m_end));
deviation_y2 =  abs(Correct_CoM_y)  ;
mxy = max(abs(Correct_CoM_y(frame_5m_start:frame_5m_end)));

max_dev_y = max(deviation_y(frame_5m_start:frame_5m_end));
max_dev_y2 = max(deviation_y2(frame_5m_start:frame_5m_end));
max_dev_y3 = max(Correct_CoM_y(frame_5m_start:frame_5m_end)) - min(Correct_CoM_y(frame_5m_start:frame_5m_end));

Walk_time = (frame_5m_end - frame_5m_start) * dt;
Walk_speed = 5 / Walk_time;


%% Joint Angle

Right_Knee_angle = data_Joint_Angle(:,49);
Left_Knee_angle = data_Joint_Angle(:,61);

Right_Ankle_angle = data_Joint_Angle(:,52);
Left_Ankle_angle = data_Joint_Angle(:,64);

Right_Hip_y = data_SegOrieEuler(:,48);  %%　股関節のy座標はupperlegのy座標と同じとしている
Left_Hip_y = data_SegOrieEuler(:,60);
% Hip_Fle = Right_Hip_Fle - Left_Hip_Fle;
Hip_y = Right_Hip_y - Left_Hip_y;
%% --Findpeaks - foot landing location-- %%  
%findpeakでは、指定した高さ以下のピークのみを検出することができないためｚの値をマイナスにして-0.01以上の値を導出
[~,Right_Footprint_locs] = findpeaks(-Right_Foot_z,'minpeakdistanc',20,'MinPeakHeight',-0.01);
[~,Left_Footprint_locs] = findpeaks(-Left_Foot_z,'minpeakdistanc',20,'MinPeakHeight',-0.01);

% % searching the footprints in 5m walking zoom　計測区間で足が接地した時のフレームを入手
Right_FootContact_true = Correct_Right_Foot_x(Right_Footprint_locs)>3 & Correct_Right_Foot_x(Right_Footprint_locs)<8;
Left_FootContact_true = Correct_Left_Foot_x(Left_Footprint_locs)>3 & Correct_Left_Foot_x(Left_Footprint_locs)<8;


%% ----歩幅----
%{
for k = 2:size(Right_Footprint_x)
    length_Right_Footprint(k-1) = Right_Footprint_x(k) - Right_Footprint_x(k-1);
end
for k = 2:size(Left_Footprint_x)
    length_Left_Footprint(k-1) = Left_Footprint_x(k) - Left_Footprint_x(k-1);
end
効率化するためにこのコードを消します
%}

tree = load_mvnx(input_file_name_mvnx);
if isfield(tree,'footContact')
    left_heel_contact = tree.footContact(1).footContacts; %左足，かかと，接地
    left_toe_contact = tree.footContact(2).footContacts;  %左足，つま先，接地
    left_foot_contact = left_heel_contact | left_toe_contact;  %左足 つま先かかかとどちらかが接していたら１
    right_heel_contact = tree.footContact(3).footContacts; %右足，かかと，接地
    right_toe_contact = tree.footContact(4).footContacts;  %右足，つま先，接地
    right_foot_contact = right_heel_contact | right_toe_contact;  
end
right_foot_contact_in5m = right_foot_contact(frame_5m_start:frame_5m_end);
left_foot_contact_in5m = left_foot_contact(frame_5m_start:frame_5m_end);

%% --歩行周期・立脚時間導出-- %% 
%{
right_foot_contact_in5m　計測区間5mでの足部接地判定
contact_frame　0から1になるタイミング＝足部に接地するタイミング
contact_end_frame　1から0になるタイミング＝足部が離地するタイミング
valid_contact_frame　すり足対策で、足部離地から足部接地が20フレーム以下のものを削除
測定開始から5m計測区間までのフレーム数を再度追加して
%}
Rcontact_frame = find([0;diff(right_foot_contact_in5m)==1;0]);
Rcontact_end_frame = find([0; diff(right_foot_contact_in5m) == -1; 0]);
if Rcontact_end_frame(1) < Rcontact_frame(1)
    Rcontact_end_frame = Rcontact_end_frame(2:end);
end
if Rcontact_end_frame(end) < Rcontact_frame(end)
    Rcontact_frame = Rcontact_frame(1:end-1);
end

Lcontact_frame = find([0;diff(left_foot_contact_in5m)==1;0]);
Lcontact_end_frame = find([0; diff(left_foot_contact_in5m) == -1; 0]);
if Lcontact_end_frame(1) < Lcontact_frame(1)
    Lcontact_end_frame = Lcontact_end_frame(2:end);
end
if Lcontact_end_frame(end) < Lcontact_frame(end)
    Lcontact_frame = Lcontact_frame(1:end-1);
end
min_contact_duration = 20; % 最小連続接地フレーム数
valid_Rcontact_frame = [];
valid_Rcontact_end_frame = [];
for i = 1:length(Rcontact_frame)
    if (Rcontact_end_frame(i) - Rcontact_frame(i)) >= min_contact_duration
        valid_Rcontact_frame = [valid_Rcontact_frame, Rcontact_frame(i)];
        valid_Rcontact_end_frame = [valid_Rcontact_end_frame, Rcontact_end_frame(i)];
    end
end
valid_Lcontact_frame = [];
valid_Lcontact_end_frame = [];
for i = 1:length(Lcontact_frame)
    if (Lcontact_end_frame(i) - Lcontact_frame(i)) >= min_contact_duration
        valid_Lcontact_frame = [valid_Lcontact_frame, Lcontact_frame(i)];
        valid_Lcontact_end_frame = [valid_Lcontact_end_frame, Lcontact_end_frame(i)];
    end
end
%% --単脚支持期の時間を導出20250901-- %% 
%{
num_frames_in5m 計測区間5mのフレーム数 101～200フレームの場合100個配列あるのに99個になってしまうため+1している
valid_R_foot_contact　すり足対策を行った足部接地の論理配列を更新
R_ss_start  single support start
%}
num_frames_in5m = frame_5m_end - frame_5m_start + 1;
valid_R_foot_contact = false(1, num_frames_in5m);
valid_L_foot_contact = false(1, num_frames_in5m);
for i=1:length(valid_Rcontact_frame)
    start_frame = valid_Rcontact_frame(i);
    end_frame = valid_Rcontact_end_frame(i);
    valid_R_foot_contact(start_frame:end_frame) = true;
end
for i=1:length(valid_Lcontact_frame)
    start_frame = valid_Lcontact_frame(i);
    end_frame = valid_Lcontact_end_frame(i);
    valid_L_foot_contact(start_frame:end_frame) = true;
end
right_single_support = valid_R_foot_contact & ~valid_L_foot_contact;
R_ss_start = find(diff([0, right_single_support]) == 1);
R_ss_end = find(diff([right_single_support, 0]) == -1);
R_ss_time = (R_ss_end - R_ss_start) * dt;
mean_R_ss_time = mean(R_ss_time);

left_single_support = valid_L_foot_contact & ~valid_R_foot_contact;
L_ss_start = find(diff([0, left_single_support]) == 1);
L_ss_end = find(diff([left_single_support, 0]) == -1);
L_ss_time = (L_ss_end - L_ss_start) * dt;
mean_L_ss_time = mean(L_ss_time);

valid_Rcontact_frame = valid_Rcontact_frame + frame_5m_start;
valid_Rcontact_end_frame = valid_Rcontact_end_frame + frame_5m_start;
valid_Lcontact_frame = valid_Lcontact_frame + frame_5m_start;
valid_Lcontact_end_frame = valid_Lcontact_end_frame + frame_5m_start;
% 歩幅   20250212歩幅の計算の仕方
length_Right_Footprint = [];
length_Left_Footprint = [];

if  Correct_Right_Foot_x(valid_Rcontact_frame(1)) > Correct_Left_Foot_x(valid_Lcontact_frame(1))   % 右脚が先に計測区間に入ったとき
    num_contact_frame = min(length(valid_Rcontact_frame), length(valid_Lcontact_frame));   % 20250827 sub17のデータを変換するときエラーが発生 valid_Rcontact_frameの配列数とvalid_Lcontact_frameの配列数が違うため生じたと考えられる
    for i=1:num_contact_frame % length(valid_Rcontact_frame)
        Rstep_length = abs(Correct_Right_Foot_x(valid_Rcontact_frame(i)) - Correct_Left_Foot_x(valid_Lcontact_frame(i)));
        length_Right_Footprint = [length_Right_Footprint; Rstep_length];
    end
    for i=1:num_contact_frame-1  % length(valid_Lcontact_frame)-1
        Lstep_length = abs(Correct_Left_Foot_x(valid_Lcontact_frame(i+1)) - Correct_Right_Foot_x(valid_Rcontact_frame(i)));
        length_Left_Footprint = [length_Left_Footprint; Lstep_length];
    end
elseif  Correct_Right_Foot_x(valid_Rcontact_frame(1)) < Correct_Left_Foot_x(valid_Lcontact_frame(1))
    num_contact_frame = min(length(valid_Rcontact_frame), length(valid_Lcontact_frame));
    for i=1:num_contact_frame-1
        Rstep_length = abs(Correct_Right_Foot_x(valid_Rcontact_frame(i+1)) - Correct_Left_Foot_x(valid_Lcontact_frame(i)));
        length_Right_Footprint = [length_Right_Footprint; Rstep_length];
    end
    for i=1:num_contact_frame
        Lstep_length = abs(Correct_Left_Foot_x(valid_Lcontact_frame(i)) - Correct_Right_Foot_x(valid_Rcontact_frame(i)));
        length_Left_Footprint = [length_Left_Footprint; Lstep_length];
    end
end

Right_StepLength_mean = mean(length_Right_Footprint);
Left_StepLength_mean = mean(length_Left_Footprint);
Right_StepLength_std = std(length_Right_Footprint);
Left_StepLength_std = std(length_Left_Footprint);

% 重複歩幅
double_support_length_Right_Footprint = [];
% valid_Rcontact_frame = valid_Rcontact_frame + frame_5m_start;
% valid_Rcontact_end_frame = valid_Rcontact_end_frame + frame_5m_start;
% valid_Lcontact_frame = valid_Lcontact_frame + frame_5m_start;
% valid_Lcontact_end_frame = valid_Lcontact_end_frame + frame_5m_start;

for i=1:length(valid_Rcontact_frame)-1
double_support_Rstep_length = sqrt( (Correct_Right_Foot_x(valid_Rcontact_frame(i+1)) - Correct_Right_Foot_x(valid_Rcontact_frame(i)))^2 + (Correct_Right_Foot_y(valid_Rcontact_frame(i+1)) - Correct_Right_Foot_y(valid_Rcontact_frame(i)))^2 );
double_support_length_Right_Footprint = [double_support_length_Right_Footprint; double_support_Rstep_length];
end
double_support_length_Left_Footprint = [];
for i=1:length(valid_Lcontact_frame)-1
double_support_Lstep_length = sqrt( (Correct_Left_Foot_x(valid_Lcontact_frame(i+1)) - Correct_Left_Foot_x(valid_Lcontact_frame(i)))^2 + (Correct_Left_Foot_y(valid_Lcontact_frame(i+1)) - Correct_Left_Foot_y(valid_Lcontact_frame(i)))^2 );
double_support_length_Left_Footprint = [double_support_length_Left_Footprint; double_support_Lstep_length];
end

double_support_Right_StepLength_mean = mean(double_support_length_Right_Footprint);
double_support_Left_StepLength_mean = mean(double_support_length_Left_Footprint);
double_support_Right_StepLength_std = std(double_support_length_Right_Footprint);
double_support_Left_StepLength_std = std(double_support_length_Left_Footprint);
StepLength_mean = (Right_StepLength_mean + Left_StepLength_mean) / 2;
SI_step = 2 * abs(Right_StepLength_mean - Left_StepLength_mean) / (Right_StepLength_mean + Left_StepLength_mean);

for i=1:length(valid_Lcontact_frame)-1
    Lstep_framelen(i) = valid_Lcontact_frame(i+1) - valid_Lcontact_frame(i);
end
for i=1:length(valid_Rcontact_frame)-1
    Rstep_framelen(i) = valid_Rcontact_frame(i+1) - valid_Rcontact_frame(i);
end

Lstep_cycle_time = (Lstep_framelen * dt)';
Rstep_cycle_time = (Rstep_framelen * dt)';
Lstep_cycle_mean = mean(Lstep_cycle_time);
Rstep_cycle_mean = mean(Rstep_cycle_time);
Lstep_std_time = std(Lstep_cycle_time);
Rstep_std_time = std(Rstep_cycle_time);
step_cycle_mean = (Rstep_cycle_mean + Lstep_cycle_mean) / 2;
for i=1:length(valid_Lcontact_frame)
    Lstance_framelen(i) = valid_Lcontact_end_frame(i) - valid_Lcontact_frame(i);
end
Lstance_time = (Lstance_framelen * dt)';
Lstance_time_mean = mean(Lstance_time);
Lstance_time_std = std(Lstance_time);

if length(Lstep_cycle_time) < length(Lstance_time)
    Lstance_time = Lstance_time(1:end-1);
end

Lswing_time = Lstep_cycle_time - Lstance_time;

Lswing_time_mean = mean(Lswing_time);
Lswing_time_std = std(Lswing_time);

for i=1:length(valid_Rcontact_frame)
    Rstance_framelen(i) = valid_Rcontact_end_frame(i) - valid_Rcontact_frame(i);
end
Rstance_time = (Rstance_framelen * dt)';
Rstance_time_mean = mean(Rstance_time);
Rstance_time_std = std(Rstance_time);
if length(Rstep_cycle_time) < length(Rstance_time)
    Rstance_time = Rstance_time(1:end-1);
end
Rswing_time = Rstep_cycle_time - Rstance_time;
Rswing_time_mean = mean(Rswing_time);
Rswing_time_std = std(Rswing_time);
SI_time = 2*abs(Lstance_time_mean-Rstance_time_mean) / (Lstance_time_mean+Rstance_time_mean);

%%歩数 歩行率の計算

right_Num_of_step = length(valid_Rcontact_frame);
left_Num_of_step = length(valid_Lcontact_frame);
Num_of_Step = right_Num_of_step + left_Num_of_step;  %% 測定開始ラインに足が接地している時はカウントしていない

first_contact_within5m = min(valid_Rcontact_frame(1), valid_Lcontact_frame(1));
last_contact_within5m = max(valid_Rcontact_frame(end), valid_Rcontact_frame(end));
Walk_time_4rate = last_contact_within5m - first_contact_within5m;
Walking_Rate = Num_of_Step / Walk_time_4rate;
walkrate_steplen = Walking_Rate / StepLength_mean;

hokaku_right = [];
hokaku_left = [];
for i=1:length(valid_Rcontact_frame)
    Right_Footprint_x(i) = Correct_Right_Foot_x(valid_Rcontact_frame(i));  %接地足の座標
    Right_Footprint_y(i) = Correct_Right_Foot_y(valid_Rcontact_frame(i));
end
for i=1:length(valid_Lcontact_frame)
    Left_Footprint_x(i) = Correct_Left_Foot_x(valid_Lcontact_frame(i));
    Left_Footprint_y(i) = Correct_Left_Foot_y(valid_Lcontact_frame(i));
end
if Right_Footprint_x(1) > Left_Footprint_x(1)
    % 右歩隔
    for k = 1:min(length(Right_Footprint_y),length(Left_Footprint_y))
        hokaku_right(k) = Right_Footprint_y(k) - Left_Footprint_y(k);
    end
    % 左歩隔
    for k = 2:min(length(Right_Footprint_y),length(Left_Footprint_y))
        hokaku_left(k-1) = Left_Footprint_y(k) - Right_Footprint_y(k-1);
    end
else
    % 左歩隔
    for k = 1:min(length(Right_Footprint_y),length(Left_Footprint_y))
        hokaku_left(k) = Left_Footprint_y(k) - Right_Footprint_y(k);
    end
    % 右歩隔
    for k = 2:min(length(Right_Footprint_y),length(Left_Footprint_y))
        hokaku_right(k-1) = Right_Footprint_y(k) - Left_Footprint_y(k-1);
    end
end

hokaku_right = (abs(hokaku_right))';
hokaku_left = (abs(hokaku_left))';
hokakuR_mean = mean(hokaku_right);
hokakuR_std = std(hokaku_right);
hokakuL_mean = mean(hokaku_left);
hokakuL_std = std(hokaku_left);
StepWidth_mean	= (hokakuL_mean + hokakuR_mean)/2;

%% --1ページ目に
%% ********** 以上,データ計算 **********
%% 所定の区間のエクセル出力，各データごとに列をつくる
% 5m区間と11m区間の範囲のシートをそれぞれ作る．
% 重心 Correct_CoM_x, Correct_CoM_y, CoM_z
% 股関節 Right_Hip_y, Left_Hip_y
% 膝関節 Right_Knee_angle,Left_Knee_angle
% 足関節 Right_Ankle_angle,Left_Ankle_angle

A_t = "CoM_x";
B_t = "CoM_y";
C_t = "CoM_z";
D_t = "Right Upper Leg y";
E_t = "Left Upper Leg y";
F_t = "Hip_joint_angle";
G_t = "Right_Knee_angle";
H_t = "Left_Knee_angle";
I_t = "Right_Ankle_angle";
J_t = "Left_Ankle_angle";
K_t = "Right_Foot_Contact";
L_t = "Left_Foot_Contact";
M_t = "Right_Foot_pos_x";
N_t = "Left_Foot_pos_x";
O_t = "Right_Foot_pos_y";
P_t = "Left_Foot_pos_y";
Q_t = "Correct_L5_ax";
R_t = "Correct_L5_ay";
S_t = "Correct_L5_ay_0.5";
T_t = "Correct_L5_ay_1";
U_t = "Correct_L5_ay_2";
V_t = "Correct_L5_ay_5";
W_t = "CoM_ay";
X_t = "CoM_ay_0.5";
Y_t = "CoM_ay_1";
Z_t = "CoM_ay_2";
AA_t = "CoM_ay_5";
AB_t = "L5_y";
AC_t = "Right_Hip_abduction";
AD_t = "Left_Hip_abduction";
AE_t = "ZMP_x";
AF_t = "ZMP_y";
AG_t = "Right Toe Clearance";
AH_t = "Left Toe Clearance";
AI_t = "CoM_x Acceralation";
AJ_t = "Right Upper Leg x";
AK_t = "Right Upper Leg z";
AL_t = "Right Lower Leg x";
AM_t = "Right Lower Leg z";
AN_t = "Right Foot x";
AO_t = "Left Upper Leg x";
AP_t = "Left Upper Leg z";
AQ_t = "Left Lower Leg x";
AR_t = "Left Lower Leg z";
AS_t = "Left Foot x";
AT_t = "Right Toe x";
AU_t = "Left Toe x";
AV_t = "Right Hip Rotation";
AW_t = "Right Hip Extension";
AX_t = "Left Hip Rotation";
AY_t = "Left Hip Extension";
AZ_t = "Pelvis Rotation H-plane(R:+ L:-)";
BA_t = "Lumber Lateral Flexion";
BB_t = "Pelvis to Neck Lateral Flexion";
BC_t = "Pelvis to Neck Flexion";
BD_t = "Right Toe y";
BE_t = "Left Toe y";
BF_t = "Neck x";
BG_t = "Neck y";
BH_t = "CoM az";
BI_t = "CoM vz";    % velocity of z-axis (veritical)
BJ_t = "L5_x";
BK_t = "L5_z";
BL_t = "Right Foot z"; 
BM_t = "Left Foot z";

A_5 = Correct_CoM_x(frame_5m_start:frame_5m_end);
B_5 = Correct_CoM_y(frame_5m_start:frame_5m_end);
C_5 = CoM_z(frame_5m_start:frame_5m_end);
D_5 = Correct_Rthigh_y(frame_5m_start:frame_5m_end);
E_5 = Correct_Lthigh_y(frame_5m_start:frame_5m_end);
F_5 = Hip_y(frame_5m_start:frame_5m_end);
G_5 = Right_Knee_angle(frame_5m_start:frame_5m_end);
H_5 = Left_Knee_angle(frame_5m_start:frame_5m_end);
I_5 = Right_Ankle_angle(frame_5m_start:frame_5m_end);
J_5 = Left_Ankle_angle(frame_5m_start:frame_5m_end);
K_5 = right_foot_contact(frame_5m_start:frame_5m_end);
L_5 = left_foot_contact(frame_5m_start:frame_5m_end);
M_5 = Correct_Right_Foot_x(frame_5m_start:frame_5m_end);
N_5 = Correct_Left_Foot_x(frame_5m_start:frame_5m_end);
O_5 = Correct_Right_Foot_y(frame_5m_start:frame_5m_end);
P_5 = Correct_Left_Foot_y(frame_5m_start:frame_5m_end);
Q_5 = Correct_L5_ax(frame_5m_start:frame_5m_end);
R_5 = Correct_L5_ay(frame_5m_start:frame_5m_end);
S_5 = IMUdata_filter(60,0.5,Correct_L5_ay(frame_5m_start:frame_5m_end));
T_5 = IMUdata_filter(60,1,Correct_L5_ay(frame_5m_start:frame_5m_end));
U_5 = IMUdata_filter(60,2,Correct_L5_ay(frame_5m_start:frame_5m_end));
V_5 = IMUdata_filter(60,5,Correct_L5_ay(frame_5m_start:frame_5m_end));
W_5 = CoM_ay(frame_5m_start:frame_5m_end);
X_5 = IMUdata_filter(60,0.5,CoM_ay(frame_5m_start:frame_5m_end));
Y_5 = IMUdata_filter(60,1,CoM_ay(frame_5m_start:frame_5m_end));   %CoM_ayはCorrect_CoMから算出している　Correctっていうのがちょっとわかりにくいっすよね　
Z_5 = IMUdata_filter(60,2,CoM_ay(frame_5m_start:frame_5m_end));
AA_5 = IMUdata_filter(60,5,CoM_ay(frame_5m_start:frame_5m_end));
AB_5 = Correct_L5_y(frame_5m_start:frame_5m_end);
AC_5 = Right_Hip_abad(frame_5m_start:frame_5m_end);
AD_5 = Left_Hip_abad(frame_5m_start:frame_5m_end);
AE_5 = ZMP_x(frame_5m_start:frame_5m_end);
AF_5 = ZMP_y(frame_5m_start:frame_5m_end);
AG_5 = Right_Toe_z(frame_5m_start:frame_5m_end);
AH_5 = Left_Toe_z(frame_5m_start:frame_5m_end);
AI_5 = CoM_ax(frame_5m_start:frame_5m_end);
AJ_5 = Correct_Rthigh_x(frame_5m_start:frame_5m_end);
AK_5 = Rthigh_z(frame_5m_start:frame_5m_end);
AL_5 = Correct_Rshank_x(frame_5m_start:frame_5m_end);
AM_5 = Rshank_z(frame_5m_start:frame_5m_end);
AN_5 = Correct_Right_Foot_x(frame_5m_start:frame_5m_end);
AO_5 = Correct_Lthigh_x(frame_5m_start:frame_5m_end);
AP_5 = Lthigh_z(frame_5m_start:frame_5m_end);
AQ_5 = Correct_Lshank_x(frame_5m_start:frame_5m_end);
AR_5 = Lshank_z(frame_5m_start:frame_5m_end);
AS_5 = Correct_Left_Foot_x(frame_5m_start:frame_5m_end);
AT_5 = Correct_Right_Toe_x(frame_5m_start:frame_5m_end);
AU_5 = Correct_Left_Toe_x(frame_5m_start:frame_5m_end);
AV_5 = Right_Hip_rotation(frame_5m_start:frame_5m_end);
AW_5 = Right_Hip_Extention(frame_5m_start:frame_5m_end);
AX_5 = Left_Hip_rotation(frame_5m_start:frame_5m_end);
AY_5 = Left_Hip_Extension(frame_5m_start:frame_5m_end);
AZ_5 = Correct_Pelvis_ratation_z(frame_5m_start:frame_5m_end);
BA_5 = Lumber_lateralFlex(frame_5m_start:frame_5m_end);
BB_5 = toneck_lateralFlex(frame_5m_start:frame_5m_end);
BC_5 = toneck_Flex(frame_5m_start:frame_5m_end);
BD_5 = Correct_Right_Toe_y(frame_5m_start:frame_5m_end);
BE_5 = Correct_Left_Toe_y(frame_5m_start:frame_5m_end);
BF_5 = Correct_neck_x(frame_5m_start:frame_5m_end);
BG_5 = Correct_neck_y(frame_5m_start:frame_5m_end);
BH_5 = CoM_az(frame_5m_start:frame_5m_end);
BI_5 = CoM_vz(frame_5m_start:frame_5m_end);
BJ_5 = Correct_L5_x(frame_5m_start:frame_5m_end);
BK_5 = L5_z(frame_5m_start:frame_5m_end);
BL_5 = Right_Foot_z(frame_5m_start:frame_5m_end);
BM_5 = Left_Foot_z(frame_5m_start:frame_5m_end);

A_11 = Correct_CoM_x(frame_11m_start:frame_11m_end);
B_11 = Correct_CoM_y(frame_11m_start:frame_11m_end);
C_11 = CoM_z(frame_11m_start:frame_11m_end);
D_11 = Correct_Rthigh_y(frame_11m_start:frame_11m_end);
E_11 = Correct_Lthigh_y(frame_11m_start:frame_11m_end);
F_11 = Hip_y(frame_11m_start:frame_11m_end);
G_11 = Right_Knee_angle(frame_11m_start:frame_11m_end);
H_11 = Left_Knee_angle(frame_11m_start:frame_11m_end);
I_11 = Right_Ankle_angle(frame_11m_start:frame_11m_end);
J_11 = Left_Knee_angle(frame_11m_start:frame_11m_end);
K_11 = right_foot_contact(frame_11m_start:frame_11m_end);
L_11 = left_foot_contact(frame_11m_start:frame_11m_end);
M_11 = Correct_Right_Foot_x(frame_11m_start:frame_11m_end);
N_11 = Correct_Left_Foot_x(frame_11m_start:frame_11m_end);
O_11 = Correct_Right_Foot_y(frame_11m_start:frame_11m_end);
P_11 = Correct_Left_Foot_y(frame_11m_start:frame_11m_end);
Q_11 = Correct_L5_ax(frame_11m_start:frame_11m_end);
R_11 = Correct_L5_ay(frame_11m_start:frame_11m_end);
S_11 = IMUdata_filter(60,0.5,Correct_L5_ay(frame_11m_start:frame_11m_end));
T_11 = IMUdata_filter(60,1,Correct_L5_ay(frame_11m_start:frame_11m_end));
U_11 = IMUdata_filter(60,2,Correct_L5_ay(frame_11m_start:frame_11m_end));
V_11 = IMUdata_filter(60,5,Correct_L5_ay(frame_11m_start:frame_11m_end));
W_11 = CoM_ay(frame_11m_start:frame_11m_end);
X_11 = IMUdata_filter(60,0.5,CoM_ay(frame_11m_start:frame_11m_end));
Y_11 = IMUdata_filter(60,1,CoM_ay(frame_11m_start:frame_11m_end));
Z_11 = IMUdata_filter(60,2,CoM_ay(frame_11m_start:frame_11m_end));
AA_11 = IMUdata_filter(60,5,CoM_ay(frame_11m_start:frame_11m_end));
AB_11 = Correct_L5_y(frame_11m_start:frame_11m_end);
AC_11 = Right_Hip_abad(frame_11m_start:frame_11m_end);
AD_11 = Left_Hip_abad(frame_11m_start:frame_11m_end);
AE_11 = ZMP_x(frame_11m_start:frame_11m_end);
AF_11 = ZMP_y(frame_11m_start:frame_11m_end);
AG_11 = Right_Toe_z(frame_11m_start:frame_11m_end);
AH_11 = Left_Toe_z(frame_11m_start:frame_11m_end);
AI_11 = CoM_ax(frame_11m_start:frame_11m_end);
AJ_11 = Correct_Rthigh_x(frame_11m_start:frame_11m_end);
AK_11 = Rthigh_z(frame_11m_start:frame_11m_end);
AL_11 = Correct_Rshank_x(frame_11m_start:frame_11m_end);
AM_11 = Rshank_z(frame_11m_start:frame_11m_end);
AN_11 = Correct_Right_Foot_x(frame_11m_start:frame_11m_end);
AO_11 = Correct_Lthigh_x(frame_11m_start:frame_11m_end);
AP_11 = Lthigh_z(frame_11m_start:frame_11m_end);
AQ_11 = Correct_Lshank_x(frame_11m_start:frame_11m_end);
AR_11 = Lshank_z(frame_11m_start:frame_11m_end);
AS_11 = Correct_Left_Foot_x(frame_11m_start:frame_11m_end);
AT_11 = Correct_Right_Toe_x(frame_11m_start:frame_11m_end);
AU_11 = Correct_Left_Toe_x(frame_11m_start:frame_11m_end);
AV_11 = Right_Hip_rotation(frame_11m_start:frame_11m_end);
AW_11 = Right_Hip_Extention(frame_11m_start:frame_11m_end);
AX_11 = Left_Hip_rotation(frame_11m_start:frame_11m_end);
AY_11 = Left_Hip_Extension(frame_11m_start:frame_11m_end);
AZ_11 = Correct_Pelvis_ratation_z(frame_11m_start:frame_11m_end);
BA_11 = Lumber_lateralFlex(frame_11m_start:frame_11m_end);
BB_11 = toneck_lateralFlex(frame_11m_start:frame_11m_end);
BC_11 = toneck_Flex(frame_11m_start:frame_11m_end);
BD_11 = Correct_Right_Toe_y(frame_11m_start:frame_11m_end);
BE_11 = Correct_Left_Toe_y(frame_11m_start:frame_11m_end);
BF_11 = Correct_neck_x(frame_11m_start:frame_11m_end);
BG_11 = Correct_neck_y(frame_11m_start:frame_11m_end);
BH_11 = CoM_az(frame_11m_start:frame_11m_end);
BI_11 = CoM_vz(frame_11m_start:frame_11m_end);
BJ_11 = Correct_L5_x(frame_11m_start:frame_11m_end);
BK_11 = L5_z(frame_11m_start:frame_11m_end);
BL_11 = Right_Foot_z(frame_11m_start:frame_11m_end);
BM_11 = Left_Foot_z(frame_11m_start:frame_11m_end);

A1 = "Walk Speed";
B1 = "Step Length";
C1 = "Step Length Right";
D1 = "Step Length Left";
E1 = "Step Width";
F1 = "Number of Steps";
G1 = "Walking Rate";
H1 = "Step Length / Walking Rate";
I1 = "SI step";
J1 = "Right Stance time";
K1 = "Left Stance time";
L1 = "SI time";
M1 = "Right Step Cycle";
N1 = "Left Step Cycle";
O1 = "Step Cycle";
P1 = "STD Right step cycle";
Q1 = "STD Left step cycle";
R1 = "Lumber Lateral Flexion mean";
S1 = "neck to pelvis Lateral Flexion mean";
T1 = "Right Single Support time";
U1 = "Left Single Support time";

% エクセルに出力するテーブル
table1_variable = [A1, B1, C1, D1, E1, F1, G1, H1, I1, J1, K1, L1, M1, N1, O1, P1, Q1, R1, S1, T1, U1];
output_table1 = [Walk_speed , StepLength_mean, Right_StepLength_mean, Left_StepLength_mean, ...
    StepWidth_mean, Num_of_Step, Walking_Rate, walkrate_steplen, SI_step, Rstance_time_mean, ...
    Lstance_time_mean, SI_time, Rstep_cycle_mean, Lstep_cycle_mean, step_cycle_mean, Rstep_std_time, ...
    Lstep_std_time,mean_lateralFlex,mean_lateralFlex_2neck,mean_R_ss_time,mean_L_ss_time];
output_title_table = [A_t, B_t, C_t, D_t, E_t, F_t, G_t, H_t, I_t, J_t, K_t,L_t,M_t,N_t,O_t,P_t,Q_t,R_t,S_t,T_t,U_t,V_t,W_t,X_t,Y_t,Z_t,...
    AA_t,AB_t,AC_t,AD_t,AE_t,AF_t,AG_t,AH_t,AI_t,AJ_t,AK_t,AL_t,AM_t,AN_t,AO_t,AP_t,AQ_t,AR_t,AS_t,AT_t,AU_t,AV_t,AW_t,AX_t,AY_t,AZ_t,...
    BA_t,BB_t,BC_t,BD_t,BE_t,BF_t,BG_t,BH_t,BI_t,BJ_t,BK_t,BL_t,BM_t];
output_matrix_5m = [A_5,B_5,C_5,D_5,E_5,F_5,G_5,H_5,I_5,J_5,K_5,L_5,M_5,N_5,O_5,P_5,Q_5,R_5,S_5,T_5,U_5,V_5,W_5',X_5',Y_5',Z_5',...
    AA_5',AB_5,AC_5,AD_5,AE_5,AF_5,AG_5,AH_5,AI_5',AJ_5,AK_5,AL_5,AM_5, AN_5,AO_5,AP_5,AQ_5,AR_5,AS_5,AT_5,AU_5,AV_5,AW_5,AX_5,AY_5,AZ_5,...
    BA_5,BB_5,BC_5,BD_5,BE_5,BF_5,BG_5,BH_5,BI_5,BJ_5,BK_5,BL_5,BM_5];
output_matrix_11m = [A_11,B_11,C_11,D_11,E_11,F_11,G_11,H_11,I_11,J_11,K_11,L_11,M_11,N_11,O_11,P_11,Q_11,R_11,S_11,T_11,U_11,V_11,W_11',X_11',Y_11',Z_11',...
    AA_11',AB_11,AC_11,AD_11,AE_11,AF_11,AG_11,AH_11,AI_11',AJ_11,AK_11,AL_11,AM_11,AN_11,AO_11,AP_11,AQ_11,AR_11,AS_11,AT_11,AU_11,AV_11,AW_11,AX_11,AY_11,AZ_11,...
    BA_11,BB_11,BC_11,BD_11,BE_11,BF_11,BG_11,BH_11,BI_11,BJ_11,BK_11,BL_11,BM_11];
%% エクセルに出力 シートごとに出力を変える　
[path, name, ~] = fileparts(input_file_name_xlsx);
filename = fullfile(path, ['Modified_', name, '.xlsx']);

num_steps = max([length(double_support_length_Right_Footprint),length(double_support_length_Left_Footprint),...
    length(length_Right_Footprint),length(length_Left_Footprint),length(Rstep_cycle_time), length(Lstep_cycle_time), length(hokaku_right),length(hokaku_left)]);

% NaNでデータを埋める関数
pad_with_nan = @(x) [x; nan(num_steps - length(x), 1)];
double_support_length_Right_Footprint = pad_with_nan(double_support_length_Right_Footprint);
double_support_length_Left_Footprint = pad_with_nan(double_support_length_Left_Footprint);
length_Right_Footprint = pad_with_nan(length_Right_Footprint);
length_Left_Footprint = pad_with_nan(length_Left_Footprint);
Lstep_cycle_time = pad_with_nan(Lstep_cycle_time);
Rstep_cycle_time = pad_with_nan(Rstep_cycle_time);
Lstance_time = pad_with_nan(Lstance_time);
Lswing_time = pad_with_nan(Lswing_time);
Rstance_time = pad_with_nan(Rstance_time);
Rswing_time = pad_with_nan(Rswing_time);
hokaku_right = pad_with_nan(hokaku_right);
hokaku_left = pad_with_nan(hokaku_left);

step_numbers = (1:num_steps)';

step_data = [step_numbers, double_support_length_Right_Footprint, double_support_length_Left_Footprint, length_Right_Footprint, length_Left_Footprint,...
    Rstep_cycle_time, Lstep_cycle_time, Rstance_time, Lstance_time, Rswing_time, Lswing_time, hokaku_right, hokaku_left];
mean_values = [double_support_Right_StepLength_mean, double_support_Left_StepLength_mean, Right_StepLength_mean, Left_StepLength_mean,...
    Rstep_cycle_mean, Lstep_cycle_mean, Rstance_time_mean, Lstance_time_mean, Rswing_time_mean, Lswing_time_mean, hokakuR_mean, hokakuL_mean];
mean_row = [{'Mean'}, num2cell(mean_values)];

std_values = [double_support_Right_StepLength_std, double_support_Left_StepLength_std, Right_StepLength_std, Left_StepLength_std,Rstep_std_time,Lstep_std_time,...
    Rstance_time_std, Lstance_time_std, Rswing_time_std, Lswing_time_std, hokakuR_std, hokakuL_std];
std_row = [{'Std'}, num2cell(std_values)];

columns_name = {'Step No.', 'R double step length', 'L double step length','R step length','L step length', 'R walking cycle', 'L walking cycle',...
    'R stance time', 'L stance time', 'R swing time', 'L swing time', 'R step width', 'L step width'};
step_data_all = [num2cell(step_data); mean_row; std_row];

step_table = cell2table(step_data_all, 'VariableNames',columns_name);

if isfile(filename)
    delete(filename);
    disp(['ファイル "' filename '" は既に存在するので上書きします。']);
end

writematrix([table1_variable; output_table1], filename, 'Sheet', '歩容特性','Range','A1');
writetable(step_table, filename, 'Sheet', '歩容特性', 'Range', 'A10');
writematrix([output_title_table; output_matrix_5m], filename, 'Sheet', '時系列データ 5m');
writematrix([output_title_table; output_matrix_11m], filename, 'Sheet', '時系列データ 11m');
end

