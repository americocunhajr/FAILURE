% -----------------------------------------------------------------
%  Main_TrescaMises.m
% ----------------------------------------------------------------- 
%  programmer: Americo Cunha Jr
%              americo.cunhajr@gmail.com
%
%  last update: July 12, 2023
% -----------------------------------------------------------------
%  This script is the main file for a program that computes
%  unceratinty propagation in the mechanical analysis of
%  a plate subjected to a plane stress state.
% ----------------------------------------------------------------- 


clc
clear
close all


% program header
% -----------------------------------------------------------
disp('                                                    ')
disp(' ---------------------------------------------------')
disp(' Stress Analysis for Plane Stress Problem           ')
disp(' (uncertanty propagation)                           ')
disp('                                                    ')
disp(' by                                                 ')
disp(' Americo Cunha Jr                                   ')
disp(' Yasar Yanik                                        ')
disp(' Carlo Olivieri                                     ')
disp(' Samuel da Silva                                    ')
disp(' ---------------------------------------------------')
disp('                                                    ')
% -----------------------------------------------------------


% simulation information
% -----------------------------------------------------------
case_name = 'FAILURE';

disp(' '); 
disp([' Case Name: ',num2str(case_name)]);
disp(' ');
% -----------------------------------------------------------



% define deterministic physical parameters
% -----------------------------------------------------------
disp(' '); 
disp(' --- defining physical parameters --- ');
disp(' ');
disp('    ... ');
disp(' ');

% yield strength (Pa)
SY = 210.0e6;

% shaft diameter (m)
d = 80.0e-3;

% axial load (N)
P = 25.0e3;

% axial torque (Nm)
T = 8.0e3;

% normal stress in y direction (Pa)
s_y = 0.0;

% normal stress in y direction (Pa)
s_z = 0.0;

% shear stress in xz (Pa)
t_xz = 0.0;

% shear stress in yz (Pa)
t_yz = 0.0;

% -----------------------------------------------------------


% compute nominal value
% -----------------------------------------------------------
tic

disp(' ')
disp(' --- computing nominal value --- ');
disp(' ');
disp('    ... ');
disp(' ');

    % shaft tranversal area (m^2)
    A = (1/4)*pi*d^2;

    % polar moment of inertia (m^4)
    J = (1/32)*pi*d^4;
    
    % normal stress in x direction (Pa)
    s_x = P/A;
    
    % shear stress in xy (Pa)
    t_xy = -T*(d/2)/J;
    
    % stress tensor (Pa)
    stress_tensor = [s_x  t_xy t_xz; 
                     t_xy s_y  t_yz; 
                     t_xz t_yz s_z ];
    
    % principal stresses (Pa)
    sigma = eig(stress_tensor);
    
    % von Mises stress (Pa)
    s_vm_nominal = sqrt(0.5*((sigma(1)-sigma(2))^2 + ...
                             (sigma(2)-sigma(3))^2 + ...
                             (sigma(3)-sigma(1))^2));
    
    % Tresca stress (Pa)
    s_tr_nominal = 0.5*max([sigma(3)-sigma(2); ...
                            sigma(3)-sigma(1); ...
                            sigma(2)-sigma(1)]);
    
    % safety factors
    SF_vm_nominal = SY/s_vm_nominal;
    SF_tr_nominal = SY/s_tr_nominal;

toc
% -----------------------------------------------------------


% generate random parameters
% -----------------------------------------------------------
tic

disp(' ');
disp(' --- generating random parameters --- ');
disp(' ');
disp('    ... ');
disp(' ');

% RNG seed
rng_stream = RandStream('mt19937ar','Seed',30081984);
RandStream.setGlobalStream(rng_stream);

% number of random samples
Ns = 1024;

% diameter support (m)
d_min = 78.0e-3;
d_max = 82.0e-3;

% coeficient of variation (%)
%cv_P = 0.05;
%cv_T = 0.05;
cv_P = 0.25;
cv_T = 0.25;

% standard deviation
stddev_P = cv_P*P;
stddev_T = cv_T*T;

% uniform random samples for d
d_samp = d_min + (d_max-d_min)*rand(Ns,1);

% Gaussian random samples for P
P_samp = P + stddev_P*randn(Ns,1);

% Gaussian  random samples for T
T_samp = T + stddev_T*randn(Ns,1);

toc
% -----------------------------------------------------------



% Monte Carlo simulation
% -----------------------------------------------------------
tic

disp(' ');
disp(' --- Monte Carlo Simulation --- ');
disp(' ');


% preallocate memory for MC samples
MC_sigma = zeros(Ns,3);
MC_s_vm  = zeros(Ns,1);
MC_s_tr  = zeros(Ns,1);
MC_SF_vm = zeros(Ns,1);
MC_SF_tr = zeros(Ns,1);


% Monte Carlo loop
for imc=1:Ns
    
    if mod(imc,round(sqrt(Ns))) == 0
        disp('')
        disp(imc)
    end
    
    % shaft tranversal area (m^2)
    A = (1/4)*pi*d_samp(imc)^2;

    % polar moment of inertia (m^4)
    J = (1/32)*pi*d_samp(imc)^4;
    
    % normal stress in x direction (Pa)
    s_x = P_samp(imc)/A;
    
    % shear stress in xy (Pa)
    t_xy = -T_samp(imc)*(d_samp(imc)/2)/J;
    
    % stress tensor (Pa)
    stress_tensor = [s_x  t_xy t_xz; 
                     t_xy s_y  t_yz; 
                     t_xz t_yz s_z ];
    
    % principal stresses (Pa)
    sigma = eig(stress_tensor);
    
    % von Mises stress (Pa)
    s_vm = sqrt(0.5*((sigma(1)-sigma(2))^2 + ...
                     (sigma(2)-sigma(3))^2 + ...
                     (sigma(3)-sigma(1))^2));
    
    % Tresca stress (Pa)
    s_tr = 0.5*max(abs([sigma(3)-sigma(2); ...
                        sigma(3)-sigma(1); ...
                        sigma(2)-sigma(1)]));
    
    % principal stresses (Pa)
    MC_sigma(imc,:) = sigma;

    % equivalent stresses (Pa)
    MC_s_vm(imc,1) = s_vm;
    MC_s_tr(imc,1) = s_tr;
    
    % safety factors
    MC_SF_vm(imc,1) = SY/s_vm;
    MC_SF_tr(imc,1) = SY/s_tr;
    
end

toc
% -----------------------------------------------------------



% compute the statistics
% -----------------------------------------------------------
tic

disp(' ')
disp(' --- computing statistics --- ');
disp(' ');
disp('    ... ');
disp(' ');

% number of bins
Nbins = round(sqrt(Ns));

%  histogram estimator
[bins_SF_vm,freq_SF_vm] = Randvar_PDF(MC_SF_vm     ,Nbins);
[bins_SF_tr,freq_SF_tr] = Randvar_PDF(MC_SF_tr     ,Nbins);
[bins_s_vm ,freq_s_vm ] = Randvar_PDF(MC_s_vm      ,Nbins);
[bins_s_tr ,freq_s_tr ] = Randvar_PDF(MC_s_tr      ,Nbins);
[bins_sig1 ,freq_sig1 ] = Randvar_PDF(MC_sigma(:,1),Nbins);
[bins_sig3 ,freq_sig3 ] = Randvar_PDF(MC_sigma(:,3),Nbins);

% kernal density estimator
[ksd_SF_vm,supp_SF_vm] = ksdensity(MC_SF_vm);
[ksd_SF_tr,supp_SF_tr] = ksdensity(MC_SF_tr);
[ksd_s_vm ,supp_s_vm ] = ksdensity(MC_s_vm);
[ksd_s_tr ,supp_s_tr ] = ksdensity(MC_s_tr);
[ksd_sig1 ,supp_sig1 ] = ksdensity(MC_sigma(:,1));
[ksd_sig3 ,supp_sig3 ] = ksdensity(MC_sigma(:,3));

toc
% -----------------------------------------------------------


% post processing
% -----------------------------------------------------------
tic

disp(' ');
disp(' --- post processing --- ');
disp(' ');
disp('    ... ');
disp(' ');



% plot safety factors PDFs
% ...........................................................
gtitle = ' ';
xlab   = ' Safety Factor';
ylab   = ' Probability Density Function';
xmin   = 0.5;
xmax   = 5.0;
ymin   = 0.0;
ymax   = 2.0;
leg1   = 'Tresca';
leg2   = 'von Mises';
gname  = [num2str(case_name),'_SF_pdf'];

fig1 = Graph_BarCurve2(bins_SF_tr,freq_SF_tr,...
                       bins_SF_vm,freq_SF_vm,...
                       supp_SF_tr,ksd_SF_tr,...
                       supp_SF_vm,ksd_SF_vm,...
                       gtitle,leg1,leg2,...
                       xlab,ylab,xmin,xmax,ymin,ymax,gname);
%close(fig1);
% ...........................................................


% plot SF samples
% ...........................................................
gtitle = ' ';
xlab   = ' Safety Factor ';
ylab   = ' ';
xmin   = 0.5;
xmax   = 5.0;
ymin   = 0;
ymax   = Ns;
leg1   = 'Tresca';
leg2   = 'von Mises';
gname  = [num2str(case_name),'_SF_samples'];
flag   = 'eps';
fig2 = Graph_Samples(MC_SF_tr,MC_SF_vm,...
                     SF_tr_nominal,SF_vm_nominal,...
                     gtitle,xlab,ylab,...
                     leg1,leg2,...
                     xmin,xmax,ymin,ymax,gname);
%close(fig2);
% ...........................................................


% plot principal stresses
% ...........................................................
gtitle = ' ';
xlab   = ' \sigma_1';
ylab   = ' \sigma_3';
xmin   = -3.0e8;
xmax   =  3.0e8;
ymin   = -3.0e8;
ymax   =  3.0e8;
leg1   = 'Tresca';
leg2   = 'von Mises';
leg3   = 'Stress State Sample';
gname  = [num2str(case_name),'_sigma'];
flag   = 'eps';
fig3   = Graph_MainStresses(MC_sigma(:,1),MC_sigma(:,3),SY,...
                            gtitle,xlab,ylab,...
                            leg1,leg2,leg3,...
                            xmin,xmax,ymin,ymax,gname);

%close(fig3);
% ...........................................................



% plot principal stresses joint PDF
% ...........................................................
gtitle = ' ';
xlab   = '\sigma_1';
ylab   = '\sigma_3';
xmin   = -150.0e6;
xmax   = -10.0e6;
ymin   =  10.0e6;
ymax   = 150.0e6;
gname  = [num2str(case_name),'_sigma_scatterhist'];

fig4 = Graph_ScatterHist(MC_sigma(:,1),MC_sigma(:,3),gtitle,...
                         xlab,ylab,xmin,xmax,ymin,ymax,gname);
%close(fig4);
% ...........................................................



% plot principal stresses marginal PDFs
% ...........................................................
gtitle = ' ';
xlab   = ' Principal Stress';
ylab   = ' Probability Density Function';
xmin   = -SY;
xmax   =  SY;
ymin   = 0.0;
ymax   = 1.0e-7;
leg1   = '\sigma_1';
leg2   = '\sigma_3';
gname  = [num2str(case_name),'_sigma_pdf'];

fig5 = Graph_BarCurve1(bins_sig1,freq_sig1,...
                       bins_sig3,freq_sig3,...
                       supp_sig1,ksd_sig1,...
                       supp_sig3,ksd_sig3,...
                       gtitle,leg1,leg2,...
                       xlab,ylab,xmin,xmax,ymin,ymax,gname);
%close(fig5);
% ...........................................................


% plot equivalent stresses PDFs
% ...........................................................
gtitle = ' ';
xlab   = ' Equivalent Stress';
ylab   = ' Probability Density Function';
xmin   = 0.0e8;
xmax   = 3.0e8;
ymin   = 0.0;
ymax   = 1.0e-7;
leg1   = 'Tresca';
leg2   = 'von Mises';
gname  = [num2str(case_name),'_s_pdf'];

fig6 = Graph_BarCurve2(bins_s_tr,freq_s_tr,...
                       bins_s_vm,freq_s_vm,...
                       supp_s_tr,ksd_s_tr,...
                       supp_s_vm,ksd_s_vm,...
                       gtitle,leg1,leg2,...
                       xlab,ylab,xmin,xmax,ymin,ymax,gname);
%close(fig6);
% ...........................................................


% plot equivalent stresses samples
% ...........................................................
gtitle = ' ';
xlab   = ' Equivalent Stress ';
ylab   = ' ';
xmin   =   0.0e6;
xmax   = 300.0e6;
ymin   = 0;
ymax   = Ns;
leg1   = 'Tresca';
leg2   = 'von Mises';
gname  = [num2str(case_name),'_s_samples'];
flag   = 'eps';
fig7 = Graph_Samples(MC_s_tr,MC_s_vm,...
                     s_tr_nominal,s_vm_nominal,...
                     gtitle,xlab,ylab,...
                     leg1,leg2,...
                     xmin,xmax,ymin,ymax,gname);
%close(fig7);
% ...........................................................


toc
% -----------------------------------------------------------