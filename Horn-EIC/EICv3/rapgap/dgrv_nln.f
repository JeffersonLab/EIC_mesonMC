
*CMZ :  2.08/04 17/01/2000  13.18.52  by  Hannes Jung
*CMZ :  2.06/31 25/03/98  16.03.43  by  Hannes Jung
*CMZ :  2.06/28 11/02/98  02.31.42  by  Hannes Jung
*-- Author :
      function dgrv_nln(dx,dq)

      implicit none
      double precision dx,dq
      REAL   dgrv_nln,x,q
      REAL s1,s2,s3,s4,s5,s6,s7,s8,s9,s10
      REAL s11,s12,s13,s14
      integer itest
      data itest/1/
      x = real(dx)
      q = real(dq)
      dgrv_nln = 0.e0
	if(q.lt.0.35) return
      if(itest.eq.0) then
         dgrv_nln = 0.e0
      else
         s2 = 0.83e0*(1-x)**(0.3404e1+0.83e0*log(0.5848488801e0*
     +   log(0.162591051e2*q)))/q
         s3 = 1/log(0.162591051e2*q)*log(1-x)*(x**(0.1724e1+0.157e0*
     +   log(0.5848488801e0*log(0.162591051e2*q)))*(0.7517e1-
     +   0.2547e1*log(0.5848488801e0*log(0.162591051e2*q))+(0.3409e2-
     +   0.5221e2*sqrt(log(0.5848488801e0*log(0.162591051e2*q)))+
     +   0.1747e2*log(0.5848488801e0*log(0.162591051e2*q)))*x+
     +   (0.4039e1+0.1491e1*log(0.5848488801e0*log(0.162591051e2*q)))
     +   *x**2)*log(1/x)**(0.8e0+0.1016e1*log(0.5848488801e0*
     +   log(0.162591051e2*q)))+log(0.5848488801e0*
     +   log(0.162591051e2*q))**0.1014e1*exp(0.1112e1-0.3438e1*
     +   log(0.5848488801e0*log(0.162591051e2*q))+0.302e0*
     +   log(0.5848488801e0*log(0.162591051e2*q))**2+sqrt((0.3256e1-
     +   0.436e0*log(0.5848488801e0*log(0.162591051e2*q)))*
     +   log(0.5848488801e0*log(0.162591051e2*q))**0.1738e1*log(1/x)
     +   )))
         s1 = s2*s3
         s3 = (1-x)**(0.3404e1+0.83e0*log(0.5848488801e0*
     +   log(0.162591051e2*q)))
         s6 = 0.157e0*x**(0.1724e1+0.157e0*log(0.5848488801e0*
     +   log(0.162591051e2*q)))/q/log(0.162591051e2*q)*log(x)*
     +   (0.7517e1-0.2547e1*log(0.5848488801e0*log(0.162591051e2*q))+
     +   (0.3409e2-0.5221e2*sqrt(log(0.5848488801e0*
     +   log(0.162591051e2*q)))+0.1747e2*log(0.5848488801e0*
     +   log(0.162591051e2*q)))*x+(0.4039e1+0.1491e1*
     +   log(0.5848488801e0*log(0.162591051e2*q)))*x**2)*log(1/x)**
     +   (0.8e0+0.1016e1*log(0.5848488801e0*log(0.162591051e2*q)))
         s7 = x**(0.1724e1+0.157e0*log(0.5848488801e0*
     +   log(0.162591051e2*q)))*(-0.2547e1/q/log(0.162591051e2*q)+(-
     +   0.26105e2/sqrt(log(0.5848488801e0*log(0.162591051e2*q)))/q/
     +   log(0.162591051e2*q)+0.1747e2/q/log(0.162591051e2*q))*x+
     +   0.1491e1/q/log(0.162591051e2*q)*x**2)*log(1/x)**(0.8e0+
     +   0.1016e1*log(0.5848488801e0*log(0.162591051e2*q)))
         s5 = s6+s7
         s6 = s5+0.1016e1*x**(0.1724e1+0.157e0*log(0.5848488801e0*
     +   log(0.162591051e2*q)))*(0.7517e1-0.2547e1*
     +   log(0.5848488801e0*log(0.162591051e2*q))+(0.3409e2-0.5221e2*
     +   sqrt(log(0.5848488801e0*log(0.162591051e2*q)))+0.1747e2*
     +   log(0.5848488801e0*log(0.162591051e2*q)))*x+(0.4039e1+
     +   0.1491e1*log(0.5848488801e0*log(0.162591051e2*q)))*x**2)*
     +   log(1/x)**(0.8e0+0.1016e1*log(0.5848488801e0*
     +   log(0.162591051e2*q)))/q/log(0.162591051e2*q)*log(log(1/x)
     +   )
         s7 = s6
         s9 = 0.1014e1*log(0.5848488801e0*log(0.162591051e2*q))**
     +   0.14e-1*exp(0.1112e1-0.3438e1*log(0.5848488801e0*
     +   log(0.162591051e2*q))+0.302e0*log(0.5848488801e0*
     +   log(0.162591051e2*q))**2+sqrt((0.3256e1-0.436e0*
     +   log(0.5848488801e0*log(0.162591051e2*q)))*
     +   log(0.5848488801e0*log(0.162591051e2*q))**0.1738e1*log(1/x)
     +   ))/q/log(0.162591051e2*q)
         s11 = log(0.5848488801e0*log(0.162591051e2*q))**0.1014e1
         s13 = -0.3438e1/q/log(0.162591051e2*q)+0.604e0*
     +   log(0.5848488801e0*log(0.162591051e2*q))/q/
     +   log(0.162591051e2*q)+1/sqrt((0.3256e1-0.436e0*
     +   log(0.5848488801e0*log(0.162591051e2*q)))*
     +   log(0.5848488801e0*log(0.162591051e2*q))**0.1738e1*log(1/x)
     +   )*(-0.436e0/q/log(0.162591051e2*q)*log(0.5848488801e0*
     +   log(0.162591051e2*q))**0.1738e1*log(1/x)+0.1738e1*(0.3256e1-
     +   0.436e0*log(0.5848488801e0*log(0.162591051e2*q)))*
     +   log(0.5848488801e0*log(0.162591051e2*q))**0.738e0*log(1/x)/
     +   q/log(0.162591051e2*q))/2
         s14 = exp(0.1112e1-0.3438e1*log(0.5848488801e0*
     +   log(0.162591051e2*q))+0.302e0*log(0.5848488801e0*
     +   log(0.162591051e2*q))**2+sqrt((0.3256e1-0.436e0*
     +   log(0.5848488801e0*log(0.162591051e2*q)))*
     +   log(0.5848488801e0*log(0.162591051e2*q))**0.1738e1*log(1/x)
     +   ))
         s12 = s13*s14
         s10 = s11*s12
         s8 = s9+s10
         s4 = s7+s8
         s2 = s3*s4
         dgrv_nln = ((s1+s2))
	
      endif
      return
      end
