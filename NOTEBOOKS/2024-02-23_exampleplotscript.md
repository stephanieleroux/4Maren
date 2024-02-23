## example plot script:

```
logo=True
showplt=True

for it in range(0,NT):
    
    # name of plot to output
    namo=prefix+exp+"_"+freq+"_SIC_"+li.Fstrmb(it)    

    # name of experiment as to appear on plot
    titleplt=texp
   
    # text label near colorbar
    tlabel="SI concentration"
    
    
    
    
    # set data to plot (field 1 and field 2)
    data2plot = SIdat.siconc.isel(time_counter=it).where(mask!=0)
    icedat = SIdat.siconc.isel(time_counter=it).where(mask!=0)
    
    # data to plot 
    tdate=SIdat.siconc.time_counter.to_index()[it]
    
    # color map field 1
    cmap = cmocean.cm.ice
    cmap.set_bad('r',1.)
    cmap.set_under('k')
    cmap.set_over('w')
    norm = mcolors.PowerNorm(gamma=4.5,vmin=0.15, vmax=0.99)


    # main plot
    fig1,(ax) = plt.subplots(1, 1, figsize=[13, 12],facecolor='w')

    cs,ax = li.FplotmapSI_gp(fig1,ax,data2plot,cmap,norm,plto='tmp_plot',gridpts=True,gridptsgrid=True,gridinc=100,gstyle='darkstyle')
    cs2   = ax.contour(icedat,alpha=0.9,colors='r',linestyles="-",linewidths=2,levels=np.arange(0.15,0.16,0.15))

    # add date on plot
    tcolordate='w' #"#848484"
    tsizedate=14
    ax.annotate(tdate,xy=(15,550),xycoords='data', color=tcolordate,size=tsizedate)
    
    # add title exp
    ax.annotate(titleplt,xy=(420,550),xycoords='data', color=tcolordate,size=tsizedate)
    
    # add colorbar
    cb = fig1.colorbar(cs,extend='max',aspect=20,shrink=0.5,label=tlabel)

    # add Datlas logo
    if logo:
        im = plt.imread('/linkhome/rech/genige01/regi915/logo-datlas-RVB-blanc.png')
        newax = fig1.add_axes([0.15,0.15,0.06,0.06], anchor='SW', zorder=10)
        newax.imshow(im,alpha=0.3)
        newax.axis('off')
        # left, bottom, width, height)of the new Axes. All quantities are in fractions of figure width and height.
    
    if (it==0): 
        plt.show()
    if (it==(NT-1)): 
        plt.show()
    if (showplt): 
        plt.show()
        
    # Save fig in png, resolution dpi    
    li.Fsaveplt(fig1,diro,namo,dpifig=300)

    plt.close(fig1)
```



Based on this function:
```
def FplotmapSI_gp(fig3,ax,data2plot,cmap,norm,plto='tmp_plot',gridpts=True,gridptsgrid=False,gridinc=200,gstyle='lightstyle'): 
    
    cs  = ax.pcolormesh(data2plot,cmap=cmap,norm=norm)

    #ax = plt.gca()
    # Remove the plot frame lines. 
    ax.spines["top"].set_visible(False)  
    ax.spines["bottom"].set_visible(False)  
    ax.spines["right"].set_visible(False)  
    ax.spines["left"].set_visible(False)  

    ax.tick_params(axis="both", which="both", bottom="off", top="off",  
                labelbottom="off", labeltop='off',left="off", right="off", labelright="off",labelleft="off")  

    
    if gridpts:
    # show gridpoint on axes
        ax.tick_params(axis="both", which="both", bottom="off", top="off",  
                labelbottom="on", labeltop='off',left="off", right="off", labelright="off",labelleft="on")  
        plto = plto+"_wthgdpts"

    if gridptsgrid:
        lstylegrid=(0, (5, 5)) 
        if (gstyle=='darkstyle'):
            cmap.set_bad('#424242')
            lcolorgrid='w'#"#585858" # "#D8D8D8"
            tcolorgrid='#848484'#"#848484"
            
        if (gstyle=='ddarkstyle'):
            cmap.set_bad('#424242')
            lcolorgrid='w'#"#585858" # "#D8D8D8"
            tcolorgrid='w'#'#848484'#"#848484"
        if (gstyle=='lightstyle'):
            cmap.set_bad('w')
            lcolorgrid="#585858" # "#D8D8D8"
            tcolorgrid='#848484'#"#848484"            

        lalpha=0.2
        lwidthgrid=1.
        #ax = plt.gca()
        ax.xaxis.set_major_locator(mticker.MultipleLocator(gridinc))
        ax.yaxis.set_major_locator(mticker.MultipleLocator(gridinc))   
        ax.tick_params(axis='x', colors=tcolorgrid)
        ax.tick_params(axis='y', colors=tcolorgrid)
        ax.grid(which='major',linestyle=lstylegrid,color=lcolorgrid,alpha=lalpha,linewidth=lwidthgrid)
        ax.axhline(y=1.,xmin=0, xmax=883,zorder=10,color=lcolorgrid,linewidth=lwidthgrid,linestyle=lstylegrid,alpha=lalpha )
    
    return cs,ax
```
