#database frame
dframe <-function(fvector,rversion,os)
{
  pkgname<-package(fvector)
  print(pkgname)
  pkgversion<-version(fvector)
  # if pkgname and version both are present
  if(length(pkgname)>0 && length(pkgversion)>0)
  { 
    channel<-intdb()
    #for checking whether package is in package table or not
    data<-sqlFetch(channel,'package',colnames=F,rownames=F)
    data2<-sqlFetch(channel,'pkgname',colnames=F,rownames=F)
    temp<-match(pkgname,data2[,2],nomatch=-1)
    temp2<-match(pkgversion,data[,4],nomatch=-1)
    # if match occurs i.e. package name is present in package table
    if(temp!=-1)
    { 
      temp<-match(data2[,1][temp[1]],data[,2])
      t<-setdiff(temp,setdiff(temp,temp2))
      # to confirm that it is the intended package version i.e. match is perfect
      if(length(t)>0 && t!=-1)
      {
        pkgid<-data[,1][t[1]]  #pkgid
        # for checking whether package is already in the snap or not
        tp<-sqlFetch(channel,'snap',colnames=F,rownames=F)
        tid<-match(pkgid,tp[,1],nomatch=-1)
        tversion<-match(pkgversion,tp[,2],nomatch=-1)
        tr<-match(rversion,tp[,3],nomatch=-1)
        tiv<-setdiff(tid,setdiff(tid,tversion))
        tir<-setdiff(tid,setdiff(tid,tr))
        finaldiff<-setdiff(tid,setdiff(tir,tiv))  
        if(length(finaldiff)==0 || finaldiff ==-1)   #package not already present in snap
      {
        pkgversion<-pkgversion
        pkgos<-os
        dta2<-data.frame(pkgid,os)
        names(dta2)<-c("idos","os")
        dta<-data.frame(pkgid,pkgversion,rversion)
        names(dta)<-c("pkgid","version","rversion")
        try(test<-sqlSave(channel,dta,tablename='snap',append=T,rownames=F,colnames=F,fast=F))
        if(test==1)
        {
          try(sqlSave(channel,dta2,tablename='os',append=T,rownames=F,colnames=F,fast=F))
        }
      }
        #if package is already present in the snap table of the database 
        else
        {
           tdata<-sqlFetch(channel,'os',colnames=F,rownames=F) 
           # if os are different then only add os to the os table
         if(length(tdata[,2])>0)
         {timepass<-tdata[,2][finaldiff[1]]
        
         if(length(timepass)>0 )
           {if(os!=timepass)
           {
             dta<-data.frame(pkgid,os)
             names(dta)<-c("idos","os")
             try(sqlSave(channel,dta,tablename='os',append=T,rownames=F,colnames=F,fast=F))
           }
        }}
        else
        {
          dta<-data.frame(pkgid,os)
          names(dta)<-c("idos","os")
          try(sqlSave(channel,dta,tablename='os',append=T,rownames=F,colnames=F,fast=F))
        }
        }
      }
    }
  closedb()
  }
  
}
# to initialize the database connection to our desired database
intdb<-function()
{
  channel<- odbcConnect('r',uid="root",pwd="root")
  sqlQuery(channel,"use finaldb;")
  return(channel)
}
# to close database connection
closedb <-function()
{
  odbcCloseAll()
}