#include <ctime>

void batch()
{
    gROOT->ProcessLine(".L TDISMC_EIC.cpp+");
    // gROOT->ProcessLine("mainx(0.00001,1.,1.0,10000.0,time(0))");
    // low,med,high
    // gROOT->ProcessLine("mainx(0.001,0.008,1.0,8.0,time(0))");
    // gROOT->ProcessLine("mainx(0.01,0.08,10.0,80.0,time(0))");
    // gROOT->ProcessLine("mainx(0.1,0.8,100.0,800.0,time(0))");
    // Full range, run for 125k
    // gROOT->ProcessLine("mainx(0.1,800,1.0,800.0,time(0))");
    // Two settings, for paper
    gROOT->ProcessLine("mainx(0.01,1.00,10.0,100.0,time(0))");
    // gROOT->ProcessLine("mainx(0.1,1.0,100.0,800.0,time(0))");
    // gROOT->ProcessLine("mainx(0.01,0.1,10.0,100.0,time(0))");
}
