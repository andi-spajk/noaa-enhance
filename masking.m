% mask FFT noise spikes

clear;
clc;


N = 9;

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

% dir selection starts at index 3 because . and .. occupy index 1,2

% select a particular dir
desired = 5;
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
    Ia = histogram_equalization(medfilt2(Ia, [5 5]));

    colormap('gray');
    Ia_fft = fft2(Ia);
    Ia_col_fft = fft(Ia,[],2);
    Ia_row_fft = fft(Ia,[],1);
    % Ia_test = fft(Ia_col_fft,[],1);

    % subplot(2,2,1);
    % imagesc(dispfft2(Ia_row_fft));
    % title("Row FFT of APT-A");
    subplot(2,2,1);
    imagesc(dispfft2(Ia_col_fft));
    title("Col FFT of APT-A")

    subplot(2,2,2);
    thresh = 6000;
    imagesc(abs(fftshift(Ia_col_fft)) > thresh);
    
    % subplot(3,2,3);
    % imagesc(dispfft2(Ia_row_fft));
    % title("Row FFT of APT-A")

    % subplot(3,2,4);
    % thresh = 5000;
    % imagesc(abs(fftshift(Ia_row_fft)) > thresh);

    subplot(2,2,3);
    imagesc(dispfft2(Ia_fft));
    title("2D FFT of APT-A")

    subplot(2,2,4);
    thresh = 250000;
    % thresh = 400000;
    mask = fftshift(abs(Ia_fft) > thresh);
    r = 30;
    M = size(mask,1);
    N = size(mask,2);
    for x=1:M
        for y=1:N
            if abs((x - M/2)+1j*(y - N/2)) < r
                % disp("in circle")
                mask(x,y) = 0;
            end
        end
    end
    pass_width = 5;
    mask(floor(M/2)-floor(pass_width/2):floor(M/2)+floor(pass_width/2), :) = 0;
    mask(:, floor(N/2)-floor(pass_width/2):floor(N/2)+floor(pass_width/2)) = 0;
    imagesc(mask);

    new_Ia_fft = zeros(M,N);
    width = 1;
    for x=1:M
        for y=1:N
            if mask(x,y)
                new_Ia_fft = median(Ia_fft(x-width:x+width,y-width:y+width),'all');
                % new_Ia_fft = mean(Ia_fft(x-width:x+width,y-width:y+width),[],'all');
                % new_Ia_fft(x,y) = mean([median(Ia_fft(x-width:x+width,y-width:y+width),'all') max(Ia_fft(x-width:x+width,y-width:y+width), [], 'all')]);
            else
                new_Ia_fft(x,y) = Ia_fft(x,y);
            end
        end
    end
    figure;
    colormap("gray")
    subplot(1,2,1)
    imagesc(dispfft2(new_Ia_fft));
    subplot(1,2,2)
    imshow(real(ifft2(ifftshift(new_Ia_fft))))

    % figure;
    % colormap('gray')
    % masked = Ia_fft .* ifftshift(~mask);
    % subplot(1,2,1)
    % imagesc(dispfft2(masked));
    % filtered = real(ifft2(masked));
    % subplot(1,2,2)
    % imshow(filtered)

end
