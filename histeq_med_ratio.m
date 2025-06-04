% everything

clear;
clc;


N = 9;

function out = logfft2(img)
    log_img = log(abs(fftshift(fft2(img)))+1);
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

% dir selection starts at index 3 because . and .. occupy index 1,2

% select a particular dir
% desired = 9;
% desired_range = 3+desired-1;

% select a range of dirs
desired = N;
desired_range = 3:3+desired-1;

% https://stackoverflow.com/a/11621907/13471272
outs = dir("images");
for i = desired_range
    dir_name = outs(i);
    outs_folder = dir(sprintf("images/%s", dir_name.name));

    med_filter = [3 3];
    apt_a = outs_folder(3);
    Ia = double(imread(sprintf("images/%s/%s", dir_name.name, apt_a.name)));
    Ia = uint8(Ia * (255.0 / 2^16));
    Ia = medfilt2(histogram_equalization(Ia), med_filter);
    apt_b = outs_folder(4);
    Ib = double(imread(sprintf("images/%s/%s", dir_name.name, apt_b.name)));
    Ib = uint8(Ib * (255.0 / 2^16));
    Ib = medfilt2(histogram_equalization(Ib), med_filter);

    switch(i-2)
    case 1
        Ia = Ia(1:end-350,:);
        Ib = Ib(1:end-350,:);
    case 2
        Ia = Ia(670:end-200,:);
        Ib = Ib(670:end-200,:);
    case 3
        Ia = Ia(100:end-150,:);
        Ib = Ib(100:end-150,:);
    case 4
        Ia = Ia(250:end-190,:);
        Ib = Ib(250:end-190,:);
    case 5
        Ia = Ia(475:end-100,:);
        Ib = Ib(475:end-100,:);
    case 6
        Ia = Ia(1:end-100,:);
        Ib = Ib(1:end-100,:);
    case 7
        Ia = Ia(150:end-150,:);
        Ib = Ib(150:end-150,:);
    case 8
        Ia = Ia(250:end-370,:);
        Ib = Ib(250:end-370,:);
    case 9
        Ia = Ia(100:end-110,:);
        Ib = Ib(100:end-110,:);
    end

    fig = figure;
    fig.WindowState = 'maximized';
    subplot(2,4,1)
    imshow(Ia);
    title(dir_name.name, 'Interpreter', 'none');

    subplot(2,4,5)
    imshow(Ib);
    title(dir_name.name, 'Interpreter', 'none');

    bv = band_ratio_image(Ia, Ib);
    m = max(bv(:));
    bv = uint8(bv * (255.0 / m));
    bv_histeq = histogram_equalization(bv);
    
    bv2 = band_ratio_image(Ib, Ia);
    m = max(bv2(:));
    bv2 = uint8(bv2 * (255.0 / m));
    bv2_histeq = histogram_equalization(bv2);

    subplot(2,4,2)
    imshow(bv);
    title("APT-A / APT-B")

    subplot(2,4,6)
    imshow(bv2)
    title("APT-B / APT-A")

    subplot(2,4,3)
    imshow(bv_histeq);
    title("HISTEQ APT-A / APT-B")

    subplot(2,4,7)
    imshow(bv2_histeq);
    title("HISTEQ APT-B / APT-A")

    bv_fft = logfft2(bv);
    bv2_fft = logfft2(bv2);

    colormap("gray")
    subplot(2,4,4)
    imagesc(bv_fft)
    title("FFT of A/B")
    subplot(2,4,8)
    imagesc(bv2_fft)
    title("FFT of B/A")
end


