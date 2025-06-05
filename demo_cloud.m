% % Cloud Detection for Enhanced Images 
% close all; clear; clc;
% 
% detectClouds = @(I) imfill(bwareaopen( ...
%     imbinarize(adapthisteq(I), 'adaptive', ...
%     'ForegroundPolarity', 'bright', 'Sensitivity', 0.45) | ...
%     imbinarize(I, graythresh(I)), ...
%     30), 'holes');
% 
% IA_orig = imread('APT-A4.png'); IB_orig = imread('APT-B4.png');
% IA_enh  = imread('APT-A44.png'); IB_enh  = imread('APT-B44.png');
% 
% IA_orig = mat2gray(rgb2gray_if_needed(IA_orig)); IA_orig = IA_orig(250:end-190,:);
% IB_orig = mat2gray(rgb2gray_if_needed(IB_orig)); IB_orig = IB_orig(250:end-190,:);
% IA_enh  = mat2gray(rgb2gray_if_needed(IA_enh));  IA_enh  = IA_enh(250:end-190,:);
% IB_enh  = mat2gray(rgb2gray_if_needed(IB_enh));  IB_enh  = IB_enh(250:end-190,:);
% 
% [overlayA, percentA]         = getOverlayAndPercent(IA_orig, detectClouds);
% [overlayB, percentB]         = getOverlayAndPercent(IB_orig, detectClouds);
% [overlayA_enh, percentA_enh] = getOverlayAndPercent(IA_enh, detectClouds);
% [overlayB_enh, percentB_enh] = getOverlayAndPercent(IB_enh, detectClouds);
% 
% showCloudFigure(overlayA, overlayB, overlayA_enh, overlayB_enh, ...
%     percentA, percentB, percentA_enh, percentB_enh, 'Cloud Detection – Image 4');
% 
% IA_orig = imread('APT-A5.png'); IB_orig = imread('APT-B5.png');
% IA_enh  = imread('APT-A55.png'); IB_enh  = imread('APT-B55.png');
% 
% IA_orig = mat2gray(rgb2gray_if_needed(IA_orig)); IA_orig = IA_orig(475:end-100,:);
% IB_orig = mat2gray(rgb2gray_if_needed(IB_orig)); IB_orig = IB_orig(475:end-100,:);
% IA_enh  = mat2gray(rgb2gray_if_needed(IA_enh));  IA_enh  = IA_enh(475:end-100,:);
% IB_enh  = mat2gray(rgb2gray_if_needed(IB_enh));  IB_enh  = IB_enh(475:end-100,:);
% 
% [overlayA, percentA]         = getOverlayAndPercent(IA_orig, detectClouds);
% [overlayB, percentB]         = getOverlayAndPercent(IB_orig, detectClouds);
% [overlayA_enh, percentA_enh] = getOverlayAndPercent(IA_enh, detectClouds);
% [overlayB_enh, percentB_enh] = getOverlayAndPercent(IB_enh, detectClouds);
% 
% showCloudFigure(overlayA, overlayB, overlayA_enh, overlayB_enh, ...
%     percentA, percentB, percentA_enh, percentB_enh, 'Cloud Detection – Image 5');
% 
% IA_orig = imread('APT-A8.png'); IB_orig = imread('APT-B8.png');
% IA_enh  = imread('APT-A88.png'); IB_enh  = imread('APT-B88.png');
% 
% IA_orig = mat2gray(rgb2gray_if_needed(IA_orig)); IA_orig = IA_orig(250:end-370,:);
% IB_orig = mat2gray(rgb2gray_if_needed(IB_orig)); IB_orig = IB_orig(250:end-370,:);
% IA_enh  = mat2gray(rgb2gray_if_needed(IA_enh));  IA_enh  = IA_enh(250:end-370,:);
% IB_enh  = mat2gray(rgb2gray_if_needed(IB_enh));  IB_enh  = IB_enh(250:end-370,:);
% 
% [overlayA, percentA]         = getOverlayAndPercent(IA_orig, detectClouds);
% [overlayB, percentB]         = getOverlayAndPercent(IB_orig, detectClouds);
% [overlayA_enh, percentA_enh] = getOverlayAndPercent(IA_enh, detectClouds);
% [overlayB_enh, percentB_enh] = getOverlayAndPercent(IB_enh, detectClouds);
% 
% showCloudFigure(overlayA, overlayB, overlayA_enh, overlayB_enh, ...
%     percentA, percentB, percentA_enh, percentB_enh, 'Cloud Detection – Image 8');
% 
% 
% function Iout = rgb2gray_if_needed(I)
%     if size(I,3) == 3
%         Iout = rgb2gray(I);
%     else
%         Iout = I;
%     end
% end
% 
% function [overlay, percent] = getOverlayAndPercent(I, detectFunc)
%     cloudMask = detectFunc(I);
%     overlay = imoverlay(I, bwperim(cloudMask), [1 1 0]);
%     percent = 100 * sum(cloudMask(:)) / numel(cloudMask);
% end
% 
% function showCloudFigure(overlayA, overlayB, overlayA_enh, overlayB_enh, ...
%                          percentA, percentB, percentA_enh, percentB_enh, figTitle)
%     figure('Name', figTitle, 'Units', 'normalized', 'Position', [0.2 0.2 0.6 0.5]);
%     tiledlayout(2,2, 'Padding', 'compact', 'TileSpacing', 'compact');
%     nexttile; imshow(overlayA); title(sprintf('Clouds in A (%.2f%%)', percentA));
%     nexttile; imshow(overlayB); title(sprintf('Clouds in B (%.2f%%)', percentB));
%     nexttile; imshow(overlayA_enh); title(sprintf('Clouds in Enh A (%.2f%%)', percentA_enh));
%     nexttile; imshow(overlayB_enh); title(sprintf('Clouds in Enh B (%.2f%%)', percentB_enh));
% end
% 
% 
% 
% 
% % Cloud Detection for Band Ratio
% close all; clear; clc;
% 
% detectClouds = @(I) imfill(bwareaopen( ...
%     imbinarize(adapthisteq(I, 'NumTiles', [4 4]), 'adaptive', ...
%     'ForegroundPolarity', 'bright', 'Sensitivity', 0.45) | ...
%     imbinarize(I, graythresh(I)), 30), 'holes');
% 
% 
% IA_orig = imread('APT-A4.png');
% IB_orig = imread('APT-B4.png');
% IA_br   = imread('A_over_B4.png');
% IB_br   = imread('B_over_A4.png');
% 
% IA_orig = mat2gray(rgb2gray_if_needed(IA_orig)); IA_orig = IA_orig(475:end-100,:);
% IB_orig = mat2gray(rgb2gray_if_needed(IB_orig)); IB_orig = IB_orig(475:end-100,:);
% IA_br   = mat2gray(rgb2gray_if_needed(IA_br));   
% IB_br   = mat2gray(rgb2gray_if_needed(IB_br));  
% 
% overlayA     = imoverlay(IA_orig, bwperim(detectClouds(IA_orig)), [1 1 0]);
% overlayB     = imoverlay(IB_orig, bwperim(detectClouds(IB_orig)), [1 1 0]);
% overlayA_br  = imoverlay(IA_br,   bwperim(detectClouds(IA_br)),   [1 1 0]);
% overlayB_br  = imoverlay(IB_br,   bwperim(detectClouds(IB_br)),   [1 1 0]);
% 
% figure('Name','Cloud Detection – Image 2','Units','normalized','Position',[0.2 0.2 0.6 0.5]);
% tiledlayout(2,2,'Padding','compact','TileSpacing','compact');
% nexttile; imshow(overlayA);    title('Clouds in A');
% nexttile; imshow(overlayB);    title('Clouds in B');
% nexttile; imshow(overlayA_br); title('Clouds in Band Ratio A');
% nexttile; imshow(overlayB_br); title('Clouds in Band Ratio B');
% 
% IA_orig = imread('APT-A5.png');
% IB_orig = imread('APT-B5.png');
% IA_br   = imread('A_over_B5.png');
% IB_br   = imread('B_over_A5.png');
% 
% IA_orig = mat2gray(rgb2gray_if_needed(IA_orig)); IA_orig = IA_orig(475:end-100,:);
% IB_orig = mat2gray(rgb2gray_if_needed(IB_orig)); IB_orig = IB_orig(475:end-100,:);
% IA_br   = mat2gray(rgb2gray_if_needed(IA_br));   
% IB_br   = mat2gray(rgb2gray_if_needed(IB_br));   
% 
% overlayA     = imoverlay(IA_orig, bwperim(detectClouds(IA_orig)), [1 1 0]);
% overlayB     = imoverlay(IB_orig, bwperim(detectClouds(IB_orig)), [1 1 0]);
% overlayA_br  = imoverlay(IA_br,   bwperim(detectClouds(IA_br)),   [1 1 0]);
% overlayB_br  = imoverlay(IB_br,   bwperim(detectClouds(IB_br)),   [1 1 0]);
% 
% figure('Name','Cloud Detection – Image 5','Units','normalized','Position',[0.2 0.2 0.6 0.5]);
% tiledlayout(2,2,'Padding','compact','TileSpacing','compact');
% nexttile; imshow(overlayA);    title('Clouds in A');
% nexttile; imshow(overlayB);    title('Clouds in B');
% nexttile; imshow(overlayA_br); title('Clouds in Band Ratio A');
% nexttile; imshow(overlayB_br); title('Clouds in Band Ratio B');
% 
% IA_orig = imread('APT-A8.png');
% IB_orig = imread('APT-B8.png');
% IA_br   = imread('A_over_B8.png');
% IB_br   = imread('B_over_A8.png');
% 
% IA_orig = mat2gray(rgb2gray_if_needed(IA_orig)); IA_orig = IA_orig(250:end-370,:);
% IB_orig = mat2gray(rgb2gray_if_needed(IB_orig)); IB_orig = IB_orig(250:end-370,:);
% IA_br   = mat2gray(rgb2gray_if_needed(IA_br));   
% IB_br   = mat2gray(rgb2gray_if_needed(IB_br)); 
% 
% overlayA     = imoverlay(IA_orig, bwperim(detectClouds(IA_orig)), [1 1 0]);
% overlayB     = imoverlay(IB_orig, bwperim(detectClouds(IB_orig)), [1 1 0]);
% overlayA_br  = imoverlay(IA_br,   bwperim(detectClouds(IA_br)),   [1 1 0]);
% overlayB_br  = imoverlay(IB_br,   bwperim(detectClouds(IB_br)),   [1 1 0]);
% 
% figure('Name','Cloud Detection – Image 8','Units','normalized','Position',[0.2 0.2 0.6 0.5]);
% tiledlayout(2,2,'Padding','compact','TileSpacing','compact');
% nexttile; imshow(overlayA);    title('Clouds in A');
% nexttile; imshow(overlayB);    title('Clouds in B');
% nexttile; imshow(overlayA_br); title('Clouds in Band Ratio A');
% nexttile; imshow(overlayB_br); title('Clouds in Band Ratio B');
% 
% 
% function Iout = rgb2gray_if_needed(I)
%     if size(I,3) == 3
%         Iout = rgb2gray(I);
%     else
%         Iout = I;
%     end
% end
% 
% 
% 
% % Feature Matching Og v Enh
% close all; clear; clc;
% 
% imagePairs = {
%     "APT-A4.png", "APT-A44.png", "Feature Matching – A4 vs A44";
%     "APT-B4.png", "APT-B44.png", "Feature Matching – B4 vs B44";
%     "APT-A5.png", "APT-A55.png", "Feature Matching – A5 vs A55";
%     "APT-B5.png", "APT-B55.png", "Feature Matching – B5 vs B55";
%     "APT-A8.png", "APT-A88.png", "Feature Matching – A8 vs A88";
%     "APT-B8.png", "APT-B88.png", "Feature Matching – B8 vs B88";
% };
% 
% for i = 1:size(imagePairs,1)
%     I1 = imread(imagePairs{i,1});
%     I2 = imread(imagePairs{i,2});
% 
%     if size(I1,3) == 3, I1 = rgb2gray(I1); end
%     if size(I2,3) == 3, I2 = rgb2gray(I2); end
% 
%     cropI1 = smartCrop(I1);
%     cropI2 = smartCrop(I2);
% 
%     points1 = detectSURFFeatures(cropI1);
%     points2 = detectSURFFeatures(cropI2);
% 
%     [features1, validPoints1] = extractFeatures(cropI1, points1);
%     [features2, validPoints2] = extractFeatures(cropI2, points2);
% 
%     indexPairs = matchFeatures(features1, features2, 'Unique', true);
% 
%     matchedPoints1 = validPoints1(indexPairs(:,1));
%     matchedPoints2 = validPoints2(indexPairs(:,2));
% 
%     figure('Name', imagePairs{i,3}, 'Units', 'normalized', 'Position', [0.2 0.2 0.6 0.5]);
%     showMatchedFeatures(cropI1, cropI2, matchedPoints1, matchedPoints2, 'montage');
%     title(imagePairs{i,3});
% end
% 
% function Iout = smartCrop(I)
%     h = size(I,1);
% 
%     if h > 800     
%         Iout = I(250:end-190,:);
%     elseif h > 600 
%         Iout = I(475:end-100,:);
%     else  
%         Iout = I(250:end-370,:);
%     end
% end
% 
% 
% 
% 
% % Feature Matching for Og vs Band Ratio 
% close all; clear; clc;
% 
% imagePairs = {
%     "APT-A4.png", "A_over_B4.png", "Feature Matching – A4 vs A_over_B4";
%     "APT-B4.png", "B_over_A4.png", "Feature Matching – B4 vs B_over_A4";
%     "APT-A5.png", "A_over_B5.png", "Feature Matching – A5 vs A_over_B5";
%     "APT-B5.png", "B_over_A5.png", "Feature Matching – B5 vs B_over_A5";
%     "APT-A8.png", "A_over_B8.png", "Feature Matching – A8 vs A_over_B8";
%     "APT-B8.png", "B_over_A8.png", "Feature Matching – B8 vs B_over_A8";
% };
% 
% for i = 1:size(imagePairs,1)
%     I_og = imread(imagePairs{i,1});
%     I_br = imread(imagePairs{i,2});
%     if size(I_og,3) == 3, I_og = rgb2gray(I_og); end
%     if size(I_br,3) == 3, I_br = rgb2gray(I_br); end
% 
%     I_og = cropOriginal(I_og);
% 
%     points_og = detectSURFFeatures(I_og);
%     points_br = detectSURFFeatures(I_br);
% 
%     [features_og, validPoints_og] = extractFeatures(I_og, points_og);
%     [features_br, validPoints_br] = extractFeatures(I_br, points_br);
% 
%     indexPairs = matchFeatures(features_og, features_br, 'Unique', true);
%     matchedPoints_og = validPoints_og(indexPairs(:,1));
%     matchedPoints_br = validPoints_br(indexPairs(:,2));
% 
%     figure('Name', imagePairs{i,3}, 'Units', 'normalized', 'Position', [0.2 0.2 0.6 0.5]);
%     showMatchedFeatures(I_og, I_br, matchedPoints_og, matchedPoints_br, 'montage');
%     title(imagePairs{i,3});
% end
% 
% function Iout = cropOriginal(I)
%     h = size(I,1);
%     if h > 800     
%         Iout = I(670:end-200,:);
%     elseif h > 600 
%         Iout = I(475:end-100,:);
%     else          
%         Iout = I(250:end-370,:);
%     end
% end
