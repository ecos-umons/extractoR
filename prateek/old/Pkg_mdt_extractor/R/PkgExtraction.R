# for the analysis of the package
pkganalysis <- function(){
  lst<- readLines(".//data//wpkg.txt")
  bpath<-readLines(".//data//srcdir.txt")
  pkgverify(lst,bpath)
}
# verify if the tar or zip is indeed a package or not
pkgverify <- function(lst,bpath)
{
wpkg<-lst #to be used by the our loop to come to this point again to check if some new sources are added after pending work is completed.
  tarlst <- grep("tar|tgz",lst)  #separate tar
  ziplst <- grep("zip",lst)     #separate list  
  if(length(tarlst>=1))
{  for(t in tarlst[1:length(tarlst)])              #verify if tar contains package and if has pkg then pass
                                  #the package tar to pkgexplore()
  {
    
   
    initpath<-lst[t]
    path<-file.path(bpath,initpath)
    oup<-try(untar(path,list=T))
    temp1<-oup[grep("\\/R\\/",oup)]
    temp2<-oup[grep("\\/man\\/",oup)]
    temp3<-grep("DESCRIPTION",oup)
    des<-oup[temp3]
    ext<-file.path(getwd(),'data/temp')
   if(length(temp1) >=1 && (length(temp2))>=1 && (length(des))==1)# if tar contains man,des, and R 
     {
     print(path)
     ofileconn<-file(".//data//opkgpath.txt")        #preserving the path of the original package package
     writeLines(path,ofileconn)            
     close(ofileconn)
       try( untar(path,exdir= ext))
        fldpath<-file.path(ext,dir(ext,recursive=F))
     ofileconn<-file(".//data//opkgtemppath.txt")        #preserving the path of the original package package
     writeLines(fldpath,ofileconn) 
     close(ofileconn) 
     # print("Analyzing a new package..." )
      
        pkgexplore(fldpath)
       # print("Finished analysis of the previous package")
   
    unlink(file.path(fldpath),recursive=T)
   }
     else if(length(temp1) >=1 && (length(temp2))>=1 && (length(des))>1)#for tar inside tar
    {
      print(path)
      try(untar(path,exdir= ext))
      fldpath<-file.path(ext,dir(ext,recursive=F))
     lstc<-dir(fldpath,recursive=F)
      for(fld in lstc[1:length(lstc)])
      {
        temppath<-file.path(fldpath,fld)
        info<-(file.info(temppath)$isdir)
        info<-info[!is.na(info)]
        if(info)
        {
          
        #  print("Analyzing a new package... ")
          
         pkgexplore(temppath) 
        unlink(file.path(temppath),recursive=T)
        #  print("Finished analysis of the previous package")
        }
      }
    }   
    #for removing items that are proccessed from the wpkg vector
    wpkg<-setdiff(wpkg,lst[t]) #separating from original function list so that next time 
    if(length(wpkg)==0)
    {
      wfileconn <- file(".//data//wpkg.txt")
      writeLines(wpkg,wfileconn)
      close(wfileconn)
      ofileconn<-file(".//data//opkg.txt")
      oldlst <-readLines(ofileconn)
      oldlst<-c(oldlst,lst[t])
      writeLines(oldlst,ofileconn)
      close(ofileconn)
      tarloc()
    }
    #updating the wpkg file
    else{
      wfileconn <- file(".//data//wpkg.txt")
      writeLines(wpkg,wfileconn)
      close(wfileconn)
      ofileconn<-file(".//data//opkg.txt")
      oldlst <-readLines(ofileconn)
      oldlst<-c(oldlst,lst[t])
      writeLines(oldlst,ofileconn)
      close(ofileconn)
    }
    
}}
  if(length(ziplst>=1))
{  for(t in ziplst[1:length(ziplst)])                  #same for zip
  {
    initpath<-lst[t]
    path<-file.path(bpath,initpath)
    oup<-try(unzip(path,list=T))
    temp1<-oup[grep("\\/R\\/",oup)]
    temp2<-oup[grep("\\/man\\/",oup)]
    temp3<-grep("DESCRIPTION",oup)
    des<-oup[temp3]
    ext<-file.path(getwd(),'data/temp')
    if(length(temp1) >=1 && (length(temp2))>=1 && (length(des))==1) #if zip contains des,man, and r
    {print(path)
      try(unzip(path,exdir= ext))
      fldpath<-file.path(ext,dir(ext,recursive=F))
     # print("Analyzing a new package... ")
      pkgexplore(fldpath)
     # print("Finished analysis of the previous package.")
      unlink(file.path(fldpath),recursive=T)
    }
    else if(length(temp1) >=1 && (length(temp2))>=1 && (length(des))>1) #for pkg inside zip
    {print(path)
      try(unzip(path,exdir= ext))
      fldpath<-file.path(ext,dir(ext,recursive=F))
      lstc<-dir(fldpath,recursive=F)
      for(fld in lstc[1:length(lstc)])
      {
        temppath<-file.path(fldpath,fld)
        info<-(file.info(temppath)$isdir)
        info<-info[!is.na(info)]
        if(info)
        {
          #print("Analyzing a new package... ")
          pkgexplore(temppath) 
        
        #  print("Finished analysis of the previous package")
          unlink(file.path(temppath),recursive=T)
        }
      }
    }
    #for removing items that are proccessed from the wpkg vector
    wpkg<-setdiff(wpkg,lst[t]) #separating from original function list so that next time 
    if(length(wpkg)==0)
{
      wfileconn <- file(".//data//wpkg.txt")
      writeLines(wpkg,wfileconn)
      close(wfileconn)
      ofileconn<-file(".//data//opkg.txt")
      oldlst <-readLines(ofileconn)
      oldlst<-c(oldlst,lst[t])
      writeLines(oldlst,ofileconn)
      close(ofileconn)
      tarloc()
    }
    #updating the wpkg file
    else{  
      wfileconn <- file(".//data//wpkg.txt")
      writeLines(wpkg,wfileconn)
      close(wfileconn)
      ofileconn<-file(".//data//opkg.txt")
      oldlst <-readLines(ofileconn)
      oldlst<-c(oldlst,lst[t])
      writeLines(oldlst,ofileconn)
      close(ofileconn)
    }
   
}}
  
}
