% FFT of cropped images

% FFT of APT images

clear;
clc;

function out = logfft2(img)
    log_img = log(abs(fftshift(fft2(img)))+1);
    scale = 255.0 / max(log_img(:));
    out = uint8(scale * log_img);
end

N = 9;

% select a particular dir
% desired_range = 9;

% select a range of dirs
desired = N;
desired_range = 3:3+desired-1;

% select all images
% 3:end because we ignore . and ..
% desired_range = 3:end;

% https://stackoverflow.com/a/11621907/13471272
outs = dir("images");
for i = desired_range
    dir_name = outs(i);
    outs_folder = dir(sprintf("images/%s", dir_name.name));
    f = figure;
    f.WindowState = 'maximized';

    apt_a = outs_folder(3);
    subplot(2,2,1);
    f = sprintf("images/%s/%s", dir_name.name, apt_a.name);
    Ia = imread(f);
    imshow(Ia);
    title(f, 'Interpreter', 'none');

    switch(i-2)
    case 1
        Ia_cropped = Ia(1:end-350,:);
    case 2
        Ia_cropped = Ia(670:end-200,:);
    case 3
        Ia_cropped = Ia(100:end-150,:);
    case 4
        Ia_cropped = Ia(250:end-190,:);
    case 5
        Ia_cropped = Ia(475:end-100,:);
    case 6
        Ia_cropped = Ia(1:end-100,:);
    case 7
        Ia_cropped = Ia(150:end-150,:);
    case 8
        Ia_cropped = Ia(250:end-370,:);
    case 9
        Ia_cropped = Ia(100:end-110,:);
    end
    subplot(2,2,2);
    imshow(Ia_cropped);
    title(f, 'Interpreter', 'none');

    colormap('gray');
    Ia_fft = logfft2(Ia);
    subplot(2,2,3);
    imagesc(Ia_fft);
    title("FFT of APT-A");

    Ia_cropped_fft = logfft2(Ia_cropped);
    subplot(2,2,4);
    imagesc(Ia_cropped_fft);
    title("FFT of Cropped APT-A");
end
