*CMZ :  2.08/02 14/07/99  18.39.55  by  Hannes Jung
*CMZ :  2.08/00 06/06/99  17.16.57  by  Hannes Jung
*CMZ :  2.07/03 24/05/99  16.49.51  by  Hannes Jung
*-- Author :    Hannes Jung   03/04/94

      SUBROUTINE RYSTFU(KF,XI,Q2I,XPQ)
      Implicit None
      Integer KF
      Real XI,Q2I

C...Gives electron, photon, pi+, neutron and proton parton structure
C...functions according to a few different parametrizations. Note
C...that what is coded is x times the probability distribution,
C...i.e. xq(x,Q2) etc.
C...MODIFIED FOR USE IN HERACLES 4.2 (BY H.SPIESBERGER, 8.2.93)
      Real PYSTOP,PYSLAM
      Integer NPYMOD,NPYMAX,NPYMIN
      COMMON /PYSTFUC/ PYSTOP,PYSLAM,NPYMOD,NPYMAX,NPYMIN
C Input:
C   PYSTOP = top mass
C   NPYMAX = maximal flavour
C   NPYMIN = minimal flavour
C   NPYMOD = Choice of parametrization
      Integer LUNTES,LUNDAT,LUNIN,LUNOUT,LUNRND
      COMMON /HSUNTS/ LUNTES,LUNDAT,LUNIN,LUNOUT,LUNRND
      Integer LPAR,LPARIN,IPART
      COMMON /HSPARL/ LPAR(20),LPARIN(12),IPART
*KEEP,RGRAHER.
      REAL XPQDIF,XPQPI
	Integer IHERPYS
	Integer NBQ2,NBX
      PARAMETER (NBQ2=20)
      PARAMETER (NBX=20)
      COMMON /RAHER/ IHERPYS,XPQDIF(-6:6,NBX,NBQ2),XPQPI(-6:6,NBX,NBQ2)
*KEEP,RGRGRIDF2.
      DOUBLE PRECISION XX,Q2X
      COMMON /RGRIDF2/ XX(NBX),Q2X(NBQ2)
      REAL F2_DIS,F2_DIF,F2_PI
      COMMON /F2VAL/ F2_DIS(NBX,NBQ2),F2_DIF(NBX,NBQ2),F2_PI(NBX,NBQ2)
cNEW
      DOUBLE PRECISION F2DIS,F2DIF,F2PI
      COMMON /F2INT/ F2DIS,F2DIF,F2PI
cNEW
*KEEP,RGLUDAT1.
      REAL PARU,PARJ
      INTEGER MSTU,MSTJ
      COMMON/LUDAT1/MSTU(200),PARU(200),MSTJ(200),PARJ(200)
C      SAVE

*KEEP,RGLUDAT2.
      REAL PMAS,PARF,VCKM
      INTEGER KCHG
      COMMON/LUDAT2/KCHG(500,3),PMAS(500,4),PARF(2000),VCKM(4,4)
C      SAVE

*KEEP,RGPYPARS.
      INTEGER IPYPAR
      PARAMETER (IPYPAR=200)
      REAL PARP
      INTEGER MSTP
      COMMON/PYPARS/MSTP(IPYPAR),PARP(IPYPAR)
C      SAVE

*KEND.
      Real XPQ,XQ,TX,TT,TS,CEHLQ,CDO,COW,CMT,EXMT,ALAM,XPQQ,SCALE
      Integer NEHLQ,NF,KPART
      DIMENSION XPQ(-6:6)
      DIMENSION XQ(9)
      DIMENSION TX(6),TT(6),TS(6),NEHLQ(8,2),
     +CEHLQ(6,6,2,8,2),CDO(3,6,5,2),COW(3,5,4,2),CMT(0:3,0:2,9,4),
     +EXMT(0:3)
      COMMON/ALPHA/NF,ALAM

      DIMENSION XPQQ(-24:24)
      COMMON /PINT/ SCALE,KPART
      DOUBLE PRECISION XXX,QQ,UPV,DNV,USEA,DSEA,STR,CHM,BOT,TOP,GLU,
     +VAL(20)
      DOUBLE PRECISION XP2,XMAX,XPRT
*KEEP,RGDIFFR.
      INTEGER NG,NPOM
      DOUBLE PRECISION T2MAX,XF,ALPHP,RN2,EPSP,QMI,YMI,QMA,YMA
      COMMON/DIFFR/T2MAX,XF,ALPHP,RN2,EPSP,QMI,YMI,QMA,YMA,NG,NPOM
      INTEGER IREM
      COMMON/PREMNANT/IREM
*KEND.
      INTEGER IRUNA,IQ2,IRUNAEM
      INTEGER IPRO
      DOUBLE PRECISION Q2START,W_Q2,OMEG2
      COMMON/RAPA /IPRO,IRUNA,IQ2,IRUNAEM,Q2START,W_Q2,OMEG2

*KEEP,RGRAPGKI.
      REAL YY,XEL,XPR,PT2H,SHH,T2GKI,XFGKI
      COMMON/RAPGKI/ YY,XEL,XPR,PT2H,SHH,T2GKI,XFGKI
      REAL ZQGKI,XPGKI,PHITGKI
      COMMON/MEINFO/ZQGKI,XPGKI,PHITGKI
C     SAVE

*KEEP,RGDISDIF.
      INTEGER IDIR,IDISDIF
      COMMON/DISDIF/ IDIR,IDISDIF
*KEEP,RGHS45.
      INTEGER IHERAC,KPAHS
      DOUBLE PRECISION YHS,XHS,Q2HS
      COMMON /HS45/ IHERAC,KPAHS,YHS,XHS,Q2HS
*KEND.
      Real FUNX,FLOW,FUP,FXT2,ULALEM,PYGAMM
      EXTERNAL FUNX,FLOW,FUP,FXT2
      EXTERNAL ULALEM,PYGAMM
      LOGICAL PDFFIRST
      COMMON /W50516/PDFFIRST
      CHARACTER*20 PARM(20)
      Integer NPDF,IP,IS,I,IT,NX,IEX,IPN,IFL,IQ,IX,KFA,mst51
      Integer ITER,NSTP,NFE,KFL,ISTP,NSET
      Real VX,EULBET,X,Y,slo,shi,q2,q2t,xd,qd,X1P,X2P,EPS,SUM
      Real aem,PME,xl,x1l,HLE,HBE,HDE,HEE,HCB,HCA,AEMP,HLG
      Real HLW,T,SXPGL,SXPQU,SXPQD,SUMXP,WTSTP,Q2IN,SD,TMIN,TMAX,VT
      Real XQSUM,CXS,EXMTS,XC,XLL,SD2,XPS
      Real XE,XLE,XG,SUMXPP,FCONV,XPGA,XPGL,XPQU,XPQD
      DATA NPDF/0/,UPV,DNV,DSEA,STR,CHM,BOT,TOP,GLU/8*0.D0/
      DATA VX/0.0/
c.hju
C...The following data lines are coefficients needed in the
C...Owens pion structure function parametrizations, see below.
C...Expansion coefficients for up and down valence quark distributions.
      DATA ((COW(IP,IS,1,1),IS=1,5),IP=1,3)/
     +  4.0000E-01,  7.0000E-01,  0.0000E+00,  0.0000E+00,  0.0000E+00,
     + -6.2120E-02,  6.4780E-01,  0.0000E+00,  0.0000E+00,  0.0000E+00,
     + -7.1090E-03,  1.3350E-02,  0.0000E+00,  0.0000E+00,  0.0000E+00/
      DATA ((COW(IP,IS,1,2),IS=1,5),IP=1,3)/
     +  4.0000E-01,  6.2800E-01,  0.0000E+00,  0.0000E+00,  0.0000E+00,
     + -5.9090E-02,  6.4360E-01,  0.0000E+00,  0.0000E+00,  0.0000E+00,
     + -6.5240E-03,  1.4510E-02,  0.0000E+00,  0.0000E+00,  0.0000E+00/
C...Expansion coefficients for gluon distribution.
      DATA ((COW(IP,IS,2,1),IS=1,5),IP=1,3)/
     +  8.8800E-01,  0.0000E+00,  3.1100E+00,  6.0000E+00,  0.0000E+00,
     + -1.8020E+00, -1.5760E+00, -1.3170E-01,  2.8010E+00, -1.7280E+01,
     +  1.8120E+00,  1.2000E+00,  5.0680E-01, -1.2160E+01,  2.0490E+01/
      DATA ((COW(IP,IS,2,2),IS=1,5),IP=1,3)/
     +  7.9400E-01,  0.0000E+00,  2.8900E+00,  6.0000E+00,  0.0000E+00,
     + -9.1440E-01, -1.2370E+00,  5.9660E-01, -3.6710E+00, -8.1910E+00,
     +  5.9660E-01,  6.5820E-01, -2.5500E-01, -2.3040E+00,  7.7580E+00/
C...Expansion coefficients for (up+down+strange) quark sea distribution.
      DATA ((COW(IP,IS,3,1),IS=1,5),IP=1,3)/
     +  9.0000E-01,  0.0000E+00,  5.0000E+00,  0.0000E+00,  0.0000E+00,
     + -2.4280E-01, -2.1200E-01,  8.6730E-01,  1.2660E+00,  2.3820E+00,
     +  1.3860E-01,  3.6710E-03,  4.7470E-02, -2.2150E+00,  3.4820E-01/
      DATA ((COW(IP,IS,3,2),IS=1,5),IP=1,3)/
     +  9.0000E-01,  0.0000E+00,  5.0000E+00,  0.0000E+00,  0.0000E+00,
     + -1.4170E-01, -1.6970E-01, -2.4740E+00, -2.5340E+00,  5.6210E-01,
     + -1.7400E-01, -9.6230E-02,  1.5750E+00,  1.3780E+00, -2.7010E-01/
C...Expansion coefficients for charm quark sea distribution.
      DATA ((COW(IP,IS,4,1),IS=1,5),IP=1,3)/
     +  0.0000E+00, -2.2120E-02,  2.8940E+00,  0.0000E+00,  0.0000E+00,
     +  7.9280E-02, -3.7850E-01,  9.4330E+00,  5.2480E+00,  8.3880E+00,
     + -6.1340E-02, -1.0880E-01, -1.0852E+01, -7.1870E+00, -1.1610E+01/
      DATA ((COW(IP,IS,4,2),IS=1,5),IP=1,3)/
     +  0.0000E+00, -8.8200E-02,  1.9240E+00,  0.0000E+00,  0.0000E+00,
     +  6.2290E-02, -2.8920E-01,  2.4240E-01, -4.4630E+00, -8.3670E-01,
     + -4.0990E-02, -1.0820E-01,  2.0360E+00,  5.2090E+00, -4.8400E-02/

C...The following data lines are coefficients needed in the
C...Eichten, Hinchliffe, Lane, Quigg proton structure function
C...parametrizations, see below.
C...Powers of 1-x in different cases.
      DATA NEHLQ/3,4,7,5,7,7,7,7,3,4,7,6,7,7,7,7/
C...Expansion coefficients for up valence quark distribution.
      DATA (((CEHLQ(IX,IT,NX,1,1),IX=1,6),IT=1,6),NX=1,2)/
     + 7.677E-01,-2.087E-01,-3.303E-01,-2.517E-02,-1.570E-02,-1.000E-04,
     +-5.326E-01,-2.661E-01, 3.201E-01, 1.192E-01, 2.434E-02, 7.620E-03,
     + 2.162E-01, 1.881E-01,-8.375E-02,-6.515E-02,-1.743E-02,-5.040E-03,
     +-9.211E-02,-9.952E-02, 1.373E-02, 2.506E-02, 8.770E-03, 2.550E-03,
     + 3.670E-02, 4.409E-02, 9.600E-04,-7.960E-03,-3.420E-03,-1.050E-03,
     +-1.549E-02,-2.026E-02,-3.060E-03, 2.220E-03, 1.240E-03, 4.100E-04,
     + 2.395E-01, 2.905E-01, 9.778E-02, 2.149E-02, 3.440E-03, 5.000E-04,
     + 1.751E-02,-6.090E-03,-2.687E-02,-1.916E-02,-7.970E-03,-2.750E-03,
     +-5.760E-03,-5.040E-03, 1.080E-03, 2.490E-03, 1.530E-03, 7.500E-04,
     + 1.740E-03, 1.960E-03, 3.000E-04,-3.400E-04,-2.900E-04,-1.800E-04,
     +-5.300E-04,-6.400E-04,-1.700E-04, 4.000E-05, 6.000E-05, 4.000E-05,
     + 1.700E-04, 2.200E-04, 8.000E-05, 1.000E-05,-1.000E-05,-1.000E-05/
      DATA (((CEHLQ(IX,IT,NX,1,2),IX=1,6),IT=1,6),NX=1,2)/
     + 7.237E-01,-2.189E-01,-2.995E-01,-1.909E-02,-1.477E-02, 2.500E-04,
     +-5.314E-01,-2.425E-01, 3.283E-01, 1.119E-01, 2.223E-02, 7.070E-03,
     + 2.289E-01, 1.890E-01,-9.859E-02,-6.900E-02,-1.747E-02,-5.080E-03,
     +-1.041E-01,-1.084E-01, 2.108E-02, 2.975E-02, 9.830E-03, 2.830E-03,
     + 4.394E-02, 5.116E-02,-1.410E-03,-1.055E-02,-4.230E-03,-1.270E-03,
     +-1.991E-02,-2.539E-02,-2.780E-03, 3.430E-03, 1.720E-03, 5.500E-04,
     + 2.410E-01, 2.884E-01, 9.369E-02, 1.900E-02, 2.530E-03, 2.400E-04,
     + 1.765E-02,-9.220E-03,-3.037E-02,-2.085E-02,-8.440E-03,-2.810E-03,
     +-6.450E-03,-5.260E-03, 1.720E-03, 3.110E-03, 1.830E-03, 8.700E-04,
     + 2.120E-03, 2.320E-03, 2.600E-04,-4.900E-04,-3.900E-04,-2.300E-04,
     +-6.900E-04,-8.200E-04,-2.000E-04, 7.000E-05, 9.000E-05, 6.000E-05,
     + 2.400E-04, 3.100E-04, 1.100E-04, 0.000E+00,-2.000E-05,-2.000E-05/
C...Expansion coefficients for down valence quark distribution.
      DATA (((CEHLQ(IX,IT,NX,2,1),IX=1,6),IT=1,6),NX=1,2)/
     + 3.813E-01,-8.090E-02,-1.634E-01,-2.185E-02,-8.430E-03,-6.200E-04,
     +-2.948E-01,-1.435E-01, 1.665E-01, 6.638E-02, 1.473E-02, 4.080E-03,
     + 1.252E-01, 1.042E-01,-4.722E-02,-3.683E-02,-1.038E-02,-2.860E-03,
     +-5.478E-02,-5.678E-02, 8.900E-03, 1.484E-02, 5.340E-03, 1.520E-03,
     + 2.220E-02, 2.567E-02,-3.000E-05,-4.970E-03,-2.160E-03,-6.500E-04,
     +-9.530E-03,-1.204E-02,-1.510E-03, 1.510E-03, 8.300E-04, 2.700E-04,
     + 1.261E-01, 1.354E-01, 3.958E-02, 8.240E-03, 1.660E-03, 4.500E-04,
     + 3.890E-03,-1.159E-02,-1.625E-02,-9.610E-03,-3.710E-03,-1.260E-03,
     +-1.910E-03,-5.600E-04, 1.590E-03, 1.590E-03, 8.400E-04, 3.900E-04,
     + 6.400E-04, 4.900E-04,-1.500E-04,-2.900E-04,-1.800E-04,-1.000E-04,
     +-2.000E-04,-1.900E-04, 0.000E+00, 6.000E-05, 4.000E-05, 3.000E-05,
     + 7.000E-05, 8.000E-05, 2.000E-05,-1.000E-05,-1.000E-05,-1.000E-05/
      DATA (((CEHLQ(IX,IT,NX,2,2),IX=1,6),IT=1,6),NX=1,2)/
     + 3.578E-01,-8.622E-02,-1.480E-01,-1.840E-02,-7.820E-03,-4.500E-04,
     +-2.925E-01,-1.304E-01, 1.696E-01, 6.243E-02, 1.353E-02, 3.750E-03,
     + 1.318E-01, 1.041E-01,-5.486E-02,-3.872E-02,-1.038E-02,-2.850E-03,
     +-6.162E-02,-6.143E-02, 1.303E-02, 1.740E-02, 5.940E-03, 1.670E-03,
     + 2.643E-02, 2.957E-02,-1.490E-03,-6.450E-03,-2.630E-03,-7.700E-04,
     +-1.218E-02,-1.497E-02,-1.260E-03, 2.240E-03, 1.120E-03, 3.500E-04,
     + 1.263E-01, 1.334E-01, 3.732E-02, 7.070E-03, 1.260E-03, 3.400E-04,
     + 3.660E-03,-1.357E-02,-1.795E-02,-1.031E-02,-3.880E-03,-1.280E-03,
     +-2.100E-03,-3.600E-04, 2.050E-03, 1.920E-03, 9.800E-04, 4.400E-04,
     + 7.700E-04, 5.400E-04,-2.400E-04,-3.900E-04,-2.400E-04,-1.300E-04,
     +-2.600E-04,-2.300E-04, 2.000E-05, 9.000E-05, 6.000E-05, 4.000E-05,
     + 9.000E-05, 1.000E-04, 2.000E-05,-2.000E-05,-2.000E-05,-1.000E-05/
C...Expansion coefficients for up and down sea quark distributions.
      DATA (((CEHLQ(IX,IT,NX,3,1),IX=1,6),IT=1,6),NX=1,2)/
     + 6.870E-02,-6.861E-02, 2.973E-02,-5.400E-03, 3.780E-03,-9.700E-04,
     +-1.802E-02, 1.400E-04, 6.490E-03,-8.540E-03, 1.220E-03,-1.750E-03,
     +-4.650E-03, 1.480E-03,-5.930E-03, 6.000E-04,-1.030E-03,-8.000E-05,
     + 6.440E-03, 2.570E-03, 2.830E-03, 1.150E-03, 7.100E-04, 3.300E-04,
     +-3.930E-03,-2.540E-03,-1.160E-03,-7.700E-04,-3.600E-04,-1.900E-04,
     + 2.340E-03, 1.930E-03, 5.300E-04, 3.700E-04, 1.600E-04, 9.000E-05,
     + 1.014E+00,-1.106E+00, 3.374E-01,-7.444E-02, 8.850E-03,-8.700E-04,
     + 9.233E-01,-1.285E+00, 4.475E-01,-9.786E-02, 1.419E-02,-1.120E-03,
     + 4.888E-02,-1.271E-01, 8.606E-02,-2.608E-02, 4.780E-03,-6.000E-04,
     +-2.691E-02, 4.887E-02,-1.771E-02, 1.620E-03, 2.500E-04,-6.000E-05,
     + 7.040E-03,-1.113E-02, 1.590E-03, 7.000E-04,-2.000E-04, 0.000E+00,
     +-1.710E-03, 2.290E-03, 3.800E-04,-3.500E-04, 4.000E-05, 1.000E-05/
      DATA (((CEHLQ(IX,IT,NX,3,2),IX=1,6),IT=1,6),NX=1,2)/
     + 1.008E-01,-7.100E-02, 1.973E-02,-5.710E-03, 2.930E-03,-9.900E-04,
     +-5.271E-02,-1.823E-02, 1.792E-02,-6.580E-03, 1.750E-03,-1.550E-03,
     + 1.220E-02, 1.763E-02,-8.690E-03,-8.800E-04,-1.160E-03,-2.100E-04,
     +-1.190E-03,-7.180E-03, 2.360E-03, 1.890E-03, 7.700E-04, 4.100E-04,
     +-9.100E-04, 2.040E-03,-3.100E-04,-1.050E-03,-4.000E-04,-2.400E-04,
     + 1.190E-03,-1.700E-04,-2.000E-04, 4.200E-04, 1.700E-04, 1.000E-04,
     + 1.081E+00,-1.189E+00, 3.868E-01,-8.617E-02, 1.115E-02,-1.180E-03,
     + 9.917E-01,-1.396E+00, 4.998E-01,-1.159E-01, 1.674E-02,-1.720E-03,
     + 5.099E-02,-1.338E-01, 9.173E-02,-2.885E-02, 5.890E-03,-6.500E-04,
     +-3.178E-02, 5.703E-02,-2.070E-02, 2.440E-03, 1.100E-04,-9.000E-05,
     + 8.970E-03,-1.392E-02, 2.050E-03, 6.500E-04,-2.300E-04, 2.000E-05,
     +-2.340E-03, 3.010E-03, 5.000E-04,-3.900E-04, 6.000E-05, 1.000E-05/
C...Expansion coefficients for gluon distribution.
      DATA (((CEHLQ(IX,IT,NX,4,1),IX=1,6),IT=1,6),NX=1,2)/
     + 9.482E-01,-9.578E-01, 1.009E-01,-1.051E-01, 3.456E-02,-3.054E-02,
     +-9.627E-01, 5.379E-01, 3.368E-01,-9.525E-02, 1.488E-02,-2.051E-02,
     + 4.300E-01,-8.306E-02,-3.372E-01, 4.902E-02,-9.160E-03, 1.041E-02,
     +-1.925E-01,-1.790E-02, 2.183E-01, 7.490E-03, 4.140E-03,-1.860E-03,
     + 8.183E-02, 1.926E-02,-1.072E-01,-1.944E-02,-2.770E-03,-5.200E-04,
     +-3.884E-02,-1.234E-02, 5.410E-02, 1.879E-02, 3.350E-03, 1.040E-03,
     + 2.948E+01,-3.902E+01, 1.464E+01,-3.335E+00, 5.054E-01,-5.915E-02,
     + 2.559E+01,-3.955E+01, 1.661E+01,-4.299E+00, 6.904E-01,-8.243E-02,
     +-1.663E+00, 1.176E+00, 1.118E+00,-7.099E-01, 1.948E-01,-2.404E-02,
     +-2.168E-01, 8.170E-01,-7.169E-01, 1.851E-01,-1.924E-02,-3.250E-03,
     + 2.088E-01,-4.355E-01, 2.239E-01,-2.446E-02,-3.620E-03, 1.910E-03,
     +-9.097E-02, 1.601E-01,-5.681E-02,-2.500E-03, 2.580E-03,-4.700E-04/
      DATA (((CEHLQ(IX,IT,NX,4,2),IX=1,6),IT=1,6),NX=1,2)/
     + 2.367E+00, 4.453E-01, 3.660E-01, 9.467E-02, 1.341E-01, 1.661E-02,
     +-3.170E+00,-1.795E+00, 3.313E-02,-2.874E-01,-9.827E-02,-7.119E-02,
     + 1.823E+00, 1.457E+00,-2.465E-01, 3.739E-02, 6.090E-03, 1.814E-02,
     +-1.033E+00,-9.827E-01, 2.136E-01, 1.169E-01, 5.001E-02, 1.684E-02,
     + 5.133E-01, 5.259E-01,-1.173E-01,-1.139E-01,-4.988E-02,-2.021E-02,
     +-2.881E-01,-3.145E-01, 5.667E-02, 9.161E-02, 4.568E-02, 1.951E-02,
     + 3.036E+01,-4.062E+01, 1.578E+01,-3.699E+00, 6.020E-01,-7.031E-02,
     + 2.700E+01,-4.167E+01, 1.770E+01,-4.804E+00, 7.862E-01,-1.060E-01,
     +-1.909E+00, 1.357E+00, 1.127E+00,-7.181E-01, 2.232E-01,-2.481E-02,
     +-2.488E-01, 9.781E-01,-8.127E-01, 2.094E-01,-2.997E-02,-4.710E-03,
     + 2.506E-01,-5.427E-01, 2.672E-01,-3.103E-02,-1.800E-03, 2.870E-03,
     +-1.128E-01, 2.087E-01,-6.972E-02,-2.480E-03, 2.630E-03,-8.400E-04/
C...Expansion coefficients for strange sea quark distribution.
      DATA (((CEHLQ(IX,IT,NX,5,1),IX=1,6),IT=1,6),NX=1,2)/
     + 4.968E-02,-4.173E-02, 2.102E-02,-3.270E-03, 3.240E-03,-6.700E-04,
     +-6.150E-03,-1.294E-02, 6.740E-03,-6.890E-03, 9.000E-04,-1.510E-03,
     +-8.580E-03, 5.050E-03,-4.900E-03,-1.600E-04,-9.400E-04,-1.500E-04,
     + 7.840E-03, 1.510E-03, 2.220E-03, 1.400E-03, 7.000E-04, 3.500E-04,
     +-4.410E-03,-2.220E-03,-8.900E-04,-8.500E-04,-3.600E-04,-2.000E-04,
     + 2.520E-03, 1.840E-03, 4.100E-04, 3.900E-04, 1.600E-04, 9.000E-05,
     + 9.235E-01,-1.085E+00, 3.464E-01,-7.210E-02, 9.140E-03,-9.100E-04,
     + 9.315E-01,-1.274E+00, 4.512E-01,-9.775E-02, 1.380E-02,-1.310E-03,
     + 4.739E-02,-1.296E-01, 8.482E-02,-2.642E-02, 4.760E-03,-5.700E-04,
     +-2.653E-02, 4.953E-02,-1.735E-02, 1.750E-03, 2.800E-04,-6.000E-05,
     + 6.940E-03,-1.132E-02, 1.480E-03, 6.500E-04,-2.100E-04, 0.000E+00,
     +-1.680E-03, 2.340E-03, 4.200E-04,-3.400E-04, 5.000E-05, 1.000E-05/
      DATA (((CEHLQ(IX,IT,NX,5,2),IX=1,6),IT=1,6),NX=1,2)/
     + 6.478E-02,-4.537E-02, 1.643E-02,-3.490E-03, 2.710E-03,-6.700E-04,
     +-2.223E-02,-2.126E-02, 1.247E-02,-6.290E-03, 1.120E-03,-1.440E-03,
     +-1.340E-03, 1.362E-02,-6.130E-03,-7.900E-04,-9.000E-04,-2.000E-04,
     + 5.080E-03,-3.610E-03, 1.700E-03, 1.830E-03, 6.800E-04, 4.000E-04,
     +-3.580E-03, 6.000E-05,-2.600E-04,-1.050E-03,-3.800E-04,-2.300E-04,
     + 2.420E-03, 9.300E-04,-1.000E-04, 4.500E-04, 1.700E-04, 1.100E-04,
     + 9.868E-01,-1.171E+00, 3.940E-01,-8.459E-02, 1.124E-02,-1.250E-03,
     + 1.001E+00,-1.383E+00, 5.044E-01,-1.152E-01, 1.658E-02,-1.830E-03,
     + 4.928E-02,-1.368E-01, 9.021E-02,-2.935E-02, 5.800E-03,-6.600E-04,
     +-3.133E-02, 5.785E-02,-2.023E-02, 2.630E-03, 1.600E-04,-8.000E-05,
     + 8.840E-03,-1.416E-02, 1.900E-03, 5.800E-04,-2.500E-04, 1.000E-05,
     +-2.300E-03, 3.080E-03, 5.500E-04,-3.700E-04, 7.000E-05, 1.000E-05/
C...Expansion coefficients for charm sea quark distribution.
      DATA (((CEHLQ(IX,IT,NX,6,1),IX=1,6),IT=1,6),NX=1,2)/
     + 9.270E-03,-1.817E-02, 9.590E-03,-6.390E-03, 1.690E-03,-1.540E-03,
     + 5.710E-03,-1.188E-02, 6.090E-03,-4.650E-03, 1.240E-03,-1.310E-03,
     +-3.960E-03, 7.100E-03,-3.590E-03, 1.840E-03,-3.900E-04, 3.400E-04,
     + 1.120E-03,-1.960E-03, 1.120E-03,-4.800E-04, 1.000E-04,-4.000E-05,
     + 4.000E-05,-3.000E-05,-1.800E-04, 9.000E-05,-5.000E-05,-2.000E-05,
     +-4.200E-04, 7.300E-04,-1.600E-04, 5.000E-05, 5.000E-05, 5.000E-05,
     + 8.098E-01,-1.042E+00, 3.398E-01,-6.824E-02, 8.760E-03,-9.000E-04,
     + 8.961E-01,-1.217E+00, 4.339E-01,-9.287E-02, 1.304E-02,-1.290E-03,
     + 3.058E-02,-1.040E-01, 7.604E-02,-2.415E-02, 4.600E-03,-5.000E-04,
     +-2.451E-02, 4.432E-02,-1.651E-02, 1.430E-03, 1.200E-04,-1.000E-04,
     + 1.122E-02,-1.457E-02, 2.680E-03, 5.800E-04,-1.200E-04, 3.000E-05,
     +-7.730E-03, 7.330E-03,-7.600E-04,-2.400E-04, 1.000E-05, 0.000E+00/
      DATA (((CEHLQ(IX,IT,NX,6,2),IX=1,6),IT=1,6),NX=1,2)/
     + 9.980E-03,-1.945E-02, 1.055E-02,-6.870E-03, 1.860E-03,-1.560E-03,
     + 5.700E-03,-1.203E-02, 6.250E-03,-4.860E-03, 1.310E-03,-1.370E-03,
     +-4.490E-03, 7.990E-03,-4.170E-03, 2.050E-03,-4.400E-04, 3.300E-04,
     + 1.470E-03,-2.480E-03, 1.460E-03,-5.700E-04, 1.200E-04,-1.000E-05,
     +-9.000E-05, 1.500E-04,-3.200E-04, 1.200E-04,-6.000E-05,-4.000E-05,
     +-4.200E-04, 7.600E-04,-1.400E-04, 4.000E-05, 7.000E-05, 5.000E-05,
     + 8.698E-01,-1.131E+00, 3.836E-01,-8.111E-02, 1.048E-02,-1.300E-03,
     + 9.626E-01,-1.321E+00, 4.854E-01,-1.091E-01, 1.583E-02,-1.700E-03,
     + 3.057E-02,-1.088E-01, 8.022E-02,-2.676E-02, 5.590E-03,-5.600E-04,
     +-2.845E-02, 5.164E-02,-1.918E-02, 2.210E-03,-4.000E-05,-1.500E-04,
     + 1.311E-02,-1.751E-02, 3.310E-03, 5.100E-04,-1.200E-04, 5.000E-05,
     +-8.590E-03, 8.380E-03,-9.200E-04,-2.600E-04, 1.000E-05,-1.000E-05/
C...Expansion coefficients for bottom sea quark distribution.
      DATA (((CEHLQ(IX,IT,NX,7,1),IX=1,6),IT=1,6),NX=1,2)/
     + 9.010E-03,-1.401E-02, 7.150E-03,-4.130E-03, 1.260E-03,-1.040E-03,
     + 6.280E-03,-9.320E-03, 4.780E-03,-2.890E-03, 9.100E-04,-8.200E-04,
     +-2.930E-03, 4.090E-03,-1.890E-03, 7.600E-04,-2.300E-04, 1.400E-04,
     + 3.900E-04,-1.200E-03, 4.400E-04,-2.500E-04, 2.000E-05,-2.000E-05,
     + 2.600E-04, 1.400E-04,-8.000E-05, 1.000E-04, 1.000E-05, 1.000E-05,
     +-2.600E-04, 3.200E-04, 1.000E-05,-1.000E-05, 1.000E-05,-1.000E-05,
     + 8.029E-01,-1.075E+00, 3.792E-01,-7.843E-02, 1.007E-02,-1.090E-03,
     + 7.903E-01,-1.099E+00, 4.153E-01,-9.301E-02, 1.317E-02,-1.410E-03,
     +-1.704E-02,-1.130E-02, 2.882E-02,-1.341E-02, 3.040E-03,-3.600E-04,
     +-7.200E-04, 7.230E-03,-5.160E-03, 1.080E-03,-5.000E-05,-4.000E-05,
     + 3.050E-03,-4.610E-03, 1.660E-03,-1.300E-04,-1.000E-05, 1.000E-05,
     +-4.360E-03, 5.230E-03,-1.610E-03, 2.000E-04,-2.000E-05, 0.000E+00/
      DATA (((CEHLQ(IX,IT,NX,7,2),IX=1,6),IT=1,6),NX=1,2)/
     + 8.980E-03,-1.459E-02, 7.510E-03,-4.410E-03, 1.310E-03,-1.070E-03,
     + 5.970E-03,-9.440E-03, 4.800E-03,-3.020E-03, 9.100E-04,-8.500E-04,
     +-3.050E-03, 4.440E-03,-2.100E-03, 8.500E-04,-2.400E-04, 1.400E-04,
     + 5.300E-04,-1.300E-03, 5.600E-04,-2.700E-04, 3.000E-05,-2.000E-05,
     + 2.000E-04, 1.400E-04,-1.100E-04, 1.000E-04, 0.000E+00, 0.000E+00,
     +-2.600E-04, 3.200E-04, 0.000E+00,-3.000E-05, 1.000E-05,-1.000E-05,
     + 8.672E-01,-1.174E+00, 4.265E-01,-9.252E-02, 1.244E-02,-1.460E-03,
     + 8.500E-01,-1.194E+00, 4.630E-01,-1.083E-01, 1.614E-02,-1.830E-03,
     +-2.241E-02,-5.630E-03, 2.815E-02,-1.425E-02, 3.520E-03,-4.300E-04,
     +-7.300E-04, 8.030E-03,-5.780E-03, 1.380E-03,-1.300E-04,-4.000E-05,
     + 3.460E-03,-5.380E-03, 1.960E-03,-2.100E-04, 1.000E-05, 1.000E-05,
     +-4.850E-03, 5.950E-03,-1.890E-03, 2.600E-04,-3.000E-05, 0.000E+00/
C...Expansion coefficients for top sea quark distribution.
      DATA (((CEHLQ(IX,IT,NX,8,1),IX=1,6),IT=1,6),NX=1,2)/
     + 4.410E-03,-7.480E-03, 3.770E-03,-2.580E-03, 7.300E-04,-7.100E-04,
     + 3.840E-03,-6.050E-03, 3.030E-03,-2.030E-03, 5.800E-04,-5.900E-04,
     +-8.800E-04, 1.660E-03,-7.500E-04, 4.700E-04,-1.000E-04, 1.000E-04,
     +-8.000E-05,-1.500E-04, 1.200E-04,-9.000E-05, 3.000E-05, 0.000E+00,
     + 1.300E-04,-2.200E-04,-2.000E-05,-2.000E-05,-2.000E-05,-2.000E-05,
     +-7.000E-05, 1.900E-04,-4.000E-05, 2.000E-05, 0.000E+00, 0.000E+00,
     + 6.623E-01,-9.248E-01, 3.519E-01,-7.930E-02, 1.110E-02,-1.180E-03,
     + 6.380E-01,-9.062E-01, 3.582E-01,-8.479E-02, 1.265E-02,-1.390E-03,
     +-2.581E-02, 2.125E-02, 4.190E-03,-4.980E-03, 1.490E-03,-2.100E-04,
     + 7.100E-04, 5.300E-04,-1.270E-03, 3.900E-04,-5.000E-05,-1.000E-05,
     + 3.850E-03,-5.060E-03, 1.860E-03,-3.500E-04, 4.000E-05, 0.000E+00,
     +-3.530E-03, 4.460E-03,-1.500E-03, 2.700E-04,-3.000E-05, 0.000E+00/
      DATA (((CEHLQ(IX,IT,NX,8,2),IX=1,6),IT=1,6),NX=1,2)/
     + 4.260E-03,-7.530E-03, 3.830E-03,-2.680E-03, 7.600E-04,-7.300E-04,
     + 3.640E-03,-6.050E-03, 3.030E-03,-2.090E-03, 5.900E-04,-6.000E-04,
     +-9.200E-04, 1.710E-03,-8.200E-04, 5.000E-04,-1.200E-04, 1.000E-04,
     +-5.000E-05,-1.600E-04, 1.300E-04,-9.000E-05, 3.000E-05, 0.000E+00,
     + 1.300E-04,-2.100E-04,-1.000E-05,-2.000E-05,-2.000E-05,-1.000E-05,
     +-8.000E-05, 1.800E-04,-5.000E-05, 2.000E-05, 0.000E+00, 0.000E+00,
     + 7.146E-01,-1.007E+00, 3.932E-01,-9.246E-02, 1.366E-02,-1.540E-03,
     + 6.856E-01,-9.828E-01, 3.977E-01,-9.795E-02, 1.540E-02,-1.790E-03,
     +-3.053E-02, 2.758E-02, 2.150E-03,-4.880E-03, 1.640E-03,-2.500E-04,
     + 9.200E-04, 4.200E-04,-1.340E-03, 4.600E-04,-8.000E-05,-1.000E-05,
     + 4.230E-03,-5.660E-03, 2.140E-03,-4.300E-04, 6.000E-05, 0.000E+00,
     +-3.890E-03, 5.000E-03,-1.740E-03, 3.300E-04,-4.000E-05, 0.000E+00/

C...The following data lines are coefficients needed in the
C...Duke, Owens proton structure function parametrizations, see below.
C...Expansion coefficients for (up+down) valence quark distribution.
      DATA ((CDO(IP,IS,1,1),IS=1,6),IP=1,3)/
     + 4.190E-01, 3.460E+00, 4.400E+00, 0.000E+00, 0.000E+00, 0.000E+00,
     + 4.000E-03, 7.240E-01,-4.860E+00, 0.000E+00, 0.000E+00, 0.000E+00,
     +-7.000E-03,-6.600E-02, 1.330E+00, 0.000E+00, 0.000E+00, 0.000E+00/
      DATA ((CDO(IP,IS,1,2),IS=1,6),IP=1,3)/
     + 3.740E-01, 3.330E+00, 6.030E+00, 0.000E+00, 0.000E+00, 0.000E+00,
     + 1.400E-02, 7.530E-01,-6.220E+00, 0.000E+00, 0.000E+00, 0.000E+00,
     + 0.000E+00,-7.600E-02, 1.560E+00, 0.000E+00, 0.000E+00, 0.000E+00/
C...Expansion coefficients for down valence quark distribution.
      DATA ((CDO(IP,IS,2,1),IS=1,6),IP=1,3)/
     + 7.630E-01, 4.000E+00, 0.000E+00, 0.000E+00, 0.000E+00, 0.000E+00,
     +-2.370E-01, 6.270E-01,-4.210E-01, 0.000E+00, 0.000E+00, 0.000E+00,
     + 2.600E-02,-1.900E-02, 3.300E-02, 0.000E+00, 0.000E+00, 0.000E+00/
      DATA ((CDO(IP,IS,2,2),IS=1,6),IP=1,3)/
     + 7.610E-01, 3.830E+00, 0.000E+00, 0.000E+00, 0.000E+00, 0.000E+00,
     +-2.320E-01, 6.270E-01,-4.180E-01, 0.000E+00, 0.000E+00, 0.000E+00,
     + 2.300E-02,-1.900E-02, 3.600E-02, 0.000E+00, 0.000E+00, 0.000E+00/
C...Expansion coefficients for (up+down+strange) sea quark distribution.
      DATA ((CDO(IP,IS,3,1),IS=1,6),IP=1,3)/
     + 1.265E+00, 0.000E+00, 8.050E+00, 0.000E+00, 0.000E+00, 0.000E+00,
     +-1.132E+00,-3.720E-01, 1.590E+00, 6.310E+00,-1.050E+01, 1.470E+01,
     + 2.930E-01,-2.900E-02,-1.530E-01,-2.730E-01,-3.170E+00, 9.800E+00/
      DATA ((CDO(IP,IS,3,2),IS=1,6),IP=1,3)/
     + 1.670E+00, 0.000E+00, 9.150E+00, 0.000E+00, 0.000E+00, 0.000E+00,
     +-1.920E+00,-2.730E-01, 5.300E-01, 1.570E+01,-1.010E+02, 2.230E+02,
     + 5.820E-01,-1.640E-01,-7.630E-01,-2.830E+00, 4.470E+01,-1.170E+02/
C...Expansion coefficients for charm sea quark distribution.
      DATA ((CDO(IP,IS,4,1),IS=1,6),IP=1,3)/
     + 0.000E+00,-3.600E-02, 6.350E+00, 0.000E+00, 0.000E+00, 0.000E+00,
     + 1.350E-01,-2.220E-01, 3.260E+00,-3.030E+00, 1.740E+01,-1.790E+01,
     +-7.500E-02,-5.800E-02,-9.090E-01, 1.500E+00,-1.130E+01, 1.560E+01/
      DATA ((CDO(IP,IS,4,2),IS=1,6),IP=1,3)/ 0.000E+00,-1.200E-01,
     +3.510E+00, 0.000E+00, 0.000E+00, 0.000E+00, 6.700E-02,-2.330E-01,
     +3.660E+00,-4.740E-01, 9.500E+00,-1.660E+01,-3.100E-02,-2.300E-02,
     +-4.530E-01, 3.580E-01,-5.430E+00, 1.550E+01/
C...Expansion coefficients for gluon distribution.
      DATA ((CDO(IP,IS,5,1),IS=1,6),IP=1,3)/
     + 1.560E+00, 0.000E+00, 6.000E+00, 9.000E+00, 0.000E+00, 0.000E+00,
     +-1.710E+00,-9.490E-01, 1.440E+00,-7.190E+00,-1.650E+01, 1.530E+01,
     + 6.380E-01, 3.250E-01,-1.050E+00, 2.550E-01, 1.090E+01,-1.010E+01/
      DATA ((CDO(IP,IS,5,2),IS=1,6),IP=1,3)/
     + 8.790E-01, 0.000E+00, 4.000E+00, 9.000E+00, 0.000E+00, 0.000E+00,
     +-9.710E-01,-1.160E+00, 1.230E+00,-5.640E+00,-7.540E+00,-5.960E-01,
     + 4.340E-01, 4.760E-01,-2.540E-01,-8.170E-01, 5.500E+00, 1.260E-01/

C...The following data lines are coefficients needed in the
C...Morfin and Tung structure function parametrizations.
C...12 coefficients each for d(valence), u(valence), g, u(sea),
C...d(sea), s, c, b and t, in that order.
C...Expansion coefficients for set 1 (fit S1).
      DATA (((CMT(IEX,IPN,IFL,1),IFL=1,9),IPN=0,2),IEX=0,3)/
     +   1.30,  1.64,  1.86, -0.60, -0.45, -1.10, -3.87, -6.14,-12.53,
     +  -0.57, -0.33, -2.76, -1.68, -1.64, -1.66,  0.79,  2.65,  8.13,
     +  -0.08, -0.10,  0.10,  0.08,  0.05,  0.13, -0.70, -1.24, -2.64,
     +   0.18,  0.08, -0.17, -0.19, -0.18, -0.19, -0.03, -0.10, -0.38,
     +   0.16,  0.14, -0.07, -0.16, -0.19, -0.09, -0.17, -0.03,  0.34,
     +  -0.02, -0.01,  0.02,  0.04,  0.06,  0.01,  0.03, -0.02, -0.14,
     +   5.27,  3.74,  7.33,  9.31,  9.36,  9.07,  7.96,  6.90, 16.30,
     +   0.43,  0.54, -0.88, -1.17, -1.01, -1.39,  0.95,  1.52,-13.23,
     +   0.06,  0.03, -0.08,  0.29,  0.20,  0.47, -0.38, -0.50,  4.77,
     +  -1.85, -2.04, -0.88, -1.45, -1.48, -1.26,  0.60,  0.80, -0.57,
     +   1.08,  0.88,  2.47,  1.65,  1.49,  1.96,  0.60,  1.05,  3.58,
     +  -0.03,  0.02, -0.32, -0.20, -0.12, -0.36,  0.08, -0.14, -0.99/
C...Expansion coefficients for set 2 (fit B1).
      DATA (((CMT(IEX,IPN,IFL,2),IFL=1,9),IPN=0,2),IEX=0,3)/
     +   1.34,  1.62,  1.88, -0.99, -0.99, -0.99, -3.98, -6.28,-13.08,
     +  -0.57, -0.33, -2.78, -1.54, -1.54, -1.54,  0.72,  2.62,  8.54,
     +  -0.08, -0.10,  0.13,  0.10,  0.10,  0.10, -0.63, -1.18, -2.70,
     +   0.15,  0.11, -0.33, -0.33, -0.33, -0.33, -0.15, -0.18, -0.40,
     +   0.16,  0.14,  0.10,  0.03,  0.03,  0.03, -0.06,  0.02,  0.31,
     +  -0.02, -0.01, -0.04, -0.03, -0.03, -0.03,  0.00, -0.03, -0.12,
     +   5.30,  3.68,  7.52,  8.53,  8.53,  8.53,  7.46,  6.56, 15.35,
     +   0.43,  0.53, -1.13, -1.08, -1.08, -1.08,  0.96,  1.40,-11.83,
     +   0.06,  0.03,  0.04,  0.39,  0.39,  0.39, -0.30, -0.38,  4.16,
     +  -1.96, -1.94, -1.34, -1.55, -1.55, -1.55,  0.35,  0.65, -0.43,
     +   1.08,  0.87,  2.92,  2.02,  2.02,  2.02,  0.89,  1.13,  3.18,
     +  -0.03,  0.02, -0.49, -0.39, -0.39, -0.39, -0.04, -0.16, -0.82/
C...Expansion coefficients for set 3 (fit B2).
      DATA (((CMT(IEX,IPN,IFL,3),IFL=1,9),IPN=0,2),IEX=0,3)/
     +   1.38,  1.64,  1.52, -0.85, -0.85, -0.85, -3.74, -6.07,-12.08,
     +  -0.59, -0.33, -2.71, -1.43, -1.43, -1.43,  0.21,  2.33,  7.31,
     +  -0.08, -0.10,  0.15, -0.03, -0.03, -0.03, -0.50, -1.15, -2.35,
     +   0.18,  0.09, -0.72, -0.82, -0.82, -0.82, -0.58, -0.52, -0.73,
     +   0.16,  0.14,  0.45,  0.35,  0.35,  0.35,  0.24,  0.22,  0.54,
     +  -0.02, -0.01, -0.15, -0.09, -0.10, -0.10, -0.07, -0.07, -0.18,
     +   5.40,  3.74,  7.75,  9.19,  9.19,  9.19,  9.63,  8.33, 21.14,
     +   0.42,  0.54, -1.56, -0.92, -0.92, -0.92, -1.13,  0.28,-19.17,
     +   0.06,  0.03,  0.16,  0.12,  0.12,  0.12,  0.25, -0.28,  6.64,
     +  -1.91, -2.02, -2.18, -2.76, -2.76, -2.76, -1.09, -0.52, -1.92,
     +   1.11,  0.88,  3.75,  2.56,  2.56,  2.56,  2.10,  1.91,  4.59,
     +  -0.03,  0.02, -0.76, -0.40, -0.40, -0.40, -0.33, -0.31, -1.25/
C...Expansion coefficients for set 4 (fit E1).
      DATA (((CMT(IEX,IPN,IFL,4),IFL=1,9),IPN=0,2),IEX=0,3)/
     +   1.43,  1.69,  2.11, -0.84, -0.84, -0.84, -3.87, -6.09,-12.56,
     +  -0.65, -0.33, -3.01, -1.65, -1.65, -1.65,  0.85,  2.81,  8.69,
     +  -0.08, -0.11,  0.18,  0.12,  0.12,  0.12, -0.73, -1.34, -2.93,
     +   0.16,  0.11, -0.33, -0.32, -0.32, -0.32, -0.15, -0.17, -0.38,
     +   0.16,  0.14,  0.10,  0.02,  0.02,  0.02, -0.07,  0.01,  0.30,
     +  -0.02, -0.01, -0.04, -0.03, -0.03, -0.03,  0.00, -0.03, -0.12,
     +   6.17,  3.69,  7.93,  8.96,  8.96,  8.96,  7.83,  6.75, 14.62,
     +   0.43,  0.54, -1.40, -1.24, -1.24, -1.24,  1.00,  1.74,-11.27,
     +   0.06,  0.03,  0.09,  0.45,  0.45,  0.45, -0.36, -0.56,  4.29,
     +  -1.94, -1.99, -1.51, -1.70, -1.70, -1.70,  0.21,  0.54, -0.41,
     +   1.12,  0.90,  3.14,  2.15,  2.15,  2.15,  0.93,  1.15,  3.19,
     +  -0.02,  0.02, -0.55, -0.43, -0.43, -0.43, -0.03, -0.16, -0.87/

c      LOGICAL FIRST/.TRUE./
C...Euler's beta function, requires ordinary Gamma function
      EULBET(X,Y)=PYGAMM(X)*PYGAMM(Y)/PYGAMM(X+Y)

c      write(6,*) ' rystfu: iherpys,idir,KF ',iherpys,idir,KF
c      write(6,*) 'rystfu ',MSTP(51)
      SLO = 0.0
      SHI = 1.0
C...Reset structure functions, check x and hadron flavour.
      ALAM=0.
      Q2 = Q2I
      X = XI
      DO 10  KFL=-6,6
   10 XPQ(KFL)=0.
c         write(6,*) 'rystfu: IDIR,KF,Q2 :',idir,KF,q2,x
      IF(X.LE.0..OR.X.GE.1.) THEN
         WRITE(MSTU(11),10000) X
         write(6,*) 'rystfu: IDIR,KF,Q2 :',idir,KF,q2,x
         RETURN
      ENDIF
c      write(6,*) iherpys,ipro
      IF(IHERPYS.EQ.1) THEN
ccc          write(6,*) ' rystfu grid calc.'
         IF(X.GT.0.99) X=0.99
         XPRT = DBLE(X)
         Q2T= Q2
         IF(Q2T.LT.Q2X(1)) Q2T=SNGL(Q2X(1))
         IF(XPRT.LT.XX(1).OR.XPRT.GT.XX(NBX) .OR.Q2T.LT.Q2X(1) .OR.Q2T
     +   .GT.Q2X(NBQ2)) THEN
            IF(IHERAC.EQ.0) THEN
               WRITE(6,*) 'RYSTFU: X or Q2 values outside grid '
               WRITE(6,*) ' X_min ',XX(1),' X_max ',XX(NBX), ' actual '
     +         //'X ', XPRT
               WRITE(6,*) ' Q2_min ',Q2X(1),' Q2_max ',Q2X(NBQ2), ' '
     +         //'actual Q2 ',Q2T
c             write(6,*) ' this was for IPRO =',ipro,idir,ng,npom
            ENDIF
            IF(XPRT.LT.XX(1)) XPRT=XX(1)
            IF(XPRT.GT.XX(NBX)) XPRT=XX(NBX)
            IF(Q2T.LT.Q2X(1)) Q2T = SNGL(Q2X(1))
            IF(Q2T.GT.Q2X(NBQ2)) Q2T = SNGL(Q2X(NBQ2))
         ENDIF
         IX = 0
   20    IX = IX + 1
         IF(XPRT.GT.XX(IX+1)) GOTO 20
         IQ = 0
   30    IQ = IQ + 1
         IF(Q2T.GT.Q2X(IQ+1)) GOTO 30

         XD = SNGL((XPRT - XX(IX))/(XX(IX+1)-XX(IX)))
         QD = (Q2T - SNGL(Q2X(IQ)))/(SNGL(Q2X(IQ+1)) -SNGL(Q2X(IQ)))
         IF(NPOM.EQ.20.OR.NPOM.EQ.21) THEN
c            write(6,*) ' RYSTFU NPOM=',NPOM
            DO 40 I=-6,6
               X1P=(XPQPI(I,IX+1,IQ)-XPQPI(I,IX,IQ))*XD +XPQPI(I,IX,
     +         IQ)
               X2P=(XPQPI(I,IX+1,IQ+1)-XPQPI(I,IX,IQ+1))*XD + XPQPI(I,
     +         IX,IQ+1)
               XPQ(I) = (X2P-X1P)*QD + X1P
   40       CONTINUE
         ELSE
            DO 50 I=-6,6
               X1P=(XPQDIF(I,IX+1,IQ)-XPQDIF(I,IX,IQ))*XD +XPQDIF(I,IX,
     +         IQ)
               X2P=(XPQDIF(I,IX+1,IQ+1)-XPQDIF(I,IX,IQ+1))*XD +
     +         XPQDIF(I, IX,IQ+1)
               XPQ(I) = (X2P-X1P)*QD + X1P
   50       CONTINUE
         ENDIF
      ENDIF
      IF(IHERPYS.EQ.1) RETURN
c      write(6,*) ' RYSTFU: IHERPHS ',IHERPYS
      KFA=IABS(KF)
c      write(6,*) ' in rystfu : KFA= ',KFA,IDIR,IPRO,MSTP(51),MSTP(52)
      IF(KFA.NE.11.AND.KFA.NE.22.AND.KFA.NE.211.AND.KFA.NE.2112.AND.
     +KFA.NE.2212.AND.KFA.NE.100.AND.KFA.NE.111) THEN
         WRITE(MSTU(11),10100) KF
         RETURN
      ENDIF
c           write(6,*) ' in rystfu idir=0: KFA= ',KFA
      SCALE = Q2
      IF(KFA.EQ.100.OR.KFA.EQ.211.OR.KFA.EQ.111) THEN
cc            write(6,*) ' rystfu: now call RASTFU ',x,q2,kfa
         CALL RASTFU(KF,X,Q2,XPQ)
         GOTO 240
      ENDIF
      IF(IDIR.EQ.0) THEN
c      write(6,*) ' rystfu: integrate pom/pi parton distributions '
c             write(6,*) ' in rystfu int: idir=',idir,' kfa = ',kfa
         XMAX=1.d0-XF
C ... XP2 = E_glue /E_proton
C ... XX  = E_glue/E_pomeron
C ... XR  = E_pomeron/E_proton
         XPR = X
         XP2 = DBLE(X)
         IF(XP2.GT.XMAX) RETURN

c         write(6,*) ' RYSTFU : X,XMAX ',X,XP2,XMAX
         DO 60  I=-6,6
            XPQ(I) = 0.
   60    CONTINUE
c         write(6,*) ' RYSTFU :',NPOM,NG
         if(NPOM.EQ.999.AND.NG.EQ.999) THEN
            call xpq30(XPR,SCALE,XPQ)
c            write(6,*) ' RYSTFU :',XPQ(1)
         ELSE
            DO 70 I=-4,4
               KPART = I
               EPS = 1.E-3
               SUM = 0.
               IF(NG.GE.20.AND.NPOM.GE.20) THEN
                  CALL GADAP2(SLO,SHI,FLOW,FUP,FXT2,EPS,SUM)
               ELSEIF(NG.LT.0.AND.NPOM.LT.0) THEN
                  CALL GADAP2(SLO,SHI,FLOW,FUP,FXT2,EPS,SUM)
               ELSEIF(NPOM.GE.20) THEN
                  CALL GADAP2(SLO,SHI,FLOW,FUP,FXT2,EPS,SUM)
               ELSE
                  CALL GADAP(SLO,SHI,FUNX,EPS,SUM)
               ENDIF
               XPQ(KPART) = SUM
cc            write(6,*) ' rystfu kpart = ',kpart,sum
   70       CONTINUE
         ENDIF
      ELSEIF(IDIR.EQ.1) THEN
cc      write(6,*) ' rystfu idir=1'
C...Call user-supplied structure function.
C...Proton structure function call.
C.. modify to call PDFLIB

         IF(MSTP(51).GT.100) THEN
C...Call PDFLIB structure functions.
            XXX=DBLE(X)
            QQ=DBLE(SQRT(MAX(0.,Q2)))
C if you use PDFLIB version 3.  then uncoment the following 2 lines
C and comment the lines with 'cold pdf'
cold pdf  PARM(1)='MODE'
cold pdf  VAL(1)=MSTP(51)
C if you use PDFLIB 4.   then use the next lines.
CNEW
            PARM(1) = 'NPTYPE'
            MST51 = MSTP(51)
            VAL(1) = INT(MST51/1000000)

            PARM(2) = 'NGROUP'
            VAL(2) = DBLE(MOD(MST51,1000000)/1000)
            PARM(3) = 'NSET'
            VAL(3) = DBLE(MOD(MOD(MST51,1000000),1000))
CNEW
            NPDF=NPDF+1
            PDFFIRST=.FALSE.
            IF(NPDF.LE.1) PDFFIRST=.TRUE.
c call PDFSET each time, because when DIF with pi structure function is
c also selected one would get in confusion....
            CALL PDFSET(PARM,VAL)
            CALL STRUCTM(XXX,QQ,UPV,DNV,USEA,DSEA,STR,CHM,BOT,TOP,GLU)
            XPQ(0)=SNGL(GLU)
            XPQ(1)=SNGL(DNV+DSEA)
            XPQ(-1)=SNGL(DSEA)
            XPQ(2)=SNGL(UPV+USEA)
            XPQ(-2)=SNGL(USEA)
            XPQ(3)=SNGL(STR)
            XPQ(-3)=SNGL(STR)
            XPQ(4)=SNGL(CHM)
            XPQ(-4)=SNGL(CHM)
            XPQ(5)=SNGL(BOT)
            XPQ(-5)=SNGL(BOT)
            XPQ(6)=SNGL(TOP)
            XPQ(-6)=SNGL(TOP)
            GOTO 240
         ENDIF
C end modify to call PDFLIB
         IF(MSTP(51).EQ.0.AND.KFA.EQ.2212) THEN
            CALL PYSTFE(KFA,X,Q2,XPQ)
         ELSEIF(KFA.EQ.11) THEN
C...Electron structure function.
            AEM=PARU(101)
            PME=PMAS(11,1)
            XL=LOG(MAX(1E-10,X))
            X1L=LOG(MAX(1E-10,1.-X))
            HLE=LOG(MAX(3.,Q2/PME**2))
            HBE=(2.*AEM/PARU(1))*(HLE-1.)

C...Electron inside electron, see R. Kleiss et al., in Z physics at
C...LEP 1, CERN 89-08, p. 34
            IF(MSTP(11).LE.1) THEN
               HDE=1.+(AEM/PARU(1))*(1.5*HLE+1.289868)+(AEM/PARU(1))**
     +         2* (-2.164868*HLE**2+9.840808*HLE-10.130464)
               HEE=0.5*HBE*(1.-X)**(0.5*HBE-1.)*SQRT(MAX(0.,HDE))-
     +         0.25* HBE*(1.+X)+HBE**2/32.*((1.+X)*(-4.*X1L+3.*XL)- 4.*
     +         XL/(1.-X) -5.-X)
               HCB=0.5*HBE
            ELSE
               HCA=PARP(11)
               HCB=PARP(12)
               IF(MSTP(11).EQ.3) HCB=HCB+0.5*HBE
               HEE=X**HCA*(1.-X)**HCB/EULBET(1.+HCA,1.+HCB)
            ENDIF
            IF(X.GT.0.9999.AND.X.LE.0.999999) THEN
               HEE=HEE*100.**HCB/(100.**HCB-1.)
            ELSEIF(X.GT.0.999999) THEN
               HEE=0.
            ENDIF
            XPQQ(11)=X*HEE

C...Photon and (transverse) W- inside electron.
            AEMP=ULALEM(PME*SQRT(MAX(0.,Q2)))/PARU(2)
            IF(MSTP(13).LE.1) THEN
               HLG=HLE
            ELSE
               HLG=LOG((PARP(13)/PME**2)*(1.-X)/X**2)
            ENDIF
            XPQQ(22)=AEMP*HLG*(1.+(1.-X)**2)
            HLW=LOG(1.+Q2/PMAS(24,1)**2)/(4.*PARU(102))
            XPQQ(-24)=AEMP*HLW*(1.+(1.-X)**2)

C..Quarks and gluons inside photon inside electron.
            IF(MSTP(12).EQ.1) THEN
               T=ALOG(MIN(1E4,MAX(1.,Q2))/0.16)
               NF=3
               IF(Q2.GT.25.) NF=4
               IF(Q2.GT.300.) NF=5
               NFE=NF-2
               XL=LOG(MAX(1E-10,X))

C...Numerical integration of struncture function convolution.
               SXPGL=0.
               SXPQU=0.
               SXPQD=0.
               SUMXPP=0.
               ITER=-1
   80          ITER=ITER+1
               SUMXP=SUMXPP
               NSTP=2**(ITER-1)
               IF(ITER.EQ.0) NSTP=2
               SXPGL=0.5*SXPGL
               SXPQU=0.5*SXPQU
               SXPQD=0.5*SXPQD
               WTSTP=0.5/NSTP
               IF(ITER.EQ.0) WTSTP=0.5
               DO 90  ISTP=1,NSTP
                  IF(ITER.EQ.0) THEN
                     XLE=XL*(ISTP-1)
                  ELSE
                     XLE=XL*(ISTP-0.5)/NSTP
                  ENDIF
                  XE=EXP(XLE)
                  XG=MIN(0.999999,X/XE)
                  XPGA=1.+(1.-XE)**2
                  CALL PYSTGA(NFE,XG,T,XPGL,XPQU,XPQD)
                  SXPGL=SXPGL+WTSTP*XPGA*XPGL
                  SXPQU=SXPQU+WTSTP*XPGA*XPQU
   90          SXPQD=SXPQD+WTSTP*XPGA*XPQD
               SUMXPP=SXPGL+SXPQU+SXPQD
               IF(ITER.LE.2.OR.(ITER.LE.7.AND.ABS(SUMXPP-SUMXP).GT.
     +         PARP(14)*(SUMXPP+SUMXP))) GOTO 80
               FCONV=AEMP*HLE*AEM*(-XL)

C...Put into output arrays.
               XPQ(0)=FCONV*SXPGL
               XPQ(1)=FCONV*SXPQD
               XPQ(-1)=XPQ(1)
               XPQ(2)=FCONV*SXPQU
               XPQ(-2)=XPQ(2)
               XPQ(3)=FCONV*SXPQD
               XPQ(-3)=XPQ(3)
               IF(NFE.GE.2) THEN
                  XPQ(4)=FCONV*SXPQU
                  XPQ(-4)=XPQ(4)
               ENDIF
               IF(NFE.EQ.3) THEN
                  XPQ(5)=FCONV*SXPQD
                  XPQ(-5)=XPQ(5)
               ENDIF
            ENDIF

         ELSEIF(KFA.EQ.22) THEN
C...Photon structure function from Drees and Grassie.
C...Allowed variable range: 1 GeV^2 < Q^2 < 10000 GeV^2.
            T=ALOG(MIN(1E4,MAX(1.,Q2))/0.16)
            NF=3
            IF(Q2.GT.25.) NF=4
            IF(Q2.GT.300.) NF=5
            NFE=NF-2
            CALL PYSTGA(NFE,X,T,XPGL,XPQU,XPQD)
            AEM=PARU(101)

C...Put into output arrays.
            XPQ(0)=AEM*XPGL
            XPQ(1)=AEM*XPQD
            XPQ(-1)=XPQ(1)
            XPQ(2)=AEM*XPQU
            XPQ(-2)=XPQ(2)
            XPQ(3)=AEM*XPQD
            XPQ(-3)=XPQ(3)
            IF(NFE.GE.2) THEN
               XPQ(4)=AEM*XPQU
               XPQ(-4)=XPQ(4)
            ENDIF
            IF(NFE.EQ.3) THEN
               XPQ(5)=AEM*XPQD
               XPQ(-5)=XPQ(5)
            ENDIF
         ELSEIF(KFA.EQ.211) THEN
C...Pion structure functions from Owens.
C...Allowed variable range: 4 GeV^2 < Q^2 < approx 2000 GeV^2.

C...Determine set, Lambda and s expansion variable.
            NSET=1
            IF(MSTP(51).EQ.2.OR.MSTP(51).EQ.4.OR.MSTP(51).EQ.13) NSET=
     +      2
            IF(NSET.EQ.1) ALAM=0.2
            IF(NSET.EQ.2) ALAM=0.4
            IF(MSTP(52).LE.0) THEN
               SD=0.
            ELSE
               Q2IN=MIN(2E3,MAX(4.,Q2))
               SD=LOG(LOG(Q2IN/ALAM**2)/LOG(4./ALAM**2))
            ENDIF

C...Calculate structure functions.
            DO 110 KFL=1,4
               DO 100 IS=1,5
  100          TS(IS)=COW(1,IS,KFL,NSET)+COW(2,IS,KFL,NSET)*SD+ COW(3,
     +         IS, KFL,NSET)*SD**2
               IF(KFL.EQ.1) THEN
                  XQ(KFL)=X**TS(1)*(1.-X)**TS(2)/EULBET(TS(1),TS(2)+1.)
               ELSE
                  XQ(KFL)=TS(1)*X**TS(2)*(1.-X)**TS(3)*(1.+TS(4)*X+
     +            TS(5)* X**2)
               ENDIF
  110       CONTINUE

C...Put into output arrays.
            XPQ(0)=XQ(2)
            XPQ(1)=XQ(3)/6.
            XPQ(2)=XQ(1)+XQ(3)/6.
            XPQ(3)=XQ(3)/6.
            XPQ(4)=XQ(4)
            XPQ(-1)=XQ(1)+XQ(3)/6.
            XPQ(-2)=XQ(3)/6.
            XPQ(-3)=XQ(3)/6.
            XPQ(-4)=XQ(4)
         ELSEIF(MSTP(51).EQ.1.OR.MSTP(51).EQ.2) THEN
C...Proton structure functions from Eichten, Hinchliffe, Lane, Quigg.
C...Allowed variable range: 5 GeV^2 < Q^2 < 1E8 GeV^2; 1E-4 < x < 1

C...Determine set, Lamdba and x and t expansion variables.
            NSET=MSTP(51)
            IF(NSET.EQ.1) ALAM=0.2
            IF(NSET.EQ.2) ALAM=0.29
            TMIN=LOG(5./ALAM**2)
            TMAX=LOG(1E8/ALAM**2)
            IF(MSTP(52).EQ.0) THEN
               T=TMIN
            ELSE
               T=LOG(MAX(1.,Q2/ALAM**2))
            ENDIF
            VT=MAX(-1.,MIN(1.,(2.*T-TMAX-TMIN)/(TMAX-TMIN)))
            NX=1
            IF(X.LE.0.1) NX=2
            IF(NX.EQ.1) VX=(2.*X-1.1)/0.9
            IF(NX.EQ.2) VX=MAX(-1.,(2.*LOG(X)+11.51293)/6.90776)
            CXS=1.
            IF(X.LT.1E-4.AND.ABS(PARP(51)-1.).GT.0.01) CXS= (1E-4/X)**
     +      (PARP(51)-1.)

C...Chebyshev polynomials for x and t expansion.
            TX(1)=1.
            TX(2)=VX
            TX(3)=2.*VX**2-1.
            TX(4)=4.*VX**3-3.*VX
            TX(5)=8.*VX**4-8.*VX**2+1.
            TX(6)=16.*VX**5-20.*VX**3+5.*VX
            TT(1)=1.
            TT(2)=VT
            TT(3)=2.*VT**2-1.
            TT(4)=4.*VT**3-3.*VT
            TT(5)=8.*VT**4-8.*VT**2+1.
            TT(6)=16.*VT**5-20.*VT**3+5.*VT

C...Calculate structure functions.
            DO 130 KFL=1,6
               XQSUM=0.
               DO 120 IT=1,6
                  DO 120 IX=1,6
  120          XQSUM=XQSUM+CEHLQ(IX,IT,NX,KFL,NSET)*TX(IX)*TT(IT)
  130       XQ(KFL)=XQSUM*(1.-X)**NEHLQ(KFL,NSET)*CXS

C...Put into output array.
            XPQ(0)=XQ(4)
            XPQ(1)=XQ(2)+XQ(3)
            XPQ(2)=XQ(1)+XQ(3)
            XPQ(3)=XQ(5)
            XPQ(4)=XQ(6)
            XPQ(-1)=XQ(3)
            XPQ(-2)=XQ(3)
            XPQ(-3)=XQ(5)
            XPQ(-4)=XQ(6)

C...Special expansion for bottom (threshold effects).
            IF(MSTP(54).GE.5) THEN
               IF(NSET.EQ.1) TMIN=8.1905
               IF(NSET.EQ.2) TMIN=7.4474
               IF(T.LE.TMIN) GOTO 150
               VT=MAX(-1.,MIN(1.,(2.*T-TMAX-TMIN)/(TMAX-TMIN)))
               TT(1)=1.
               TT(2)=VT
               TT(3)=2.*VT**2-1.
               TT(4)=4.*VT**3-3.*VT
               TT(5)=8.*VT**4-8.*VT**2+1.
               TT(6)=16.*VT**5-20.*VT**3+5.*VT
               XQSUM=0.
               DO 140 IT=1,6
                  DO 140 IX=1,6
  140          XQSUM=XQSUM+CEHLQ(IX,IT,NX,7,NSET)*TX(IX)*TT(IT)
               XPQ(5)=XQSUM*(1.-X)**NEHLQ(7,NSET)*CXS
               XPQ(-5)=XPQ(5)
  150          CONTINUE
            ENDIF

C...Special expansion for top (threshold effects).
            IF(MSTP(54).GE.6) THEN
               IF(NSET.EQ.1) TMIN=11.5528
               IF(NSET.EQ.2) TMIN=10.8097
               TMIN=TMIN+2.*LOG(PMAS(6,1)/30.)
               TMAX=TMAX+2.*LOG(PMAS(6,1)/30.)
               IF(T.LE.TMIN) GOTO 170
               VT=MAX(-1.,MIN(1.,(2.*T-TMAX-TMIN)/(TMAX-TMIN)))
               TT(1)=1.
               TT(2)=VT
               TT(3)=2.*VT**2-1.
               TT(4)=4.*VT**3-3.*VT
               TT(5)=8.*VT**4-8.*VT**2+1.
               TT(6)=16.*VT**5-20.*VT**3+5.*VT
               XQSUM=0.
               DO 160 IT=1,6
                  DO 160 IX=1,6
  160          XQSUM=XQSUM+CEHLQ(IX,IT,NX,8,NSET)*TX(IX)*TT(IT)
               XPQ(6)=XQSUM*(1.-X)**NEHLQ(8,NSET)*CXS
               XPQ(-6)=XPQ(6)
  170          CONTINUE
            ENDIF

         ELSEIF(MSTP(51).EQ.3.OR.MSTP(51).EQ.4) THEN
C...Proton structure functions from Duke, Owens.
C...Allowed variable range: 4 GeV^2 < Q^2 < approx 1E6 GeV^2.

C...Determine set, Lambda and s expansion parameter.
            NSET=MSTP(51)-2
            IF(NSET.EQ.1) ALAM=0.2
            IF(NSET.EQ.2) ALAM=0.4
            IF(MSTP(52).LE.0) THEN
               SD=0.
            ELSE
               Q2IN=MIN(1E6,MAX(4.,Q2))
               SD=LOG(LOG(Q2IN/ALAM**2)/LOG(4./ALAM**2))
            ENDIF

C...Calculate structure functions.
            DO 190 KFL=1,5
               DO 180 IS=1,6
  180          TS(IS)=CDO(1,IS,KFL,NSET)+CDO(2,IS,KFL,NSET)*SD+ CDO(3,
     +         IS, KFL,NSET)*SD**2
               IF(KFL.LE.2) THEN
                  XQ(KFL)=X**TS(1)*(1.-X)**TS(2)*(1.+TS(3)*X)/ (EULBET(
     +            TS(1), TS(2)+1.)*(1.+TS(3)*TS(1)/(TS(1)+TS(2)+
     +            1.)))
               ELSE
                  XQ(KFL)=TS(1)*X**TS(2)*(1.-X)**TS(3)*(1.+TS(4)*X+
     +            TS(5)* X**2+ TS(6)*X**3)
               ENDIF
  190       CONTINUE

C...Put into output arrays.
            XPQ(0)=XQ(5)
            XPQ(1)=XQ(2)+XQ(3)/6.
            XPQ(2)=3.*XQ(1)-XQ(2)+XQ(3)/6.
            XPQ(3)=XQ(3)/6.
            XPQ(4)=XQ(4)
            XPQ(-1)=XQ(3)/6.
            XPQ(-2)=XQ(3)/6.
            XPQ(-3)=XQ(3)/6.
            XPQ(-4)=XQ(4)

         ELSEIF(MSTP(51).GE.5.AND.MSTP(51).LE.8) THEN
C...Proton structure functions from Morfin and Tung.
C...Allowed variable range: 4 GeV^2 < Q^2 < 1E8 GeV^2, 0 < x < 1.

C...Calculate expansion parameters.
            NSET=MSTP(51)-4
            IF(NSET.EQ.1) ALAM=0.187
            IF(NSET.EQ.2) ALAM=0.212
            IF(NSET.EQ.3) ALAM=0.191
            IF(NSET.EQ.4) ALAM=0.155
            IF(MSTP(52).EQ.0) THEN
               SD=0.
            ELSE
               SD=LOG(LOG(MAX(4.,Q2)/ALAM**2)/LOG(4./ALAM**2))
            ENDIF
            XL=LOG(MAX(1E-10,X))
            X1L=LOG(MAX(1E-10,1.-X))
            XLL=LOG(MAX(1E-10,LOG(1.+1./MAX(1E-10,X))))

C...Calculate structure functions up to b.
            DO 210 IP=1,8
               DO 200 IEX=0,3
  200          EXMT(IEX)=CMT(IEX,0,IP,NSET)+CMT(IEX,1,IP,NSET)*SD+
     +         CMT(IEX ,2,IP,NSET)*SD**2
               EXMTS=EXMT(0)+EXMT(1)*XL+EXMT(2)*X1L+EXMT(3)*XLL
               IF(EXMTS.LT.-50.) THEN
                  XQ(IP)=0.
               ELSE
                  XQ(IP)=EXP(EXMTS)
               ENDIF
  210       CONTINUE
            IF(Q2.LE.2.25) XQ(7)=0
            IF(Q2.LE.25.0) XQ(8)=0

C...Calculate t structure function, shifting effective Q scale for
C...nondefault t mass, Q_actual = Q_nominal * m_t_nominal/m_t_actual.
            IF(MSTP(52).EQ.0.OR.Q2.LE.PMAS(6,1)**2) THEN
               XQ(9)=0.
            ELSE
               SD=LOG(LOG(MAX(4.,Q2)/ALAM**2*(100./PMAS(6,1))**2)/
     +         LOG(4./ ALAM**2))
               DO 220 IEX=0,3
  220          EXMT(IEX)=CMT(IEX,0,9,NSET)+CMT(IEX,1,9,NSET)*SD+
     +         CMT(IEX, 2,9,NSET)*SD**2
               EXMTS=EXMT(0)+EXMT(1)*XL+EXMT(2)*X1L+EXMT(3)*XLL
               IF(EXMTS.LT.-50.) THEN
                  XQ(IP)=0.
               ELSE
                  XQ(IP)=EXP(EXMTS)
               ENDIF
            ENDIF

C...Put into output array.
            XPQ(0)=XQ(3)
            XPQ(1)=XQ(1)+XQ(5)
            XPQ(-1)=XQ(5)
            XPQ(2)=XQ(2)+XQ(4)
            XPQ(-2)=XQ(4)
            XPQ(3)=XQ(6)
            XPQ(-3)=XQ(6)
            XPQ(4)=XQ(7)
            XPQ(-4)=XQ(7)
            XPQ(5)=XQ(8)
            XPQ(-5)=XQ(8)
            XPQ(6)=XQ(9)
            XPQ(-6)=XQ(9)
         ELSEIF(MSTP(51).EQ.9) THEN
C...Lowest order parametrization of Gluck, Reya, Vogt.
C...Allowed variable range: 0.2 GeV^2 < Q2 < 1E6 GeV^2; 1E-4 < x < 1;
C...extended to 0.2 GeV^2 < Q2 < 1E8 GeV^2; 1E-6 < x < 1
C...after consultation with the authors.

C...Determine s and x.
            ALAM=0.25
            IF(MSTP(52).EQ.0) THEN
               SD=0.
            ELSE
               Q2IN=MIN(1E8,MAX(0.2,Q2))
               SD=LOG(LOG(Q2IN/ALAM**2)/LOG(0.2/ALAM**2))
            ENDIF
            XC=MAX(1E-6,X)
            XL=-LOG(XC)

C...Calculate structure functions.
            XQ(1)=(0.794+0.312*SD)*XC**(0.427-0.011*SD)* (1.+(6.887-
     +      2.227* SD)*XC+(-11.083+2.136*SD)*XC**2+ (3.900+1.079*SD)*
     +      XC**3)*(1.- XC)**(1.037+1.077*SD)
            XQ(2)=(0.486+0.139*SD)*XC**(0.434-0.018*SD)* (1.+(7.716-
     +      2.684* SD)*XC+(-12.768+3.122*SD)*XC**2+ (4.564+0.470*SD)*
     +      XC**3)*(1.- XC)**(1.889+1.129*SD)
            XQ(3)=(XC**(0.415+0.186*SD)*((0.786+0.942*SD)+ (5.256-
     +      5.810* SD)*XC+(-4.599+5.842*SD)*XC**2)+SD**0.592* EXP(-
     +      (0.398+2.135* SD)+SQRT(3.779*SD**1.250*XL)))* (1.-XC)**
     +      (1.622+1.980*SD)
            XQ(4)=SD**0.448*(1.-XC)**(5.540-0.445*SD)* EXP(-(4.668+
     +      1.230* SD)+SQRT((13.173-1.361*SD)*SD**0.442*XL))/ XL**
     +      (3.181-0.862* SD)
            XQ(5)=0.
            IF(SD.GT.1.125) XQ(5)=(SD-1.125)*(1.-XC)**(2.038+1.022*SD)*
     +      EXP(-(4.290+1.569*SD)+SQRT((2.982+1.452*SD)*SD**0.5*XL))
            XQ(6)=0.
            IF(SD.GT.1.603) XQ(6)=(SD-1.603)*(1.-XC)**(2.230+1.052*SD)*
     +      EXP(-(4.566+1.559*SD)+SQRT((4.147+1.268*SD)*SD**0.5*XL))

C...Put into output array - special factor for small x.
            CXS=1.
            IF(X.LT.1E-6.AND.ABS(PARP(51)-1.).GT.0.01) CXS=(1E-6/X)**
     +      (PARP(51)-1.)
            XPQ(0)=CXS*XQ(3)
            XPQ(1)=CXS*(XQ(2)+XQ(4))
            XPQ(-1)=CXS*XQ(4)
            XPQ(2)=CXS*(XQ(1)+XQ(4))
            XPQ(-2)=CXS*XQ(4)
            XPQ(3)=CXS*XQ(4)
            XPQ(-3)=CXS*XQ(4)
            XPQ(4)=CXS*XQ(5)
            XPQ(-4)=CXS*XQ(5)
            XPQ(5)=CXS*XQ(6)
            XPQ(-5)=CXS*XQ(6)
cc            write(6,*) ' GRV ',MSTP(51),' xpq(4) ',xpq(4)
         ELSEIF(MSTP(51).EQ.10) THEN
C...Higher order parametrization of Gluck, Reya, Vogt.
C...Allowed variable range: 0.2 GeV^2 < Q2 < 1E6 GeV^2; 1E-4 < x < 1;
C...extended to 0.2 GeV^2 < Q2 < 1E8 GeV^2; 1E-6 < x < 1
C...after consultation with the authors.

C...Determine s and x.
            ALAM=0.20
            IF(MSTP(52).EQ.0) THEN
               SD=0.
            ELSE
               Q2IN=MIN(1E8,MAX(0.2,Q2))
               SD=LOG(LOG(Q2IN/ALAM**2)/LOG(0.2/ALAM**2))
            ENDIF
            SD2=SD**2
            XC=MAX(1E-6,X)
            XL=-LOG(XC)

C...Calculate structure functions.
            XQ(1)=(1.364+0.989*SD-0.236*SD2)*XC**(0.593-0.048*SD)* (1.+
     +      (8.912-6.092*SD+0.852*SD2)*XC+(-16.737+7.039*SD)*XC**2+
     +      (10.275+0.806*SD-2.000*SD2)*XC**3)* (1.-XC)**(2.043+1.408*
     +      SD-0.283*SD2)
            XQ(2)=(0.835+0.527*SD-0.144*SD2)*XC**(0.600-0.054*SD)* (1.+
     +      (10.245-7.821*SD+1.325*SD2)*XC+(-19.511+10.940*SD- 1.133*
     +      SD2)* XC**2+(12.836-2.570*SD-1.041*SD2)*XC**3)* (1.-XC)**
     +      (3.083+ 1.382*SD-0.276*SD2)
            XQ(3)=(XC**(0.321-0.135*SD)*((10.51-2.299*SD)+ (-17.28+
     +      0.755* SD)*XC+(8.242+2.543*SD)*XC**2)* XL**(-2.023-0.103*
     +      SD)+SD** 1.044* EXP(-(-1.178+2.792*SD)+SQRT(2.318*SD**
     +      1.673*XL)))* (1.-XC)**(3.720+2.337*SD-0.199*SD2)
            XQ(4)=SD**0.761*(1.+(6.078-2.065*SD)*XC)*(1.-XC)**(4.654+
     +      0.603*SD-0.326*SD2)*EXP(-(4.231+1.036*SD)+SQRT(3.419*SD**
     +      0.316* XL))/XL**(0.897-0.618*SD)
            XQ(5)=0.
            IF(SD.GT.0.918) XQ(5)=(SD-0.918)*(1.-XC)**(3.328+0.859*SD)*
     +      EXP(-(3.837+1.504*SD)+SQRT((2.150+1.291*SD)*SD**0.5*XL))
            XQ(6)=0.
            IF(SD.GT.1.353) XQ(6)=(SD-1.353)*(1.-XC)**(3.382+0.909*SD)*
     +      EXP(-(4.130+1.486*SD)+SQRT((2.895+1.240*SD)*SD**0.5*XL))

C...Put into output array - special factor for small x.
            CXS=1.
            IF(X.LT.1E-6.AND.ABS(PARP(51)-1.).GT.0.01) CXS=(1E-6/X)**
     +      (PARP(51)-1.)
            XPQ(0)=CXS*XQ(3)
            XPQ(1)=CXS*(XQ(2)+XQ(4))
            XPQ(-1)=CXS*XQ(4)
            XPQ(2)=CXS*(XQ(1)+XQ(4))
            XPQ(-2)=CXS*XQ(4)
            XPQ(3)=CXS*XQ(4)
            XPQ(-3)=CXS*XQ(4)
            XPQ(4)=CXS*XQ(5)
            XPQ(-4)=CXS*XQ(5)
            XPQ(5)=CXS*XQ(6)
            XPQ(-5)=CXS*XQ(6)
c            write(6,*) ' GRV HO',MSTP(51)
C...Proton structure functions from Diemoz, Ferroni, Longo, Martinelli.
C...These are accessed via PYSTFE since the files needed may not always
C...available.
         ELSEIF(MSTP(51).GE.11.AND.MSTP(51).LE.13) THEN
            CALL PYSTFE(2212,X,Q2,XPQ)
C...Unknown proton parametrization.
         ELSE
            WRITE(MSTU(11),10200) MSTP(51)
         ENDIF

C...Isospin conjugation for neutron.
         IF(KFA.EQ.2112) THEN
            XPS=XPQ(1)
            XPQ(1)=XPQ(2)
            XPQ(2)=XPS
            XPS=XPQ(-1)
            XPQ(-1)=XPQ(-2)
            XPQ(-2)=XPS
         ENDIF

C...Charge conjugation for antiparticle.
         IF(KF.LT.0) THEN
            DO 230 KFL=1,6
               IF(KFL.EQ.21.OR.KFL.EQ.22.OR.KFL.EQ.23.OR.KFL.EQ.25)
     +         GOTO 230
               XPS=XPQ(KFL)
               XPQ(KFL)=XPQ(-KFL)
               XPQ(-KFL)=XPS
  230       CONTINUE
         ENDIF

      ELSE
         write(6,*) ' RYSTFU: no parton density caclulated '
         write(6,*) ' RYSTFU: IDIR=',IDIR,' IDISDIF = ',IDISDIF
         write(6,*) ' RYSTFU: KF = ',KF,' Q2 = ',Q2,' X = ',X
      ENDIF
  240 CONTINUE
C...Check positivity and reset above maximum allowed flavour.
      DO 250 KFL=-6,6
         XPQ(KFL)=MAX(0.,XPQ(KFL))
  250 IF(IABS(KFL).LE.8.AND.IABS(KFL).GT.MSTP(54)) XPQ(KFL)=0.
C...Formats for error printouts.
10000 FORMAT(' Error: x value outside physical range, x =',1P,E12.3)
10100 FORMAT(' Error: illegal particle code for structure function,',
     +' KF =',I5)
10200 FORMAT(' Error: bad value of parameter MSTP(51) in RYSTFU,',
     +' MSTP(51) =',I5)

      RETURN
      END
