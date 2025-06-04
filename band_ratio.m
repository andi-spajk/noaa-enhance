% Band ratio

clear;
clc;


function out = logfft2(img)
    log_img = log(abs(fftshift(fft2(img)))+1);
    scale = 255.0 / max(log_img(:));
    out = uint8(scale * log_img);
end

function out = inverted(I)
    out = zeros(size(I), 'uint16');
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

N = 9;

% dir selection starts at index 3 because . and .. occupy index 1,2

% select a particular dir
% desired = 3;
% desired_range = 3+desired-1;

% select a range of dirs
desired = N;
desired_range = 3:3+desired-1;

% https://stackoverflow.com/a/11621907/13471272
outs = dir("images");
for i = desired_range
    dir_name = outs(i);
    outs_folder = dir(sprintf("images/%s", dir_name.name));

    apt_a = outs_folder(3);
    Ia = double(imread(sprintf("images/%s/%s", dir_name.name, apt_a.name)));
    Ia = uint8(Ia * (255.0 / 2^16));
    apt_b = outs_folder(4);
    Ib = double(imread(sprintf("images/%s/%s", dir_name.name, apt_b.name)));
    Ib = uint8(Ib * (255.0 / 2^16));

    switch(i-2)
    case 1
        Ia = Ia(1:end-350,:);
        Ib = Ib(1:end-350,:);
    case 2
        Ia = Ia(670:end-200,:);
        Ib = Ib(670:end-200,:);
    case 3
        % both channels had a day/night cycle shift
        Ia(646:end,:) = inverted(Ia(646:end,:));
        Ib(646:end,:) = inverted(Ib(646:end,:));
        Ia = Ia(100:end-150,:);
        Ib = Ib(100:end-150,:);
    case 4
        Ia = Ia(250:end-190,:);
        Ib = Ib(250:end-190,:);
    case 5
        % channel A had a day/night cycle shift
        Ia(694:end,:) = inverted(Ia(694:end,:));
        Ia = Ia(475:end-100,:);
        Ib = Ib(475:end-100,:);
    case 6
        % channel A had a day/night cycle shift
        Ia(565:end,:) = inverted(Ia(565:end,:));
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

    % figure;
    % subplot(1,2,1)
    % imshow(Ia);
    % subplot(1,2,2)
    % imshow(Ib);

    % prevent division by zero
    M = size(Ia,1);
    N = size(Ib,2);
    for x=1:M
        for y=1:N
            if Ia(x,y) == 0
                Ia(x,y) = 1;
            end
            if Ib(x,y) == 0
                Ib(x,y) = 1;
            end
        end
    end

    bv = double(Ia) ./ double(Ib);
    bv2 = double(Ib) ./ double(Ia);
    for x=1:M
        for y=1:N
            if bv(x,y) <= 1.0
                bv(x,y) = floor(bv(x,y)*127 + 1);
            else
                bv(x,y) = floor(128 + bv(x,y)/2);
            end
            if bv2(x,y) <= 1.0
                bv2(x,y) = floor(bv2(x,y)*127 + 1);
            else
                bv2(x,y) = floor(128 + bv2(x,y)/2);
            end
        end
    end
    m = max(bv(:));
    bv = uint8(bv * (255.0 / m));
    m = max(bv2(:));
    bv2 = uint8(bv2 * (255.0 / m));

    fig2 = figure;
    fig2.WindowState = 'maximized';
    subplot(3,2,1)
    imshow(bv);
    title("APT-A / APT-B")

    subplot(3,2,2)
    imshow(bv2);
    title("APT-B / APT-A")

    bv_fft = logfft2(bv);
    bv2_fft = logfft2(bv2);

    colormap("gray")
    subplot(3,2,3)
    imagesc(bv_fft)
    title("FFT of A/B")
    subplot(3,2,4)
    imagesc(bv2_fft)
    title("FFT of B/A")

    Ia_fft = logfft2(Ia);
    Ib_fft = logfft2(Ib);

    subplot(3,2,5)
    imagesc(Ia_fft)
    title("FFT of A")
    subplot(3,2,6)
    imagesc(Ib_fft)
    title("FFT of B")
end


