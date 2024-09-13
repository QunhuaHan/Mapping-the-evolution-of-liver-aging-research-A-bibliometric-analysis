library(bibliometrix)
library(fs)
library(dplyr)
library(tidyr)
library(stringr)
library(writexl)
base_dir="C:\\Users\\xuzhe\\Desktop\\SciMAT\\WOS 20240125"
base_dir="D:\\hqh_sci_cailiao\\20240219_new\\data_20240219"
files=dir_ls(base_dir,regexp="download_.*")
#file=c(paste0(base_dir,"download_1-500.txt"),paste0(base_dir,"download_1-500.txt"),paste0(base_dir,"download_1-500.txt"),paste0(base_dir,"download_1-500.txt"),paste0(base_dir,"download_1-500.txt"),paste0(base_dir,"download_1-500.txt"))
biblio_df=convert2df(files,dbsource = "wos",format = "plaintext")

trace(bibliometrix:::AU_CO, edit = T)

biblio_df=metaTagExtraction(biblio_df,Field = "AU_CO",sep = ";")

biblio_df=metaTagExtraction(biblio_df,Field = "AU_UN",sep = ";")


trace(threeFieldsPlot, edit = T) # 修改后保存



biblio_df_2=termExtraction(biblio_df, Field = "ID", ngrams = 1,
               synonyms=synonyms, verbose=TRUE,remove.terms = remove_terms)
biblio_df_2%>%select(ID,ID_TM)%>%head(3)
p=threeFieldsPlot(biblio_df_2,c("ID_TM", "AU_CO", "SO"),n=c(10, 10, 10))
p$Nodes
saveWidget(p, file = "d://your_graph.html")
chrome_print("d://your_graph.html", output = "d://your_graph.pdf")

biblio_df_extends=biblio_df%>%separate_rows(ID,sep = ";")%>%separate_rows(AU_CO,sep = ";")

biblio_df_extends_counts=biblio_df_extends%>%group_by(DE,AU_CO,SO)%>%count()

biblio_df_extends_counts_limit10=biblio_df_extends_counts%>%filter(n>=50)



library(ggalluvial)

ggplot(biblio_df_extends_counts_limit10,
       aes(y = n, axis1 = ID, axis2 = AU_CO,axis3=SO)) +
  geom_alluvium(
                width = 1/8, knot.pos = 0, reverse = FALSE) +
  guides(fill = FALSE) +
  geom_stratum(aes(fill=n),alpha = .25, width = 1/8, reverse = FALSE) +
  geom_text(stat = "stratum", aes(label = after_stat(stratum)),
            reverse = FALSE) +
  scale_x_continuous(breaks = 1:3, labels = c("ID", "AU_CO", "SO")) +
  ggtitle("ID AU_CO SO Three_Field_Plot")


















ggplot(biblio_df_extends_counts_limit10,
       aes(y = n, axis1 = ID, axis2 = AU_CO,axis3=SO)) +
  geom_alluvium(width = 1/12) +
  geom_stratum(width = 1/12, fill = "black", color = "grey") +
  geom_label(stat = "stratum", aes(label = after_stat(stratum))) +
  scale_x_discrete(limits = c("ID", "AU_CO","SO"), expand = c(.05, .05)) +
  scale_fill_brewer(type = "qual", palette = "Set1") +
  ggtitle("three_field_plot")

