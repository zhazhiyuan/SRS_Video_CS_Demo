clc
clear
m_20=0; 
m_30=0;    
m_40=0;  
m_10=0;  
m_50=0; 
m_60=0; 

All_data_Results_2_20 = cell(1,200);
All_data_Results_2_30 = cell(1,200);
All_data_Results_2_40 = cell(1,200);
All_data_Results_2_10 = cell(1,200);
All_data_Results_2_50 = cell(1,200);
All_data_Results_2_60 = cell(1,200);


SRS_Frame_Final_005                        =    cell (14, 17);   

SRS_Frame_Final_01                         =    cell (14, 17);   

SRS_Frame_Final_02                         =    cell (14, 17);  

SRS_Frame_Final_03                         =    cell (14, 17);  

SRS_Frame_Final_04                         =    cell (14, 17); 

SRS_Frame_Final_05                         =    cell (14, 17);  


SRS_PSNR_Final_005                         =    zeros (14, 17);   

SRS_PSNR_Final_01                         =    zeros (14, 17);   

SRS_PSNR_Final_02                         =    zeros (14, 17);  

SRS_PSNR_Final_03                         =    zeros (14, 17);  

SRS_PSNR_Final_04                         =    zeros (14, 17); 

SRS_PSNR_Final_05                         =    zeros (14, 17);  




SRS_SSIM_Final_005                         =    zeros (14, 17);   

SRS_SSIM_Final_01                         =    zeros (14, 17);   

SRS_SSIM_Final_02                         =    zeros (14, 17);  

SRS_SSIM_Final_03                         =    zeros (14, 17);  

SRS_SSIM_Final_04                         =    zeros (14, 17); 

SRS_SSIM_Final_05                         =    zeros (14, 17);  



SRS_FSIM_Final_005                         =    zeros (14, 17);   

SRS_FSIM_Final_01                         =    zeros (14, 17);   

SRS_FSIM_Final_02                         =    zeros (14, 17);  

SRS_FSIM_Final_03                         =    zeros (14, 17);  

SRS_FSIM_Final_04                         =    zeros (14, 17); 

SRS_FSIM_Final_05                         =    zeros (14, 17);  



total_frame_num                      =                          17; % to be tuned

GOP_size                             =                          8; % to be tuned

key_ratio                            =                          0.5;

block_size                           =                          32;





for i =  2
    
ImageNum =i;

switch ImageNum
    
          case 1
                filename = 'akiyo_cif';
            case 2
                filename = 'bus_cif';
            case 3
                filename = 'coastguard_cif';    
            case 4
                filename = 'container_cif'; 
                
            case 5
                filename = 'flower_cif';
            case 6
                filename = 'foreman_cif';
            case 7
                filename = 'hall_cif';
            case 8
                filename = 'mobile_cif';    
            case 9
                filename = 'mother-daughter_cif'; 
                
            case 10
                filename = 'news_cif';
            case 11
                filename = 'silent_cif';     
                
            case 12
                filename = 'stefan_cif';
            case 13
                filename = 'tempete_cif';
            case 14
                filename = 'waterfall_cif';

end

filename


[all_frames,numframes]                   =      yuv2rgb(filename);


all_frames                               =       double(all_frames)/255;


for j  =  1:5
    
 filename   


ratio_Num        =       [0.05, 0.1, 0.2, 0.3, 0.4]; 


ratio             =       ratio_Num(j)





  
        % Constructe Measurement Matrix (Gaussian Random)
N                                       =                                      block_size * block_size;
        
M_key                                   =                                      round(key_ratio * N);

M                                       =                                      round(ratio * N);

randn('seed',0);  
        
PhiN                                    =                                      orth(randn(N, N))';
        
Phi_key                                 =                                      PhiN(1:M_key, :);

Phi                                     =                                      PhiN(1:M, :);

Opts                                    =                                      [];





for m = 1:17 %numframes
    
    
  filename
    
  ratio
   % m
  frame{m}                                    =                             double(rgb2gray(all_frames(:,:,:,m)))*255;
    
  [row, col]                                  =                             size(frame{m});

        
  if mod(m, GOP_size) == 1
  
  Opts.Phi                                    =                             Phi_key;
  
  Opts.ratio                                  =                             key_ratio;
  
  else
            
  Opts.Phi                                    =                             Phi;
            
  Opts.ratio                                  =                             ratio;
  
  end  
    
    
x                                            =                           im2col(frame{m}, [block_size block_size], 'distinct');
        
y{m}                                         =                           Opts.Phi * x;      

end




%    Opts.Phi_key = Phi_key;             % A

Opts.Phi                                      =                          Phi;

Opts.org                                       =                         frame;                   % all the original frames

Opts.y                                         =                         y;      
  
Opts.row                                       =                         row;
  
Opts.col                                       =                          col;

Opts.block_size                                =                         block_size;

Opts.IterNum                                   =                          300;


 
Opts.patch                                     =                        8;

Opts.Region                                    =                        20;
 
Opts.Sim                                       =                        20;

Opts.eps                                       =                        0.4;

Opts.step                                      =                        4;

Opts.nSig                                      =                        sqrt(2);

Opts.Inloop                                    =                        200;

Opts.hr                                        =                         80;



if ratio == 0.05
    
    load('Frame_Inital_005.mat')
    
    Opts.initial = Frame_Inital_005;
    
    Opts.initial_psnr = PSNR_Inital_005;
    
    Opts.initial_ssim = SSIM_Inital_005;   
    
    Opts.initial_fsim = FSIM_Inital_005;   
    
    Opts.mu           =                     0.6;  
 
    Opts.c            =                        1;
    
elseif ratio == 0.1
    
    load('Frame_Inital_01.mat')
    
    Opts.initial = Frame_Inital_01;
    
    Opts.initial_psnr = PSNR_Inital_01;
    
    Opts.initial_ssim = SSIM_Inital_01;   
    
    Opts.initial_fsim = FSIM_Inital_01;   
    
      Opts.mu           =                     0.3;  
 
    Opts.c            =                        1;  
    
    
elseif ratio == 0.2
    
    load('Frame_Inital_02.mat')
    
    Opts.initial = Frame_Inital_02;
    
    Opts.initial_psnr = PSNR_Inital_02;
    
    Opts.initial_ssim = SSIM_Inital_02;   
    
    Opts.initial_fsim = FSIM_Inital_02;   
    
        Opts.mu           =                     0.1;  
 
    Opts.c            =                        0.001;

elseif ratio == 0.3
    
    load('Frame_Inital_03.mat')
    
    Opts.initial = Frame_Inital_03;
    
    Opts.initial_psnr = PSNR_Inital_03;
    
    Opts.initial_ssim = SSIM_Inital_03;   
    
    Opts.initial_fsim = FSIM_Inital_03; 
    
            Opts.mu           =                     0.2;  
 
    Opts.c            =                        0.001;
    
elseif ratio == 0.4
    
    load('Frame_Inital_04.mat')
    
    Opts.initial = Frame_Inital_04;
    
    Opts.initial_psnr = PSNR_Inital_04;
    
    Opts.initial_ssim = SSIM_Inital_04;   
    
    Opts.initial_fsim = FSIM_Inital_04;   
    
              Opts.mu           =                     0.2;  
 
    Opts.c            =                        0.001;  
    
end



for n = 1:17
  filename
    
  ratio

  cur_no                                       =                            n
        
if cur_no == 1 || cur_no == 9|| cur_no == 17    
    
  if ratio == 0.05  
      
SRS_Frame_Final_005{i, cur_no} = Opts.initial{i,cur_no};

SRS_PSNR_Final_005 (i, cur_no) = Opts.initial_psnr(i, cur_no);

SRS_SSIM_Final_005 (i, cur_no) = Opts.initial_ssim(i, cur_no);

SRS_FSIM_Final_005 (i, cur_no) = Opts.initial_ssim(i, cur_no);


 elseif ratio == 0.1
      
SRS_Frame_Final_01{i, cur_no} = Opts.initial{i,cur_no};

SRS_PSNR_Final_01 (i, cur_no) = Opts.initial_psnr(i, cur_no);

SRS_SSIM_Final_01 (i, cur_no) = Opts.initial_ssim(i, cur_no);

SRS_FSIM_Final_01 (i, cur_no) = Opts.initial_ssim(i, cur_no);
 
 elseif ratio == 0.2
      
SRS_Frame_Final_02{i, cur_no} = Opts.initial{i,cur_no};

SRS_PSNR_Final_02 (i, cur_no) = Opts.initial_psnr(i, cur_no);

SRS_SSIM_Final_02 (i, cur_no) = Opts.initial_ssim(i, cur_no);

SRS_FSIM_Final_02 (i, cur_no) = Opts.initial_ssim(i, cur_no);     

 elseif ratio == 0.3
      
SRS_Frame_Final_03{i, cur_no} = Opts.initial{i,cur_no};

SRS_PSNR_Final_03 (i, cur_no) = Opts.initial_psnr(i, cur_no);

SRS_SSIM_Final_03 (i, cur_no) = Opts.initial_ssim(i, cur_no);

SRS_FSIM_Final_03 (i, cur_no) = Opts.initial_ssim(i, cur_no);   

 elseif ratio == 0.4
      
SRS_Frame_Final_04{i, cur_no} = Opts.initial{i,cur_no};

SRS_PSNR_Final_04 (i, cur_no) = Opts.initial_psnr(i, cur_no);

SRS_SSIM_Final_04 (i, cur_no) = Opts.initial_ssim(i, cur_no);

SRS_FSIM_Final_04 (i, cur_no) = Opts.initial_ssim(i, cur_no);
      
  end
  
else
    
    
    if cur_no < 9
       ref1 = 1;
       
       ref2 = 9;
       
     elseif cur_no < 17
       ref1 = 9;
       
       ref2 = 17;
    end     
    
    Inital_psnr = Opts.initial_psnr(i,cur_no)
     

if  ratio==0.05


  [reconstructed_image, PSN_Result, FSIM_Result, SSIM_Result, All_PSNR, jjj, difff] = Video_SRS_Main (Opts,i, cur_no,ref1,ref2);

  SRS_Frame_Final_005{i, n}  = reconstructed_image;
  
  
  SRS_PSNR_Final_005 (i,n)   =   PSN_Result;
  
  
  SRS_SSIM_Final_005 (i,n)   =   SSIM_Result;  

  SRS_FSIM_Final_005 (i,n)  =    FSIM_Result;
  
elseif ratio==0.1
    
  [reconstructed_image, PSN_Result, FSIM_Result, SSIM_Result, All_PSNR, jjj, difff] = Video_SRS_Main (Opts,i, cur_no,ref1,ref2);

  SRS_Frame_Final_01{i, n}  = reconstructed_image;
  
  SRS_PSNR_Final_01 (i,n)   =   PSN_Result;

  SRS_SSIM_Final_01 (i,n)   =   SSIM_Result;  

  SRS_FSIM_Final_01 (i,n)  =    FSIM_Result;
  
elseif ratio==0.2
    
  [reconstructed_image, PSN_Result, FSIM_Result, SSIM_Result, All_PSNR, jjj, difff] = Video_SRS_Main (Opts,i, cur_no,ref1,ref2);

  SRS_Frame_Final_02{i, n}  = reconstructed_image;  
  
    SRS_PSNR_Final_02 (i,n)   =   PSN_Result;
  
  
  SRS_SSIM_Final_02 (i,n)   =   SSIM_Result;  

  SRS_FSIM_Final_02 (i,n)  =    FSIM_Result;
  
elseif ratio==0.3
    
  [reconstructed_image, PSN_Result, FSIM_Result, SSIM_Result, All_PSNR, jjj, difff] = Video_SRS_Main (Opts,i, cur_no,ref1,ref2);

  SRS_Frame_Final_03{i, n}  = reconstructed_image;  
  
    SRS_PSNR_Final_03 (i,n)   =   PSN_Result;
  
  
  SRS_SSIM_Final_03 (i,n)   =   SSIM_Result;  

  SRS_FSIM_Final_03 (i,n)  =    FSIM_Result;
  
elseif ratio==0.4
    
  [reconstructed_image, PSN_Result, FSIM_Result, SSIM_Result, All_PSNR, jjj, difff] = Video_SRS_Main (Opts,i, cur_no,ref1,ref2);

  SRS_Frame_Final_04{i, n}  = reconstructed_image;  
  
    SRS_PSNR_Final_04 (i,n)   =   PSN_Result;
  
  
  SRS_SSIM_Final_04 (i,n)   =   SSIM_Result;  

  SRS_FSIM_Final_04 (i,n)  =    FSIM_Result;
  
elseif ratio==0.5
    
  [reconstructed_image, PSN_Result, FSIM_Result, SSIM_Result, All_PSNR, jjj, difff] = Video_SRS_Main (Opts,i, cur_no,ref1,ref2);

  SRS_Frame_Final_05{i, n}  = reconstructed_image;   
  
  
  SRS_PSNR_Final_05 (i,n)   =   PSN_Result;
  
  
  SRS_SSIM_Final_05 (i,n)   =   SSIM_Result;  

  SRS_FSIM_Final_05 (i,n)  =    FSIM_Result;
  
end

end

end


end

end

save SUM_SRS_Frame_Final_005 SRS_Frame_Final_005 SRS_PSNR_Final_005 SRS_SSIM_Final_005 SRS_FSIM_Final_005

save SUM_SRS_Frame_Final_01 SRS_Frame_Final_01 SRS_PSNR_Final_01 SRS_SSIM_Final_01 SRS_FSIM_Final_01

save SUM_SRS_Frame_Final_02 SRS_Frame_Final_02 SRS_PSNR_Final_02 SRS_SSIM_Final_02 SRS_FSIM_Final_02

save SUM_SRS_Frame_Final_03 SRS_Frame_Final_03 SRS_PSNR_Final_03 SRS_SSIM_Final_03 SRS_FSIM_Final_03

save SUM_SRS_Frame_Final_04 SRS_Frame_Final_04 SRS_PSNR_Final_04 SRS_SSIM_Final_04 SRS_FSIM_Final_04 



         