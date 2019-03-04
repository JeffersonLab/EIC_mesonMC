*CMZ :  2.06/23 17/12/97  19.41.07  by  Hannes Jung
*-- Author :
      SUBROUTINE GARINI

*#**********************************************************************
*#
*#    SUBROUTINE GARINI
*#
*# PURPOSE: initialise ARIADNE 4.8 parameter commons
*#
*# NOTE: GARINI has to be called before call to GLECHA
*#
*# CALLED BY: GLEPTO
*#
*# CALLING: UCOPY
*#
*# AUTHOR: Peter Lanius             CREATED AT: 92/03/02
*#
*# CHANGED BY:                              AT:
*# REASON:
*#
*#**********************************************************************

C...Initialization of the common blocks used in Ariadne

      PARAMETER(MAXDIP=500,MAXPAR=500,MAXSTR=100,MAXONI=100)

      IMPLICIT DOUBLE PRECISION (D)
      IMPLICIT DOUBLE PRECISION (B)
      IMPLICIT LOGICAL (Q)

      COMMON /ARDAT1/ PARA(40),MSTA(40)
      SAVE /ARDAT1/
      COMMON /ARDAT2/ PQMAS(10)
      SAVE /ARDAT2/
      COMMON /ARDAT3/ IWRN(40)
      SAVE /ARDAT3/
      COMMON /ARHIDE/ PHAR(400),MHAR(400)
      SAVE /ARHIDE/
      COMMON /ARPOPA/ TOTSIG,PPOW,CA(3),PB(3),CF(0:6),XA(0:6),NB(0:6)
      SAVE /ARPOPA/

C-MH array for H1 specific steering of ARTUNE:
      COMMON /H1TUNE/ CH1TUN
      CHARACTER*4 CH1TUN

C...Breif explanation of parameters and switches:
C...
C...
C...Parameters:
C...
C...PARA(1) (D=0.22) lambda_QCD
C...PARA(2) (D=0.200) Constant alpha_QCD for MSTA(12)=0
C...PARA(3) (D=0.600) Cutoff in invariant p_t for QCD emission
C...PARA(4) (D=1/137) Constant alpha_EM
C...PARA(5) (D=0.600) Cutoff in invariant p_t for EM emission
C...PARA(6) (D=-1.00) Maximum allowed invariant p_t^2 (if >0)
C...PARA(7-9) not used
C...PARA(10)(D=1.000) Power in soft suppression (dimnsionality of
C...                  the extended source)
C...PARA(11)(D=0.600) Soft suppression parameter for code 1 or for
C...                  hadron on side 1 in PYTHIA or for the hadron
C...                  in LEPTO
C...PARA(12)(D=0.600) Soft suppression parameter for code 2 or for
C...                  hadron on side 2 in PYTHIA
C...PARA(13)(D=0.600) Soft suppression parameter for code 3
C...PARA(14)(D=1.000) Factor to multiply p_t of resolved photon or
C...                  or pomeron to get soft suppression parameter
C...PARA(15)(D=1.000) Power in soft suppression for resolved photon or
C...                  or pomeron
C...PARA(16)(D=-1.00) Mean of gaussian distributed mean intrinsic k_t
C...                  in pomeron (if less that 0 this is instead taken
C...                  from the corresponding hadron variables in LEPTO
C...                  or PYTHIA
C...PARA(17)(D=2.000) Maximum value of intrinsic k_t as given by
C...                  PARA(16)
C...PARA(18)(D=1.000) Maximum fraction of pomeron strf of total
C...PARA(19)(D=0.001) Minimum value of stucture function in denominator in
C...                  initial state g->qqbar
C...PARA(20)(D=0.000) Factor multiplying Q^2 before comparing with
C...                  momentum transfer in cutoff for DIS Matrix
C...                  elements. If < 0 W^2 is used as scale.
C...PARA(21)(D=1.000) Factor multiplying Q^2 when comparing with an
C...                  invariant p_T^2
C...PARA(22-24) not used
C...PARA(25)(D=2.000) exponent in propability for having a larger
C...                  fraction than a in extended emissions.
C...PARA(26)(D=9.000) Number of differently coloured dipoles
C...PARA(27)(D=0.600) Squared gives the mean value of primordial
C...                  k_t^2 for MSTA(37) > 0
C...PARA(28)(D=0.000) If > 0: Minimum energy for an emitted gluon.
C...                  If < 0: -Maximum energy for an emitted gluon.
C...PARA(29-30) not used
C...PARA(31)(D=25.00) Maximum invariant p_t^2 for clustering three jets
C...                  into two in ARCLUS
C...PARA(33-38) not used
C...PARA(39)(D=0.001) Tolerance factor for momentum conservation
C...PARA(40)(D=1E32)  Maximum allowed floating point number ("minimum"
C...                  is 1/PARA(40)
C...
C...Switches:
C...
C...MSTA(1) (R)       Ariadne mode (set by ARINIT) for treatment of
C...                  incomming events.
C...         0 =>      No special treatment
C...         1 =>      as if produced by JETSET
C...         2 =>      as if produced by PYTHIA
C...         3 =>      as if produced by LEPTO
C...MSTA(2) (I)       Initialization done and headers written
C-MH default is MSTA(3)=0!
C...MSTA(3) (D=1)     Setting of parameters in  Ariadne, JETSET,
C...                  PYTHIA and LEPTO to suitable values.
C...         0 =>      off
C...         1 =>      on
C...MSTA(4) (I)       Number of calls made to AREXEC
C...MSTA(5) (D=0)     Perform fragmentation at the end of AREXEC
C...         0 =>      off
C...         1 =>      on
C...                  When running with JETSET, PYTHIA or LEPTO this
C...                  switch is set to the value of the corresponding
C...                  switch in these programs.
C...MSTA(6) (D=-1)    Maximum number of emission (per string) in a
C...                  AREXEC call (if <0 - no limit) (Disabled when
C...                  used with PYTHIA.)
C...MSTA(7) (D=6)     File number for output (stdout) from Ariadne
C...                  set to MSTU(11) by ARINIT
C...MSTA(8) (D=6)     File number for error messages (stdout) from
C...                  Ariadne
C...MSTA(9) (D=1)     Debug mode
C...         0 =>      debug off
C...         1 =>      check that energy and momentum is conserved after
C...                   each call to AREXEC produce. Warns if change
C...                   in momentum is larger a factor PARA(39)
C...         2 =>      as for 1 but check every emission
C...         3 =>      as for 2 but dump string to /LUJETS/ after each
C...                   emission
C...MSTA(10)(D=5)     Maximum number of warnings (of each kind) issued
C...                  by Ariadne
C...MSTA(11)(D=0)     Phase space restrictions. The maximum p_t of an
C...                  emission is set to the p_t of the last emission
C...                  (otherwise no restrictions) for:
C...                    gluon  q-qbar  photon  emissions
C...         0 =>        yes     yes     yes
C...         1 =>        yes     yes     no
C...         2 =>        yes     no      yes
C...         3 =>        yes     no      no
C...         4 =>        no      no      no
C...MSTA(12)(D=1)     Running alpha_QCD
C...         0 =>      off
C...         1 =>      on
C...MSTA(13) (R)      Error experienced by Ariadne in last call to
C...                  AREXEC. Reset to 0 at each call to AREXEC
C...MSTA(14)(D=1)     The maximum allowed p_t is set to the minimum
C...                  invariant p_t of all gluons in an incomming
C...                  string
C...         0 =>      off
C...         1 =>      on except in PYTHIA where instead limit is set
C...                   to the p_T^2 of the hard interaction for
C...                   relevant sub processes.
C...         2 =>      on
C...MSTA(15)(D=5)     Number of flavours allowed in final state
C...                  gluon -> q-qbar emission
C...MSTA(16)(D=2)     Recoil treatment
C...         0 =>      minimize p_t1^2 + p_t3^2
C...         1 =>      as for 0 but pointlike string ends takes
C...                   all recoil
C...         2=>       as for 0 but also extended string ends which
C...                   have a>1 takes full recoil
C...MSTA(17)(D=3)     Recoil treatment for extended dipoles
C...         0 =>      no special treatment (but cf. MSTA(16))
C...         1 =>      emit recoil gluon (except if pointlike quark
C...                   in other dipole end for MSTA(16)=1)
C...         2 =>      emit recoilgluon according to new strategy
C...                   (except if pointlike quark in other dipole end
C...                   for MSTA(16)=1)
C...         3 =>      always emit recoilgluon according to new strategy
C...MSTA(18)(D=3)     P_t ordering of recoil gluons
C...         0 =>      off
C...         1 =>      on and require p_t larger than cutoff and mu
C...         2 =>      as 1 but p_t may be smaller than mu
C...         3 =>      as 2 but p_t may also be smaller than the cutoff
C...MSTA(19)(D=2)     Correct or quick treatment of emissions from
C...                  heavy quarks
C...         0 =>      quick
C...         1 =>      correct
C...         2 =>      as for 1 but also use max(p_t^2,Q^2) in argument
C...                   for alpha_S for LEPTO
C...MSTA(20)(D=0)     Final state photon radiation
C...         0 =>      off
C...         1 =>      on
C...         2 =>      on but turned off at the first occurence of
C...                   q-qbar emission in a string.
C...MSTA(21)(D=0)     Photon radiation when run with PYTHIA or LEPTO
C...         0 =>      off
C...         1 =>      on
C...MSTA(22)(D=1)     Transfer of recoils in Drell-Yan processes
C...         0 =>      off
C...         1 =>      on
C...         2 =>      on but no transfer if a > 1
C...         3 =>      on but modified phase space
C...        <0 =>      as for >0 but only transfer recoil from recoil
C...                   gluons
C...MSTA(23)(D=1)     Fix bug in matix element for q-qbar emissions
C...         0 =>      Wrong ME
C...         1 =>      correct ME
C...         2 =>      as 1 but use m_t as ordering variable for q-qbar
C...                   emissions instead of p_t.
C...MSTA(24)(D=2)     Quark masses to be used in q-qbar emissions
C...         0 =>      as specified in PMAS(1-8) in /ARDAT2/
C...         1 =>      "bare" quark masses as specified in PMAS(1-8)
C...                   in /LUDAT2/
C...         2 =>      "constituent" quark masses as specified in
C...                   PARF(101-108) in /LUDAT2/
C...MSTA(25)(D=1)     Generation procedure for exetended dipoles
C...         0 =>      Using restricted phase space
C...         1 =>      Using full phase space rejecting unphysical
C...                   emissions allowing larger fractions of a
C...                   according  to PARA(25)
C...         2 =>      as 1 but new definition of p_T for calculation
C...                   of a
C...         3 =>      as for 1
C...         4 =>      but use real p_t of gluon w.r.t. remnant.
C...         5 =>      but use real p_t of gluon w.r.t. struck quark.
C...MSTA(26) not used
C...MSTA(27)(D=0)     Normalize pomeron structure function
C...         0 =>      nope
C...         1 =>      jupp
C...MSTA(28)(D=0)     Final state g->QQbar options
C...          0        normal Dipole model p_t ordering
C...          1        require m_QQ < p_tg
C...          2        require m_QQ-2m_Q < p_tg
C...         <0        as for >0 but don't limit p_tQQ
C...MSTA(29)(D=0)     Treatment of gluon rings
C...          0        allowed
C...          1        disallowed
C...MSTA(30)(D=3)     Extendedness of remnants
C...         0 =>      Stuck quark point like, remnant extended with
C...                   PARA(11)
C...         1 =>      as 0 but remnant extended with PARA(11)/(1-x)
C...         2 =>      as 1 but struck quark extended with Q
C...         3 =>      as 2 but emitted quark in initial state g->qqbar
C...                   not extended.
C...MSTA(31)(D=1)     mass of extended partons
C...         0 =>      set to zero for backward compatibility
C...         1 =>      keeps value given
C...MSTA(32)(D=1)     Treatment of DIS matrix element for BGF, and inclusion
C...                  of initial state g->qqbar in cascade
C...         0 =>      use old (wrong) treatment of BGF matrix elements
C...                   events
C...         1 =>      Let Lepto only generate Electro-weak vertex.
C...                   Generate BGF with sudakov in Ariadne and perform
C...                   this if it has higher p_t^2 than the first gluon
C...                   emission
C...         2 =>      Include initial state g->qqbar in cascade and correct
C...                   first emission for matrix elements if MSTA(33)!=0
C...MSTA(33)(D=1)     Treatment of DIS matrix element for QCM
C...
C...
C...         0 =>      approximated in cascade with the dipole formula
C...                   (Also only leading log BGF)
C...         1 =>      cascade corrected in first gluon emission
C...MSTA(34)(D=2)     Include Pomeron remnants
C...         -1 =>      included using external structure functions as
C...                   supplied in subroutine ARUPOM
C...         0 =>      not included
C...         1 =>      included using built in structure functions as
C...                   defined in /ARPOPA/ with zfq(z) = cf z^xa(1-z)^nb
C...                   and fp(x) ~ x^(-ppow/2)
C...         2 =>      as for 1 but zfq(z) = cf z(1-z) and
C...                   fp(x) ~ (1-x)^3/x
C...         3 =>      as for 1 but zfq(z) = cf z(1-z) and
C...                   fp(x) ~ (1-x)^5/x
C...
C...MSTA(35)(D=0)     Colour rearrangement of dipoles in the cascade
C...                    -1 => Allow rearrangement after the cascade
C...                     0 => off
C...                     1 => Allow rearrangement within each initial
C...                          string separately
C...                     2 => As 1 but allow global rearrangements
C...                          e.g. below gluon energies of PARA(28)
C...                     3 => Allow global rearrangements from start
C...MSTA(36)(D=2)     Extension of remnant overides other switches
C...                      0 => PARA(11/12) or as defined by other switches
C...                      1 => PARA(11/12)/(1-z)
C...
C...
C...                      2 => intrinsic p_t*PARA(14)
C...                      3 => intrinsic p_t*PARA(14)/(1-x)
C...                      4 => intrinsic p_t*PARA(14)/((1-x)(1-z))
C...MSTA(37)(D=1)     Handeling of primordial k_t of proton
C...                      0 => As in program initialized for
C...                      1 => Gaussian with <k_T^2> = PARA(27)^2
C...                      2 => Exponential with <k_T^2> = PARA(27)^2
C...End of description

      REAL XPARA(40),XPHAR(400),XPQMAS(10)
      REAL XCA(3),XPB(3),XCF(0:6),XXA(0:6)
      INTEGER IMSTA(40),IMHAR(400),IIWRN(40),INB(0:6)

      DATA XPARA/0.22,0.2,0.6,0.007297353,0.6,-1.0,0.0,0.0,0.0,1.0,
     $           0.6,0.6,0.6,1.0,1.0,-1.0,2.0,1.0,0.001,0.0,
     $           1.0,0.0,2*0.0,2.0,9.0,0.6,3*0.0,
     $           25.0,7*0.0,0.001,1.0E32/
      DATA IMSTA/0,0,1,0,0,-1,6,6,1,5,
     $           0,1,0,1,5,2,3,3,2,0,
     $           0,1,1,2,1,0,0,2*0,3,
     $           1,1,1,2,0,2,1,3*0/
      DATA XPHAR/100*0.0,
     $           -1.0,-1.0,1.0,1.0,0.0,0.0,-1.0,0.0,9.0,91*0.0,
     $           100*0.0,
     $           100*0.0/
      DATA IMHAR/100*0,
     $           2,2,1,0,0,0,0,0,0,0,1,-1,1,0,0,0,0,0,0,1,7*0,1,0,1,
     $           1,1,9,1,66*0,
     $           100*0,
     $           100*0/
      DATA XPQMAS/10*0.0/
      DATA IIWRN/40*0/
      DATA XTOTSIG/2.3/
      DATA XPPOW/2.0/
      DATA XCA/6.38,0.424,0.0/
      DATA XPB/8.0,3.0,0.0/
      DATA (XCF(I),I=0,6)/0.0,1.0,1.0,0.0,0.0,0.0,0.0/
      DATA (XXA(I),I=0,6)/7*1.0/
      DATA (INB(I),I=0,6)/7*1/

      CALL UCOPY( XPARA, PARA, 40 )
      CALL UCOPY( IMSTA, MSTA, 40 )

      CALL UCOPY( XPHAR, PHAR, 400 )
      CALL UCOPY( IMHAR, MHAR, 400 )

      CALL UCOPY( XPQMAS, PQMAS, 10 )
      CALL UCOPY( IIWRN, IWRN, 40 )

      TOTSIG = XTOTSIG
      PPOW = XPPOW

      CALL UCOPY( XCA, CA, 3 )
      CALL UCOPY( XPB, PB, 3 )

      CALL UCOPY( XCF, CF, 7 )
      CALL UCOPY( XXA, XA, 7 )
      CALL UCOPY( INB, NB, 7 )

C-MH
      CH1TUN = 'EMC '

      MSTA(3) = 0

      RETURN
      END
