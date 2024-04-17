function  [im_denoised]     =  FFD_Net_Denoiser (input, imageNoiseSigma)

randn ('seed',0);

inputNoiseSigma   =   imageNoiseSigma;

format compact;
global sigmas;


load(fullfile('models','FFDNet_gray.mat'));
net = vl_simplenn_tidy(net);




    input = double(input)/255;
   
 %   noise = imageNoiseSigma/255.*randn(size(label));
 %   input = single(label + noise);
    
    
sigmas = inputNoiseSigma/255; 
    
 %res    = vl_ffdnet_matlab(net, input); % use this if you did  not install matconvnet; very slow
 
 res    = vl_ffdnet_concise(net, input);    % concise version
    
    output = res(end).x;
    
    im_denoised  =  double(output*255);

 


end

