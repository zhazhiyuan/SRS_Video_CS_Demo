
function [reconstructed_image, PSN_Result,FSIM_Result,SSIM_Result] = EIC_Video_CS_Main(y, Opts)

row = Opts.row;

col = Opts.col;

Phi = Opts.Phi;

x_org = Opts.org;

IterNum = Opts.IterNum;

x_initial = Opts.initial;

block_size = Opts.block_size;

Inloop = Opts.Inloop;

mu = Opts.mu;

x = im2col(x_initial, [block_size block_size], 'distinct');

%u = zeros(size(x));

c = zeros(size(x));

%w = zeros(size(x));

ATA = Phi'*Phi;

ATy = Phi'*y;

IM = eye(size(ATA));

All_PSNR = zeros(1,IterNum);

 GSR_NLS_Results    =  cell (1,IterNum);   
    

for j = 1:IterNum
    
    x_hat            =                  x;
    
    g                =                  col2im(x - c, [block_size block_size],[row col], 'distinct');  
    
    w                =                  EIC_CS_Solver (g, Opts );
    
    w_bar            =                  im2col(w, [block_size block_size], 'distinct');
    
    f                =                  w_bar; 
    

    for kk = 1:Inloop
        
        d = ATA*x_hat - ATy +  mu*(x_hat - f - c);
        
        dTd = d'*d;
        
        G = d'*(ATA + mu*IM)*d;
        
        Step_Matrix = abs(dTd./G); 
        
        Step_length = diag(diag(Step_Matrix));
        
        x = x_hat - d*Step_length;
        
        x_hat = x;  
        
    end
    
    c                       =                   c - (x -  f);
   
    x_img                   =                   col2im(x, [block_size block_size],[row col], 'distinct');

    All_PSNR(j)             =                   csnr( x_img, x_org, 0, 0);
    
    GSR_NLS_Results{j}      =                      x_img;
    
    fprintf('EIC for Individual Video Frame: IterNum = %d, PSNR = %f\n', j, csnr(x_img,x_org,0,0));
    
    
    
    
     if j>1
        
        if   All_PSNR(j) -  All_PSNR(j-1)<0.01
            break;
        end
        
    end

end

reconstructed_image                      =                   x_img;

PSN_Result                               =                   csnr(reconstructed_image,x_org,0,0);

FSIM_Result                              =                   FeatureSIM(reconstructed_image,x_org);

SSIM_Result                              =                   cal_ssim(reconstructed_image,x_org,0,0);

end

