#! /usr/bin/python

#
# Description:
# ================================================================
# Time-stamp: "2021-10-06 03:42:19 trottar"
# ================================================================
#
# Author:  Richard L. Trotta III <trotta@cua.edu>
#
# Copyright (c) trottar
#

import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import matplotlib.colors as colors
from matplotlib.ticker import MaxNLocator
from scipy.interpolate import griddata

import sys
from sys import path
sys.path.insert(1,'./src/process/cuts/') # Note: this is relative to the bash script NOT this python script!
import cuts as c

kinematics = sys.argv[1]

xbinwidth = float(sys.argv[2])
qbinwidth = float(sys.argv[3])
tbinwidth = float(sys.argv[4])
xLbinwidth = float(sys.argv[5])

#xlmin,xlmax = 0.8000,0.8100
#xlmin,xlmax = 0.8400,0.8500
xlmin,xlmax = 0,0

df = pd.read_csv(r'./src/process/datafiles/x{0:0.3f}q{1:0.1f}t{2:0.3f}xL{3:0.3f}_{4}.csv'.format(xbinwidth,qbinwidth,tbinwidth,xLbinwidth,kinematics)) # xL bin, no t bin
print(df)

xbj = df['TDIS_xbj']
Q2 = df['TDIS_Q2']
#fpi = df['fpi']
t = df['TDIS_t']
xL = df['xL']
y = df['TDIS_y']
sigma_tdis = df['sigma_tdis']
f2N = df['f2N']
xpi = df['xpi']
xpi2 = xbj/(1.-xL)
ypi = df['ypi']
tpi = df['tpi']
lumi = df['tot_int_lumi']

def densityPlot(x,y,title,xlabel,ylabel,binx,biny,
                    xmin=None,xmax=None,ymin=None,ymax=None,cuts=None,fig=None,ax=None,layered=True):

    if ax or fig:
        print("")
    else:
        fig, ax = plt.subplots(tight_layout=True,figsize=(11.69,8.27))

    # norm=colors.LogNorm() makes colorbar normed and logarithmic
    hist = ax.hist2d(x, y,bins=(binx,biny),norm=colors.LogNorm())
    if layered is True :
        plt.colorbar(hist[3], ax=ax, spacing='proportional', label='Number of Events')

    plt.title(title)
    plt.xlabel(xlabel)
    plt.ylabel(ylabel)
        
    return fig

# Create cut dictionary
cutDict = {}

qbinarray = [7.0,15.0,30.0,60.0,120.0,240.0,480.0,1000.0]
#qbinarray = np.arange(qbinwidth/2,1000.,qbinwidth).tolist()
for i,q in enumerate(qbinarray) :
    qtmp = '{"Q2cut%i" : ((%0.1f <= Q2) & (Q2 <= %0.1f))}' % (i,qbinarray[i]-qbinwidth/2,qbinarray[i]+qbinwidth/2)
    print('{"Q2cut%i" : ((%0.1f <= Q2) & (Q2 <= %0.1f))}' % (i,qbinarray[i]-qbinwidth/2,qbinarray[i]+qbinwidth/2))
    cutDict.update(eval(qtmp))

xarray = np.arange(xbinwidth/2,1.0,xbinwidth).tolist()
for i,x in enumerate(xarray):
    xtmp = '{"xcut%i" : ((%0.4f <= xbj) & (xbj <= %0.4f))}' % (i,xarray[i]-xbinwidth/2,xarray[i]+xbinwidth/2)
    #print('{"xcut%i" : ((%0.4f <= xbj) & (xbj <= %0.4f))}' % (i,xarray[i]-xbinwidth/2,xarray[i]+xbinwidth/2))
    cutDict.update(eval(xtmp))

tarray = np.arange(tbinwidth/2,1.0,tbinwidth).tolist()
for i,tval in enumerate(tarray):
    ttmp = '{"tcut%i" : ((-%0.4f >= t) & (t >= -%0.4f))}' % (i,tarray[i]-tbinwidth/2,tarray[i]+tbinwidth/2)
    print('{"tcut%i" : ((-%0.4f >= t) & (t >= -%0.4f))}' % (i,tarray[i]-tbinwidth/2,tarray[i]+tbinwidth/2))
    cutDict.update(eval(ttmp))

xLarray = np.arange(xLbinwidth/2,1.0,xLbinwidth).tolist()
for i,x in enumerate(xLarray):
    xLtmp = '{"xLcut%i" : ((%0.4f <= xL) & (xL <= %0.4f))}' % (i,xLarray[i]-xLbinwidth/2,xLarray[i]+xLbinwidth/2)
    print('{"xLcut%i" : ((%0.4f <= xL) & (xL <= %0.4f))}' % (i,xLarray[i]-xLbinwidth/2,xLarray[i]+xLbinwidth/2))
    cutDict.update(eval(xLtmp)) 
    
ytmp = '{"ycut" : ((0.01 <= y) & (y <= 0.95))}'
cutDict.update(eval(ytmp))
cut = c.pyPlot(cutDict)    

ycut1 = ["ycut"]

if xlmin == 0.8400 or xlmax == 0.8500:
    cut7 = ["Q2cut0","xLcut85","ycut"]
    cut15 = ["Q2cut1","xLcut85","ycut"]
    cut30 = ["Q2cut2","xLcut85","ycut"]
    cut60 = ["Q2cut3","xLcut85","ycut"]
    cut120 = ["Q2cut4","xLcut85","ycut"]
    cut240 = ["Q2cut5","xLcut85","ycut"]
    cut480 = ["Q2cut6","xLcut85","ycut"]
    cut1000 = ["Q2cut7","xLcut85","ycut"]
elif xlmin == 0.8000 or xlmax == 0.8100:
    cut7 = ["Q2cut0","xLcut80","ycut"]
    cut15 = ["Q2cut1","xLcut80","ycut"]
    cut30 = ["Q2cut2","xLcut80","ycut"]
    cut60 = ["Q2cut3","xLcut80","ycut"]
    cut120 = ["Q2cut4","xLcut80","ycut"]
    cut240 = ["Q2cut5","xLcut80","ycut"]
    cut480 = ["Q2cut6","xLcut80","ycut"]
    cut1000 = ["Q2cut7","xLcut80","ycut"]
else:
    cut7 = ["Q2cut0","ycut","tcut6"]
    cut15 = ["Q2cut1","ycut","tcut6"]
    cut30 = ["Q2cut2","ycut","tcut6"]
    cut60 = ["Q2cut3","ycut","tcut6"]
    cut120 = ["Q2cut4","ycut","tcut6"]
    cut240 = ["Q2cut5","ycut","tcut6"]
    cut480 = ["Q2cut6","ycut","tcut6"]
    cut1000 = ["Q2cut7","ycut","tcut6"]

def F2pi(xpi, Q2):
    points,values=np.load('./analysis/interpGrids/xpiQ2.npy'),np.load('./analysis/interpGrids/F2pi.npy')
    F2pi=lambda xpi,Q2: griddata(points,values,(np.log10(xpi),np.log10(Q2)))
    return F2pi(xpi,Q2)

# Calculate cross-section using Patrick's interpolate grid
def ds_dxdQ2dxLdt(x, xL,t):
    points60,values60=np.load('./analysis/xsec/pointsxsec60.npy'),np.load('./analysis/xsec/valuesxsec60.npy')
    points120,values120=np.load('./analysis/xsec/pointsxsec120.npy'),np.load('./analysis/xsec/valuesxsec120.npy')
    points240,values240=np.load('./analysis/xsec/pointsxsec240.npy'),np.load('./analysis/xsec/valuesxsec240.npy')
    points480,values480=np.load('./analysis/xsec/pointsxsec480.npy'),np.load('./analysis/xsec/valuesxsec480.npy')
    sigma60=lambda x,xL,t: griddata(points60,values60,(x,xL,t))
    sigma120=lambda x,xL,t: griddata(points120,values120,(x,xL,t))
    sigma240=lambda x,xL,t: griddata(points240,values240,(x,xL,t))
    sigma480=lambda x,xL,t: griddata(points480,values480,(x,xL,t))

    return [sigma60(x,xL,t),sigma120(x,xL,t),sigma240(x,xL,t),sigma480(x,xL,t)]

fpi = F2pi(xpi, Q2)
dsigma = ds_dxdQ2dxLdt(xpi, xL,t)

def dsigma_Plot():
    
    f = plt.figure(figsize=(11.69,8.27))
    plt.rcParams.update({'font.size': 15})
    plt.style.use('classic')

    ax = f.add_subplot(221)
    xpiscat4 = ax.errorbar(xpi,dsigma[0],yerr=np.sqrt(lumi)/lumi,fmt='.',label='$Q^2$=60 $GeV^2$',ecolor='cyan',capsize=2, capthick=2)
    plt.xscale('log')
    #plt.ylim(0.,0.3)
    plt.xlim(1e-2,1.)
    ax.text(0.25, 0.65, '$Q^2$=60 $GeV^2$', transform=ax.transAxes, fontsize=15, verticalalignment='top', horizontalalignment='left')
    ax.yaxis.set_major_locator(MaxNLocator(prune='both'))
    ax.xaxis.set_major_formatter(plt.NullFormatter())
    #ax.set_yticks([0.0,0.1,0.2,0.3])
    ax.set_xticks([1.,1e-1])
    
    plt.title("{0} $\leq$ xL $\leq$ {1}".format(xlmin,xlmax))
    plt.ylabel(r'$\frac{d\sigma}{dxdQ^2dx_Ldt}$', fontsize=20)
    
    ax = f.add_subplot(222)
    xpiscat5 = ax.errorbar(cut.applyCuts(xpi,cut120),cut.applyCuts(dsigma[1],cut120),yerr=np.sqrt(cut.applyCuts(lumi,cut120))/cut.applyCuts(lumi,cut120),fmt='.',label='$Q^2$=120 $GeV^2$',ecolor='cyan',capsize=2, capthick=2)
    plt.xscale('log')
    #plt.ylim(0.,0.3)
    plt.xlim(1e-2,1.)
    ax.text(0.25, 0.65, '$Q^2$=120 $GeV^2$', transform=ax.transAxes, fontsize=15, verticalalignment='top', horizontalalignment='left')
    ax.yaxis.set_major_formatter(plt.NullFormatter())
    ax.xaxis.set_major_formatter(plt.NullFormatter())
    #ax.set_yticks([0.1,0.2,0.3])
    ax.set_xticks([1.,1e-1])
    
    ax = f.add_subplot(223)
    xpiscat6 = ax.errorbar(cut.applyCuts(xpi,cut240),cut.applyCuts(dsigma[2],cut240),yerr=np.sqrt(cut.applyCuts(lumi,cut240))/cut.applyCuts(lumi,cut240),fmt='.',label='$Q^2$=240 $GeV^2$',ecolor='cyan',capsize=2, capthick=2)
    plt.xscale('log')
    #plt.ylim(0.,0.3)
    plt.xlim(1e-2,1.)
    ax.text(0.25, 0.65, '$Q^2$=240 $GeV^2$', transform=ax.transAxes, fontsize=15, verticalalignment='top', horizontalalignment='left')
    ax.yaxis.set_major_locator(MaxNLocator(prune='both'))
    #ax.set_yticks([0.0,0.1,0.2,0.3])
    ax.set_xticks([1e-2,1.,1e-1])

    ax = f.add_subplot(224)
    xpiscat7 = ax.errorbar(cut.applyCuts(xpi,cut480),cut.applyCuts(dsigma[3],cut480),yerr=np.sqrt(cut.applyCuts(lumi,cut480))/cut.applyCuts(lumi,cut480),fmt='.',label='$Q^2$=480 $GeV^2$',ecolor='cyan',capsize=2, capthick=2)
    plt.xscale('log')
    #plt.ylim(0.,0.3)
    plt.xlim(1e-2,1.)
    ax.text(0.25, 0.65, '$Q^2$=480 $GeV^2$', transform=ax.transAxes, fontsize=15, verticalalignment='top', horizontalalignment='left')
    ax.yaxis.set_major_formatter(plt.NullFormatter())
    #ax.set_yticks([0.0,0.1,0.2,0.3])
    ax.set_xticks([1.,1e-1])

    plt.xlabel('$x_\pi$', fontsize=20)    
    plt.tight_layout()
    plt.subplots_adjust(hspace=0.0,wspace=0.0)

    plt.style.use('default')


def fpivxpi_Plot():
    
    f = plt.figure(figsize=(11.69,8.27))
    plt.rcParams.update({'font.size': 15})
    plt.style.use('classic')
    
    ax = f.add_subplot(221)
    xpiscat4 = ax.errorbar(cut.applyCuts(xpi,cut60),cut.applyCuts(fpi,cut60),yerr=np.sqrt(cut.applyCuts(lumi,cut60))/cut.applyCuts(lumi,cut60),fmt='.',label='$Q^2$=60 $GeV^2$',ecolor='cyan',capsize=2, capthick=2)
    plt.plot([0.001,0.01,0.1],[1.2,0.45,0.25], label="GRV fit",color="y")
    plt.xscale('log')
    plt.ylim(0.,0.3)
    plt.xlim(1e-2,1.)
    ax.text(0.25, 0.65, '$Q^2$=60 $GeV^2$', transform=ax.transAxes, fontsize=15, verticalalignment='top', horizontalalignment='left')
    ax.yaxis.set_major_locator(MaxNLocator(prune='both'))
    ax.xaxis.set_major_formatter(plt.NullFormatter())
    ax.set_yticks([0.0,0.1,0.2,0.3])
    ax.set_xticks([1.,1e-1])
    
    plt.title("{0} $\leq$ xL $\leq$ {1}".format(xlmin,xlmax))
    plt.ylabel('$F^{\pi}_{2}$', fontsize=20)
    
    ax = f.add_subplot(222)
    xpiscat5 = ax.errorbar(cut.applyCuts(xpi,cut120),cut.applyCuts(fpi,cut120),yerr=np.sqrt(cut.applyCuts(lumi,cut120))/cut.applyCuts(lumi,cut120),fmt='.',label='$Q^2$=120 $GeV^2$',ecolor='cyan',capsize=2, capthick=2)
    plt.plot([0.01,0.1,0.3],[0.5,0.25,0.15], label="GRV fit",color="y")
    plt.xscale('log')
    plt.ylim(0.,0.3)
    plt.xlim(1e-2,1.)
    ax.text(0.25, 0.65, '$Q^2$=120 $GeV^2$', transform=ax.transAxes, fontsize=15, verticalalignment='top', horizontalalignment='left')
    ax.yaxis.set_major_formatter(plt.NullFormatter())
    ax.xaxis.set_major_formatter(plt.NullFormatter())
    ax.set_yticks([0.1,0.2,0.3])
    ax.set_xticks([1.,1e-1])
    
    ax = f.add_subplot(223)
    xpiscat6 = ax.errorbar(cut.applyCuts(xpi,cut240),cut.applyCuts(fpi,cut240),yerr=np.sqrt(cut.applyCuts(lumi,cut240))/cut.applyCuts(lumi,cut240),fmt='.',label='$Q^2$=240 $GeV^2$',ecolor='cyan',capsize=2, capthick=2)
    plt.plot([0.01,0.1,0.3],[0.55,0.25,0.15], label="GRV fit",color="y")
    plt.xscale('log')
    plt.ylim(0.,0.3)
    plt.xlim(1e-2,1.)
    ax.text(0.25, 0.65, '$Q^2$=240 $GeV^2$', transform=ax.transAxes, fontsize=15, verticalalignment='top', horizontalalignment='left')
    ax.yaxis.set_major_locator(MaxNLocator(prune='both'))
    ax.set_yticks([0.0,0.1,0.2,0.3])
    ax.set_xticks([1e-2,1.,1e-1])

    ax = f.add_subplot(224)
    xpiscat7 = ax.errorbar(cut.applyCuts(xpi,cut480),cut.applyCuts(fpi,cut480),yerr=np.sqrt(cut.applyCuts(lumi,cut480))/cut.applyCuts(lumi,cut480),fmt='.',label='$Q^2$=480 $GeV^2$',ecolor='cyan',capsize=2, capthick=2)
    plt.plot([0.01,0.1,0.3],[0.55,0.25,0.15], label="GRV fit",color="y")
    plt.xscale('log')
    plt.ylim(0.,0.3)
    plt.xlim(1e-2,1.)
    ax.text(0.25, 0.65, '$Q^2$=480 $GeV^2$', transform=ax.transAxes, fontsize=15, verticalalignment='top', horizontalalignment='left')
    ax.yaxis.set_major_formatter(plt.NullFormatter())
    ax.set_yticks([0.0,0.1,0.2,0.3])
    ax.set_xticks([1.,1e-1])

    plt.xlabel('$x_\pi$', fontsize=20)    
    plt.tight_layout()
    plt.subplots_adjust(hspace=0.0,wspace=0.0)

    plt.style.use('default')

def phaseSpace_Plots():

    fig = plt.figure(figsize=(17,12),facecolor='silver')

    ax = fig.add_subplot(331)
    plt.scatter(cut.applyCuts(t,cut60),cut.applyCuts(fpi,cut60))
    #densityPlot(t,fpi, '','$t$','$fpi$', 200, 200, ax=ax, fig=fig)

    ax = fig.add_subplot(332)
    #densityPlot(xbj,fpi, '','$x$','$fpi$', 200, 200, ax=ax, fig=fig)

    ax = fig.add_subplot(333)
    denplt = densityPlot(xbj,xL, '','$x$','$xL$', 200, 200, ax=ax, fig=fig)

    ax = fig.add_subplot(334)
    densityPlot(xbj,t, '','$x$','$t$', 200, 200, ax=ax, fig=fig)

    ax = fig.add_subplot(335)
    densityPlot(xL,t, '','$xL$','$t$', 200, 200, ax=ax, fig=fig)

    ax = fig.add_subplot(336)
    densityPlot(xbj,Q2, '','$x$','$Q^{2}$', 200, 200, ax=ax, fig=fig)

    ax = fig.add_subplot(337)
    densityPlot(cut.applyCuts(xbj,cut60),cut.applyCuts(t,cut60), '','$x$','t', 200, 200, ax=ax, fig=fig)

    ax = fig.add_subplot(338)
    plt.scatter([np.average(cut.applyCuts(xbj,cut60))],[np.average(cut.applyCuts(xL,cut60))],label='$Q^2$=60 $GeV^2$')
    plt.scatter([np.average(cut.applyCuts(xbj,cut120))],[np.average(cut.applyCuts(xL,cut120))],label='$Q^2$=120 $GeV^2$')
    plt.scatter([np.average(cut.applyCuts(xbj,cut240))],[np.average(cut.applyCuts(xL,cut240))],label='$Q^2$=240 $GeV^2$')
    plt.scatter([np.average(cut.applyCuts(xbj,cut480))],[np.average(cut.applyCuts(xL,cut480))],label='$Q^2$=480 $GeV^2$')
    plt.legend()
    plt.xlabel('x')
    plt.ylabel('xL')
    #plt.title("x = {0:0.3f}, xL = {1:0.3f}".format(np.average(cut.applyCuts(xbj,cut60)),np.average(cut.applyCuts(xL,cut60))))
    #print("~~~~",np.average(cut.applyCuts(xbj,cut60)),np.average(cut.applyCuts(xL,cut60)))

    ax = fig.add_subplot(339)

    plt.tight_layout()

def TheoryTable():

    def dict2df(inp_d):
        out_t = pd.DataFrame(inp_d, columns=inp_d.keys())
        out_t = out_t.reindex(sorted(out_t.columns), axis=1)
        return out_t

    cut7Dict = {

        "Q2-7" : cut.applyCuts(Q2,cut7),
        "xbj-7" : cut.applyCuts(xbj,cut7),
        "xpi-7" : cut.applyCuts(xpi,cut7),
        "xL-7" : cut.applyCuts(xL,cut7),
        "y-7" : cut.applyCuts(y,cut7),
        "lumi-7" : cut.applyCuts(lumi,cut7),
    }

    cut7Table = dict2df(cut7Dict)
    
    cut15Dict = {

        "Q2-15" : cut.applyCuts(Q2,cut15),
        "xbj-15" : cut.applyCuts(xbj,cut15),
        "xpi-15" : cut.applyCuts(xpi,cut15),
        "xL-15" : cut.applyCuts(xL,cut15),
        "y-15" : cut.applyCuts(y,cut15),
        "lumi-15" : cut.applyCuts(lumi,cut15),
    }

    cut15Table = dict2df(cut15Dict)
    
    cut30Dict = {

        "Q2-30" : cut.applyCuts(Q2,cut30),
        "xbj-30" : cut.applyCuts(xbj,cut30),
        "xpi-30" : cut.applyCuts(xpi,cut30),
        "xL-30" : cut.applyCuts(xL,cut30),
        "y-30" : cut.applyCuts(y,cut30),
        "lumi-30" : cut.applyCuts(lumi,cut30),
    }

    cut30Table = dict2df(cut30Dict)
    
    cut60Dict = {

        "Q2-60" : cut.applyCuts(Q2,cut60),
        "xbj-60" : cut.applyCuts(xbj,cut60),
        "xpi-60" : cut.applyCuts(xpi,cut60),
        "xL-60" : cut.applyCuts(xL,cut60),
        "y-60" : cut.applyCuts(y,cut60),
        "lumi-60" : cut.applyCuts(lumi,cut60),
    }

    cut60Table = dict2df(cut60Dict)

    cut120Dict = {

        "Q2-120" : cut.applyCuts(Q2,cut120),
        "xbj-120" : cut.applyCuts(xbj,cut120),
        "xpi-120" : cut.applyCuts(xpi,cut120),
        "xL-120" : cut.applyCuts(xL,cut120),
        "y-120" : cut.applyCuts(y,cut120),
        "lumi-120" : cut.applyCuts(lumi,cut120),
    }

    cut120Table = dict2df(cut120Dict)

    cut240Dict = {

        "Q2-240" : cut.applyCuts(Q2,cut240),
        "xbj-240" : cut.applyCuts(xbj,cut240),
        "xpi-240" : cut.applyCuts(xpi,cut240),
        "xL-240" : cut.applyCuts(xL,cut240),
        "y-240" : cut.applyCuts(y,cut240),
        "lumi-240" : cut.applyCuts(lumi,cut240),
    }

    cut240Table = dict2df(cut240Dict)

    cut480Dict = {

        "Q2-480" : cut.applyCuts(Q2,cut480),
        "xbj-480" : cut.applyCuts(xbj,cut480),
        "xpi-480" : cut.applyCuts(xpi,cut480),
        "xL-480" : cut.applyCuts(xL,cut480),
        "y-480" : cut.applyCuts(y,cut480),
        "lumi-480" : cut.applyCuts(lumi,cut480),
    }

    cut480Table = dict2df(cut480Dict)

    cut1000Dict = {

        "Q2-1000" : cut.applyCuts(Q2,cut1000),
        "xbj-1000" : cut.applyCuts(xbj,cut1000),
        "xpi-1000" : cut.applyCuts(xpi,cut1000),
        "xL-1000" : cut.applyCuts(xL,cut1000),
        "y-1000" : cut.applyCuts(y,cut1000),
        "lumi-1000" : cut.applyCuts(lumi,cut1000),
    }

    cut1000Table = dict2df(cut1000Dict)
    
    # Merge pandas df
    dataDict = {}
    for d in (cut7Table,cut15Table,cut30Table,cut60Table,cut120Table,cut240Table,cut480Table,cut1000Table):
        dataDict.update(d)
    data ={i : dataDict[i] for i in sorted(dataDict.keys())}

    theory_table = dict2df(dataDict).sort_values(['Q2-7','Q2-15','Q2-30','Q2-60','Q2-120','Q2-240','Q2-480','Q2-1000'])
    print("Table created...\n",theory_table)

    return theory_table
    
def main() :
    
    dsigma_Plot()
    fpivxpi_Plot()
    phaseSpace_Plots()
    plt.show()

    out_f = "OUTPUTS/theory_table.csv"
    theory_table = TheoryTable()
    theory_table.to_csv(out_f, index=False, header=True, mode='w+')
    
    
if __name__=='__main__': main()
