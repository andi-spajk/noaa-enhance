% FFT of APT images, before and after histeq

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

% dir selection starts at index 3 because . and .. occupy index 1,2

% select a particular dir
desired = 9;
desired_range = 3+desired-1;

% select a range of dirs
% desired = N;
% desired_range = 3:3+desired-1;

% https://stackoverflow.com/a/11621907/13471272
outs = dir("images");
for dir_name = outs(desired_range)'
    outs_folder = dir(sprintf("images/%s", dir_name.name));
    fig = figure;
    fig.WindowState = 'maximized'; 

    apt_a = outs_folder(3);
    Ia = double(imread(sprintf("images/%s/%s", dir_name.name, apt_a.name)));
    Ia = uint8(Ia * (255.0 / 2^16));
    Ia_histeq = histogram_equalization(Ia);

    subplot(2,4,1);
    imshow(Ia);
    title(dir_name.name, 'Interpreter', 'none');
    subplot(2,4,2);
    imshow(Ia_histeq);
    title(append("HISTEQ ", dir_name.name), 'Interpreter', 'none');

    apt_b = outs_folder(4);
    Ib = double(imread(sprintf("images/%s/%s", dir_name.name, apt_b.name)));
    Ib = uint8(Ib * (255 / 2^16));
    Ib_histeq = histogram_equalization(Ib);

    subplot(2,4,3);
    imshow(Ib);
    title(dir_name.name, 'Interpreter', 'none');
    subplot(2,4,4);
    imshow(Ib_histeq);
    title(append("HISTEQ ", dir_name.name), 'Interpreter', 'none');

    colormap('gray');
    Ia_fft = logfft2(Ia);
    Ia_histeq_fft = logfft2(Ia_histeq);

    subplot(2,4,5);
    imagesc(Ia_fft);
    title("FFT of APT-A");
    subplot(2,4,6);
    imagesc(Ia_histeq_fft);
    title("FFT of HISTEQ APT-A");

    Ib_fft = logfft2(Ib);
    Ib_histeq_fft = logfft2(Ib_histeq);

    subplot(2,4,7);
    imagesc(Ib_fft);
    title("FFT of APT-B");
    subplot(2,4,8);
    imagesc(Ib_histeq_fft);
    title("FFT of HISTEQ APT-B");
end
