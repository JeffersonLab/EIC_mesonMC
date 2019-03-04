*CMZ :  2.06/00 17/07/97  14.24.16  by  Hannes Jung
*CMZ :  2.05/28 15/07/97  10.27.09  by  Hannes Jung
*-- Author :    Hannes Jung   15/07/97
      SUBROUTINE F2MCD(BETA,X_POM,Q2,T2,XDX,FLQ)
* calculate   in the approach of M. McDermott
      IMPLICIT DOUBLE PRECISION (A-G,O-Z)
*KEEP,RGPARAS.
      DOUBLE PRECISION PT2CUT,THEMA,THEMI,Q2START,W_Q2,OMEG2
      INTEGER IRUNA,IQ2,IRUNAEM
      INTEGER IPRO
      COMMON/RAPA /IPRO,IRUNA,IQ2,IRUNAEM,Q2START,W_Q2,OMEG2
      DOUBLE PRECISION SCALFA
      COMMON/SCALF/ SCALFA
      COMMON/PTCUT/ PT2CUT(100)
      COMMON/ELECT/ THEMA,THEMI
      REAL ULALPS,ULALEM
      EXTERNAL ULALPS,ULALEM
C     SAVE

*KEEP,RGPARAM.
      INTEGER IWEI
      DOUBLE PRECISION ALPHS,PI,ALPH
      COMMON /PARAM/ ALPHS,PI,ALPH,IWEI
      DOUBLE PRECISION SIN2W,XMW2
      COMMON/ELWEAK/SIN2W,XMW2
*KEEP,RGLUCO.
      REAL PLEPIN,PPIN
      INTEGER KE,KP,KEB,KPH,KGL,KPA,NFRAG,ILEPTO,IFPS,IHF,IALMKT
      INTEGER INTER,ISEMIH
      INTEGER NIA1,NIR1,NIA2,NIR2,NF1,NF2,NFT,NFLAV,NFLQCDC
      COMMON/LUCO  /KE,KP,KEB,KPH,KGL,KPA,NFLAV,NFLQCDC
      COMMON/INPU  /PLEPIN,PPIN,NFRAG,ILEPTO,IFPS,IHF,IALMKT,INTER,
     +              ISEMIH
      COMMON/HARD/ NIA1,NIR1,NIA2,NIR2,NF1,NF2,NFT
      INTEGER IHFLA
      COMMON/HFLAV/ IHFLA
C      SAVE

*KEND.
      DOUBLE PRECISION PT2GEN,PHIGEN
      COMMON/HARDPOM/PT2GEN,PHIGEN
      COMMON /SEL/IPHI
      DOUBLE PRECISION XDX(-4:4)
      DOUBLE PRECISION C1,Cg
      COMMON/BUCHMUE/C1,Cg
*KEEP,RGLUDAT2.
      REAL PMAS,PARF,VCKM
      INTEGER KCHG
      COMMON/LUDAT2/KCHG(500,3),PMAS(500,4),PARF(2000),VCKM(4,4)
C      SAVE

*KEND.
      EXTERNAL FMD
      DATA SMALL/1.D-6/
      IPHI = 0
c      C1 = 1.d0
c      Cg = 1.d0
      q2t = q2
      t2t = t2
      bet = beta
      xpom = x_pom
      ymcd = xpom*bet
      umcd = xpom/ymcd - 1.d0
c      write(6,*) ' xpom',x_pom,beta,q2,t2
c include Donnacchi/Landshoff dipole form factor for t
      dl =(4.d0-2.8d0*t2t)/(4.d0-t2t)*
     +   1.d0/(1.d0-t2t/0.7d0)**2
      DO 10 I=-4,4
   10 XDX(I)=0.d0
c 1/xpom removed due to jacobian dy/dx_g=x_pom
      XDX(0) = C1/(cg + umcd)/xpom/bet*dl
      XDX(-4)=XDX(4)
      XDX(-3)=XDX(3)
      XDX(-2)=XDX(2)
      XDX(-1)=XDX(1)
      RETURN
      END
