srcexplore <- function(rpath,dpath,namespace)
{
#print(nmsimport(nmsres(namespace)))
  #print(rpath)
 # print(dpath)
  opkgpath<-readLines(".//data//opkgpath.txt")
  opkgpath<-opkgpath[opkgpath!=""]
  temp<-list.files(rpath,pattern="\\.R|\\.S|\\.q|\\.r|\\.s", full.names=T,include.dirs=T)
  rfiles<-setdiff(temp,temp[grep("\\.rda|\\.in",temp)])   #getting only r source files
  
  env<-attach(NULL, name = "custom")  #our main environment for function dependency analysis
  if(length(rfiles)>=1)
  {
    for(i in 1:length(rfiles))
    {
      try(sys.source(rfiles[i], envir=env))
      
    }
  }

  originalfunlst<-NULL       #list of the original function present inside the package
  originalfunlst<-as.vector(lsf.str("custom"))
  #print(try(rownames(foodweb(where="custom")$funmat)))
  
  
  
  #temp<-(dependency(fvector))
  #print(lsf.str())
  #print(rpath)
  
  
  
  
  
  #dependency manipulation starts here
  
  dplst<-(deplist(dependency(finalvector(dpath))))
  #print(dplst)
  fdplst<-NULL # dependency list of the packages
  #separating version from packages names
   for(t in dplst)
   {
     fdplst<-c(fdplst,unlist(strsplit(t,"\\("))[1])  # final dependency list by package names
   }
tx<-nmsimport(nmsres(namespace))
fdplst<-c(tx,setdiff(fdplst,tx)) #as import field in namespace got more priority over depends in description file
 # print(fdplst)
  pkgpath<-NULL
  pkgname<-NULL
  # getting file paths of the dependent packages
  if(length(fdplst)>0)
  {
    timepass<-(readLines(file.path(getwd(),"data/pkgpaths.txt")))
    dpnpaths<-file.path(readLines(file.path(getwd(),"data/srcdir.txt")),timepass)
    dpnpaths<-dpnpaths[dpnpaths !=dpnpaths[grep(opkgpath,dpnpaths)]] # To package from identifying itself
    for(t in fdplst)
    {
      temp<-paste(c(t,tolower(t)),collapse="|")
      temp2<-dpnpaths[grep(temp,dpnpaths)]
     pkgpath<-c(pkgpath,temp2)   #path of the packages
      if(length(temp2)>0)
      {
       pkgname[(length(pkgname)+1):(length(temp2)+length(pkgname))]<-t 
      }
    }
    
  }
  
  funname<-NULL
  finalfunlst<-NULL #final list of the functions with names of the vector representing the package in which it is found
  funlst<-NULL #list of the function
  names(pkgpath)<-pkgname                 #assigning names to the package paths that are found
  
  ext<-file.path(getwd(),'data/temp')
  tmppkgpath<-NULL
 
  if(length(pkgpath)>0)
  {for(i in 1:length(pkgpath))  # loop in which everything is processed
{path<-pkgpath[i]
    names(path)<-pkgname[i]#assigning the names to the path as names are not passed with vector
 if(length(path)>0)
  {if(grepl("tar|tgz",path)==T)
  {
    tmp<-try(untar(path,exdir= ext,list=T)) # doesn't untar the files only list them
    try(untar(path,exdir=ext))
    tmpname<-pkgname[i]  # to get the name of the package we are processing
    #print(tmpname)
    #print(tmppkgpath)
    #print("fuck u")
    fldpath1<-file.path(ext,dir(ext,recursive=F))     
      temp<-fldpath1[grep(tmpname,fldpath1)]       # separating only the packages that we are currently processing.It doesn't seem working.
      temp1<-readLines(".//data//opkgtemppath.txt")
      temp1<-temp1[temp1!=""]
    fldpath1<-setdiff(fldpath1,temp1)   #separating the dependent packages and original packages
    fldpath1<-setdiff(fldpath1,tmppkgpath) #separating the dependent packages from other dependent packages
    #print(fldpath1)
    fldpath<-dir(fldpath1,pattern="^R$",recursive=F)
    #print(fldpath)
    tmppkgpath<-c(tmppkgpath,fldpath1)  #creating the list of dependent pacakges already processed
    fldpath<-(file.path(fldpath1,(setdiff(fldpath,setdiff(fldpath,c('R'))))))
    fldpath<-list.files(fldpath,pattern="\\.R|\\.S|\\.q|\\.r|\\.s", full.names=T,include.dirs=T)
    fldpath<-setdiff(fldpath,fldpath[grep("\\.rda|\\.in",fldpath)])   #getting only r source files
    if(length(grep("\\/R\\/",tmp))>0)
    {
      #print(fldpath)
      funextractlst<-funextract(fldpath)

      funlst<-as.vector(funextractlst[[1]])   #getting list of functions present inside the dependent package
      funlst<-c(pkgname[i],funlst)
      rfpath<-funextractlst[[2]]    #path of the r source file in the dependent package
      if(length(rfpath)>0)        #this code has literally raped my mind
      {
        for(i in 1:length(rfpath))
        {  
          try(sys.source(rfpath[i], envir =env))    #adding the package variables to main package environmennt
        }
      }
      
        }
    unlink(fldpath1,recursive=T,force=T)  # for unlinking the folders
  }
 
  else if(grepl("zip",path)==T)
  {
    tmp<-try(unzip(path,exdir= ext,list=T)) # doesn't untar the files only list them
    try(unzip(path,exdir=ext))
    tmpname<-pkgname[i]  # to get the name of the package we are processing
    
    #print(tmppkgpath)
    #print("fuck u")
    fldpath1<-file.path(ext,dir(ext,recursive=F))     
    temp<-fldpath1[grep(tmpname,fldpath1)]       # separating only the packages that we are currently processing.It doesn't seem working.
    temp1<-readLines(".//data//opkgtemppath.txt")
    temp1<-temp1[temp1!=""]
    fldpath1<-setdiff(fldpath1,temp1)   #separating the dependent packages and original packages
    fldpath1<-setdiff(fldpath1,tmppkgpath) #separating the dependent packages from other dependent packages
    #print(fldpath1)
    fldpath<-dir(fldpath1,pattern="^R$",recursive=F)
    #print(fldpath)
    tmppkgpath<-c(tmppkgpath,fldpath1)  #creating the list of dependent pacakges already processed
    fldpath<-(file.path(fldpath1,(setdiff(fldpath,setdiff(fldpath,c('R'))))))
    fldpath<-list.files(fldpath,pattern="\\.R|\\.S|\\.q|\\.r|\\.s", full.names=T,include.dirs=T)
    fldpath<-setdiff(fldpath,fldpath[grep("\\.rda|\\.in",fldpath)])   #getting only r source files
   # print("loop again")
    if(length(grep("\\/R\\/",tmp))>0)
    {
      #print(fldpath)
      funextractlst<-funextract(fldpath)
     
      funlst<-as.vector(funextractlst[[1]])   #getting list of functions present inside the dependent package
      
      rfpath<-funextractlst[[2]]   #path of the r source file in the dependent package
      if(length(rfpath)>0)        #this code has literally raped my mind
      {
        for(i in 1:length(rfpath))
        {  
          try(sys.source(rfpath[i], envir =env))    #adding the package variables to main package environmennt
        }
      }
      
    }
    unlink(fldpath1,recursive=T,force=T)  # for unlinking the folders
      
}
 }
 #print(as.vector(lsf.str("custom")))
# print(foodweb(where="custom",plotting=F)$funmat)
# print(funlst)
  if(length(funlst)>0)
  {
      #funname[(length(funname)+1):(length(funname)+length(funlst))]<-names(path)
    finalfunlst<-c(finalfunlst,list(funlst))  #creating final function list
  }
    }}
  tp<-(nmsimpfrm(nmsres(namespace)))  #returns a list of function and its package name
  tfun<-tp[[1]]
  tname<-tp[[2]]
  tlist<-c(list(tname),list(tfun))
  ofuncallees<-NULL #list of calls to the original function in the same order as they are in vecctor.
  if(length(tfun)!=0)
 {finalfunlst<-c(tlist,finalfunlst)}   #final function list
  #print("here")
 # print("fuck")
  fw<-NULL
  try({fw<-foodweb(where="custom",plotting=F)})
 # print("yaha")
  if(length(fw)>0)
 { for(fun in originalfunlst)
  {
    ofuncallees<-(c(ofuncallees,list(c(fun,callees.of(fun,fw)))))
  }
  #print(ofuncallees)
  detach(custom) # it is detached before calling function because it changes base environment to this and then the actual i.e. my program can't find the functions of my program.
dframefunction(originalfunlst,finalfunlst,ofuncallees)
  #print(finalfunlst)
 # print(originalfunlst)
 #names(finalfunlst)<-funname  #final function list with names of vector element representing package in which a function belongs
 #print(finalfunlst) 
  #detach(custom)
   #print("h")
  # end of dependency manipulation with list of the function of each dependent package in our hand
}}




#for extracting the names of the functions implemented inside the package
funextract<-function(path)
{
  #  print(path)

  rpath<-path
  rfiles<-NULL
  if(length(rpath)>=1)
  {  temp<-rpath[grep("\\.R|\\.S|\\.q|\\.r|\\.s",rpath)]
  rfiles<-setdiff(temp,temp[grep("\\.rda|\\.in",temp)])
  }
  #print(rfiles)
  environment<-attach(NULL, name = "pkg")
  if(length(rfiles)>=1)
  {
    for(i in 1:length(rfiles))
    {
      try(sys.source(rfiles[i], envir =environment))
    }
  }
  funclst<-as.vector(lsf.str("pkg"))  
  #print(funclst)
  detach(pkg)
  return(list(funclst,rfiles))
}
  