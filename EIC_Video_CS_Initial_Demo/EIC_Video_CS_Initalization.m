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


Frame_Inital_005                        =    cell (16, 17);   

Frame_Inital_01                         =    cell (16, 17);   

Frame_Inital_02                         =    cell (16, 17);  

Frame_Inital_03                         =    cell (16, 17);  

Frame_Inital_04                         =    cell (16, 17); 

Frame_Inital_05                         =    cell (16, 17);  


PSNR_Inital_005                         =    zeros (16, 17);   

PSNR_Inital_01                         =    zeros (16, 17);   

PSNR_Inital_02                         =    zeros (16, 17);  

PSNR_Inital_03                         =    zeros (16, 17);  

PSNR_Inital_04                         =    zeros (16, 17); 

PSNR_Inital_05                         =    zeros (16, 17);  




SSIM_Inital_005                         =    zeros (16, 17);   

SSIM_Inital_01                         =    zeros (16, 17);   

SSIM_Inital_02                         =    zeros (16, 17);  

SSIM_Inital_03                         =    zeros (16, 17);  

SSIM_Inital_04                         =    zeros (16, 17); 

SSIM_Inital_05                         =    zeros (16, 17);  



FSIM_Inital_005                         =    zeros (16, 17);   

FSIM_Inital_01                         =    zeros (16, 17);   

FSIM_Inital_02                         =    zeros (16, 17);  

FSIM_Inital_03                         =    zeros (16, 17);  

FSIM_Inital_04                         =    zeros (16, 17); 

FSIM_Inital_05                         =    zeros (16, 17);  








total_frame_num                      =                          1;%17; % to be tuned

GOP_size                             =                          8; % to be tuned

key_ratio                            =                          0.5;

block_size                           =                          32;





for i =2
    
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


 if  ratio   <= 0.1
     
          mu1 = 0.009; c1  = 0.0003; err  = 1.18e-4;
     
 elseif ratio   <= 0.2
     
          mu1 = 0.3; c1  = 0.001;   err  = 4.45e-5;
                             
 elseif ratio   <= 0.3
     
          mu1 = 0.3; c1  = 0.0007;   err  = 3.29e-5;
          
 else
     
          mu1 = 0.3; c1  = 0.0003;   err  = 2.39e-5;  
 end
 



  
        % Constructe Measurement Matrix (Gaussian Random)
N                                       =                                      block_size * block_size;
        
M_key                                   =                                      round(key_ratio * N);

M                                       =                                      round(ratio * N);

randn('seed',0);  
        
PhiN                                    =                                      orth(randn(N, N))';
        
Phi_key                                 =                                      PhiN(1:M_key, :);

Phi                                     =                                      PhiN(1:M, :);

Opts                                    =                                      [];

%if ~isfield(Opts,'block_size')
Opts.block_size                         =                                       block_size;
%end

%if ~isfield(Opts,'initial')
%  Opts.initial = double(x_MH);
%end
        
%if ~isfield(Opts,'org')
%Opts.org = x_org;
%end
%if ~isfield(Opts,'IterNum')
Opts.IterNum = 300;
%end

%if ~isfield(Opts,'mu')
Opts.mu = mu1;
%end
       
%if ~isfield(Opts,'c1') 
Opts.c1 = c1;
%end       
       
%if ~isfield(Opts,'patch')
Opts.patch = 8;
%end

%if ~isfield(Opts,'Region')
Opts.Region = 25;
%end

%if ~isfield(Opts,'Sim')
Opts.Sim = 60;
%end

%if ~isfield(Opts,'err')
%Opts.err = err;
%end
  
%if ~isfield(Opts,'eps')
Opts.eps = 0.4;
%end
       
%if ~isfield(Opts,'step')
Opts.step = 4;
%end

%if ~isfield(Opts,'nSig')
Opts.nSig = sqrt(2);
%end       
       
%if ~isfield(Opts,'Inloop')
Opts.Inloop = 200;
%end
        
%if ~isfield(Opts,'hr')
Opts.hr = 80;
%end    
        


for m = 1:17 %numframes
    
    m
    
    filename
    
    ratio
    
  frame{m}                              =                             double(rgb2gray(all_frames(:,:,:,m)))*255;
    
  [row, col]                            =                             size(frame{m});

  Opts.row                              =                             row;
  
  Opts.col                              =                             col;
        
  if mod(m, GOP_size) == 1
  
  Opts.Phi                              =                             Phi_key;
  
  Opts.ratio                            =                             key_ratio;
  
  end
  
  if mod(m, GOP_size) ~= 1
            
  Opts.Phi                              =                             Phi;
            
  Opts.ratio                            =                             ratio;
  
  end  
    
    
x                                       =                           im2col(frame{m}, [Opts.block_size Opts.block_size], 'distinct');
        
y                                       =                           Opts.Phi * x;    
       
[x_MH,  ~]                              =                           MH_BCS_SPL_Decoder(y, Opts.Phi, Opts.ratio, Opts.row, Opts.col);       
       
%if ~isfield(Opts,'initial')
    
Opts.initial                            =                           double(x_MH);

%end     

%if ~isfield(Opts,'org')
    
Opts.org                                =                           frame{m};

%end

inital_image                            =                           csnr (Opts.initial,Opts.org,0,0)


if  ratio==0.05

[reconstructed_image, PSN_Result,FSIM_Result,SSIM_Result]     =     EIC_Video_CS_Main(y, Opts);

  Frame_Inital_005{i, m}  = reconstructed_image;
  
  
  PSNR_Inital_005 (i,m)   =   PSN_Result;
  
  
  SSIM_Inital_005 (i,m)   =   SSIM_Result;  

  FSIM_Inital_005 (i,m)  =    FSIM_Result;
  
elseif ratio==0.1
    
 [reconstructed_image, PSN_Result,FSIM_Result,SSIM_Result]   =      EIC_Video_CS_Main(y, Opts);

  Frame_Inital_01{i, m}  = reconstructed_image;
  
  PSNR_Inital_01 (i,m)   =   PSN_Result;

  SSIM_Inital_01 (i,m)   =   SSIM_Result;  

  FSIM_Inital_01 (i,m)  =    FSIM_Result;
  
elseif ratio==0.2
    
 [reconstructed_image, PSN_Result,FSIM_Result,SSIM_Result]   =        EIC_Video_CS_Main(y, Opts);

  Frame_Inital_02{i, m}  = reconstructed_image;  
  
    PSNR_Inital_02 (i,m)   =   PSN_Result;
  
  
  SSIM_Inital_02 (i,m)   =   SSIM_Result;  

  FSIM_Inital_02 (i,m)  =    FSIM_Result;
  
elseif ratio==0.3
    
 [reconstructed_image, PSN_Result,FSIM_Result,SSIM_Result]   =        EIC_Video_CS_Main(y, Opts);

  Frame_Inital_03{i, m}  = reconstructed_image;  
  
    PSNR_Inital_03 (i,m)   =   PSN_Result;
  
  
  SSIM_Inital_03 (i,m)   =   SSIM_Result;  

  FSIM_Inital_03 (i,m)  =    FSIM_Result;
  
elseif ratio==0.4
    
 [reconstructed_image, PSN_Result,FSIM_Result,SSIM_Result] = EIC_Video_CS_Main(y, Opts);

  Frame_Inital_04{i, m}  = reconstructed_image;  
  
    PSNR_Inital_04 (i,m)   =   PSN_Result;
  
  
  SSIM_Inital_04 (i,m)   =   SSIM_Result;  

  FSIM_Inital_04 (i,m)  =    FSIM_Result;
  
elseif ratio==0.5
    
 [reconstructed_image, PSN_Result,FSIM_Result,SSIM_Result] = EIC_Video_CS_Main(y, Opts);

  Frame_Inital_05{i, m}  = reconstructed_image;   
  
  
  PSNR_Inital_05 (i,m)   =   PSN_Result;
  
  
  SSIM_Inital_05 (i,m)   =   SSIM_Result;  

  FSIM_Inital_05 (i,m)  =    FSIM_Result;
  
end


end

end

end

save Frame_Inital_005_1 Frame_Inital_005 PSNR_Inital_005 SSIM_Inital_005 FSIM_Inital_005

save Frame_Inital_01_1 Frame_Inital_01 PSNR_Inital_01 SSIM_Inital_01 FSIM_Inital_01

save Frame_Inital_02_1 Frame_Inital_02 PSNR_Inital_02 SSIM_Inital_02 FSIM_Inital_02

save Frame_Inital_03_1 Frame_Inital_03 PSNR_Inital_03 SSIM_Inital_03 FSIM_Inital_03

save Frame_Inital_04_1 Frame_Inital_04 PSNR_Inital_04 SSIM_Inital_04 FSIM_Inital_04



         