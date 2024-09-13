#参考文献时间可视化
library(bibliometrix)
library(fs)
library(dplyr)
library(tidyr)
library(writexl)
base_dir="C:\\Users\\xuzhe\\Desktop\\SciMAT\\WOS 20240125"
files=dir_ls(base_dir,regexp="download_.*")
#file=c(paste0(base_dir,"download_1-500.txt"),paste0(base_dir,"download_1-500.txt"),paste0(base_dir,"download_1-500.txt"),paste0(base_dir,"download_1-500.txt"),paste0(base_dir,"download_1-500.txt"),paste0(base_dir,"download_1-500.txt"))
biblio_df=convert2df(files,dbsource = "wos",format = "plaintext")
#timespan =  c(1984,2023),
hrs=rpys(biblio_df,sep = ";",graph = TRUE)
ggsave(filename = "D:\\hqh_sci_cailiao\\20240219_new\\rpys1761.pdf", # 指定要保存的文件名和扩展名
       # plot = p_a,                  # ggplot对象，可以省略，默认会保存最后绘制的图
       width = 210,           # 图像宽度（单位：英寸）
       height = 150,          # 图像高度（单位：英寸）
       device = "pdf",units = "mm")
hrs$rpysTable
write_xlsx(hrs$rpysTable,"d://Spectroscopy.xlsx")

#光谱深入分析

biblio_df_CR=biblio_df%>%filter(PY==2013)%>%arrange(desc(TC))%>%head(3)%>%select(TI,TC)

biblio_df1991=biblio_df%>%filter(PY==2013)%>%separate_rows(CR,sep=";")%>%group_by(CR)%>%count()%>%arrange(desc(n))