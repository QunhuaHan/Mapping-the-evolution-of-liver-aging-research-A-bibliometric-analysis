library(bibliometrix)
library(fs)
library(readxl)
library(ggplot2)
base_dir="C:\\Users\\xuzhe\\Desktop\\SciMAT\\WOS 20240125"
files=dir_ls(base_dir,regexp="download_.*")
#file=c(paste0(base_dir,"download_1-500.txt"),paste0(base_dir,"download_1-500.txt"),paste0(base_dir,"download_1-500.txt"),paste0(base_dir,"download_1-500.txt"),paste0(base_dir,"download_1-500.txt"),paste0(base_dir,"download_1-500.txt"))
biblio_df=convert2df(files,dbsource = "wos",format = "plaintext")
biblio_df_SO_COUNT=biblio_df%>%group_by(SO)%>%count()%>%arrange(desc(n))
top10_journal=biblio_df_SO_COUNT%>%head(10)%>%pull(SO)
biblio_df_top10_SO_PY_count=biblio_df%>%group_by(SO,PY)%>%count()%>%filter(SO %in% top10_journal,PY<2024)

p_A=ggplot(biblio_df_top10_SO_PY_count,aes(x=PY,y=n,fill="lightblue"))+
  geom_bar(stat = "identity",alpha=0.8,width = 0.8)+
  #scale_x_continuous(breaks = seq(1985, 2020, by = 5)) +
  facet_wrap(~SO,scales = "free_y")+#
 theme(strip.text = element_text(size = 5))

ggsave(filename = "D:\\hqh_sci_cailiao\\20240219_new\\journal_publication_per_year.pdf", # 指定要保存的文件名和扩展名
      plot = p_A,                  # ggplot对象，可以省略，默认会保存最后绘制的图
       width = 320,           # 图像宽度（单位：英寸）
       height = 150,          # 图像高度（单位：英寸）
       device = "pdf",
       units ="mm") 