*CMZ :  2.08/00 06/06/99  15.46.42  by  Hannes Jung
*CMZ :  2.07/03 15/05/99  14.37.42  by  Hannes Jung
*-- Author :    Hannes Jung   30/10/94
      SUBROUTINE DIFFR4(X,WDIF)
      IMPLICIT NONE
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

*KEND.
      Double Precision GEV2NB,WPART,WDIF,WT1
	Double Precision X(20)
      DATA GEV2NB/.3893857D+6/
      WPART=0.D0
      WDIF=0.D0
      WT1=0.D0
      CALL PARTDF(X,WPART)
c      write(6,*) 'diffr4: WPART ',WPART
      IF(WPART.NE.0.) THEN
         IF(IPRO.EQ.100) CALL ELERHO(WT1)
      ENDIF
      WDIF=WPART*WT1*GEV2NB
c      write(6,*) 'diffr4: WDIF ',WDIF
c      call lulist(1)
      RETURN
      END
