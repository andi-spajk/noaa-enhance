% make extra plots for the report

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
dir_name1 = outs(2+9);
outs_folder1 = dir(sprintf("images/%s", dir_name1.name));

apt_a = outs_folder1(3);
Ia1 = double(imread(sprintf("images/%s/%s", dir_name1.name, apt_a.name)));
Ia1 = uint8(Ia1 * (255.0 / 2^16));
apt_b = outs_folder1(4);
Ib1 = double(imread(sprintf("images/%s/%s", dir_name1.name, apt_b.name)));
Ib1 = uint8(Ib1 * (255.0 / 2^16));

Ia1_3x3 = medfilt2(Ia1, [3 3]);
Ia1_5x5 = medfilt2(Ia1, [5 5]);
figure;
subplot(1,3,1)
imshow(Ia1(480:800,325:700))
title("Original")
subplot(1,3,2)
imshow(Ia1_3x3(480:800,325:700))
title("3x3 Median")
subplot(1,3,3)
imshow(Ia1_5x5(480:800,325:700))
title("5x5 Median")