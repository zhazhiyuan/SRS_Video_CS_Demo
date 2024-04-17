clc
clear
m_10_1=0; 
m_10_2=0; 
m_10_3=0; 
m_20_1=0; 
m_20_2=0; 
m_20_3=0; 
m_30_1=0; 
m_30_2=0; 
m_30_3=0; 
m_40_1=0;
m_40_2=0; 
m_40_3=0; 
m_50_1=0;
m_50_2=0; 
m_50_3=0; 
m_75_1=0;
m_75_2=0; 
m_75_3=0; 
m_100_1=0;
m_100_2=0; 
m_100_3=0; 

All_data_Results_10_1 = cell(1,200);
All_data_Results_10_2 = cell(1,200);
All_data_Results_10_3 = cell(1,200);

All_data_Results_20_1 = cell(1,200);
All_data_Results_20_2 = cell(1,200);
All_data_Results_20_3 = cell(1,200);

All_data_Results_30_1 = cell(1,200);
All_data_Results_30_2 = cell(1,200);
All_data_Results_30_3 = cell(1,200);

All_data_Results_40_1 = cell(1,200);
All_data_Results_40_2 = cell(1,200);
All_data_Results_40_3 = cell(1,200);

All_data_Results_50_1 = cell(1,200);
All_data_Results_50_2 = cell(1,200);
All_data_Results_50_3 = cell(1,200);

All_data_Results_75_1 = cell(1,200);
All_data_Results_75_2 = cell(1,200);
All_data_Results_75_3 = cell(1,200);

All_data_Results_100_1 = cell(1,200);
All_data_Results_100_2 = cell(1,200);
All_data_Results_100_3 = cell(1,200);



for i = 1:16
    
ImageNum =i;

switch ImageNum
         case 1
                filename = 'akiyo_cif';
            case 2
                filename = 'bus_cif';
            case 3
                filename = 'carphone_qcif';
            case 4
                filename = 'coastguard_cif';    
            case 5
                filename = 'container_cif'; 
                
            case 6
                filename = 'flower_cif';
            case 7
                filename = 'foreman_cif';
            case 8
                filename = 'hall_cif';
            case 9
                filename = 'mobile_cif';    
            case 10
                filename = 'mother-daughter_cif'; 
                
            case 11
                filename = 'news_cif';
            case 12
                filename = 'salesman_qcif';
            case 13
                filename = 'silent_cif';     
                
            case 14
                filename = 'stefan_cif';
            case 15
                filename = 'tempete_cif';
            case 16
                filename = 'waterfall_cif';
    
end


%Fn           = [filename, '.yuv'];


 [all_frames,numframes]                   =      yuv2rgb(filename);
 
 
 for i  = 1: numframes
     
     
     aa =   double(all_frames(:,:,:,i));
     
Final_denoisng= strcat(filename,'_i_',num2str(i),'.png');
 
imwrite(uint8(aa),strcat('./Ori_Video/',Final_denoisng));       
     
 end
 
 
 
 

 
end