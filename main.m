%b = reArrangeImage('Images_Training/im9c.jpg'); %worst
%file = 'Images_Training/im13c.jpg'; %worst

close all;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%easy pictures
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
files = [];
%########## Dance %%%%%%%%%%%%%%%%%%%%%%%%%%%% 1
% - 4,8
% - half line at end
file = {'Images_Training/im1s.jpg'};
files = [files; file];
files
%file = 'Images_Training/im1see.jpg';

%########## Julpolska %%%%%%%%%%%%%%%%%%%%%%%% 2
% - 4,8
file = {'Images_Training/im3s.jpg'};
files = [files; file];
files

%########## Allegro %%%%%%%%%%%%%%%%%%%%%%%%%% 3
% - 4,8 
% - with Synkopes
file = {'Images_Training/im5s.jpg'};
files = [files; file];

%########## Pippi Langstrumpf %%%%%%%%%%%%%%%% 4
% - 2,4,8
file = {'Images_Training/im8s.jpg'};
files = [files; file];

%########## Bred dina varingar %%%%%%%%%%%%%%% 5
% - has 2,4,8
% - with Synkopes
file = {'Images_Training/im9s.jpg'};
files = [files; file];

%########## Titanic %%%%%%%%%%%%%%%%%%%%%%%%%% 6
% - has 1,2,4,8
% - with Synkopes
file = {'Images_Training/im6s.jpg'};
files = [files; file];

%########## Naer det lider mot jul %%%%%%%%%%% 7
% - has 2,4,8
% - with Synkopes
% - very long
file = {'Images_Training/im10s.jpg'};
files = [files; file];

%########## Allemande %%%%%%%%%%%%%%%%%%%%%%% 8
% - has 2,4,8,16
file = {'Images_Training/im13s.jpg'};
%file = 'Images_Training/im13s_grey.jpg';
files = [files; file];

%########## own composition 
% - has 4,8,16, 32
%file = 'Images_Training/im14s.jpg';
%files = [files; file];

%########## Guantanamera %%%%%%%%%%%%%%%%%%%% 9
%file = {'Images_Training/im15s.jpg'};
%needed to adapt size!!!
%file = 'Images_Training/im15se.jpg';
%files = [files; file];
%files

%for file = files'
    %file = files(9);
    img = reArrangeImage(char(file));
    tnm034(img);
%end
disp('Congratulations. You finished =D');

