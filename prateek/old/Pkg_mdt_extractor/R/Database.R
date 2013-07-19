#first frame to be inserted to database is pkgname because pkgname is the foreign key for package
dframepkgname<- function(fvector)
{
  channel<-intdb()
  t<-package(fvector)
  temp<-sqlFetch(channel,'pkgname',colnames=F,rownames=F)[,1]
  #when no entry in the database
  if(length(temp)==0)
  {
    if(length(t)>0) #because package name may not be present in the description file
  {  data<-data.frame(c(1),t,stringsAsFactors=F)
    names(data)<-c("idpkgname","pkgname")
    try(sqlSave(channel,data,tablename='pkgname',append=T,rownames=F,colnames=F))
    
  }}
  #when database is filled with some entries
  else
  {
   if(length(t)>0)
   {
    x<-sqlFetch(channel,'pkgname',colnames=F,rownames=F)[,2]
    if(any(grepl(t,x))==F)  # if any package name that is found is already present in the database or not 
    {
      data<-data.frame(c(max(sqlFetch(channel,'pkgname',colnames=F,rownames=F)[,1])+1),t,stringsAsFactors=F)
      names(data)<-c("idpkgname","pkgname")
      try(sqlSave(channel,data,tablename='pkgname',append=T,rownames=F,colnames=F))
      
    }
   }
  }
  #print(sqlQuery(channel,"desc pkgname;"))
  closedb()
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
#frame to be inserted to the package table of the database 
dframepackage<-function(fvector)
{
  channel<-intdb()
  t<-package(fvector)
  if(length(t)>0)
  {
    x<-sqlFetch(channel,'pkgname',colnames=F,rownames=F)
    if(any(grepl(t,x[,2]))==T)  #checking whether pkgname is already present or not
    {
      temp<-sqlFetch(channel,'package',colnames=F,rownames=F)[,1]
      #name vector for naming columns of dataframe
      name<-c("pkgid","pkgnameid","priority","version","date","title","author","maintainer","description","license","url","packaged","ar","encoding","copyright","sysreq","revision","bug","biocviews","bundledes","collate","collatewin","collateunix","keepsrc","lazydata","lazyload","bytecompile","zipdata","biarch","buildvignettes","vignettebuilder","needscompilation","os","ACM","JEL","MSC","language","built","note","contact","mailinglist","repo","publication","architecture","contains","type")
     #pkgid(integer)
      pkgid<-NULL
      if(length(temp)==0)
      {
        pkgid<-c(1)
      }
      else
      {
        pkgid<-c(max(temp)+1)
      }
      #pkgnameid(integer)
    pkgnameid<-x[,1][grep(t,x[,2])]   #find package name index from second column and then find the corresponding pkgnameindex
      #Priority
      pkgpriority<-NULL
      if(length(priority(fvector))>0)
      {
        pkgpriority<-priority(fvector)[1]
      }
      else
      {
        pkgpriority<-c("NULL")
      }
      #version
      pkgversion<-NULL
      if(length(version(fvector))>0)
      {
        pkgversion<-version(fvector)[1]
      }
      else
      {
        pkgversion<-c("NULL")
      }
      #date
      pkgdate<-NULL
      if(length(date(fvector))>0)
      {
        pkgdate<-date(fvector)[1]
      }
      else
      {
        pkgdate<-c("NULL")
      }
      #title
      pkgtitle<-NULL
      if(length(title(fvector))>0)
      {
        pkgtitle<-title(fvector)[1]
      }
      else
      {
        pkgtitle<-c("NULL")
      }
      #author
      pkgauthor<-NULL
      if(length(author(fvector))>0)
      {
        pkgauthor<-author(fvector)[1]
      }
      else
      {
        pkgauthor<-c("NULL")
      }
      #maintainer
      pkgmaintainer<-NULL
      if(length(maintainer(fvector))>0)
      {
        pkgmaintainer<-maintainer(fvector)[1]
      }
      else
      {
        pkgmaintainer<-c("NULL")
      }
      #description
      pkgdescription<-NULL
      if(length(description(fvector))>0)
      {
        pkgdescription<-description(fvector)[1]
      }
      else
      {
        pkgdescription<-c("NULL")
      }
      #License
      pkglicense<-NULL
      if(length(license(fvector))>0)
      {
        pkglicense<-license(fvector)[1]
      }
      else
      {
        pkglicense<-c("NULL")
      }
      #url
      pkgurl<-NULL
      if(length(url(fvector))>0)
      {
        pkgurl<-url(fvector)[1]
      }
      else
      {
        pkgurl<-c("NULL")
      }
      #10 packaged
      pkgpackaged<-NULL
      if(length(packaged(fvector))>0)
      {
        pkgpackaged<-packaged(fvector)[1]
      }
      else
      {
        pkgpackaged<-c("NULL")
      }
      #11 authors@r
      pkgar<-NULL
      if(length(authorsatr(fvector))>0)
      {
        pkgar<-authorsatr(fvector)[1]
      }
      else
      {
        pkgar<-c("NULL")
      }
      #12 encoding
      pkgencoding<-NULL
      if(length(encoding(fvector))>0)
      {
        pkgencoding<-encoding(fvector)[1]
      }
      else
      {
        pkgencoding<-c("NULL")
      }
      #13 copyright
      pkgcopyright<-NULL
      if(length(copyright(fvector))>0)
      {
        pkgcopyright<-copyright(fvector)[1]
      }
      else
      {
        pkgcopyright<-c("NULL")
      }
      #14 sysreq
      pkgsysreq<-NULL
      if(length(sysreq(fvector))>0)
      {
        pkgsysreq<-sysreq(fvector)[1]
      }
      else
      {
        pkgsysreq<-c("NULL")
      }
      #15 revision
      pkgrevision<-NULL
      if(length(revision(fvector))>0)
      {
        pkgrevision<-revision(fvector)[1]
      }
      else
      {
        pkgrevision<-c("NULL")
      }
      #16 bug
      pkgbug<-NULL
      if(length(bugreports(fvector))>0)
      {
        pkgbug<-bugreports(fvector)[1]
      }
      else
      {
        pkgbug<-c("NULL")
      }
      #17 biocviews
      pkgbiocviews<-NULL
      if(length(biocviews(fvector))>0)
      {
        pkgbiocviews<-biocviews(fvector)[1]
      }
      else
      {
        pkgbiocviews<-c("NULL")
      }
      #18 bundledes
      pkgbundledes<-NULL
      if(length(bundledes(fvector))>0)
      {
        pkgbundledes<-bundledes(fvector)[1]
      }
      else
      {
        pkgbundledes<-c("NULL")
      }
      #19 collate
      pkgcollate<-NULL
      if(length(collate(fvector))>0)
      {
        pkgcollate<-collate(fvector)[1]
      }
      else
      {
        pkgcollate<-c("NULL")
      }
      #20 collate.windows
      pkgcollate.windows<-NULL
      if(length(collate.windows(fvector))>0)
      {
        pkgcollate.windows<-collate.windows(fvector)[1]
      }
      else
      {
        pkgcollate.windows<-c("NULL")
      }
      #21 collate.unix
      pkgcollate.unix<-NULL
      if(length(collate.unix(fvector))>0)
      {
        pkgcollate.unix<-collate.unix(fvector)[1]
      }
      else
      {
        pkgcollate.unix<-c("NULL")
      }
      
      #22 keepsrc
      pkgkeepsrc<-NULL
      if(length(keepsrc(fvector))>0)
      {
        pkgkeepsrc<-keepsrc(fvector)[1]
      }
      else
      {
        pkgkeepsrc<-c("NULL")
      }
      
      #23 lazydata
      pkglazydata<-NULL
      if(length(lazydata(fvector))>0)
      {
        pkglazydata<-lazydata(fvector)[1]
      }
      else
      {
        pkglazydata<-c("NULL")
      }
      #24 lazyload
      pkglazload<-NULL
      if(length(lazyload(fvector))>0)
      {
        pkglazload<-lazyload(fvector)[1]
      }
      else
      {
        pkglazload<-c("NULL")
      }
      #25 bytecompile
      pkgbytecompile<-NULL
      if(length(bytecompile(fvector))>0)
      {
        pkgbytecompile<-bytecompile(fvector)[1]
      }
      else
      {
        pkgbytecompile<-c("NULL")
      }
      #26 zipdata
      pkgzipdata<-NULL
      if(length(zipdata(fvector))>0)
      {
        pkgzipdata<-zipdata(fvector)[1]
      }
      else
      {
        pkgzipdata<-c("NULL")
      }
      #27 biarch
      pkgbiarch<-NULL
      if(length(biarch(fvector))>0)
      {
        pkgbiarch<-biarch(fvector)[1]
      }
      else
      {
        pkgbiarch<-c("NULL")
      }
      #28 buildvignettes
      pkgbuildvig<-NULL
      if(length(buildvig(fvector))>0)
      {
        pkgbuildvig<-buildvig(fvector)[1]
      }
      else
      {
        pkgbuildvig<-c("NULL")
      }
      #29 vignettebuilder
      pkgvigbuild<-NULL
      if(length(vigbuilder(fvector))>0)
      {
        pkgvigbuild<-vigbuilder(fvector)[1]
      }
      else
      {
        pkgvigbuild<-c("NULL")
      }
      #30 needscompilation
      pkgneedcompile<-NULL
      if(length(needcompile(fvector))>0)
      {
        pkgneedcompile<-needcompile(fvector)[1]
      }
      else
      {
        pkgneedcompile<-c("NULL")
      }
      #31 os
      pkgos<-NULL
      if(length(os(fvector))>0)
      {
        pkgos<-os(fvector)[1]
      }
      else
      {
        pkgos<-c("NULL")
      }
      #32 ACM
      pkgacm<-NULL
      if(length(acm(fvector))>0)
      {
        pkgacm<-acm(fvector)[1]
      }
      else
      {
        pkgacm<-c("NULL")
      }
      #33 JEL
      pkgjel<-NULL
      if(length(jel(fvector))>0)
      {
        pkgjel<-jel(fvector)[1]
      }
      else
      {
        pkgjel<-c("NULL")
      }
      #34 MSC
      pkgmsc<-NULL
      if(length(msc(fvector))>0)
      {
        pkgmsc<-msc(fvector)[1]
      }
      else
      {
        pkgmsc<-c("NULL")
      }
      #35 language
      pkglng<-NULL
      if(length(lng(fvector))>0)
      {
        pkglng<-lng(fvector)[1]
      }
      else
      {
        pkglng<-c("NULL")
      }
      #36 built
      pkgbuilt<-NULL
      if(length(built(fvector))>0)
      {
        pkgbuilt<-built(fvector)[1]
      }
      else
      {
        pkgbuilt<-c("NULL")
      }
      #37 note
      pkgnote<-NULL
      if(length(note(fvector))>0)
      {
        pkgnote<-note(fvector)[1]
      }
      else
      {
        pkgnote<-c("NULL")
      }
      #38 contact
      pkgcontact<-NULL
      if(length(contact(fvector))>0)
      {
        pkgcontact<-contact(fvector)[1]
      }
      else
      {
        pkgcontact<-c("NULL")
      }
      #39 mailinglist
      pkgmlst<-NULL
      if(length(mailinglst(fvector))>0)
      {
        pkgmlst<-mailinglst(fvector)[1]
      }
      else
      {
        pkgmlst<-c("NULL")
      }
      #40 repo
      pkgrepo<-NULL
      if(length(repo(fvector))>0)
      {
        pkgrepo<-repo(fvector)[1]
      }
      else
      {
        pkgrepo<-c("NULL")
      }
      #41 publication
      pkgpublication<-NULL
      if(length(datepub(fvector))>0)
      {
        pkgpublication<-datepub(fvector)[1]
      }
      else
      {
        pkgpublication<-c("NULL")
      }
      #42 architecture
      pkgarchitecture<-NULL
      if(length(arch(fvector))>0)
      {
        pkgarchitecture<-arch(fvector)[1]
      }
      else
      {
        pkgarchitecture<-c("NULL")
      }
      #43 contains
      pkgcontains<-NULL
      if(length(contains(fvector))>0)
      {
        pkgcontains<-contains(fvector)[1]
      }
      else
      {
        pkgcontains<-c("NULL")
      }
      #44 type
      pkgtype<-NULL
      if(length(typepkg(fvector))>0)
      {
        pkgtype<-typepkg(fvector)[1]
      }
      else
      {
        pkgtype<-c("NULL")
      }
      #dataframe
      dta<-data.frame(pkgid,pkgnameid,pkgpriority,pkgversion,pkgdate,pkgtitle,pkgauthor,pkgmaintainer,pkgdescription,pkglicense,pkgurl,pkgpackaged,pkgar,pkgencoding,pkgcopyright,pkgsysreq,pkgrevision,pkgbug,pkgbiocviews,pkgbundledes,pkgcollate,pkgcollate.windows,pkgcollate.unix,pkgkeepsrc,pkglazydata,pkglazload,pkgbytecompile,pkgzipdata,pkgbiarch,pkgbuildvig,pkgvigbuild,pkgneedcompile,pkgos,pkgacm,pkgjel,pkgmsc,pkglng,pkgbuilt,pkgnote,pkgcontact,pkgmlst,pkgrepo,pkgpublication,pkgarchitecture,pkgcontains,pkgtype,stringsAsFactors=F)
      dta<-data.frame(pkgid,pkgnameid,pkgpriority,pkgversion,pkgdate,pkgtitle,pkgauthor,pkgmaintainer,pkgdescription,pkglicense,stringsAsFactors=F)
      dta2<-data.frame(pkgid,pkgurl,pkgpackaged,pkgar,pkgencoding,pkgcopyright,pkgsysreq,pkgrevision,pkgbug,pkgbiocviews,stringsAsFactors=F)
      dta3<-data.frame(pkgid,pkgbundledes,pkgcollate,pkgcollate.windows,pkgcollate.unix,pkgkeepsrc,pkglazydata,pkglazload,pkgbytecompile,pkgzipdata,stringsAsFactors=F)
      dta4<-data.frame(pkgid,pkgbiarch,pkgbuildvig,pkgvigbuild,pkgneedcompile,pkgos,pkgacm,pkgjel,pkgmsc,pkglng,stringsAsFactors=F)
      dta5<-data.frame(pkgid,pkgbuilt,pkgnote,pkgcontact,pkgmlst,pkgrepo,pkgpublication,pkgarchitecture,pkgcontains,pkgtype,stringsAsFactors=F)
      names(dta)<-name[1:10]
      names(dta2)<-c(name[1],name[11:19])
      names(dta3)<-c(name[1],name[20:28])
      names(dta4)<-c(name[1],name[29:37])
      names(dta5)<-c(name[1],name[38:46])
      fileconn<-file(".//data//pkgid.txt")  # writing pkgid to text file
     writeLines(as.character(pkgid),fileconn)
      close(fileconn)
      #appending to package 
     try(test<-sqlSave(channel,dta,tablename='package',append=T,rownames=F,colnames=F,fast=F))
      if(test==1)  #for checking if the above operation succeeded or no
    {  #appending to package 2
      try(sqlSave(channel,dta2,tablename='package2',append=T,rownames=F,colnames=F,fast=F))
      
      try(sqlSave(channel,dta3,tablename='package3',append=T,rownames=F,colnames=F,fast=F))
      
      #appending to package 4
      try(sqlSave(channel,dta4,tablename='package4',append=T,rownames=F,colnames=F,fast=F))
      
      #appending to package 5
      try(sqlSave(channel,dta5,tablename='package5',append=T,rownames=F,colnames=F,fast=F))
    
      #appending to depends
      dframedepends(fvector,pkgid)
      #appending to suggests
      dframesuggests(fvector,pkgid)
      #appending to enchances
      dframeenhances(fvector,pkgid)
      }
    }
    
  }
  closedb()
  
}
# Depends Table
dframedepends<-function(fvector,pkgid)
{
  pkg<-NULL
  temp<-dependency(fvector)
  if(length(temp)>0)
  {
    for(i in 1:length(temp))
    {
      pkg[i]<-pkgid
    }
    dta<-data.frame(pkg,temp)
    names(dta)<-c("pkgid","name")
    channel<-intdb()
   try(sqlSave(channel,dta,tablename='depends',append=T,rownames=F,colnames=F))
    closedb()
  }
}
#Suggests Table
dframesuggests<-function(fvector,pkgid)
{
  pkg<-NULL
  temp<-suggests(fvector)
  if(length(temp)>0)
  {
    for(i in 1:length(temp))
    {
      pkg[i]<-pkgid
    }
    dta<-data.frame(pkg,temp)
    names(dta)<-c("pkgid","name")
    channel<-intdb()
    try(sqlSave(channel,dta,tablename='suggests',append=T,rownames=F,colnames=F))
    closedb()
  }
}
#Enchances Table
dframeenhances<-function(fvector,pkgid,ofuncallees)
{
  pkg<-NULL
  temp<-enhances(fvector)
  if(length(temp)>0)
  {
    for(i in 1:length(temp))
    {
      pkg[i]<-pkgid
    }
    dta<-data.frame(pkg,temp)
    names(dta)<-c("pkgid","name")
    channel<-intdb()
    try(sqlSave(channel,dta,tablename='enhances',append=T,rownames=F,colnames=F))
    closedb()
  }
}
dframefunction<-function(originalfunlst,finalfunlst,ofuncallees)
{  
  channel<-intdb()
  temp<-sqlFetch(channel,'function',colnames=F,rownames=F)[,1]
  pkgid<-readLines(".//data//pkgid.txt")
  if(length(pkgid)>0)
  {
    if(length(originalfunlst)>0)
    {
      idfunction<-c(1)
      if(length(temp)>0)
      {
        idfunction<-c((max(temp)+1))
      }
      functionid<-NULL
      #for filling function table
      for(fun in originalfunlst)
      {
        fname<-fun
        generic<-any(grepl("UseMethod\\(", deparse(fun)))
        name<-c("idfunction","fname","generic","pkgid")
        dta<-data.frame(idfunction,fun,generic,pkgid,stringsAsFactors=F)
        names(dta)<-name
        try(sqlSave(channel,dta,tablename='function',append=T,rownames=F,colnames=F,fast=F))
        functionid<-c(functionid,idfunction)
        idfunction<-c(idfunction+1)
       # print(finalfunlst)
        #print(idfunction)
      }
      closedb()
      #for filling internal function table
     for(i in 1:length(originalfunlst))
     {
       funid<-functionid[i]
      temp<-ofuncallees[[i]]
       if(length(temp)>1)
       {
         for(i in 2:length(temp))
         {
           tmatch<-match(temp[i],originalfunlst,nomatch=-1)
           if(tmatch!=-1)
           {
             callees<-functionid[tmatch]
             dframeinternalfun(funid,callees)
             }
         }
       }
     }
      #for filling external function table
      for(i in 1:length(originalfunlst))
      {
        funid<-functionid[i]
        temp<-ofuncallees[[i]]
        if(length(temp)>1)
        {
          extfun<-setdiff(temp[2:length(temp)],originalfunlst)
         if(length(extfun)>0)
         {
           for(fun in extfun)
           {
             if(length(finalfunlst)>0)
             {
               for(j in 1:length(finalfunlst))
               {
                 tfinal<-finalfunlst[[j]]
                 if(length(tfinal)>1)
                 {
                   tm<-match(fun,tfinal[2:length(tfinal)],nomatch=-1)
                   if(tm!=-1)
                   {
                     dframeexternalfun(funid,fun,tfinal[1])
                     break
                   }
                 }
               }
             }
           }
         }
        }
      }
    } 
  }
 
}
dframeinternalfun<-function(funid,callees)
{
  channel<-intdb()
  data<-data.frame(funid,callees,stringsAsFactors=F)
  names(data)<-c("idinternalfun","callees")
  try(sqlSave(channel,data,tablename='internalfun',append=T,colnames=F,rownames=F))
  closedb()
}
dframeexternalfun<-function(funid,fun,pkgname)
{
  data<-data.frame(funid,fun,pkgname,stringsAsFactors=F)
  names(data)<-c("idextfun","extfun","pkgname")
  channel<-intdb()
  try(sqlSave(channel,data,tablename='externalfun',append=T,colnames=F,rownames=F,fast=F))
  closedb()
}