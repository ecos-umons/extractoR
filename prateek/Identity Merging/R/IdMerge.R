merge<-function(data)
{
  name<-data[,2]
  aid<-data[,1]
  email<-data[,3]
 # nmerge(name,aid)
 # emerge(email,aid)
  nemerge(name,email,aid)
}
# name-name merging
nmerge<-function(name,aid)
{
  #print(length(aid))
 # print(length(name))
  #print(aid)
  #print(name)
  temporary<-(grep("NULL",name))
  tempx<-aid[temporary]
  for(t in tempx)
  {aid<-aid[aid!=t]} # some error due to which two elements are not removed from the vector at once so we have to use that
  name<-name[name!=name[temporary]]
  #print(aid)
 # print(name)
  name<-tolower(name)
  mhelper<-name
  helperm<-aid
  helpern<-NULL
  helperaid<-NULL
  if(length(name)>0)
  {
    for(i in (1:length(name)))
{
      nameparts<-(unlist(strsplit(name[i]," ")))
      posnames<-permn(nameparts)
      index<-NULL
      if(length(posnames)>0)
      {
        for(t in posnames)
        {
          
          s1<-paste(t,collapse=" ")
          
          if(length(mhelper)>0)
       {   for(x in 1:length(mhelper))
          {
         fsim<-NULL
         sim<-NULL
         index<-x
            parts<-(unlist(strsplit(mhelper[x]," ")))
            poss2<-permn(parts)
       #  print(poss2)
         if(length(poss2)>0)
         {
           for(j in  (1:length(poss2)))
           {
             tsim<-NULL
             s2<-paste(poss2[[j]],collapse=" ")
            # print(s2)
             tsim<-levenshteinSim(s1,s2)
             if(length(tsim)>0)
             {  
               sim<-c(sim,tsim)
             }
           }
         }
      #  print(sim)
        # print("bhad mein jaa")
        fsim<-max(sim)
        # print(index)
        # print(i)
       #print(fsim)
         if(length(fsim)>0)
         {
           if(fsim>.8)    # Please insert here levenshtein similiarity for appropriate merging.
           {
             if(i!=index)
             {
              # print("fuck")
              # print(fsim)
             # print(aid[i])
             #  print(aid[index])
             # print("maa chuda")
              #print(name[i])
              #print(mhelper[index])
              # print(i)
              # print(index)
              # print("chal ja bc")
               dbwrite(aid[index],aid[i])
             }
           }   
         }           
         }}
        }
      }
# print(index)
 #print(sim)
            }
      }
    }
emerge<-function(name,aid)
{
  #print(length(aid))
  # print(length(name))
  #print(aid)
  #print(name)
  temporary<-(grep("NULL",name))
  tempx<-aid[temporary]
  for(t in tempx)
  {aid<-aid[aid!=t]} # some error due to which two elements are not removed from the vector at once so we have to use that
  name<-name[name!=name[temporary]]
  xname<-name
  name<-NULL
  for(t in xname)
  {
    temp<-(unlist(strsplit(t,"@"))[1])
    temp2<-unlist(strsplit(temp,"<|!|>|[|]|$|%|&|(|\\^|\\+|\\-|)|,|\\.|"))
    temp3<-paste(temp2,collapse=" ")
    name<-c(name,temp3)
  }
  #print(aid)
  # print(name)
  name<-tolower(name)
  mhelper<-name
  helperm<-aid
  helpern<-NULL
  helperaid<-NULL
  if(length(name)>0)
  {
    for(i in (1:length(name)))
    {
      nameparts<-(unlist(strsplit(name[i]," ")))
      posnames<-permn(nameparts)
      index<-NULL
      if(length(posnames)>0)
      {
        for(t in posnames)
        {
          
          s1<-paste(t,collapse=" ")
          
          if(length(mhelper)>0)
          {   for(x in 1:length(mhelper))
          {
            fsim<-NULL
            sim<-NULL
            index<-x
            parts<-(unlist(strsplit(mhelper[x]," ")))
            poss2<-permn(parts)
            #  print(poss2)
            if(length(poss2)>0)
            {
              for(j in  (1:length(poss2)))
              {
                tsim<-NULL
                s2<-paste(poss2[[j]],collapse=" ")
                # print(s2)
                tsim<-levenshteinSim(s1,s2)
                if(length(tsim)>0)
                {  
                  sim<-c(sim,tsim)
                }
              }
            }
            #  print(sim)
            # print("bhad mein jaa")
            fsim<-max(sim)
            # print(index)
            # print(i)
            #print(fsim)
            if(length(fsim)>0)
            {
              if(fsim>.8)    # Please insert here levenshtein similiarity for appropriate merging.
              {
                if(i!=index)
                {
                  #print("fuck")
                  #print(fsim)
                  #print(aid[i])
                  #print(aid[index])
                  #print("maa chuda")
                  #print(name[i])
                  #print(mhelper[index])
                  # print(i)
                  # print(index)
                  # print("mother fucker")
                  dbwrite(aid[index],aid[i])
                }
              }   
            }           
          }}
        }
      }
      # print(index)
      #print(sim)
    }
  }
}
nemerge<-function(name,email,aid)
{
  tpass1<-grep("NULL",name)
  fname<-name[name!=name[tpass1]]
  naid<-aid
  for(x in tpass1)
  {
    naid<-naid[naid!=x]
  }
  #print(fname)
 # print(naid)
 # print(tpass)
  eaid<-aid
  tpass2<-grep("NULL",email)
  femail<-email[email!=email[tpass2]]
  for(x in tpass2)
  {
    eaid<-eaid[eaid!=x]
  }
  femail<-tolower(femail)
  fname<-tolower(fname)
  if(length(fname)>0)
 { for(j in (1:length(fname)))
  {
   aut<-fname[j]
    author<-unlist(strsplit(aut," "))
    posid<-gpe(author)
    # for p.rastogi and r.prateek type emailids
    for(parts in author)
    {
      timepass<-author[author!=parts]
      timepass<-c(timepass,unlist(strsplit(parts,""))[1])
      temp<-gpe(timepass)
      posid<-c(posid,temp)
    }
   if(length(femail)>0)
   {
     for(k in 1:length(femail))
     {
       tempemail<-(unlist(strsplit(femail[k],"@"))[1])
       aid1<-naid[j]
       aid2<-eaid[k]
       #print(aid1)
       #print(aid2)
       #print(tempemail)
       result<-F
       result2<-F
       result<-neperfect(tempemail,posid)
       if(length(result)==0)
       {
         result<-F
       }
       # i.e. if perfect merge occurs then write the merge on to the database
       if(result==T)
       {
        # print(aid1)
         #print(aid2)
        # print(fname[j])
         #print(femail[k])
        # print("here")
         dbwrite(aid1,aid2)
       }
       # try levenshtein similiarity merging
       else
       {
        # print(fname[j])
        # print("here")
         result2<-neapprox(tempemail,fname[j])
       }
       #i.e. if levenshtein merging occurs then write merge on the database
       if(length(result2)==0)
       {
         result2<-F
       }
       if(result2==T)
       {
         #print("here")
         dbwrite(aid1,aid2)
       }
     }
   }
    #print(posid)
  }}#red line
  # print(eaid)
  # print(femail)
}
