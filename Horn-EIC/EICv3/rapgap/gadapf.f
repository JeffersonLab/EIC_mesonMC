*CMZ :  2.07/03 15/05/99  20.45.54  by  Hannes Jung
*-- Author :
C **********************************************************************


      FUNCTION GADAPF(X,A0,B0,F,EPS)
	IMPLICIT NONE
	Integer NUM,IFU,I,L,N
	Real F,A,B,F1,F2,F3,S,DSUM,F1F,F2F,F3F,AA,BB,EPS,RED
	Real SUM,C,A0,B0,X,W1,U2,SS,SOLD,GADAPF
      COMMON/GADAP1/ NUM,IFU
      EXTERNAL F
      DIMENSION A(300),B(300),F1(300),F2(300),F3(300),S(300),N(300)

      DSUM(F1F,F2F,F3F,AA,BB)=5./18.*(BB-AA)*(F1F+1.6*F2F+F3F)
      IF(EPS.LT.1.0E-8) EPS=1.0E-8
      RED=1.4
      L=1
      I=1
      SUM=0.
      C=SQRT(15.)/5.
      A(1)=A0
      B(1)=B0
      F1(1)=F(X,0.5*(1+C)*A0+0.5*(1-C)*B0)
      F2(1)=F(X,0.5*(A0+B0))
      F3(1)=F(X,0.5*(1-C)*A0+0.5*(1+C)*B0)
      IFU=3
      S(1)=  DSUM(F1(1),F2(1),F3(1),A0,B0)
   10 CONTINUE
      L=L+1
      N(L)=3
      EPS=EPS*RED
      A(I+1)=A(I)+C*(B(I)-A(I))
      B(I+1)=B(I)
      A(I+2)=A(I)+B(I)-A(I+1)
      B(I+2)=A(I+1)
      A(I+3)=A(I)
      B(I+3)=A(I+2)
      W1=A(I)+(B(I)-A(I))/5.
      U2=2.*W1-(A(I)+A(I+2))/2.
      F1(I+1)=F(X,A(I)+B(I)-W1)
      F2(I+1)=F3(I)
      F3(I+1)=F(X,B(I)-A(I+2)+W1)
      F1(I+2)=F(X,U2)
      F2(I+2)=F2(I)
      F3(I+2)=F(X,B(I+2)+A(I+2)-U2)
      F1(I+3)=F(X,A(I)+A(I+2)-W1)
      F2(I+3)=F1(I)
      F3(I+3)=F(X,W1)
      IFU=IFU+6
      IF(IFU.GT.5000) GOTO 40
      S(I+1)=  DSUM(F1(I+1),F2(I+1),F3(I+1),A(I+1),B(I+1))
      S(I+2)=  DSUM(F1(I+2),F2(I+2),F3(I+2),A(I+2),B(I+2))
      S(I+3)=  DSUM(F1(I+3),F2(I+3),F3(I+3),A(I+3),B(I+3))
      SS=S(I+1)+S(I+2)+S(I+3)
      I=I+3
      IF(I.GT.300)GOTO 30
      SOLD=S(I-3)
      IF(ABS(SOLD-SS).GT.EPS*(1.+ABS(SS))/2.) GOTO 10
      SUM=SUM+SS
      I=I-4
      N(L)=0
      L=L-1
   20 CONTINUE
      IF(L.EQ.1) GOTO 40
      N(L)=N(L)-1
      EPS=EPS/RED
      IF(N(L).NE.0) GOTO 10
      I=I-1
      L=L-1
      GOTO 20
   30 WRITE(6,10000)
10000 FORMAT(' GADAP:I TOO BIG')
   40 GADAPF=SUM
      EPS=EPS/RED
      RETURN
      END
