clear all;
close all;
Base  = '..\covid19_ECG\ECG Images of COVID-19 Patients (250)\type_2';
List  = dir(fullfile(Base, '**', '*.jpg'));
Files = fullfile({List.folder}, {List.name});
load('coordinates.mat');
covid_statistical=[];
%iFile = 1

% figure, set(gcf,'visible','off');
for iFile = 1:numel(Files)
    
    I = imread(Files{iFile});
    %imshow(I)
    %k�rpma
    % [J,rect] = imcrop(I); %koordinatlar� bulmak icin
    %[103.5 104.5 723 432] t�m ecg
    % imshow(I2)
    %I3 = imcrop(I2,[40.5 4.5 152 90]); % bir kanal
    % imshow(I_image)
   
    %different sizes :(
    size_I=size (I);
    if (size_I(1)<950)
        I2 = imcrop(I,[38.5 195.5 1105 662]);
        %%%%[J,rect] = imcrop(I2); %koordinatlar� bulmak icin
        
        
        
        I_image= imcrop(I2,[63.5 0.5 189 189]);
        aVR_image= imcrop(I2,[360.5 0.5 189 189]);   % imshow(aVR_image)
        V1_image=imcrop(I2,[593.5 0.5 189 189]);
        V4_image= imcrop(I2,[871.5 0.5 189 189]);
        II_image= imcrop(I2,[63.5 189.5 189 189]);
        aVL_image= imcrop(I2,[360.5 189.5 189 189]);
        V2_image=imcrop(I2,[593.5 189.5 189 189]);
        V5_image= imcrop(I2,[871.5 189.5 189 189]);
        III_image= imcrop(I2,[63.5 378.5 189 189]);
        aVF_image= imcrop(I2,[360.5 378.5 189 189]);
        V3_image=imcrop(I2,[593.5 378.5 189 189]);
        V6_image= imcrop(I2,[871.5 378.5 189 189]);
        
        
    else %normal or stisfied size
        I2 = imcrop(I,[41.5 218.5 1230 733]);
        
        
        I_image= imcrop(I2,[72.5 0.5 189 189]);
        aVR_image= imcrop(I2,[402.5 0.5 189 189]); % imshow(aVR_image)
        V1_image=imcrop(I2,[685.5 0.5 189 189]);
        V4_image= imcrop(I2,[990 0.5 189 189]);
        II_image= imcrop(I2,[72.5 189.5 189 189]);
        aVL_image= imcrop(I2,[402.5 189.5 189 189]);
        V2_image=imcrop(I2,[685.5 189.5 189 189]);
        V5_image= imcrop(I2,[990 189.5 189 189]);
        III_image= imcrop(I2,[72.5 378.5 189 189]);
        aVF_image= imcrop(I2,[402.5 378.5 189 189]);
        V3_image=imcrop(I2,[685.5 378.5 189 189]);
        V6_image= imcrop(I2,[990 378.5 189 189]);
        
    end
    
    % -li sinyal olu�turma
    I_image_neg=I_image(end:-1:1,:,:); %figure, imshow(I_image_neg)
    aVR_image_neg=aVR_image(end:-1:1,:,:);
    II_image_neg=II_image(end:-1:1,:,:);
    aVL_image_neg=aVL_image(end:-1:1,:,:);
    III_image_neg=III_image(end:-1:1,:,:);
    aVF_image_neg=aVF_image(end:-1:1,:,:);
    
    all_cropped_image=cat(4, I_image, aVL_image, III_image_neg, aVF_image_neg, ...
        II_image_neg, aVR_image, I_image_neg, aVL_image_neg, III_image, aVF_image,...
        II_image, aVR_image_neg, V1_image, V2_image, V3_image, V4_image, V5_image, V6_image );
    %size(all_cropped_image)
    % figure, imshow(all_cropped_image(:,:,:,5));
    
    
    % coordinate_labels=["I", "aVL" , "III(-)" ,"aVF(-)" ,"II(-)" ,"aVR", "I(-)" , "aVL(-)", ...
    %"III", "aVF", "II", "aVR(-)", "V1", "V2", "V3", "V4", "V5", "V6"];
    
    
    %adjust
    for i=1:18
        
        K = imadjust(all_cropped_image(:,:,:,i),[0.1 0.7],[]);
        % figure
        % imshow(K)
        % arkaplan kald�rma
        
        binaryImage = K(:, :, 2) < 250; % Or whatever threshold works.
        binaryImage = bwareafilt(binaryImage, 1); % Extract only the largest blob.
        % figure, imshow(1-binaryImage)
        all_cropped_image_binary(:,:,i)=(binaryImage);
        
        
%         %figure, imshow (all_cropped_image_binary(:,:,5))
%         switch (i)
%             case 1
%                 channel='\I\';
%             case 11
%                 channel='\II\';
%             case 9
%                 channel='\III\';
%             case 6
%                 channel='\aVR\';
%             case 2
%                 channel='\avL\';
%             case 10
%                 channel='\avF\';
%             case 13
%                 channel='\V1\';
%             case 14
%                 channel='\V2\';
%             case 15
%                 channel='\V3\';
%             case 16
%                 channel='\V4\';
%             case 17
%                 channel='\V5\';
%             case 18
%                 channel='\V6\';
%             case 7
%                 channel='\I(-)\';
%             case 5
%                 channel='\II(-)\';
%             case 3
%                 channel='\III(-)\';
%             case 12
%                 channel='\aVR(-)\';
%             case 8
%                 channel='\avL(-)\';
%             case 4
%                 channel='\avF(-)\';
%                 
%         end
%         
%         % coordinate_labels=["I", "aVL" , "III(-)" ,"aVF(-)" ,"II(-)" ,"aVR", "I(-)" , "aVL(-)", ...
%         %"III", "aVF", "II", "aVR(-)", "V1", "V2", "V3", "V4", "V5", "V6"];
%         
%         %%save ECG images
%         kayit_yeri=strcat( '..\covid19_ECG\preprocessed_dataset\covid_19'...
%             ,channel);
%         kayit_yeri=strcat(kayit_yeri,num2str(iFile+89)); %continue on  type1
%         kayit_yeri=strcat(kayit_yeri,'.png');
%         imshow (1-all_cropped_image_binary(:,:,i))
%         export_fig( kayit_yeri ,'-transparent', '-r300')
%         %-m2.5
%         
        
    end % 12 channel
    
    
    % %comatrix
    % comat=[];
    % for k=1:18
    %     comat= [comat graycomatrix(logical(all_cropped_image_binary(:,:,k)))];
    %
    % end
    
    
    
    %as�l feature cikarma burasi, eskiden matrix al�yorduk �imdi burada her�eyi
    %d�zg�nce hesapl�yoruz
    comat_energy=[];
%     comat_correlation=[];
%     comat_contrast=[];
%     comat_homogeneity=[];
    
    for k=1:18
        glcms=graycomatrix(logical(all_cropped_image_binary(:,:,k)));
        stats = graycoprops(glcms);% Calculate properties of gray-level co-occurrence matrix
        
        comat_energy= [comat_energy stats.Energy];
       % comat_correlation= [comat_correlation stats.Correlation];
       % comat_contrast= [comat_contrast stats.Contrast];
       % comat_homogeneity= [comat_homogeneity stats.Homogeneity];
        
    end %feature exraction
    
    
    %statistical difference
  %  covid_statistical= [covid_statistical; comat_energy' comat_correlation' comat_contrast' comat_homogeneity'];
    %  statistical_label= ["Energy","Correlation","Contrast","Homogeneity"] ;
    
    
    %loksayona g�re haritalama
    
    
    
%     % x_coordinates = [2.5; 1.5; 3; 2; 1; 2; 3; 5; 6; 7; 6; 5; 6.5; 5.5];
%     % y_coordinates = [7; 5.7; 5.8; 5; 4; 2; 1; 1; 2; 4; 5; 5.8; 6; 7];
%     xi=linspace(min(x_coordinates),max(x_coordinates),100);
%     yi=linspace(min(y_coordinates),max(y_coordinates),100);
%     [XI YI]=meshgrid(xi,yi);
%     ZI = griddata(x_coordinates,y_coordinates,comat_energy(1,1:end)',XI,YI,'natural');
%     
%     figure, set(gcf,'visible','off');
%     contourf(XI,YI,ZI,50,'edgecolor','none');
% %     colormap(jet);
%     axis off
%     set(gcf,'position',[-15,15,710,720])
%     set(gca,'LooseInset',get(gca,'TightInset'))
% 
%     %save features map
%     kayit_yeri=strcat( '..\covid19_ECG\feature_maps\covid_19\'...
%         ,num2str(iFile+89));
%     kayit_yeri=strcat(kayit_yeri,'.png');
%     export_fig( kayit_yeri ,'-transparent') %, '-r300'
%     %-m2.5
    
    
    
end% dosya










