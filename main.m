%b = reArrangeImage('Images_Training/im9c.jpg'); %worst
%b = reArrangeImage('Images_Training/im13c.jpg'); %worst

%close all;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%easy pictures
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%########## Dance
% - 4,8
% - half line at end
file = 'Images_Training/im1s.jpg';

%########## Julpolska
% - 4,8
%file = 'Images_Training/im3s.jpg';

%########## Allegro
% - 4,8 
% - with Synkopes
%file = 'Images_Training/im5s.jpg';

%########## Pippi Langstrumpf
% - 2,4,8
%file = 'Images_Training/im8s.jpg';

%########## Bred dina varingar
% - has 2,4,8
% - with Synkopes
%file = 'Images_Training/im9s.jpg';

%########## Titanic
% - has 1,2,4,8
% - with Synkopes
%file = 'Images_Training/im6s.jpg';

%########## Naer det lider mot jul
% - has 2,4,8
% - with Synkopes
% - very long
%file = 'Images_Training/im10s.jpg';

%########## Allemande
% - has 2,4,8,16
%file = 'Images_Training/im13s.jpg';
%file = 'Images_Training/im13s_grey.jpg';

%########## own composition
% - has 4,8,16, 32
%file = 'Images_Training/im14s.jpg';

img = reArrangeImage(file);
tnm034(img);

