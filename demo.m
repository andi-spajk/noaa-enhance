%% Demo script

clear;
clc;


function out = logfft2(img)
    log_img = log(abs(fftshift(fft2(img)))+1);
    scale = 255.0 / max(log_img(:));
    out = uint8(scale * log_img);
end

function out = dispfft2(I_fft)
    log_img = log(abs(fftshift(I_fft))+1);
    scale = 255.0 / max(log_img(:));
    out = uint8(scale * log_img);
end

function out = histogram_equalization(I)
    [h,~] = imhist(I);
    n_j = cumsum(h);
    M = size(I,1);
    N = size(I,2);
    scaler = (255.0 / (M*N));
    s_k = scaler * n_j;
    Tr = uint8(round(s_k));

    out = zeros([M N],'uint8');
    for i = 1:M
        for j = 1:N
            out(i,j) = Tr(I(i,j)+1);
        end
    end
end

function out = inverted(I)
    out = zeros(size(I), 'uint8');
    for x=1:size(I,1)
        for y=1:size(I,2)
            % 0 -> 255
            % 1 -> 254
            % 127 -> 128
            % 128 -> 127
            % 254 -> 1
            % 255 -> 0
            out(x,y) = 2^8 - 1 - I(x,y);
        end
    end
end

function bv = band_ratio_image(A,B)
    % prevent division by zero
    M = size(A,1);
    N = size(B,2);
    for x=1:M
        for y=1:N
            if A(x,y) == 0
                A(x,y) = 1;
            end
            if B(x,y) == 0
                B(x,y) = 1;
            end
        end
    end

    bv = double(A) ./ double(B);
    for x=1:M
        for y=1:N
            if bv(x,y) <= 1.0
                bv(x,y) = floor(bv(x,y)*127 + 1);
            else
                bv(x,y) = floor(128 + bv(x,y)/2);
            end
        end
    end
end

outs = dir("images");
dir_name4 = outs(2+4);
outs_folder4 = dir(sprintf("images/%s", dir_name4.name));
dir_name5 = outs(2+5);
outs_folder5 = dir(sprintf("images/%s", dir_name5.name));

apt_a = outs_folder4(3);
Ia4 = double(imread(sprintf("images/%s/%s", dir_name4.name, apt_a.name)));
Ia4 = uint8(Ia4 * (255.0 / 2^16));
apt_b = outs_folder4(4);
Ib4 = double(imread(sprintf("images/%s/%s", dir_name4.name, apt_b.name)));
Ib4 = uint8(Ib4 * (255.0 / 2^16));
apt_a = outs_folder5(3);
Ia5 = double(imread(sprintf("images/%s/%s", dir_name5.name, apt_a.name)));
Ia5 = uint8(Ia5 * (255.0 / 2^16));
apt_b = outs_folder5(4);
Ib5 = double(imread(sprintf("images/%s/%s", dir_name5.name, apt_b.name)));
Ib5 = uint8(Ib5 * (255.0 / 2^16));

%% =================================================================
% raw images

f = figure;
f.WindowState = 'maximized';

subplot(1,4,1)
imshow(Ia4)
title("APT-A NOAA19 2025/5/20 11:15:08")
subplot(1,4,2)
imshow(Ib4)
title("APT-B NOAA19 2025/5/20 11:15:08")
subplot(1,4,3)
imshow(Ia5)
title("APT-A NOAA15 2025/5/20 19:39:10")
subplot(1,4,4)
imshow(Ib5)
title("APT-B NOAA15 2025/5/20 19:39:10")

%% =================================================================
% FFT of raw images

f = figure;
f.WindowState = 'maximized';
Ia4_fft = fft2(Ia4);
Ib4_fft = fft2(Ib4);
Ia5_fft = fft2(Ia5);
Ib5_fft = fft2(Ib5);

subplot(1,4,1)
imshow(dispfft2(Ia4_fft))
title("FFT of APT-A")
subplot(1,4,2)
imshow(dispfft2(Ib4_fft))
title("FFT of APT-B")
subplot(1,4,3)
imshow(dispfft2(Ia5_fft))
title("FFT of APT-A")
subplot(1,4,4)
imshow(dispfft2(Ib5_fft))
title("FFT of APT-B")

%% ================================================================
% restored/enhanced images

f = figure;
f.WindowState = 'maximized';

% crop out unacceptably noisy parts
Ia4 = Ia4(250:end-190,:);
Ib4 = Ib4(250:end-190,:);

% channel A had a day/night cycle shift
Ia5(694:end,:) = inverted(Ia5(694:end,:));
Ia5 = Ia5(475:end-100,:);
Ib5 = Ib5(475:end-100,:);

med_filt = [5 5];
Ia4_better = medfilt2(histogram_equalization(Ia4), med_filt);
Ib4_better = medfilt2(histogram_equalization(Ib4), med_filt);
Ia5_better = medfilt2(histogram_equalization(Ia5), med_filt);
Ib5_better = medfilt2(histogram_equalization(Ib5), med_filt);

subplot(1,4,1)
imshow(Ia4_better)
title("Enhanced APT-A")
subplot(1,4,2)
imshow(Ib4_better)
title("Enhanced APT-B")
subplot(1,4,3)
imshow(Ia5_better)
title("Enhanced APT-A")
subplot(1,4,4)
imshow(Ib5_better)
title("Enhanced APT-B")

%
% Aish feature detection
%

%% =================================================================
% FFT of pair 4, thresholding

f = figure;
f.WindowState = 'maximized';

% most are well thresholded at thresh = 250000;
% maximum thresh = 400000;
mask1 = fftshift(abs(Ia4_fft) > 250000);
mask2 = fftshift(abs(Ia4_fft) > 300000);
mask3 = fftshift(abs(Ia4_fft) > 350000);
mask4 = fftshift(abs(Ia4_fft) > 400000);

colormap("gray");
subplot(2,5,1)
imshow(dispfft2(Ia4_fft))
title("FFT of APT-A")
subplot(2,5,2)
imagesc(mask1)
title("FFT of APT-A, 250,000")
subplot(2,5,3)
imagesc(mask2)
title("FFT of APT-A, 300,000")
subplot(2,5,4)
imagesc(mask3)
title("FFT of APT-A, 350,000")
subplot(2,5,5)
imagesc(mask4)
title("FFT of APT-A, 400,000")

masked1 = Ia4_fft .* ifftshift(~mask1);
masked2 = Ia4_fft .* ifftshift(~mask2);
masked3 = Ia4_fft .* ifftshift(~mask3);
masked4 = Ia4_fft .* ifftshift(~mask4);
filtered1 = real(ifft2(masked1));
filtered2 = real(ifft2(masked2));
filtered3 = real(ifft2(masked3));
filtered4 = real(ifft2(masked4));

subplot(2,5,6)
imshow(Ia4)
subplot(2,5,7)
imshow(filtered1)
subplot(2,5,8)
imshow(filtered2)
subplot(2,5,9)
imshow(filtered3)
subplot(2,5,10)
imshow(filtered4)

%% =================================================================
% FFT of pair 5, thresholding

f = figure;
f.WindowState = 'maximized';

mask1 = fftshift(abs(Ia5_fft) > 250000);
mask2 = fftshift(abs(Ia5_fft) > 300000);
mask3 = fftshift(abs(Ia5_fft) > 350000);
mask4 = fftshift(abs(Ia5_fft) > 400000);

colormap("gray");
subplot(2,5,1)
imshow(dispfft2(Ia5_fft))
title("FFT of APT-A")
subplot(2,5,2)
imagesc(mask1)
title("FFT of APT-A, 250,000")
subplot(2,5,3)
imagesc(mask2)
title("FFT of APT-A, 300,000")
subplot(2,5,4)
imagesc(mask3)
title("FFT of APT-A, 350,000")
subplot(2,5,5)
imagesc(mask4)
title("FFT of APT-A, 400,000")

masked1 = Ia5_fft .* ifftshift(~mask1);
masked2 = Ia5_fft .* ifftshift(~mask2);
masked3 = Ia5_fft .* ifftshift(~mask3);
masked4 = Ia5_fft .* ifftshift(~mask4);
filtered1 = real(ifft2(masked1));
filtered2 = real(ifft2(masked2));
filtered3 = real(ifft2(masked3));
filtered4 = real(ifft2(masked4));

subplot(2,5,6)
imshow(Ia5)
subplot(2,5,7)
imshow(filtered1)
subplot(2,5,8)
imshow(filtered2)
subplot(2,5,9)
imshow(filtered3)
subplot(2,5,10)
imshow(filtered4)

%
% Aish cloud detection on restored/enhanced images
%

%% =================================================================
% band ratio

f = figure;
f.WindowState = 'maximized';

bv4_ab = band_ratio_image(Ia4, Ib4);
m = max(bv4_ab(:));
bv4_ab = uint8(bv4_ab * (255.0 / m));
bv4_ab_histeq = histogram_equalization(bv4_ab);

bv4_ba = band_ratio_image(Ib4, Ia4);
m = max(bv4_ba(:));
bv4_ba = uint8(bv4_ba * (255.0 / m));
bv4_ba_histeq = histogram_equalization(bv4_ba);

bv5_ab = band_ratio_image(Ia5, Ib5);
m = max(bv5_ab(:));
bv5_ab = uint8(bv5_ab * (255.0 / m));
bv5_ab_histeq = histogram_equalization(bv5_ab);

bv5_ba = band_ratio_image(Ib5, Ia5);
m = max(bv5_ba(:));
bv5_ba = uint8(bv5_ba * (255.0 / m));
bv5_ba_histeq = histogram_equalization(bv5_ba);

subplot(1,4,1)
imshow(bv4_ab_histeq)
title("APT-A / APT-B")
subplot(1,4,2)
imshow(bv4_ba_histeq)
title("APT-B / APT-A")
subplot(1,4,3)
imshow(imrotate(bv5_ab_histeq,180))
title("APT-A / APT-B")
subplot(1,4,4)
imshow(imrotate(bv5_ba_histeq,180))
title("APT-B / APT-A")

%% =================================================================
% FFT of band ratio

f = figure;
f.WindowState = 'maximized';

bv4_ab_fft = logfft2(bv4_ab);
bv4_ba_fft = logfft2(bv4_ba);
bv5_ab_fft = logfft2(bv5_ab);
bv5_ba_fft = logfft2(bv5_ba);

colormap('hot')
subplot(1,4,1)
imagesc(bv4_ab_fft)
title("FFT of APT-A / APT-B")
subplot(1,4,2)
imagesc(bv4_ba_fft)
title("FFT of APT-B / APT-A")
subplot(1,4,3)
imagesc(bv5_ab_fft)
title("FFT of APT-A / APT-B")
subplot(1,4,4)
imagesc(bv5_ba_fft)
title("FFT of APT-B / APT-A")

%
% Aish cloud detection with band ratio images
%