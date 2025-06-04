% lowpass filtering

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

function distance = D(u,v,P,Q)
    distance = sqrt((u-P/2)^2 + (v-Q/2)^2);
end

function H = make_butterworth(D_0, n, P, Q)
    H = zeros([P Q]);
    for u = 1:P
        for v = 1:Q
            H(u,v) = 1 / ((1 + D(u,v,P,Q)/D_0)^(2*n));
        end
    end
end

function H = make_gaussian(D_0, P, Q)
    H = zeros([P Q]);
    for u = 1:P
        for v = 1:Q
            H(u,v) = 1 - exp((-1*D(u,v,P,Q)^2)/(2*D_0^2));
        end
    end
end

% dir selection starts at index 3 because . and .. occupy index 1,2

% select a particular dir
desired = 10;
desired_range = 3+desired-1;

% select a range of dirs
% desired = N;
% desired_range = 3:3+desired-1;

% https://stackoverflow.com/a/11621907/13471272
outs = dir("images");
for dir_name = outs(desired_range)'
    outs_folder = dir(sprintf("images/%s", dir_name.name));

    apt_a = outs_folder(3);
    Ia = double(imread(sprintf("images/%s/%s", dir_name.name, apt_a.name)));
    Ia = uint8(Ia * (255.0 / 2^16));
    Ia = histogram_equalization(medfilt2(Ia, [5 5]));

    % SIZE = size(Ia);
    % P = SIZE(1);
    % Q = SIZE(2);
    % 
    % filt = ones(SIZE);
    % filt(1:(P/2)-10,1:(Q/2)-10) = 0;
    % filt((P/2)+10:end,1:(Q/2)-10) = 0;
    % filt(1:(P/2)-10,(Q/2)+10:end) = 0;
    % filt((P/2)+10:end,(Q/2)+10:end) = 0;
    % figure;
    % imagesc(filt)

    % H_notch_reject = ones(SIZE);
    % uk = [-50];% -40 41 81];
    % vk = [30];% 28 28 28];
    % D_0k = [20 12 12 12];
    % n = 4;
    % for i = 1:length(uk)
    %     Hi = ones(SIZE);
    %     for u = 1:P
    %         for v = 1:Q
    %             D1 = D(u-uk(i),v-vk(i),P,Q);    % H_{k}
    %             D2 = D(u - -uk(i),v - -vk(i),P,Q);  % H_{-k}
    %             H1 = 1 / (1 + (D_0k(i) / D1)^(2*n));
    %             H2 = 1 / (1 + (D_0k(i) / D2)^(2*n));
    %             Hi(u,v) = H1 * H2;
    %         end
    %     end
    %     H_notch_reject = H_notch_reject .* Hi;
    % end
    % figure;
    % imagesc(H_notch_reject);

    bw_lpf = make_butterworth(200, 2, size(Ia,1), size(Ia,2));
    I_fft = fftshift(fft2(Ia));
    % I_lpf_fft = I_fft .* H_notch_reject;
    I_lpf_fft = I_fft .* bw_lpf;
    % I_lpf_fft = I_fft .* filt;
    I_lpf = real(ifft2(ifftshift(I_lpf_fft)));
    scale = 255.0 / max(I_lpf(:));
    I_lpf = uint8(scale * I_lpf);

    fig = figure;
    fig.WindowState = 'maximized'; 

    subplot(2,2,1);
    imshow(Ia);
    title(dir_name.name, 'Interpreter', 'none');
    subplot(2,2,2);
    imshow(I_lpf);
    title("LPF Image", 'Interpreter', 'none');

    colormap('gray');
    Ia_fft = logfft2(Ia);
    % I_lpf_fft= logfft2(I_lpf);

    subplot(2,2,3);
    imagesc(Ia_fft);
    title("FFT of APT-A");
    % subplot(2,2,4);
    % imagesc(I_lpf_fft);
    % title("FFT of LPF");
end