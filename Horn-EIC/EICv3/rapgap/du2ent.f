*CMZ :  2.07/03 15/05/99  15.00.27  by  Hannes Jung
*-- Author :    Hannes Jung   03/04/94
      SUBROUTINE DU2ENT(NF1,KP1,KP2,ECM)
	IMPLICIT NONE
      INTEGER N,K
      REAL P,V
      DOUBLE PRECISION DP
*KEEP,RGLUPARM.
      INTEGER LUPAN
      PARAMETER (LUPAN=4000)


*KEND.
      COMMON/LUJETS/N,K(LUPAN,5),P(LUPAN,5),V(LUPAN,5)
      COMMON/DUJETS/DP(LUPAN,5)
      REAL ECM
	INTEGER NF1,KP1,KP2,I,J
      DO 10 I=1,N
         DO 10 J=1,5
   10 P(I,J)= SNGL(DP(I,J))
      CALL LU2ENT(NF1,KP1,KP2,ECM)
      DO 20 I = 1,N
         DO 20 J=1,5
   20 DP(I,J) = DBLE(P(I,J))
      RETURN
      END
