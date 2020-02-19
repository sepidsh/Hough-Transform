function [img1] = myImageFilter(img0, h)
  
    image_size=size(img0); 
    % Apply Same Padding 
    center = floor((size(h)-1)/2);
    img0_temp = padarray(img0,[center(1), center(2)],'replicate');
    % Perpare Fillter For Convolution
    filter = rot90(h,2);
    filter_size=size(filter);
    %Apply Convolution
    filter_coloums_rep= repmat(filter_coloums, [1,size( im2col(img0_temp, [filter_size(1), filter_size(2)]),2)]);
    img1 = reshape(sum( im2col(img0_temp, [filter_size(1), filter_size(2)]) .* filter_coloums_rep), [image_size(1), image_size(2)]);


end
