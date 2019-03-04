*CMZ :  2.00/01 20/04/95  17.18.33  by  Hannes Jung
*-- Author :
C*********************************************************************

      SUBROUTINE PYSTGA(NFE,X,T,XPGL,XPQU,XPQD)

C...Gives photon structure function; external to PYSTFU since it
C...may be called several times for convolution of photon structure
C...functions with photons in electron structure function.
      DIMENSION DGAG(4,3),DGBG(4,3),DGCG(4,3),DGAN(4,3),DGBN(4,3),
     +DGCN(4,3),DGDN(4,3),DGEN(4,3),DGAS(4,3),DGBS(4,3),DGCS(4,3),
     +DGDS(4,3),DGES(4,3)

C...The following data lines are coefficients needed in the
C...Drees and Grassie photon structure function parametrizations.
      DATA DGAG/-.207E0,.6158E0,1.074E0,0.E0,.8926E-2,.6594E0,
     +.4766E0,.1975E-1,.03197E0,1.018E0,.2461E0,.2707E-1/
      DATA DGBG/-.1987E0,.6257E0,8.352E0,5.024E0,.5085E-1,.2774E0,
     +-.3906E0,-.3212E0,-.618E-2,.9476E0,-.6094E0,-.1067E-1/
      DATA DGCG/5.119E0,-.2752E0,-6.993E0,2.298E0,-.2313E0,.1382E0,
     +6.542E0,.5162E0,-.1216E0,.9047E0,2.653E0,.2003E-2/
      DATA DGAN/2.285E0,-.1526E-1,1330.E0,4.219E0,-.3711E0,1.061E0,
     +4.758E0,-.1503E-1,15.8E0,-.9464E0,-.5E0,-.2118E0/
      DATA DGBN/6.073E0,-.8132E0,-41.31E0,3.165E0,-.1717E0,.7815E0,
     +1.535E0,.7067E-2,2.742E0,-.7332E0,.7148E0,3.287E0/
      DATA DGCN/-.4202E0,.1778E-1,.9216E0,.18E0,.8766E-1,.2197E-1,
     +.1096E0,.204E0,.2917E-1,.4657E-1,.1785E0,.4811E-1/
      DATA DGDN/-.8083E-1,.6346E0,1.208E0,.203E0,-.8915E0,.2857E0,
     +2.973E0,.1185E0,-.342E-1,.7196E0,.7338E0,.8139E-1/
      DATA DGEN/.5526E-1,1.136E0,.9512E0,.1163E-1,-.1816E0,.5866E0,
     +2.421E0,.4059E0,-.2302E-1,.9229E0,.5873E0,-.79E-4/
      DATA DGAS/16.69E0,-.7916E0,1099.E0,4.428E0,-.1207E0,1.071E0,
     +1.977E0,-.8625E-2,6.734E0,-1.008E0,-.8594E-1,.7625E-1/
      DATA DGBS/.176E0,.4794E-1,1.047E0,.25E-1,25.E0,-1.648E0,
     +-.1563E-1,6.438E0,59.88E0,-2.983E0,4.48E0,.9686E0/
      DATA DGCS/-.208E-1,.3386E-2,4.853E0,.8404E0,-.123E-1,1.162E0,
     +.4824E0,-.11E-1,-.3226E-2,.8432E0,.3616E0,.1383E-2/
      DATA DGDS/-.1685E-1,1.353E0,1.426E0,1.239E0,-.9194E-1,.7912E0,
     +.6397E0,2.327E0,-.3321E-1,.9475E0,-.3198E0,.2132E-1/
      DATA DGES/-.1986E0,1.1E0,1.136E0,-.2779E0,.2015E-1,.9869E0,
     +-.7036E-1,.1694E-1,.1059E0,.6954E0,-.6663E0,.3683E0/

C...Photon structure function from Drees and Grassie.
C...Allowed variable range: 1 GeV^2 < Q^2 < 10000 GeV^2.
      X1=1.-X

C...Evaluate gluon content.
      DGA=DGAG(1,NFE)*T**DGAG(2,NFE)+DGAG(3,NFE)*T**(-DGAG(4,NFE))
      DGB=DGBG(1,NFE)*T**DGBG(2,NFE)+DGBG(3,NFE)*T**(-DGBG(4,NFE))
      DGC=DGCG(1,NFE)*T**DGCG(2,NFE)+DGCG(3,NFE)*T**(-DGCG(4,NFE))
      XPGL=DGA*X**DGB*X1**DGC

C...Evaluate up- and down-type quark content.
      DGA=DGAN(1,NFE)*T**DGAN(2,NFE)+DGAN(3,NFE)*T**(-DGAN(4,NFE))
      DGB=DGBN(1,NFE)*T**DGBN(2,NFE)+DGBN(3,NFE)*T**(-DGBN(4,NFE))
      DGC=DGCN(1,NFE)*T**DGCN(2,NFE)+DGCN(3,NFE)*T**(-DGCN(4,NFE))
      DGD=DGDN(1,NFE)*T**DGDN(2,NFE)+DGDN(3,NFE)*T**(-DGDN(4,NFE))
      DGE=DGEN(1,NFE)*T**DGEN(2,NFE)+DGEN(3,NFE)*T**(-DGEN(4,NFE))
      XPQN=X*(X**2+X1**2)/(DGA-DGB*LOG(X1))+DGC*X**DGD*X1**DGE
      DGA=DGAS(1,NFE)*T**DGAS(2,NFE)+DGAS(3,NFE)*T**(-DGAS(4,NFE))
      DGB=DGBS(1,NFE)*T**DGBS(2,NFE)+DGBS(3,NFE)*T**(-DGBS(4,NFE))
      DGC=DGCS(1,NFE)*T**DGCS(2,NFE)+DGCS(3,NFE)*T**(-DGCS(4,NFE))
      DGD=DGDS(1,NFE)*T**DGDS(2,NFE)+DGDS(3,NFE)*T**(-DGDS(4,NFE))
      DGE=DGES(1,NFE)*T**DGES(2,NFE)+DGES(3,NFE)*T**(-DGES(4,NFE))
      DGF=9.
      IF(NFE.EQ.2) DGF=10.
      IF(NFE.EQ.3) DGF=55./6.
      XPQS=DGF*X*(X**2+X1**2)/(DGA-DGB*LOG(X1))+DGC*X**DGD*X1**DGE
      IF(NFE.LE.1) THEN
         XPQU=(XPQS+9.*XPQN)/6.
         XPQD=(XPQS-4.5*XPQN)/6.
      ELSEIF(NFE.EQ.2) THEN
         XPQU=(XPQS+6.*XPQN)/8.
         XPQD=(XPQS-6.*XPQN)/8.
      ELSE
         XPQU=(XPQS+7.5*XPQN)/10.
         XPQD=(XPQS-5.*XPQN)/10.
      ENDIF

      RETURN
      END
