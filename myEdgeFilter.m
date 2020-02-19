function [img1] = myEdgeFilter(img0, sigma)
    
    
    % smooth out the image
    img_temp = myImageFilter(img0, fspecial('gaussian',  (ceil(sigma*3)*2) + 1, sigma));

    %Vertical Edges
    img_ver = myImageFilter(img_temp,  fspecial('sobel'));
    %Horizantal Edges
    img_hor = myImageFilter(img_temp, transpose(fspecial('sobel')));
   
   
    
    % gradient magnitude
    magnitude = sqrt(img_ver.^2 + img_hor.^2);
    
    
    % check thick edges results
    % figure;
    % imshow(magnitude, [min(min(magnitude)) max(max(magnitude))]);
    
    % Try to extract thin edges that have a single pixel width by
    % non-maximum suppression
    
    % gradient direction in degrees
    % https://www.mathworks.com/help/matlab/ref/atan2d.html
    direction = atan2d(img_hor,img_ver);
    

    % 0 and 180 degree -> 0
    % 45 and -135 degree -> 1
    % 90 and -90 degree -> 2
    % 135 and -45 degree -> 3
    direction = round(direction/45);
    direction(direction < 0) = direction(direction < 0) + 4;
    direction( direction == 4) = 0;
    
    

    % non-maximum suppression
    % move a 3 � 3  filter over the image
    % r and l are two directions in each angle
    filter_0_r = [0  0  0;
                  0 -1  1;
                  0  0  0];
              
    filter_0_l = [0  0  0;
                  1 -1  0;
                  0  0  0];

    filter_45_r = [0  0  1;
                   0 -1  0;
                   0  0  0];
             
    filter_45_l = [0  0  0;
                   0 -1  0;
                   1  0  0];

    filter_90_r = [0  1  0;
                  0 -1  0;
                  0  0  0];
             
    filter_90_l = [0  0  0;
                   0 -1  0;
                   0  1  0];

    filter_135_r = [1  0  0;
                   0 -1  0;
                   0  0  0];
              
    filter_135_l = [0  0  0;
                   0 -1  0;
                   0  0  1];


    % compute gradient magnitude difference in each direction for every
    % point
    img_0_r = myImageFilter(magnitude, filter_0_r);
    img_0_l = myImageFilter(magnitude, filter_0_l);

    img_45_r = myImageFilter(magnitude, filter_45_r);
    img_45_l = myImageFilter(magnitude, filter_45_l);

    img_90_r = myImageFilter(magnitude, filter_90_r);
    img_90_l = myImageFilter(magnitude, filter_90_l);

    img_135_r = myImageFilter(magnitude, filter_135_r);
    img_135_l = myImageFilter(magnitude, filter_135_l);
    
    
    % index_i: store indexed where the angle equals to 
    index_0 = (direction==0);
    index_45 = (direction==1);
    index_90 = (direction==2);
    index_135 = (direction==3);


    % we store maximum magnitude difference in every point based on the
    % relative direction
    NMS_img = zeros(size(magnitude));

    NMS_img(index_0) = max(img_0_r(index_0), img_0_l(index_0));
    NMS_img(index_45) = max(img_45_r(index_45), img_45_l(index_45));
    NMS_img(index_90) = max(img_90_r(index_90), img_90_l(index_90));
    NMS_img(index_135) = max(img_135_r(index_135), img_135_l(index_135));

    % if the maximum is negetive then keep the original value, else set its
    % value to zero
    img1 = zeros(size(magnitude));
    img1(NMS_img<0) = magnitude(NMS_img<0);
   

end
    
                
        
        
